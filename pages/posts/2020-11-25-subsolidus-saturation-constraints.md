---
layout: post
title: Imposing subsolidus phase saturation constraints
active: lab-book
author: Aaron S. Wolf
date: 2020-11-25
prev:
  post: 2020-11-05-MEXQAL
  title: Calculating phase composition with the Metastable eXchange EQuilibrium ALgorithm (MEXQAL)
next:
motivation: Subsolidus experiments involving multi-phase assemblages pose unique challenges to thermodynamic model development, due to their lack of an omnicomponent phase like silicate liquid. Determining chemical potentials or phase saturation affinities for model calibration & assessment must resort to more indirect methods for determining system conditions. This post focuses presenting and developing these methods and concepts.
future-work: In a future post, we will examine the more elaborate method of extracting partial chemical potential constraints from compositionally incomplete lookup phase assemblages. Additionally, we will apply these theoretical concepts to realistic subsolidus phase assemblages. Utilizing the pMELTS thermodynamic model, we will demonstrate the quantitative power of these chemical potential constraints in a model calibration setting.
key-points:
  - Saturated phases are those present in the equilibrium assemblage and jointly define the chemical potentials of the system (as required by the conditions of equilibrium).
  - Undersaturated (missing) phases are distinguished by vertical energy offsets representing saturation affinities.
  - The chemical potentials of the system (in terms of elements or oxides) can be determined from the equilibrium assemblage using thermodynamic models and linear least squares inversion.
  - Chemical potential constraints useful for model fitting are extracted from observed phase assemblages; thermodynamic models provide a lookup for system chemical potentials.
  - Oftentimes, the component space of the lookup phases is incomplete, and thus provide only partial constraints on system chemical potentials.
  - Singular value decomposition (SVD) is used to obtain component space of lookup phases and remaining system components are obtained by SVD of the residual stoichiometry of the calibration phase.
---



# Geometric view of phase saturation affinity
<!-- # [[202011091500]] Geometric view of phase saturation affinity -->

Phase saturation describes whether a phase is expected to be present in the equilibrium assemblage of a system at a particular set of conditions.
Saturated phases appear in the assemblage because they minimize the relevant thermodynamic potential at current conditions (e.g. total Gibbs energy at defined T, P, and bulk composition).
Any equilibrium phase assemblage can be described in terms of a set of chemical potentials for the system components.
In most geological applications, it is usually simplest to work in terms of elements or oxides.
This chemical potential vector describes a plane in composition-energy space where all of the saturated phases (present in the assemblage) are confined to lie in the plane.
Metastable phases necessarily lie above this plane, since they are energetically disfavored, and no phases lie below the plane if the phase assemblage is indeed the equilibrium assemblage.
The bulk composition of the system is likewise expressed as the weighted average composition of all phases present.

In thermodynamic modeling of evolving systems or ones with large kinetic barriers, it is critical to track not only the saturated phases but also the nearly stable undersaturated phases as well.
The degree of metastability (or undersaturation) is described by the saturation affinity:

$$
\mathcal{A} = -(\mu_i - \hat{\mu}_i)
$$

where $\mu_i$ is the chemical potential vector for the phase in question, $\hat{\mu}_i$ is the external chemical potentials of the system, and the saturation affinity $\mathcal{A}$ is the vertical offset between them.
(Note that this expression holds for all components, all values of $i$.)
The fact that the chemical potential plane of every phase lies parallel to---though possibly vertically offset from---the chemical potential plane of the system reflects that the phase is in metastable exchange equilibrium with the system as a whole.
It is for this reason that, at equilibrium, every phase has a single saturation affinity that is component-independent.
Additionally, the negative sign convention reflects the fact that under-saturated phases, which lie above the chemical potential plane of the system (with positive excess Gibbs energy) are taken to have negative affinities.
Using the standard convention, only reactions with positive affinities are allowed to progress forward and drive the system toward equilibrium.


# Imposing system chemical potentials on individual phases
<!-- [[202006110913]] Imposing system chemical potentials on individual phases -->

The chemical potential of each phase with respect to its endmembers is the most important quantity in all of chemical thermodynamics, since it is responsible for establishing and maintaining chemical equilibrium.
The condition of chemical equilibrium is that all phases in equilibrium must maintain equality of chemical potentials.
A typical approach to imposing this condition is to linearly map the endmember chemical potentials for a particular phase onto a common component basis set (like the elements or oxides).
Due to the linearity of chemical potentials, the equilibrium phase assemblage linearly (and uniquely) determines the chemical potentials of the system components (e.g. oxides or elements):
<!-- TK: Switch from ox to 'c' for generic system components!!! -->

$$
\nu_{\phi}^{c} \cdot \mu^{c} = \mu^{end}_{\phi}
$$

where $\mu_{sys}^{c}$ and $\mu_{\phi}^{end}$ are the chemical potentials of the system components and the endmembers for phase $\phi$, and $\nu_{\phi}^{c}$ is the stoichiometry matrix for the endmembers of phase $\phi$ in terms of system components.
If the phase of interest is an omnicomponent phase, then this expression provides a complete set of linear equations (i.e. the stoichiometry matrix is square), and the chemical potentials of the system can be determined from the phase chemical potentials using the inverse stoichiometry matrix ($\nu_{\phi}^{c} = [\mu_{sys}^{c}]^{-1} \cdot \mu^{end}_{\phi}$).
In the general case, the complete set of phases in the assemblage must be combined to infer the chemical potentials of the system.


# Inferring system chemical potentials from observed phase assemblage
<!-- [[202011231519]] Inferring system chemical potentials from assemblage -->

Even in cases lacking an omnicomponent phase (e.g. typical subsolidus phase assemblages), the chemical potentials of the system components (e.g. elements) can be determined directly from the observed phases, their compositions, and reliable thermodynamic models for each phase.
The stoichiometry matrix and chemical potential vector for the entire system are created by combining phase stoichiometries and chemical potentials for all phases in the assemblage.
For the system-wide stoichiometry matrix, we create a block matrix composed of the stoichiometry matrices for each phase stacked vertically, with one row for each endmember of every phase present in the assemblage and one column for each system component:

$$
\nu_{sys} =
\left[
\begin{array}{c}
  \nu_1  \\
  {\small \vdots} \\
  \nu_\phi  \\
  {\small \vdots} \\
  \nu_{N_\phi}
\end{array}
\right]
$$

where $\nu_\phi$ is the stoichiometry matrix for phase $\phi$, and there are $N_\phi$ phases present in the assemblage.
Similarly, we construct a vector of endmember chemical potentials:

$$
\mu^{end}_{sys} = [\mu^{end}_1 {\small \dots} \mu^{end}_\phi
{\small \dots} \mu^{end}_{N_\phi}]^T
$$

where ordering of endmembers and phases is maintained across the two expressions.
At thermodynamic equilibrium, chemical potentials are equal for all phases in the assemblage, and thus the system-wide expression holds:

$$
\nu_{sys} \cdot \mu_{sys}^c = \mu^{end}_{sys}
$$

where $\mu_{sys}^c$ is the system chemical potential expressed in system components (typically oxides or elements).
The implied chemical potentials of the system consistent with this phase assemblage is then determined by solving this system of linear equations.
For purely equilibrium theoretical modeling, this expression has an exact solution, but typical applications involving experiments must rely upon linear least squares to obtain the optimal solution, averaging over measurement and model uncertainties.

# Using subsolidus phase assemblages as a 'lookup' for chemical potential constraints
<!-- # [[202011250619]] Subsolidus phase assemblages as 'lookup' model constraints -->

In cases where an omnicomponent phase does not exist, as in most subsolidus phase assemblages, the chemical potentials of the system can be inferred directly from the equilibrium assemblage.
The previous discussions of chemical potential inference presumed that all phase models were accurate and fixed, but this general approach gains even greater utility when we consider calibrating the model for one (or more) of the phases in the assemblage.
The general idea behind this calibration strategy is that the parameters of one phase model are determined assuming that the models for all other phases in the assemblage are sufficiently accurate to be used as a dynamic 'lookup' table for the chemical potentials of the system.
Thus the assemblage is split into 'lookup phases' (whose model parameters are fixed) and the target calibration phase (whose parameters are modified during the fitting procedure).

Subsequent calibration based on these experimental constraints can be rather straightforward if we are lucky enough to have a set of lookup phases that fully span the component space of the system.
This simplified case occurs when the number of independent components for the lookup phase assemblage (given by the rank of the lookup stoichiometry matrix) is equal to that of the full system.
The system chemical potentials are thus fully determined by the lookup phase assemblage alone---via linear least squares---providing experimental constraints on the chemical potentials of the calibration phase.
A more complex, yet common, situation arises when the lookup phase assemblage does not fully span the composition space of the system, necessitating a significantly more sophisticated approach to extracting usable chemical potential constraints.




<!-- # Extracting incomplete chemical potential constraints from the lookup phase assemblage
# [[202011250651]] Incomplete chempot constraints from lookup phase assemblage

When the lookup phase assemblage does not fully span the compositional space of the system, it is only possible to constrain the chemical potentials for a subset of the system components.
In general, identifying these components and the energetic constraints they impose is non-trivial, necessitating the use of matrix decomposition methods.
We outline an automated algorithm for obtaining these constraints which is accurate and efficient, designed for use in model calibration procedures where both are high priorities.

To begin we must determine the independent components of the lookup assemblage as well as the additional components needed to describe the calibration phase.
This is readily accomplished using singular value decomposition (SVD) of the lookup stoichiometry matrix.
SVD provides a decomposition of the lookup phase endmembers, remapping them from system components to a smaller orthogonal composition space, where additional compositional degrees of freedom are needed to represent the calibration phase.
To obtain these missing compositional vectors, the stoichiometry matrix of the calibration phase is projected into the reduced lookup component space.
A residual stoichiometry matrix captures the compositional mismatch between this projected representation and the true calibration phase stoichiometry.
SVD is finally applied to this residual stoichiometry matrix, yielding the final compositional vectors needed to describe the complete phase assemblage.
With this procedure, it is clear that the energetic constraints provided by the lookup phases are restricted to the lookup component space, while additional degrees of freedom are needed to fully describe calibration phase properties. -->
