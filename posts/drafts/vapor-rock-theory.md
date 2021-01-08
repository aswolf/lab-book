---
layout: post
title: Thermodynamics of Vaporized Rock
active: lab-book
author: Aaron S. Wolf
date: 2020-01-08
prev:
  post:
  title:
next:
  post:
  title:
motivation:
  Silicate vapors are receive little attention in many geoscience contexts, but outgassed vapors play key roles in planetary evolution spanning the full range of planetary length- and time-scales, from the earliest proto-dust grains to the eventual erosion and erasure of entire rocky planets.
  Thermodynamic equilibrium ensures that rocky silicate vapors are always present above condensed (liquid or solid) phases, though typically at very low pressures.
  In most situations, these vapors are (rightly) ignored when other external processes dominate, such as the biotically controlled near-surface atmospheric conditions on Earth.
  But outgassed vapors are critical in key high-temperature stages of planet formation, which appear throughout the lifetime of evolving planets.
  Before planets or rocks even exist, vapors condense from the stellar nebula to form the original planetary building blocks.
  In the later stages of planet formation, giant impacts are likely ubiquitous and readily produce global-scale melting and vaporization.
  Immediately following planetary accretion, rocky planets are dominated by deep magma oceans (especially after giant impacts) that exchange both volatile and refractory elements with silicate vapor and steam atmospheres.
  During the prolonged secular evolution of the planet, volcanic outgassing controls the long-term exchange of matter (primarily volatile and moderately volatile elements) between interiors and atmospheres.
  And finally, the terminal stage of rocky planet evolution, reserved for those parked too close to the surface of their parent star---whether by planetary migration or runaway stellar expansion in the red-giant phase---is marked by progressive planetary vaporization and whole-scale erosion, driven by atmospheric escape and stellar winds.
  Solving the puzzles of planetary evolution thus depends critically on our ability to model silicate vapors and their interplay with liquid and solid phases through condensation and vaporization.
key-points:
  - Vaporized rock is in high-temperature settings throughout planetary evolution (pre-formation to destruction) including nebular condensation, giant impacts, magma-ocean- & interior-outgassing, and radiation-induced planetary erosion.
  - Thermodynamic modeling of vaporized silicates requires accurate databases of both condensed (liquid & solid) phases as well as all relevant vapor species; ideal gas approximation is used to extend to very low partial pressures.
  - Equilibrium of partially vaporized system depends on vapor abundance relative to condensed phases; simplified endmembers are vapor-limited or vapor-dominant, w/ complex interactions for intermediate vapor-abundant systems.
  - In vapor-limited regime, condensed phases dominate mass of system, so they control equilibrium conditions (e.g. chemical potentials), and vapor species are calculated as 2nd order correction.
  - Vapor species are ideal gases at low pressure; thus, a simple description of their temperature-dependence at a 1bar ref. pressure is enough to fully capture their behavior over the full low pressure regime.
  - Abundances (partial pressures) of each vapor species are calculated from mass balance & law of mass action, given the oxide chemical potentials & fO2; since P_vi << 1bar for all species, they are treated as ideal gases.
  - The Shomate equation provides an empirical analytic formulation to model the energy of a material over a broad temperature range evaluated at a (1 bar) reference pressure; fitted coefficients are given by JANAF database.
future-work:
  In a future week, we will show a demonstration of how the code works.
---

**[NOTE-ASW: Role of externally imposed oxygen abundance???]**

<!-- Motivation -->
<!-- # [[202101030642]] Role of vaporized rock throughout planetary evolution -->

## Modeling vaporized silicates overview
<!-- # [[202101050640]] Modeling vaporized silicates overview -->

To quantitatively study rock vaporization processes, we must have a complete set of accurate thermodynamic models for condensed and vapor phases sampling broad ranges in composition and temperature.
It is critical that these solution models faithfully represent geologically realistic mixed compositions, including minor components which play key roles in vaporization due to their high volatilities, reflecting strong preferences for the vapor phase.
Fortunately, this burden is eased by the typically low-pressure conditions of vaporization, where thermodynamic models can neglect the complications introduced by compression---with the notable exception of supercritical vapors in high-energy giant impacts.
The MELTS model (@Ghiorso1985 *TK*), for instance, provides an accurate description of igneous geologic systems in this low-pressure regime, and is thus well-suited to the task.
Calculating the composition, speciation, and abundance of the gas phase likewise requires an extensive and detailed thermodynamic database of vapor species, conveniently provided by standard thermodynamic tables like JANAF or the work of @Lamoreaux??? *TK*.
As most vaporization processes are confined to the low-pressure regime, we can likewise rely on simple empirical thermal gas models (developed at 1 bar) that use the ideal gas approximation to extend to arbitrarily low partial pressures.
This database of phase models is finally used with an appropriate equilibrium-seeking algorithm---depending on the vapor abundance regime---to predict the equilibrium phase assemblage by minimizing the total Gibbs energy of the system.


##  Vapor equilibrium modeling regimes
<!-- # [[202101051402]] Vapor equilibrium modeling regimes -->

Determining the equilibrium phase assemblage requires an efficient search of composition/abundance space for all possible phases in the system, ensuring the that final predicted assemblage corresponds to the global minimum Gibbs energy.
The ideal approach to this task depends on the vapor abundance regime of the system.
The two endmember regimes are vapor-limited [[202101060632]] and vapor-dominated [[*TK*]], where the bulk elemental composition of the system is assumed to be housed entirely in either the condensed phases or the mixed vapor phase, respectively.
In either endmember, we make the approximation that low-abundance phases constitute an insignificant fraction of the system by mass.
This simplifies computation, since equilibrium is established independently by either the condensed phases or mixed vapor alone.
These dominant phases thus determine the equilibrium conditions, setting the chemical potentials of the system which thereby dictate the properties of the minor coexisting phases.
More complicated is the intermediate vapor-abundant case, in which both vapor and condensed phases coexist in significant quantities.
Finding equilibrium in this case requires simultaneous energy minimization of all available condensed phases and vapor species, including abundances and compositions for every potential phase in the system.

##  Vapor-limited equilibrium modeling
<!-- # [[202101060632]] Vapor-limited equilibrium modeling -->

The vapor-limited regime is the most common across a range of geoscience contexts, as it occurs at much lower temperatures and higher pressures thus spanning a larger range of environmental conditions.
A system is vapor-limited when the amount of vapor (by mass) is vastly outweighed by condensed phases, ensuring that the equilibrium state of the system is largely set by the condensed phases alone, and the addition of vapor can be considered a second-order correction.
We can thus model these systems in two steps, first considering only condensed phases, and then adding vapor species as a second-order correction.
This approach allows us to use existing thermodynamic models (like the equilibration algorithm embedded in MELTS) to establish condensed-phase equilibrium, after which we can then determine the coexisting abundances of vapor species.
The task is even further simplified at higher temperatures where the condensed phase is fully molten.
In this case, condensed-phase equilibrium is trivial, since the composition and abundance of liquid are just equal to the bulk composition and total mass of the system.
In the vapor-limited regime, the conditions of equilibrium are controlled by the condensed phase assemblage, which sets the chemical potentials for the system [[202011231519]].
Vapor species abundances are finally determined directly from these chemical potentials, providing a complete picture of all the stable phases in the system.

## Vapor species thermodynamics
<!-- # [[202006090637]] Overview of modeling vapor species thermodynamics -->

The description of vapor species is vastly simplified as compared to condensed phases like pure phase solids, solid solutions, or liquids.
This is because vapors (in the low density limit) behave as ideal gases, meaning that the species in a mixed vapor do not interact with one another.
The ideal gas also imposes a simple link between pressure and temperature effects through the ideal gas law, enabling experimental constraints at a 1 bar reference pressure to trivially extend to the full range of low density pressure conditions.
The energetics and resulting properties of vapor species are typically captured in terms of a simple analytic empirical function of temperature.
The Shomate equations [[202006090659]] provides a common form used by the JANAF thermochemical tables (and others).
(Assuming equilibrium, vaporized samples might be used as a direct experimental measure of chemical potentials [[202006081345]].)
This thermal description of the pure single species vapor at 1 bar is then combined with models for all other relevant vapor species and condensed phase models [[202006110721]] to build a thermodynamic model of the system.

## Vapor Abundances above Condensed Phases
<!-- # [[202006110721]] Equilibrium Vapor Species Abundances above Condensed Phs -->

Equilibrium abundances of every vapor species above a condensed phase are readily calculated given a model of each pure species at 1 bar.
Simple mass balance shows how each gaseous species ($i$) can be formed from basic system components (e.g. the oxides with additional oxygen consumed or produced as needed):
$$
n^v_i = \sum_{j} \nu_{ij} n^{ox}_j + \nu_{iO_2} n^{O_2}
$$
the number of moles of each compound ($n$) is related to the stoichiometry vector $\nu_i$, which tracks contributions from the oxides ($\nu_{ij}$) and from molecular oxygen $\nu_{iO_2}$.
With the law of mass action, we reformulate mass balance as the equivalent equilibrium condition:
$$
\begin{aligned}
\mu^v_{i} &= \sum_{j} \nu_{ij} \mu^{ox}_j + \nu_{iO_2} \mu^{O_2}\\
\mu^v_{i0} + RT\log P_i^v &= \sum_{j} \nu_{ij} \mu^{ox}_j + \nu_{iO_2} \cdot ( \mu^{O_2}_0 + RT\log f_{O_2})
\end{aligned}
$$
where $\mu_i^v$, $\mu_j^{ox}$, & $\mu^{O_2}$ are the chemical potentials of vapor species $i$, oxide $j$, & molecular oxygen, $P_i^v$ is the partial pressure of vapor species $i$, and $f_{O_2}$ is the oxygen fugacity.
This expression of equilibrium imposes equality of chemical potentials for gas species $i$ and the system components that are freely exchanged with coexisting liquid or solid phases.
The above formulation uses chemical potentials directly, but is equivalent to the activity-focused formulation of @Sossi2018.
Since vapor species are present only at very low abundances ($P^v_i \ll \textrm{1 bar}$), we use the ideal gas approximation ($f_{i}^v=P_i^v$) to simplify this calculation.
Rearranging, we obtain the governing equation for the abundances of each vapor species in terms of its partial pressure:
$$
\log P_i^v = \frac{1}{RT} \left[ \sum_{j} \nu_{ij} \mu^{ox}_j + \nu_{i O_2}\mu^{O_2}_0 - \mu^g_{i0} \right] + \nu_{iO_2} \log f_{O_2}
$$ {#eq:vapor-abundances}
where the 1 bar thermal properties of the vapor species (and oxygen) are given by $\mu_{i0}^g$ (and $\mu_0^{O_2}$).


### Shomate Equation
**[NOTE-ASW: shrink this section]**
<!-- # [[202006090659]] Shomate Equation -->

The Shomate equation provides an analytic empirical description of the Gibbs energy surface of a phase as a function of temperature (evaluated at a reference pressure).
It includes a variety of non-linear terms able to capture thermal behavior over a broad temperature range, though often multiple piecewise models are combined to retain desired accuracy over 1000+ degree intervals.
The generalized polynomial form of the Shomate equation describes enthalpy in kJ/mol:
$$
\Delta H^0 = H^0 - H^0_{298.15} = At + \frac{B}{2} t^2 + \frac{C}{3} t^3
+ \frac{D}{4} t^4 - E t^{-1} + F
$$
entropy in J/mol/K:
$$
S^0 = A\ln{t} + Bt + \frac{C}{2} t^2 + \frac{D}{3} t^3 - \frac{E}{2} t^{-2} + G
$$
and heat capacity in J/mol/K:
$$
C^0_P = A + Bt + C t^2 + D t^3 + E t^{-2}
$$
where $t$ is temperature given in kK ($t = T/1000$).
These are combined to evaluate the Gibbs energy surface:
$$
G^0 = \Delta H^0 - T S^0
$$
These numerical coefficients are provided for a huge set of phases in the JANAF thermochemical database.
It should be noted that all of these quantities are reported for the pure substance (as indicated by the 0 superscript) and energies are given relative to the elements evaluated at 298.15 K.

# References {.unnumbered}
