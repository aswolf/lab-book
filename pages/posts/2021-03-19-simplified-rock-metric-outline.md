---
layout: post
title: Simplified Rock Metric Outline
active: lab-book
author: Aaron S. Wolf
date: 2021-03-19
prev:
  post: posts/2021-02-03-rock-fitness-metric
  title: Quantitative modeling of rock formation histories
next:
  post:
  title:
motivation:
  The following is a somewhat detailed outline for a simplified rock fitness metric to be used in modeling the formation histories of igneous rock sequences.
  This work will be incorporated into a proposal for continued development of the magma chamber simulator.
  [Past writing describing this metric](posts/2021-02-03-rock-fitness-metric.html) relied too heavily on background knowledge in statistics and numerical simulation, and was not properly tailored to the target audience of petrologist and geochemists.
  This outline thus represents a significant reworking of that previous idea, proposing how a significantly simplified version could be presented and implemented.

future-work:
  This document will be reviewed by coauthors to determine what adjustments are needed to properly engage with the desired readers.
  Given that feedback, I will expand upon this skeletal outline, some of which can be salvaged from previously written material.
  An expanded and updated discussion of our proposed rock fitness metric will be discussed in a future post.
key-points:
  -
---


## Justify need for quantitative metric
- Why do we even need something better than fit-by-eye? What does a quantitative metric give us?
- How does a fitness metric capture relative model quality?
- How does it reproduce our by-eye judgement? How does it go beyond our subjective judgement?

## How do we actually model the formation history for suites of rock samples?
- Each sample represents a snapshot of the evolutionary path of the magma chamber.
- Fine-grained ground mass represents liquid and phenocrysts represent crystal cargo, fractionating directly from that liquid.
- The liquid composition should be given by the groundmass, but for low phenocryst abundance, this is roughly equal to whole rock composition. **(How often is this assumed? Should we change name from bulk composition to liquid or groundmass or matrix composition?)**

## Simple bulk composition metric
- Create a rock fitness metric ($\chi^2$), beginning with a simplified metric considering only whole rock composition.

$$
\chi^2 = \sum_s^{\textrm{samples}} r_s^2
$$

- Initially, consider only major rock-forming oxides (which determine phase equilibria):

$$
r_s^2 (\textrm{bulk})= \frac{1}{\sigma_{\textrm{bulk}}^2} \sum_i^{\textrm{oxides}} [\Delta X_i(s)]^2
$$

- $\Delta X_i(s)$ is the compositional model residual or misfit (in wt%) of the $i^{\rm th}$ major oxide for sample $s$.
- $\sigma^2_{\textrm{bulk}}$ is the variability (or variance) describing the typical overall wt% deviation from the mean composition.
- Scaling residuals by variability effectively normalizes the metric, ensuring that reasonable models have metric values near one ($\chi^2\approx1$).

### A brief aside on matching compositional trends
- Simple explanation of compositional trajectory matching (Hausdorff distance).
- Allows us to infer/estimate model epoch for each individual sample.

## Steens major oxide modeling example
- (Steens application already introduced in proposal, right?)
- Compare hand-tuned models: Anorthisite/Gabbro recharge at low/high pressure; fractional crystallization default model
- All models fit data well, but are indistinguishable with major oxides alone
- **Include tables and figures from python notebook analysis**

## Distinguishing evolutionary models using phase compositions and chemical tracers
- While whole rock compositions track broad chemical evolution in the geologic system, individual phase compositions and chemical tracers are generally needed to break model degeneracies.
- Models incorporating divergent evolutionary processes can often produce frustratingly similar chemical trends in the major oxides.
- Chemical tracers are compositional attributes (like trace elements, radioactive or stable isotopic abundances, and trace components within particular phases) that do not affect the equilibrium phase assemblage, but are sensitive to the entire chemical and environmental history of the system.
- Phase assemblage (presence/absence) constraints are applied as a filter, only allowing models with acceptable assemblage predictions.
- For a particular rock sample, whole rock composition only provides a chemical snapshot of the magma chamber, while individual phase compositions are potentially sensitive to environmental conditions (e.g. temperature, pressure, and fO2) due to constraints imposed by chemical equilibrium.
- Potentially even more powerful are trace element, and stable & radiogenic isotopic abundances, which can constrain timing information, due to their sensitivity to evolutionary path

$$
r_s^2 = w_\textrm{bulk} \cdot r_s^2(\textrm{bulk})
  + \sum_\phi^\textrm{phases} w_\phi \cdot r_s^2(\phi)
  + \sum_t^{\textrm{tracers}} w_t \cdot r_s^2(t)
$$


- with new phase composition and chemical tracer abundance contributions to the fitness metric given by:

$$
r_s^2 (\phi)= \frac{1}{\sigma_{X_\phi}^2} \sum_j^{\textrm{components}} [\Delta X^\phi_j(s)]^2
$$

$$
r_s^2 (t)= \frac{1}{\sigma_{y_t}^2}  [\Delta y_t(s)]^2
$$


- where $\Delta X^\phi_j(s)$ is the model concentration residual of the $j^{\rm th}$ component of phase $\phi$ for sample $s$, evaluated in mol fraction (**Is it a problem if phases composition is in mol fraction and whole rock composition is in wt%? Do we need a different symbol (not X) for wt%, like m_i?**)
- The ability to combine unlike data types, like disparate chemical tracers and phase compositions, into a single rock fitness metric is critical for its utility; variability scaling factors enable this feat, expressing the model fitness in terms of the fraction of the observed variability signal captured by the model relative to the observed variability in each measurement. (In this way, the rock metric beahaves like a generalization of the familiar R-square fitting metric).

- Discussion of user-defined weighting factors; variability scaling ensures that default value of 1 for all fitting weights gives a reasonable starting point, to be refined during model exploration
- Brief discussion of how phase info and chemical tracers can help improve model epoch matching, especially as they are much more sensitive to evolutionary history.

## Steens phase composition and trace element modeling
- Demonstrate how trace elements and Anorthite composition distinguish between competing models
- Exploration of weighting factor adjustments may or may not be needed?
- Recover/contradict model preference determined by-eye, and discuss agreement/disagreement **Waiting on upcoming chemical tracer analysis. Data to be provided for all samples and all models by Valerie.**

## Distinguishing sub-groups within rock sample suites
- Explore with example of upper vs lower Steens.
- Can see based on stratigraphic data that potentially distinct groups exist.
- User provides field-based meta-data, splitting samples into potentially different categories.
- Model-dependent clustering analysis can determine if sample suites actually belong to separate evolutionary groups (do compositional, tracer, and meta-data actually reflect different evolutionary scenarios?)
- The net model residual (including all compositional and tracer information) can help discern data meaningful data groupings by clustering well-peforming data subsets for one model vs another.
- **It is very likely that for sufficiently noisy/scattered data like the Steens example, that predefined potential categories based on meta-data (like stratagraphic or textural information) will be required. This anlaysis will determine whether such categories actually point to meaningfully distinct formation histories. In some cases, chemical tracer data may alleviate the need for user-provided potential categories, but this depends on the data signal-to-noise.**
