---
layout: post
title: Basis-tuned entropy approximation for complex solution phases
active: lab-book
author: Aaron S. Wolf
date: 2021-03-31
prev:
  post: posts/2021-03-12-mult-tuned-entropy-approx
  title: Approximating entropy due to mixing through multiplicity tuning
next:
  post:
  title:
motivation:
  In the process of finding the equilibrium phase assemblage within a thermodynamic calculation, it is necessary to continuously update the chemical potentials for every phase, as their compositions are refined during the approach to equilibrium.
  This motivates the construction of a computationally efficient method for approximating the Gibbs energy surface of complex solution phases, most importantly capturing the complicated behavior of the entropy of mixing term.
  The multiplicity-tuned entropy approximation, [previously discussed](posts/2021-03-12-mult-tuned-entropy-approx.html), provides a useful starting point for building a local entropy extrapolation model, but it fails to deliver the accuracy required.
  In this post, we present the basis-tuned entropy approximation, which explicitly considers modifications to the mixing species forming the basis of the solution model.
future-work:
  The local entropy approximation scheme outlined here provides a useful roadmap for how to make progress representing complex solution phases.
  In a future post, we will discuss necessary modifications to the mixing species derivation procedure, taking care to handle issues surrounding elements present at trace levels.
  We will also present a simple method for selecting the final mixing species from the set of possibilities, maximizing the compositional span of the approximate solution model.
  Finally, we will benchmark this method to explore its computational performance and accuracy for realistic geo-phases.
key-points:
  - Basis-tuned entropy approximation adjusts the assumed mixing species for the solution model, stretching and reorienting compositional space to capture asymmetries.
  - Mixing entropy depends strongly on the mixing species, with small values for off-diagonal entropy curvature terms; modeling flexibility is greatly constrained by the choice of mixing species.
  - Principal solution components represent primary directions of entropy variation and are determined by decomposition of the entropy curvature matrix (iterative approach is adopted to account for small but nonzero off-diagonal terms).
  - Local mixing species are obtained from principal solution components by imposing non-negativity bounds on elemental abundances along principal directions; 2N possible mixing species are identified and must be culled.
---

## Basis tuning to approximate local mixing entropy
<!-- ## [[202103080846]] Basis tuning to approximate local mixing entropy -->

To represent complex solution phases, we must go a step beyond multiplicity-tuning by adjusting the very basis species used to represent the solution.
Solution species can be modified by scaling their relative sizes (effectively stretching the solution space to capture asymmetry) or by constructing linear recombinations of the species (reorienting the solution space to match the primary directions of entropic change).
To obtain generalized expressions for the entropy gradient and curvature, we take molar derivatives of the mixing entropy equation:
 <!-- [[202103031634]] -->
<!-- accounting for scaling adjustments to the solution basis ($\hat{n}_i = n_i f_i$) -->
$$
\begin{align}
\frac{dS}{dn_k} &= -R f_k \left[ m_k \log \hat{X}_k + m_k - \sum_i m_i \hat{X}_i \right]\\
\frac{d^2S}{dn_k dn_l} &= -R f_k f_l \left[ \frac{ m_k }{\hat{n}_k} \delta_{kl} - \frac{(m_k+m_l)}{\hat{n}_\textrm{tot}}  + \sum_i m_i \hat{X}_i \right]\\
\end{align}
$$ {eq:basis-tuned-Sderiv}
where $f_k$ are the molar basis factors that scale the original solution species ($\hat{n}_k = n_k f_k$), $m_k$ are the multiplicity factors, and $\hat{n}_\textrm{tot} = \sum_i \hat{n}_i$ is the total number of moles in the new solution basis.
Deriving this expression involves application of the chain rule to account for the change of basis, introducing the basis factor terms in the expressions above ($d\hat{n}_k / dn_k = f_k$).
Note that the derivatives are taken with respect to the original solution species (not scaled by the basis factors).
This distinction is crucial since it relates our model back to the abundances for the original solution components, which are set by the solution composition and are unaffected by changes to the model parameters.

<!-- By examining the structure of this expression, we can greater insights into the benefits and limitations of such an approximate model [[202103240850]]. -->


## Diagonal structure of mixing entropy
<!-- ## [[202103240850]] Diagonal structure of the basis-tuned entropy approximation -->

The form of the basis-tuned entropy model underscores an implicit underlying assumption in its application, that the original solution species represent the primary units of chemical mixing.
 <!-- [[202103080846]] -->
This foundational assumption is not surprising given that the approximation is built upon the ideal mixing model, in which solution components are assumed to be independent and mix randomly and free from significant interactions.
Such independent mixing behavior manifests in the diagonal-dominant structure of the entropy curvature matrix.
This is most readily seen by considering well-behaved solutions in which both multiplicity- and basis-factors take values of order one ($m_k \sim 1$ and $f_k \sim 1$).
With such modest adjustments to the solution basis and multiplicities, the entropy curvature matrix is restricted to off-diagonal terms of order one (with $\hat{n}_\textrm{tot} \sim 1$ and $\sum_i m_i \hat{X}_i \sim 1$).
In contrast, the diagonal terms are able to dominate the entropy curvature as they are inversely proportional to the abundance of the relevant solution species.
Low abundance species can thus have arbitrarily large curvature terms that completely drown out any contribution from the off-diagonal terms.

This diagonal dominant structure is, of course, modified by the particular values of the multiplicity- and basis-factors, but we cannot escape the fact that molar abundances typically vary over many orders of magnitude.
Even though this model was designed to provide the flexibility to capture the behavior of complex species with strong ordering effects, the importance of the originally defined solution species is directly baked into the model, blocking its effectiveness as a generalized entropy approximation tool.
We might potentially sidestep this issue, however, by reorienting the solution space along the primary directions of entropic variation, effectively 'discovering' the fundamental units of chemical mixing in the solution specific to the local region of composition space.
 <!-- [[202103240930]] -->

## Determine principle components of solution mixing
<!-- ## [[202103240930]] Determine principle components of solution mixing iteratively -->

To accurately capture the mixing entropy of complex solution phases, an entropy approximation must directly represent the solution in terms of its chemical mixing components.
For simple solutions, the chemical endmembers act as the mixing components over the entire compositional solution space.
For complex ordered phases, however, the relative importance of different species within the solution depends on composition (as well as environmental conditions like temperature and pressure).
In developing an approximate local entropy model, we must have a method that can empirically determine these effective mixing components based on the local properties of the solution.

We propose applying singular value decomposition to the entropy curvature matrix to determine the principal directions of entropic change.
Since the entropy curvature is diagonally dominant when expressed in terms of the species actually undergoing mixing, we can therefore use linear algebra to determine these principal directions and from them derive the primary mixing species.
 <!-- [[202103240850]] and then  [[202103250655]] -->
One challenge to this approach is that the curvature matrix is not purely diagonal, having small but important off-diagonal terms.
We therefore must determine the mixing species iteratively: finding a best-fit solution for the basis-tuned model, adjusting the curvature matrix to account for the expected off-diagonal contribution, updating the principal mixing species, and repeating until convergence.
 <!-- [[202103080846]] -->
Due to the relative smallness of the off-diagonal terms for most solutions, this process should generally take only a few iterations to achieve satisfactory convergence.

## Derive mixing species from principal entropy directions
<!-- # [[202103250655]] Derive mixing species from principal entropy directions -->

Designing a useful entropy approximation requires determining the local mixing species themselves, rather than merely the vector that points toward them.
In selecting the mixing species, we also want to construct an approximate solution space with the largest compositional span possible to maximize the region of compositional accuracy.
Each principal entropy vector provides an array of possible mixing species going in either direction, from which we select the best example based on its contribution to the compositional span of the approximate mixing model.
This can be conceived of as a binary mixing problem, in which the original reference composition is one mixing endmember and the principal direction (or its negative reflection) is the other endmember.
Physical constraints allow only mixtures resulting in non-negative amounts of every element, so each of these compositional vectors is mapped to elemental space using the elemental stoichiometry matrix.
In general, the principal compositional vector has some positive and some negative elements, and thus non-negative abundance constraints identify a potential mixing species as the first instance of total removal of one of the elements with increased displacement from the reference composition.
In the uncommon case where a principal compositional vector points in a uniformly positive direction for every element, the vector itself represents the potential mixing species.
This calculation is repeated for the positive and negative direction of every principal vector, yielding a set of 2N possible mixing species (or N pairs).
To determine the final mixing species, we must select one composition from each of the pairs, such that the overall compositional space contains the original reference composition and also spans the largest compositional space possible.
