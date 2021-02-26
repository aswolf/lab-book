---
layout: post
title: Thermochemical Database for vaporization/condensation
active: lab-book
author: Aaron S. Wolf
date: 2021-01-17
prev:
  post: 2021-01-08-vapor-rock-theory
  title: 'Thermodynamics of Vaporized Rock'
next:
  post: 2021-01-25-vaporock-validation-challenges
  title: 'Challenges with experimental validation of vaporization modeling'
motivation:
  Having demonstrated the strong scientific motivation for better understanding silicate vaporization processes, we propose to develop a new code VapoRock, which combines the MELTS liquid model (as implemented by the ThermoEngine code) with gas-species properties from the thermochemistry tables of NIST-JANAF and @Lamoreaux1984 & @Lamoreaux1987, enabling coexisting vapor speciation calculations similar to those provided by the MAGMA code. VapoRock is fully capable of determining gaseous species abundances in contact with a magma, represented using the MELTS liquid model. MELTS has been rigorously tested and validated by the petrology community over the last 25 years. Currently, the closed-source tool MAGMA is the only one available that is capable of predicting gas abundances in equilibrium with a magma ocean. Thus a major benefit of our project will be the extension of the open-source ThermoEngine code to treat magma-vapor systems as a new tool for the community.
future-work:
  In this post, we have described the remaining requisite pieces needed for practical thermodynamic computations. At this stage, we are fully capable of performing predictive models of silicate vapor outgassing, to be presented in a future post. Additionally, we will carry out and analyze validation calculations to compare the results of VapoRock to the existing vapor software MAGMA. In particular, we will focus on the qualitative similarities and work to understand the root cause of key quantitative differences.
key-points:
  - A thermochemical database for liquid/vapor coexistence in geologic systems is constructed based on the MELTS thermodynamic model combined with lab-based vapor species thermal models at 1bar.
  - Liquid components and vapor species are converted to common oxide basis (system components) to enable simple equilibrium calculations
  - Thermochemical data tables for vapor compounds are used to calculate relative abundances of vapor species; NIST-JANAF, IVTAN, and compillations of Lamoreaux are used and are in general agreement.
  - Conversion of liquid chemical potentials from phase endmembers to system components is given by dot product of inverse liquid stoichiometry matrix with calculated liquid phase chemical potentials.
---

## Liquid/Vapor equilibrium thermochemical database
<!-- # [[202101111354]] Liquid/Vapor equilibrium thermochemical database -->

Modeling coupled liquid-vapor evolution relies upon an accurate thermochemical database that spans the compositional range of important geologic and planetary systems.
We adopt the chemical system of MELTS [@Ghiorso1995], a petrologic modeling tool which has stood the test of time and has also proven useful in simulating condensation of the early solar nebula as part of the no longer operable VAPORS code [@Ebel2000].
Consequently, our thermochemical database describes a subset of the $SiO_2$--$MgO$--$FeO$--$Fe_2O_3$--$Al_2O_3$--$CaO$--$Na_2O$--$K_2O$--$H_2O$--$TiO_2$--$Cr_2O_3$--$P_2O_5$ system, to which liquid and vapor compounds are readily converted using stoichiometric constraints.
 <!-- [[202101121125]] -->
<!-- strip out tbl refs since not working yet in open lab-book (FIX LATER) -->
The MELTS model itself adopts liquid endmember components (see Table below) that were chosen to maximize model accuracy (during both calibration and extrapolation) while retaining a simple regular solution form.
To couple with MELTS, we adopt a description of the potential vapor species in this chemical system, considering all lone elements and energetically favorable molecular species.

|system components (c)|liquid components (l)|vapor species (v)|
|:---|:---|:---|
|$SiO_2$|$SiO_2$|$Si, Si_2, Si_3, SiO, Si_20_2, SiO_2$|
|$MgO$|$Mg_2SiO_4$|$Mg, Mg_2, MgO$|
|$FeO, Fe_2O_3$|$Fe_2SiO_4, Fe_2O_3$|$Fe, FeO$|
|$Al_2O_3$|$Al_2O_3$|$Al, Al_2, Al_2O, AlO, Al_2O_2, AlO_2$|
|$CaO$|$CaSiO_3$|$Ca, Ca_2, CaO$|
|$Na_2O$|$Na_2SiO_3$|$Na, Na_2, Na_2O, NaO$|
|$K_2O$|$KAlSiO_4$|$K, K_2, K_2O, KO, KO_2$|
|-|-|$O, O_2$|
| |||
|$H_2O$|$H_2O$|-|
|$TiO_2$|$TiO_2$|-|
|$Cr_2O_3$|$MgCr_2O_4$|-|
|$P_2O_5$|$Ca_3(PO_4)_2$|-|

  Table: Thermochemical database of VapoRock.
  <!-- {#tbl:chem-sys} -->
<!-- Table ref removed until working xnos activated in open lab-book -->

This chosen set of system components and vapor species is comparable to the model space of the MAGMA code [@Schaefer2004;@Fegley1987].
The data describing these vapor species is obtained from a variety of (overlapping) thermochemical databases found to be in generally good agreement for these modeling purposes.
 <!-- [[202101121012]] -->


## Thermochemical tables for vapor species modeling
<!-- # [[202101121012]] Thermochemical tables for vapor species modeling -->

High-temperature thermochemical models rest upon comprehensive databases of vapor species energetics.
Assuming low densities conditions where the ideal gas approximation holds, a complete model can be built solely from empirical Gibbs energy models.
These models are typically presented as tabular data evaluated on a grid of temperatures, suitable for interpolation lookup, or as empirical equations as a function of temperature.
The most widely used example is the NIST-JANAF thermochemical database, which contains an exhaustive set of materials described by both lookup tables and analytic expressions (using the Shomate equations).
 <!-- [[202006090659]] -->
Likewise, the IVTAN thermochemical tables provide comprehensive thermal data on a similarly large set of compounds (derived from Russian-based rather than American research efforts), though digital access to this database is significantly more challenging than the free and open access to the JANAF tables.
A more limited dataset focused specifically on vaporized oxides is provided by @Lamoreaux1984 and @Lamoreaux1987, which uses a polynomial description of relative Gibbs energy changes ($\Delta G / RT$).
As one might hope, the energetics described by each of these independent data sources are in generally reasonable agreement (typically at the level of $\pm100 J$), sufficient for vaporization modeling purposes.
This agreement is particularly important as most of these data sources are incomplete in some respect, and thus some mixing of sources is typically required to obtain a full description of all compounds of interest.



## Converting liquid/vapor compounds to common oxide basis
<!-- # [[202101121125]] Converting liquid/vapor compounds to common oxide basis -->


To carry out equilibrium liquid/vapor computations with our thermochemical database, we first convert both liquid components and vapor species into their equivalent representation using system components (oxides) with additional oxygen (vapor) as needed to ensure stoichiometric balance.
 <!-- [[202101111354]] -->
Some representative examples are given for a number of liquid components and vapor species of varying complexity:
$$
\begin{aligned}
&\textbf{liquid components}\\
Fe_2O_3(\ell) &= Fe_2O_3(c)\\
Fe_2SiO_4(\ell) &= 2 FeO(c) + SiO_2(c)\\
KAlSiO_4(\ell) &= \frac12 K_2O(c) + \frac12 Al_2O_3(c) + SiO_2(c)\\
&\textbf{vapor species}\\
Na_2O(v) &= Na_2O(c)\\
NaO(v) &= \frac12 Na_2O(c) + \frac14 O_2(v)\\
Si_2(v) &= 2 SiO_2(c) - 2 O_2(v)\\
Al_2O_2(v) &= Al_2O_3(c) - \frac12 O_2(v)\\
\end{aligned}
$$
where chemical compounds exist in the liquid ($\ell$) or vapor ($v$) phase are represented using system components ($c$), typically oxides.
Due to the linearity of chemical potentials, this allows us to work in a common basis of oxides while interfacing between the condensed and vaporized portions of the system.



## Chemical potentials for liquid-dominated system w/ MELTS
<!-- [[202101130617]] Chemical potentials for liquid-dominated system w/ MELTS -->

In liquid-dominated systems---where the liquid phase houses the majority of every element---the conditions of equilibrium are entirely dictated by the energetics of the liquid phase.
In typical applications, state of the system in terms of bulk composition, pressure, temperature, and oxygen fugacity are externally imposed or evolved through time, and thus the properties of the liquid state set the chemical potential of the system.
We employ the 12-component MELTS liquid model [@Ghiorso1995] to predict liquid properties and thus rapidly calculate the chemical potentials of the system as a function of current system conditions $(T, P, X, f_{O_2})$.
This computation provides the chemical potentials in terms of the liquid endmember components, but we can readily convert to system components by relying on the linearity of chemical potentials.
Generalizing the specific examples given, compositional conversion of the liquid endmembers is determined by stoichiometry:
 <!-- [[202101121125]] -->
$$
\phi_i^\ell = \sum_{j} \nu_{ij}^\ell c_j
$$
where $\phi_i^\ell$ is the $i^{th}$ endmember component for the liquid phase, $c_j$ is the vector of basic system components (like oxides), and $\nu_{ij}^\ell$ is the stoichiometry matrix for the liquid phase reflecting the composition of the $i^{th}$ endmember in terms of the $j^{th}$ system component.
Given the linearity of chemical potentials, the relation between phase and system chemical potentials can be written:
$$
\mu_{i}^{\ell} = \sum_j \nu_{ij}^{\ell} \mu_j
$$
which is inverted to obtain the expression needed for thermodynamic computation:
$$
\mu_j = \sum_i \tilde{\nu}^\ell_{ji} \mu_i^\ell
$$
where $\tilde{\nu}^\ell = ({\nu^\ell})^{-1}$ is the inverse stoichiometry matrix for the liquid phase.
Thus we obtain the chemical potentials of the system in terms of the desired (oxide) components through a simple dot product with the inverse liquid stoichiometry matrix.
Having brought both the liquid endmember and vapor species into a common basis of system components, we are able to meaningfully combine the thermochemical data on each phase to preform useful computations.


# References
