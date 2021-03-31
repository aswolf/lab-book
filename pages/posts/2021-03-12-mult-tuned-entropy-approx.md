---
layout: post
title: Approximating entropy due to mixing through multiplicity tuning
active: lab-book
author: Aaron S. Wolf
date: 2021-03-12
prev:
  post: posts/2020-12-04-basic-solution-perturbation-models
  title: Basic composition-perturbation models for solution phases
next:
  post: posts/2021-03-31-basis-tuned-entropy-approx
  title: Basis-tuned entropy approximation for complex solution phases
motivation:
  To construct a local regular solution approximation that accurately extrapolates in composition space, it is important to separate entropy and enthalpy contributions.
  While it is possible to directly fit the Gibbs curvature matrix to determine regular solution mixing parameters ([see previous post](posts/2020-12-04-basic-solution-perturbation-models.html)), this approach ignores important complications due to ordering that dominate entropy for complex solutions.
  It is much better, instead, to directly model the entropy surface (which is primarily responsible for the behavioral richness of most complex solution phases), and then combine this entropy approximation with a simple quadratic representation of the enthalpy of mixing.
  In this post, we outline a straightforward framework for modeling the local entropy surface due to mixing, testing it against the properties of geological phases under realistic igneous conditions.
  We focus this benchmarking effort on the simplest implementation of the local entropy model, multiplicity-tuning, to build an understanding of its strengths and weaknesses, before moving on to the full parameterization in a future post.
future-work:
  The poor performance of simple multiplicity tuning for complex solutions motivates us to introduce an additional refinement to the local entropy model, through tuning of the basis components for the solution.
  In a future week, we will derive the non-linear expressions for approximating entropy with basis-tuning, in the hope that they will dramatically improve extrapolation accuracy for complex ordered solutions.
key-points:
  - A local mixing entropy approximation is proposed; multiplicity & basis factors for each species component scale and stretch composition space to best match the shape of the entropy surface.
  - Linear least squares is used to determine multiplicity factors from local entropy gradient.
  - Monte Carlo perturbation benchmark tests multiplicity-tuned entropy approximation on geo-phases.
  - The logarithmic form of ideal entropy of mixing causes entropy gradient errors to grow like the fractional perturbation magnitude for each component, providing a rough upper error bound for any approximate solution model.
  - Extrapolation accuracy is found to be good for simple solutions (e.g. liquid & feldspar) but poor for complex phases with ordering (e.g. clinopyroxene & spinel).
---

## Local entropy of mixing approximation for complex phases
<!-- # [[202103031634]] Local entropy of mixing approximation for complex phases -->

A local entropy approximation represents the entropy surface of a solution phase in the region surrounding a reference composition.
This approximation provides a computationally efficient and accurate method for calculating evolving phase properties as the composition of the solution is progressively altered.
The local mixing entropy is represented with a modified form of the standard ideal entropy of mixing, applied to a set of dependent species that fully span the compositional space (in place of independent endmember components):
$$
S_{mix} = -R \sum_i m_i \hat{n}_i \log{\hat{X}_i}
$$ {#eq:modified-Smix}
where $\hat{n}_i$ are the molar abundances of the dependent species in the solution, and $m_i$ are the effective multiplicities for each species that effectively scale the entropic mixing effect for each species.
We will show that introducing variable multiplicity factors for each species is sufficient to approximately capture the behavior of the simpler solution phases, like the regular (and sub-regular) solution models describing silicate liquids and feldspar.
More complex solution phases, like clinopyroxene and spinel, require additional modeling flexibility to capture the strong asymmetric effects of atomic ordering within the solution.
Adjustable molar basis fractions can provide this additional flexibility by redefining the molar formula unit of each species ($\hat{n}_i = n_i / f_i$), effectively introducing asymmetry into the solution model by stretching the compositional solution space.
We will begin by exploring the simpler case of individual multiplicity factors for each species, demonstrating its efficacy for simpler solution phases, before adding the complication of basis fractions.
 <!-- [[202103050855]] -->


## Multiplicity tuning for approximating mixing entropy
<!-- # [[202103050855]] Multiplicity tuning for approximating mixing entropy -->

A tuned multiplicity solution represents one of the simplest non-ideal local entropy approximations, introducing individual multiplicity factors specific to each species in the solution.
By taking molar derivatives of the mixing entropy equation (Eq. @eq:modified-Smix), we derive expressions for the entropy gradient and curvature for this model:
$$
\begin{align}
\frac{dS}{d\hat{n}_k} &= -R m_k \log \hat{X}_k - R m_k + R \sum_i m_i \hat{X}_i\\
\frac{d^2S}{d\hat{n}_k d\hat{n}_l} &= - \frac{R m_k }{\hat{X}_k} \delta_{kl}+ R(m_k+m_l)  - R \sum_i m_i \hat{X}_i\\
\end{align}
$$ {#eq:mult-tuned-Sderiv}
where $\delta_{kl}$ is the Kronecker delta, which takes a non-zero value only when $l$ and $k$ are equal.
These expressions reduce to a strictly ideal solution when all multiplicities are set to unity ($m_k=1$).
While it is tempting to construct a simpler entropy gradient model without the second and third terms in the gradient expression above, it is a grievous mistake that produces an unphysical description of entropy.
These additional terms---which cancel for the ideal solution---are absolutely necessary to maintain the requisite symmetry of the curvature matrix, introducing the required multiplicity-dependence for both species $k$ and $l$.

These expressions reveal a strict linear dependence on multiplicity factors, enabling the use of linear least squares methods to fit a local entropy model.
The fitted multiplicity parameter values can thus be determined directly from the calculated entropy gradient evaluated at a reference composition.
The accuracy of this model depends strongly on the complexity of the particular solution phase, with phases displaying strong ordering behaviors requiring a more complex modeling approach (that includes adjustable basis fractions).
 <!-- [[202103050941]] -->


## Benchmarking entropy of tuned-multiplicity approximation
<!-- # [[202103050941]] Benchmarking entropy of tuned-multiplicity approximation -->

To test the real-world accuracy of the tuned-multiplicity model for mixing entropy, we apply it to phase compositions derived for a realistic geologically typical situation.
 <!-- [[202103050855]] -->
The phases and compositions used in this benchmark test are derived from simulating the equilibrium crystallization of MORB liquid ([see previous post](posts/2020-11-12-MEXQAL-geo-application.html)).
We begin by fitting the approximate models for each phase: liquid (liq), feldspar (fsp), clinopyroxene (cpx), and spinel (spl) at geologically-relevant temperature, pressure, and composition.
To quantify the accuracy of these fitted models, we then adopt a simple Monte Carlo perturbation approach.
Starting with the appropriate geo-reference compositions, we randomly perturb the fractional amount of each solution species and recalculate the entropy and entropy-gradient.
Deviations of the local approximation from reality are calculated for a large number of random compositional perturbations and summarized by the average rms error.


## Expected compositional extrapolation error for entropy gradient
<!-- ## [[202103081121]] Compositional extrapolation error for entropy gradient -->

To place the Monte Carlo benchmarking results into a broader context, we derive a simple expression for the expected growth in the compositional extrapolation error.
Due to the logarithmic composition-dependence of the entropy of mixing, we consider random logarithmic (or fractional) compositional perturbations, where $\delta \hat{X}$ describes the fractional adjustments to the abundances of each species in the solution away from their reference values.
We can approximate the entropy gradient for an ideal solution as:
$$
\frac{1}{R}\frac{dS}{d\hat{n}} \sim \log \hat{X} \approx \log [\hat{X}_r (1 + \delta \hat{X})] \approx log\hat{X}_r + \delta \hat{X} \approx \frac{1}{R}  \left. \frac{dS}{d\hat{n}}\right|_r + \delta \hat{X}
$$
where $\hat{X}_r$ is the reference composition.
We can thus see that the perturbation adjustment adds linearly with the reference entropy gradient, providing a trivially simple form for the expected error magnitude:
$$
\Delta (dS / d\hat{n})/R  \sim \delta \hat{X}
$$
Potential compositional perturbations are spread over many orders of magnitude, and thus it is useful to recognize that the (scaled) logarithmic error in the entropy gradient falls on the one-to-one line when plotted against average perturbation magnitude.
For non-ideal solution phases, we should consider the modified local entropy approximation in place of an ideal solution, but the form of the entropy gradient is nearly identical (see Eq. @eq:mult-tuned-Sderiv), differing only in an additional scaling factor and constant offset terms involving the multiplicity factors.
We thus expect a similar linear growth of extrapolation error, which falls close to but offset from the one-to-one line, depending on the effective species multiplicities.
The one-to-one line thus represents the average expected error growth assuming fixed entropy gradient (neglecting composition dependence), and thus the performance of a particular compositional model can be measured against this theoretical default.


## Approximation performance on realistic igneous phases

The Monte Carlo benchmarking process is repeated for a range of perturbation sizes to explore how accuracy scales with the extrapolation magnitude and also how it compares with the mathematically expected error bound.
Figures @fig:simple-mult-benchmark and @fig:complex-mult-benchmark show the results of this Monte Carlo benchmark analysis, where shaded regions represent the range of approximation errors for the entropy gradient across all species components.
For comparison, the dashed line in each figure marks the one-to-one line, corresponding to model deviations that perfectly track the compositional perturbation size.

![Multiplicity-tuned approximation for simple solutions.](figs/202103070647-mult-tuned-dSdn-error-simple-soln.png){#fig:simple-mult-benchmark width=100%}

![Multiplicity-tuned approximation for complex solutions.](figs/202103070646-mult-tuned-dSdn-error-complex-soln.png){#fig:complex-mult-benchmark width=100%}

As shown in the figures above, model deviations grow in tandem with the size of the compositional extrapolation, but these deviations remain relatively small for simple solution models like silicate liquid and feldspar.
For more complex solution models involving considerable preferential ordering (like clinopyroxene and spinel), the same growth in model deviations is seen but with a baseline accuracy that is considerably worse.
Performance for these complex phases is typically no better than the expected accuracy limit neglecting all composition dependence, thus preventing useful application of this model.
