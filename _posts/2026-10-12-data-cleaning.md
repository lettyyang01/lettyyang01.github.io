---
layout: post
title: Data Cleaning Checklist
date: 2026-10-12
description: a pandas routine for turning a raw table into something you can trust
tags: pandas data-cleaning
categories: notes
related_posts: false
toc:
  sidebar: left
---

Four phases: **Inspect → Standardize → Repair → Verify**. Three rules hold throughout:

- The raw file is never edited. Cleaning lives in code so it can be re-run.
- Profile before fixing. Every change should answer something you actually saw.
- Count what each step dropped or changed; that becomes the audit at the end.

## 1. Inspect

Look, don't touch.

### Load and freeze

```python
raw = pd.read_csv("data.csv")   # or read_parquet / read_sql
df = raw.copy()
n_raw = len(raw)
```

`raw` stays untouched as the baseline for every before/after comparison.

### Profile the table

```python
df.shape
df.head()
df.sample(5)      # head() hides problems further down

df.info()                     # dtypes + non-null counts
df.describe(include="all")    # numeric + categorical

# missing rate per column
df.isna().mean().sort_values(ascending=False)

df.corr(numeric_only=True)
```

Look for numbers read as `object`, nearly empty columns, and ranges that make no sense.

### Profile each column

```python
# " NYC", "nyc" and "N/A" show up as separate values
df["city"].value_counts(dropna=False)
df["city"].nunique()

df["price"].describe()
```

`value_counts(dropna=False)` on every categorical column is the fastest way to find formatting noise and disguised missing values.

## 2. Standardize

Make names, types and formats consistent so values become comparable.

### Column names

```python
df.columns = (
    df.columns.str.strip()
              .str.lower()
              .str.replace(r"[^\w]+", "_", regex=True)
)
df = df.rename(columns={"cust_id": "customer_id"})
```

### Missing placeholders

```python
NA_TOKENS = ["", " ", "NA", "N/A", "null", "-", "?", "unknown"]
df = df.replace(NA_TOKENS, np.nan)

# numeric sentinels
df["age"] = df["age"].replace({-1: np.nan, 999: np.nan})
```

Do this before converting types. Otherwise `errors="coerce"` turns the placeholders into `NaN` silently and you lose track of which ones were sentinels.

### Types and formats

```python
# text: whitespace and case
df["city"] = df["city"].str.strip().str.title()

# numeric: strip symbols, then coerce
df["price"] = df["price"].str.replace(r"[$,]", "", regex=True)
df["price"] = pd.to_numeric(df["price"], errors="coerce")

# dates
df["signup_date"] = pd.to_datetime(df["signup_date"], errors="coerce")

# codes -> labels
# unmapped values become NaN, so check value_counts first
df["gender"] = df["gender"].map({"M": "male", "F": "female"})

# how many values did coercion lose?
df["price"].isna().sum() - raw["price"].isna().sum()
```

Coercion never raises; it quietly produces `NaN`. Count the loss after each conversion.

### Duplicates

```python
df.duplicated().sum()                          # exact copies
df.duplicated(subset=["customer_id"]).sum()    # same key

# keep the latest row per key
df = (
    df.sort_values("updated_at")
      .drop_duplicates(subset=["customer_id"], keep="last")
)
```

This comes after standardization: `"NYC"` and `" nyc "` only become duplicates once formats agree. Decide explicitly which row survives, usually the latest.

## 3. Repair

Decide what to do with the values that are absent or extreme.

### Missing values

```python
# is missingness random, or tied to another column?
df.isna().mean()
df.groupby(df["income"].isna())["age"].mean()

# drop a column that is mostly empty
df = df.drop(columns=["fax"])

# drop rows missing a key field
df = df.dropna(subset=["customer_id", "signup_date"])

# keep a flag before filling: "was missing" is often informative
df["income_was_na"] = df["income"].isna()

# median for skewed numeric, constant for categorical
df["income"] = df["income"].fillna(df["income"].median())
df["city"] = df["city"].fillna("Unknown")
```

For modeling, compute fill values on the training split only; otherwise the test set leaks into the imputer.

### Outliers

```python
# IQR: robust to the outliers themselves
q1, q3 = df["price"].quantile([0.25, 0.75])
iqr = q3 - q1
lo, hi = q1 - 1.5 * iqr, q3 + 1.5 * iqr
is_out = ~df["price"].between(lo, hi)

# z-score: assumes roughly normal data,
# and mean / std are themselves pulled by the outliers
z = (df["price"] - df["price"].mean()) / df["price"].std()
is_out = z.abs() > 3

# look before touching: entry error, unit mix-up, or real?
df.loc[is_out, ["customer_id", "price"]]

# then flag (safest), cap, or transform
df["price_outlier"] = is_out

cap = df["price"].quantile(0.99)
df["price"] = df["price"].clip(upper=cap)

df["log_price"] = np.log1p(df["price"])
```

Remove only confirmed errors. A real but extreme value is information, not noise.

## 4. Verify

Prove the result is valid and that cleaning did not distort it.

### Validity checks

```python
assert df["customer_id"].is_unique
assert df["age"].between(0, 120).all()
assert (df["end_date"] >= df["start_date"]).all()

total_ok = np.isclose(df["subtotal"] + df["tax"], df["total"])
assert total_ok.all()
```

Write the domain rules as `assert` so the pipeline fails loudly when new data breaks them.

### Audit and save

```python
dropped = 1 - len(df) / n_raw
print(f"rows {n_raw} -> {len(df)} ({dropped:.1%} dropped)")

df.isna().mean()      # should be ~0 where you filled

pd.DataFrame({
    "raw": raw["age"].describe(),
    "clean": df["age"].describe(),
})

df.to_parquet("clean_2026-10-12.parquet")
```

A large shift in mean or variance between `raw` and `clean` means a step was too aggressive. Finally, wrap phases 2 to 4 in one `clean(raw)` function so the same cleaning runs on the next batch.
