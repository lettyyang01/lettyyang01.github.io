---
layout: cv
permalink: /cv/
title: CV
nav: true
nav_order: 5
cv_pdf: example_pdf.pdf
description: Curriculum Vitae of Letian Yang
toc: false
---

# Curriculum Vitae

{% assign cv = site.data.cv %}  <!-- Load the cv.yml data -->

## General Information
{% include cv/map.liquid items=cv[0].contents %}

## Education
{% include cv/time_table.liquid items=cv[1].contents %}

## Research Interests
{% include cv/list.liquid items=cv[2].contents %}

## Professional Experience
{% include cv/time_table.liquid items=cv[4].contents %}

## Additional Information
{% include cv/map.liquid items=cv[5].contents %}
