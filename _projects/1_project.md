---
layout: page
title: Benign Overfitting beyond Prediction
description:
img:
importance: 1
category: academic
related_publications: false
---

**Letian Yang**, **[Dennis Shen](https://deshen24.github.io/)**

---

## Motivation

Modern machine learning has challenged classical statistical intuition: deep models with far more parameters than data can **generalize well despite overfitting** — a phenomenon known as _benign overfitting_ ([Zhang et al., 2017](https://arxiv.org/abs/1611.03530); [Belkin, 2021](https://www.cambridge.org/core/journals/acta-numerica/article/abs/fit-without-fear-remarkable-mathematical-phenomena-of-deep-learning-through-the-prism-of-interpolation/DBAC769EB7F4DBA5C4720932C2826014)). High-dimensional linear regression plays a key role in understanding this behavior ([Bartlett et al., 2020a](https://pmc.ncbi.nlm.nih.gov/articles/PMC7720150/); [Hastie et al., 2022](https://projecteuclid.org/journals/annals-of-statistics/volume-50/issue-2/Surprises-in-high-dimensional-ridgeless-least-squares-interpolation/10.1214/21-AOS2133.full)).

<div class="text-center">
{% include figure.liquid 
   path="assets/img/proj1/double_descent.png" 
   class="img-fluid rounded mx-auto" 
   caption="Double Descent Curve" 
   width="80%" %}
</div>

While much of the existing theory focuses on **prediction**, many scientific fields — especially causal inference, econometrics, and the social sciences — rely not only on predicting outcomes but also on **estimating interpretable parameters** such as treatment effects. This raises a natural and largely unresolved question:

<div style="margin-left: 2em; font-style: italic;">
Can we still trust overparameterized least squares for parameter estimation and inference?
</div>

<br>

To investigate this, we study a variant of the ordinary least squares (OLS) interpolator in which **only a subset of coefficients is implicitly regularized**, a setting we refer to as _partial regularization_. This framework mirrors modern causal workflows where a treatment coefficient must remain unregularized for interpretability, while high-dimensional nuisance covariates may be effectively penalized.

<div class="text-center">
{% include figure.liquid 
   path="assets/img/proj1/model_mat.png" 
   class="img-fluid rounded mx-auto" 
   caption="We leave θ* and β₀* un-regularized." 
   width="70%" %}
</div>

---

## What We Achieve

This project extends the study of benign overfitting beyond prediction, offering:

- **New algebraic identities** that clarify how partial regularization reshapes OLS
- **Variance estimation tools** for **inference** in high-dimensional regression
- **Conceptual bridges** between benign overfitting and modern causal estimation
- **Empirical evidence** that interpolating estimators can remain useful for parameter estimation

Together, these results suggest that **overparameterization does not inherently preclude valid inference**, provided appropriate structure and regularization are present.

---

## Publication Status

A manuscript based on this work is currently under submission to **AISTATS 2026**, and another is available on [arXiv](https://arxiv.org/abs/2411.06593).

---

## Future Directions

This project contributes to a broader effort to understand:

- High-dimensional linear models
- Overparameterization and interpolation
- Causal inference in modern regimes

If you are interested in collaborating or discussing related topics, feel free to reach out!
