---
layout: page
title: Research
permalink: /projects/
description:
nav: True
nav_order: 3
---

_“We do not have knowledge of a thing until we have grasped its cause.” — Aristotle_

I believe the world is shaped by causal forces, and I am committed to understanding their structure through rigorous statistical methodology. Modern datasets are vast and deeply informative; statistical models distill the patterns they contain and illuminate the mechanisms that govern real systems. When principled modeling meets domain knowledge, data cease to be mere observations: they become evidence of how and why things happen.

Guided by this perspective, my research and career interests lie at the intersection of **causal inference** and **high-dimensional statistical modeling**.

---

<!-- _pages/projects.md -->
<!-- Each card below is generated from a file in _projects/ (title + description), ordered by `importance`. -->
<div class="projects">
  {% assign sorted_projects = site.projects | sort: "importance" %}
  <div class="container">
    <div class="row row-cols-1">
    {% for project in sorted_projects %}
      {% include projects_horizontal.liquid %}
    {% endfor %}
    </div>
  </div>
</div>
