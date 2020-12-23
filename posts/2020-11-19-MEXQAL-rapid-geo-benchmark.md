---
layout: post
title: Least-squares-optimized MEXQAL calculations for geo-phases
active: lab-book
author: Aaron S. Wolf
date: 2020-11-19
prev:
  post: 2020-11-12-MEXQAL-geo-application
  title: Benchmarking MEXQAL method for geologically-relevant phases
next:
  post: 2020-12-04-basic-solution-perturbation-models
  title: Basic composition-perturbation models for solution phases
motivation: In the previous section, we demonstrated how the MEXQAL algorithm can applied to geologically-relevant phases and is capable of accurately determining phase compositions under typical modeling conditions. These calculations used the direct iterative convergence method described previously (modeled after the approach of @Ghiorso2013), ensuring relatively fast and accurate results. But low-level routines like MEXQAL are called thousands of times (or more) in a typical large-scale simulation application, such as tracking an evolving phase assemblage or calibrating a new thermodynamic model requiring many repeat calculations with slightly altered parameter values. With such highly repetitive applications comprising the primary use-cases for this algorithm, speed is of the utmost importance. We are therefore motivated to develop a modified procedure that linearizes the compositional update procedure to obtain further performance gains. This section focuses on approximating the chemical potential expression for the phase by shifting to logarithmic-composition space, enabling the use of highly optimized linear least-squares methods to update the composition with each iteration, completely replacing the inner iteration loop discussed previously with a single optimal-update step. While this is in principle fairly straightforward, additional complications arise surrounding the use of degenerate species (rather than independent components)---as required for complex multi-site solution phases like clinopyroxene and spinel---and the necessary mathematical transformations are also derived and presented below.
key-points:
  - Exchange equilibrium conditions can be found approximately by transforming to log-composition space; this yields a set of coupled linear equations, with $\Delta \log X_i$ and $A$ as unknowns, that can be solved using least squares.
  - Fractional composition adjustments must be rather small (<0.1), otherwise the accuracy of the approximate normalized composition equation suffers.
  - For complex phases, the Gibbs curvature matrix must be remapped to dependent species space, inflating the matrix to describe how species' chemical potentials change with species abundances; this operation relies only on the known stoichiometry of each species.
  - Testing of igneous phases under realistic magmatic conditions reveals excellent performance for simple phases like liquid and feldspar, but only modest gains for complex phases like spinel and clinopyroxene.
  - Added computational cost of the least squares approach could be avoided for most early iterations by accepting direct compositional update if any components exceed a threshold value.
---

## Linearized least squares affinity solution w/ MEXQAL
<!-- # [[202011061439]] Linearized least squares affinity solution w/ MEXQAL -->

An approximate coupled solution for composition and affinity of a solution phase can be determined in a single step by linearizing the exchange equilibrium condition with respect to fractional changes in composition.
Translating the curvature matrix to log-space results in an expression whose compositional-dependence is linear in log-compostion terms $(logX_i)$.
Since metastable equilibrium holds simultaneously for each component of the solution, we obtain an approximate system of equations with N constraints:

$$
A + \sum_j \frac{\partial \mu_i}{\partial \log X_j} \cdot \delta X_j  =  \hat{\mu}_i - \mu_i^\textrm{ref}
$$

where $\delta X_j = \log X_j - \log X_j^\textrm{ref}$ is the logarithmic change in the composition with respect to the reference, approximately equal to fractional changes as long as they are small.
Yet there remains an additional unknown, the saturation affinity of the phase $A$, which requires a final normalized compositional constraint (or closure condition), ensuring that the sum of all components equals 1.
Though we cannot perfectly express this in log-space, it can be approximated as:

$$\sum_i X_i^\textrm{ref} \cdot \delta X_i = 0$$

where the $\delta X_i$ provide fractional adjustments to the reference composition, and since the reference composition is properly normalized, these changes must all sum to zero to ensure that the final result remains (approximately) normalized.

Combined, the two expressions above provide a system of N+1 linear equations constraining the value of N+1 unknowns ($\delta X_i$ and $A$).
They can thus be rapidly solved using any standard linear solver.

## Restraining fractional composition adjustments
It is important to recognize that the inherent assumption that fractional composition adjustments are small will hold true near the end of the convergence process, but may be violated quite strongly at the beginning, depending on the quality of the initial guess.
In practice, we find that this poses no problem for most simple solutions (like feldspar or silicate liquid), but does indeed cause serious errors for more complex solutions involving many dependent species, especially when a reasonable initial compositional guess is unknown and we are forced to rely upon the endmember-based initialization method described in @Ghiorso2013.
To address this, we test the optimal suggested composition update in each iteration to verify that none of the suggested magnitudes exceed a sensible cutoff (like ~0.01).
If any of the solution values exceed this threshold, indicating an unacceptably large composition adjustment that violates the assumptions of the least squares approach, then the suggestion from the direct update method is utilized for that iteration.
<!-- Address in next section by adding constraints on composition adjustments -->




## Re-mapping chemical potentials & Gibbs curvature to dependent species
<!-- [[202011131534]] Mapping chempot & Gibbs curvature to dependent species -->

For complex solutions with multi-site mixing, it is crucial to transform the composition to dependent species space, which raises additional mathematical challenges associated with deriving properties of the dependent species from those of the endmember components.
This transformation rests directly on the species stoichiometry matrix:
$$\tilde{\nu}_{ij} = \partial n_j / \partial \tilde{n}_i$$
which describes how the number of moles of the $j^\textrm{th}$ endmember component ($n_j$) changes in response to changes in the amount of the $i^\textrm{th}$ species ($\tilde{n}_i$).
The chemical potentials of the species are then given simply by the stoichiometrically-weigthed average of the endmember chemical potentials:

$$
\tilde{\mu}_i = \sum_j \tilde{\nu}_{ij} \mu_j
$$

Likewise, we must also find a transformation for the Gibbs curvature matrix, which describes the linear dependence of chemical potentials on changes in molar composition, but it does so in endmember component space.
When solving problems in the larger degenerate compositional space of dependent species, we must mathematically inflate this matrix to describe how the chemical potentials of these species change as their quantity is altered.

$$
\frac{\partial \tilde{\mu}_i}{\partial \tilde{n}_l} = \sum_k \sum_j \tilde{\nu}_{ij} \frac{\partial \tilde{\mu}_j}{\partial \tilde{n}_k} \tilde{\nu}^T_{kl}\\
\frac{\partial \tilde{\mu}}{\partial \tilde{n}} = \tilde{\nu}  \cdot \frac{\partial \tilde{\mu}}{\partial \tilde{n}} \cdot \tilde{\nu}^T
$$

where $\nu^T$ is the transpose of the stoichiometry matrix (oriented with species as columns rather than rows).
This transformation is derived by applying the stoichiometry matrix once to calculate the linear dependence of species on the molar endmember composition, and then a second time to calculate their dependence on the molar abundance of the species themselves.
Since the stoichiometry matrix is unchanging and fixed by the composition of each species, this new Gibbs curvature matrix for dependent species retains all the linearity of the original in endmember component space, thereby allowing an identical least squares approach to solve for dependent species abundances.

## Real-world performance benchmarks
Using the methods described above, we implement a modified form of the MEXQAL method optimized to outperform the standard direct update approach previously reported.
For simple solutions like Feldspar or silicate liquid, we find sigificant speed and iteration gains of order ~50% drop in computation time and a reduction of the necessary iterations by a factor of ~3.
Unfortunately, the story is less straightforward for the complex solutions like spinel and clinopyroxene.
We are pleased that the algorithm shows clear convergence and accurate results, but the current speed gains are far more modest.
Further investigation reveals that this is due in large part to the fact that the suggested optimal composition adjustments exceed a reasonable threshold of 0.1 for the vast majority of the iterations.
This implies, perhaps unsurprisingly, that the least-squares approach is really only useful in the final stages of the convergence loop, reducing the last dozen iterations or so to only 2 or 3.

At the very least, this implies that most of the computational overhead for the least-squares approach can be avoided using the suggested composition adjustment from the direct method.
Only if the direct adjustment is smaller than the threshold value, should we proceed with the least squares optimization.
This would avoid calculation of the gibbs curvature matrix as well as the least-squares refinement for the bulk of the initial iterations.
Speculatively, it is also possible that most solution phases are more accurately approximated in linear composition space (at least for the most abundant species).
Perhaps using a linear compositional adjustment vector combined with bounded least squares minimization (to prevent negative species quantities) could dramatically improve the quality of the approximation.
This will be further explored in a future discussion.
