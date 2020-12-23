---
layout: post
title: 'Urgently seeking equilibrium: Manuscript outlines for equilibrium algorithms'
active: lab-book
author: Aaron S. Wolf
date: 2020-12-11
prev:
  post: 2020-12-04-basic-solution-perturbation-models
  title: Basic composition-perturbation models for solution phases
next:
  post: 2020-12-18-equilibrium-paper-draft
  title: Urgently seeking equilibrium Working Draft (Paper I)
motivation: For this week, I have developed an article template for use with the markdown-based 'pandoc-scholar' software. It uses a simplified (hassle-free) markdown input file, which is then processed to simultaneously produce many output formats including html, pdf, latex, docx (word), odt, epub. The goal is to produce a manuscript for submission to journals where only minor modifications (if any) need be applied to the final submitted file. When in doubt, let the copy editors take care of it.

  With this manuscript preparation in mind, I present an outline for the current equilibrium algorithm focused manuscripts. These outlines combined with previous lab-book posts will form the basis for a first draft using the new pandoc-scholar-template I have developed.
future-work: In future weeks, these outlines will be combined with the posts already made to this site to produce a rough draft of the first paper. This is already in progress, and will be posted here in future weeks, once greater revision has been carried out. The manuscript uses the same pandoc-scholar-template described and linked above. This approach appears to be incredibly powerful for keeping things simple and professional, and reducing unnecessary work in porting lab-book posts directly into the manuscript.
key-points:
  - markdown approach to manuscript creation is simple and convenient
  - allows focus to remain on content rather than formatting details
  - outline for equilibrium papers is presented
  - draft paper is underway using the markdown template
---

# Markdown-based manuscripts with pandoc-scholar



A lot of time is wasted on formatting for journals that completely reformat the article to their liking in the final stage anyway.
**Let's avoid that.**

The 'pandoc-scholar' software provides a set of generalized templates that automatically creates nice academic manuscript files in a huge set of formats simultaneously.
This allows you to write the manuscript in plain text markdown, and then distribute to colleagues or submit to journal in any required format.
The key insight to this approach is **Do not waste effort fiddling with the format**.
The manuscript file contains all the content, and journals can worry about formatting details.
Any changes that are absolutely required for submission should be applied manually to the output file just before submission.

I have customized and extended this approach by developing my own [pandoc-scholar-template](https://github.com/aswolf/pandoc-scholar-template).
This is presented in the form of a manuscript that describes the markdown-to-manuscript capabilities it demonstrates.
* The current version of the pandoc-scholar-template [manuscript can be found here](pandoc-scholar-template.html), presented in both html and pdf formats.


# Equilibrium Algorithms Manuscript Outlines

Below I include rough outlines for a pair of companion papers in preparation describing our new computational equilibrium algorithms.


## The problem **[[lab-book-post]]**


* modeling equilibrium assemblages is generally very slow, holding back planetary understanding
* especially problematic in Monte Carlo applications (e.g. exoplanet studies, MCS for igneous suite inference)
* Existing tools are often too slow, not sufficiently robust, or rely on special conditions (e.g. melt-present)
  - MELTS
  - THERMOCALC
  - THERIAK
  - PerpleX (inaccessible composition space)
  - Hephestos
* Many tools are locked to specific thermodynamic database making comparison difficult (e.g. MELTS, THERMOCALC, Hephestos)

### Paper 1
* title: 'Urgently seeking equilibrium: I. Rapid and robust phase saturation calaculations with the Metastable eXchange EQuilibrium ALgorithm (MEXQAL)'
* MEXQAL phase saturation algorithm
* Equilibrium of individual phases with environment
* motivate BOTH papers 1 and 2
* optimized algorithm underlying full equilibration algorithm (described in paper 2)
* Metastable Equilibrium phase properties obtained for imposed environmental conditions
* Consider simple vs Complex phases
* Geological Benchmarks **[[lab-book-post]]**
  - simple to complex phases
  - robust convergence
  - fast results
  - compare w/ existing tools??
  - **Objective C implementation likely required**
* Miscibility gaps and exsolution **[[lab-book-post]]**
  - employs simplified deCapitani algorithm
* Miscibility gaps for complex phases  **[[lab-book-post]]**
  - w/ structural transition (like Cpx)
  - include in paper 1 if possible
  - special case of phase with identical endmembers should be possible
  - 3 phase triangle
* Gap finder algorithm? **[[lab-book-post]]**
  - **Do we need a method to trace miscibility gaps?**
  - Find exteremum of concavity of Gibbs surface
  - Use simulated annealing or MCMC to explore/map-out concave down regions of composition space
  - Then run MEXQAL to trace boundary edges
  - comment on calibration opportunities
* application demos:
  - exsovled Fe-rich liquid phase vs SiO2 rich
  - Feldspar geo-thermometer
  - cpx 3 phase triangle?

### Paper 2
* title: **Urgently seeking equilibrium: II. Computing phase assemblages with confidence using the sunken hull method**
* Equilibrate full assemblage w/ sunken hull method
* Especially subsolidus assemblages
* Robust fallback for optimized MELTS algorithm
* use MEXQAL finds equil state for individual phases
* Sunken Hull Algorithm
* demonstrate efficacy
* Benchmark speed
* Show utility on subsolidus assemblages (MELTS & Stixrude databases)
* application to pyrolite, MORB, etc
