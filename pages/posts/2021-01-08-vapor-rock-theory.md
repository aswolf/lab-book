---
layout: post
title: Thermodynamics of Vaporized Rock
active: lab-book
author: Aaron S. Wolf
date: 2021-01-08
next:
  post: 2021-01-17-thermochem-vapor-database
  title: 'Thermochemical Database for vaporization/condensation'
motivation:
  Silicate vapors receive little attention in many geoscience contexts, but these outgassed vapors play key roles in planetary evolution spanning the full range of planetary length- and time-scales, from the earliest proto-dust grains to the eventual erosion and erasure of entire rocky planets.
  Thermodynamic equilibrium ensures that rocky silicate vapors are always present above condensed (liquid or solid) phases, though typically at very low pressures.
  In most situations, these vapors are (rightly) ignored when other external processes dominate, such as the biotically controlled surface conditions on Earth.


  But outgassed vapors are critical in key high-temperature stages of planetary evolution, which appear throughout the planet's lifetime.
  Before planets or rocks even exist, vapors condense from the stellar nebula to form the original planetary building blocks.
  In later stages of planet formation, giant impacts are likely ubiquitous and readily produce global-scale melting and vaporization.
  Immediately following planetary accretion, rocky planets are dominated by deep magma oceans (especially after giant impacts) that exchange both volatile and refractory elements with silicate vapor and steam atmospheres.
  During the prolonged secular evolution of the planet, volcanic outgassing controls the long-term exchange of matter (primarily volatile and moderately volatile elements) between interiors and atmospheres.
  And finally, the terminal stage of rocky planet evolution, reserved for those parked too close to the surface of their parent star, involves progressive vaporization and whole-scale erosion by atmospheric escape, afflicting victims of both planetary migration and runaway stellar expansion in the red-giant phase.
  Solving the puzzles of planetary evolution thus depends critically on our ability to model silicate vapors and their interplay with liquid and solid phases through condensation and vaporization processes.
key-points:
  - Thermodynamic modeling of vaporized silicates requires accurate databases of both condensed (liquid & solid) phases as well as all possible vapor species.
  - In vapor-limited regime, condensed phases dominate mass of system controlling equilibrium chemical potentials, allowing vapor species to be calculated as 2nd-order correction.
  - Partial pressures for each vapor species are calculated independently (reflecting ideal behavior), assuming equilibrium reaction with condensed phases.
future-work:
  In future weeks, we will present a description of our Python open-source software, [VapoRock](https://gitlab.com/ENKI-portal/vaporock), (currently in the working prototype stage) that was created based on this theoretical framework.
  Using a standard set of major and minor elements for geological systems, we will predict coexisting equilibrium vapor atmospheres corresponding to typical planetary compositions.
  These results will also be compared with those published for the primary existing closed-source modeling tool, MAGMA.
  This post thus represents the first in a series focused on silicate vaporization modeling that will form the core of a manuscript showcasing the new VapoRock software.
---

<!-- Motivation -->
<!-- # [[202101030642]] Role of vaporized rock throughout planetary evolution -->

## Modeling vaporized silicates overview
<!-- # [[202101050640]] Modeling vaporized silicates overview -->

To quantitatively study rock vaporization processes, we must have a complete set of accurate thermodynamic models for both condensed and vapor phases sampling broad ranges in composition and temperature.
It is critical that these solution models faithfully represent geologically realistic mixed compositions, including minor components which play key roles in vaporization due to their high volatilities, reflecting strong preferences for the vapor phase.
Fortunately, this burden is eased by the typically low-pressure conditions of vaporization, where thermodynamic models can neglect the complications introduced by compression (with the notable exception of supercritical vapors in high-energy giant impacts).
The MELTS model [@Ghiorso1995], for instance, provides an accurate description of igneous geologic systems in this low-pressure regime, and is thus well-suited to the task.
Calculating the composition, speciation, and abundance of the gas phase likewise requires an extensive and detailed thermodynamic database of vapor species, conveniently provided by standard thermodynamic tables, e.g. NIST-JANAF or similar tables [@Lamoreaux1984;@Lamoreaux1987].
As most vaporization processes occur at low-pressure conditions, we can likewise rely on empirical thermal models of pure 1 bar gasses that use the ideal gas approximation to extend to arbitrarily low partial pressures and mixed compositions.
This database of phase models is finally used with an appropriate equilibrium-seeking algorithm---depending on the vapor abundance regime---to predict the equilibrium phase assemblage by minimizing the total Gibbs energy of the system.


##  Vapor-abundance regimes
<!-- # [[202101051402]] Vapor equilibrium modeling regimes -->

Finding an equilibrium assemblage requires a comprehensive search of composition/abundance space for the global minimum Gibbs energy, where the optimal strategy depends on the relative total abundance of vapor in the system.
In the two endmember regimes, vapor-limited and vapor-dominated, the bulk composition of the system is housed nearly exclusively in the condensed phases or the mixed vapor phase, respectively, with negligible mass residing in other low-abundance phases.
This simplifies computation, since equilibrium is established independently by either the condensed phases or mixed vapor alone.
These dominant phases thus determine the equilibrium conditions, setting the chemical potentials of the system that control the properties of coexisting minor phases.
Far more complex is the intermediate vapor-abundant case, in which both vapor and condensed phases coexist in significant quantities.
Finding equilibrium in this case requires simultaneous energy minimization of all available condensed phases and vapor species.

<!-- # [[202101060632]] Vapor-limited equilibrium modeling -->

The vapor-limited regime is the most common across a range of geoscience contexts, as it occurs at much lower temperatures and higher pressures, thus spanning a larger range of environmental conditions.
A system is vapor-limited when the amount of vapor (by mass) is vastly outweighed by condensed phases.
This ensures that the equilibrium state of the system is largely set by the condensed phases alone, allowing us to model these systems in two steps, first considering only condensed phases and then adding vapor species as a second-order correction.
With this approach, we can use existing thermodynamic models (like the equilibration algorithm embedded in MELTS) to establish condensed-phase equilibrium, after which we can then determine the coexisting abundances of vapor species.
The task is even further simplified at higher temperatures where the condensed phase is fully molten.
In this case, condensed-phase equilibrium is trivial, since the composition and abundance of liquid are just equal to the bulk composition and total mass of the system.
The conditions of equilibrium are therefore controlled by the condensed phase assemblage, dictating the chemical potentials of the system ($\mu_j$). <!-- [[202011231519]] -->
Vapor species abundances are finally determined directly from these chemical potentials, providing a complete picture of all the stable phases in the system.


## Modeling equilibrium vapor compositions
<!-- # [[202006110721]] Equilibrium Vapor Species Abundances above Condensed Phs -->

<!-- Equilibrium abundances of every vapor species above a condensed phase are readily calculated given a model of each pure species at 1 bar. -->
In the vapor-limited regime, thermodynamics provides a straightforward framework for predicting vapor compositions, where the abundance of each vapor species is independently adjusted to equalize its chemical potential with the bulk system.
Using mass-balance constraints, we write the balanced chemical reaction that forms the $i^{th}$ gaseous species from the condensed phase assemblage by exchange of basic system components (e.g. the oxides with additional oxygen consumed or produced as needed):
$$
\phi_{iv} = \sum_{j} \nu_{ij} c_j + \nu_{iO_2} c_{O_2}
$$
where $\phi_{iv}$ is the $i^{th}$ vapor species, $c_j$ & $c_{O_2}$ are the vector of basic system components (like oxides) plus oxygen, and $\nu_{ij}$ & $\nu_{iO_2}$ give the stoichiometry of the vapor species in question, expressing its composition in terms of system components.
With the law of mass action, the corresponding equilibrium condition is written:
$$
\begin{aligned}
\mu_{iv} &= \sum_{j} \nu_{ij} \mu_j + \nu_{iO_2} \mu_{O_2}\\
\mu^0_{iv} + RT\log P_{iv} &= \sum_{j} \nu_{ij} \mu_j + \nu_{iO_2} \cdot ( \mu_{O_2}^0 + RT\log f_{O_2})
\end{aligned}
$$
where $P_{iv}$ is the equilibrium partial pressure of vapor species $i$, $f_{O_2}$ is the oxygen fugacity, and $\mu_{iv}$, $\mu_j$, & $\mu_{O_2}$ are the chemical potentials of vapor species $i$, component $j$, & molecular oxygen, respectively.
This expression of equilibrium imposes equality of chemical potentials for gas species $i$ in terms of system components that are freely exchanged with coexisting liquid or solid phases.
The above formulation uses chemical potentials directly, but is equivalent to the activity-focused formulation of @Sossi2018.
Rearranging, we obtain the governing equation for the abundances of each vapor species in terms of its partial pressure:
$$
\log P_{iv} = \frac{1}{RT} \left[ \sum_{j} \nu_{ij} \mu_j + \nu_{i O_2}\mu_{O_2}^0 - \mu_{iv}^0 \right] + \nu_{iO_2} \log f_{O_2}
$$
<!-- {#eq:vapor-abundances} -->
The equilibrium abundance of each vapor species is thus determined by environmental conditions (temperature and oxygen fugacity), the condensed phase assemblage (that dictates the chemical potentials of the system), and the 1 bar thermal properties of each vapor species ($\mu_{iv}^0$ & $\mu^0_{O_2}$).
<!-- **[NOTE-ASW: need to mention calculation of muj using melts]** -->


## Leveraging ideal behavior of vapor species
<!-- # [[202006090637]] Overview of modeling vapor species thermodynamics -->

<!-- **[NOTE-ASW: label eqns using fignos or change this ref]** -->
Calculation of species abundances using the governing expression above, rests upon the simplified behavior of ideal gases in the low density limit, where species in a mixed vapor do not interact with one another.
The ideal gas approximation imposes a simple link between pressure and temperature effects through the ideal gas law, enabling experimental constraints at a 1 bar reference pressure to trivially extend to arbitrarily low-density pressure conditions.
For this application, the primary benefit of the ideal gas approximation is the absence of compositional mixing terms, ensuring that the fugacity of any gaseous species is simply equal to its partial pressure, $f_{i}^v=P_i^v$, enabling the abundance of each vapor species to be determined independently of all others.

To evaluate the chemical potential of each vapor species, the ideal gas approximation must be coupled with an analytic expression for energy as a function of temperature, like the Shomate equation used by the thermochemical tables of JANAF and @Lamoreaux1984.
<!-- ## Shomate Equation -->
<!-- # [[202006090659]] Shomate Equation -->
<!-- The Shomate equation provides an analytic empirical description of the chemical potential of a phase as a function of temperature evaluated at a (1 bar) reference pressure. -->
The Shomate equation empirically captures energy variations for a wide selection of materials over a broad temperature range, and multiple piecewise models are sometimes combined to retain desired accuracy over 1000+ degree intervals.
The generalized polynomial form of the Shomate equation describes molar enthalpy in kJ/mol:
$$
\Delta \bar{H}^0 = \bar{H}^0 - \bar{H}^0_{298.15} = At + \frac{B}{2} t^2 + \frac{C}{3} t^3
+ \frac{D}{4} t^4 - E t^{-1} + F
$$
molar entropy in J/mol/K:
$$
\bar{S}^0 = A\ln{t} + Bt + \frac{C}{2} t^2 + \frac{D}{3} t^3 - \frac{E}{2} t^{-2} + G
$$
and molar heat capacity in J/mol/K:
$$
C^0_P = A + Bt + C t^2 + D t^3 + E t^{-2}
$$
where $t$ is temperature given in kilo-Kelvin ($t = T/1000$).
These are combined to evaluate the molar Gibbs energy (or chemical potential):
$$
\bar{G}^0 \equiv \mu^0 = \Delta \bar{H}^0 - T \bar{S}^0
$$
These numerical coefficients ($A,B,C,D,E,F,G$) are provided for a huge set of phases in the JANAF thermochemical database, as well as the tables of @Lamoreaux1984 and @Lamoreaux1987.
Using these expressions, we can rapidly evaluate the chemical potential reference state for every vapor species in the system, allowing us to determine the equilibrium partial pressure of each one.
<!-- **[NOTE-ASW: reference governing eqn above once eqnos pkg working]** -->


# References {.unnumbered}
