---
layout: post
title: Challenges with experimental validation of vaporization modeling
active: lab-book
author: Aaron S. Wolf
date: 2021-01-25
prev:
  post: 2021-01-17-thermochem-vapor-database
  title: Thermochemical Database for vaporization/condensation
motivation:
  The 1970s saw a major scientific push to understand the lunar samples returned from the moon landing missions, spurring a host of experimental studies on lunar samples aimed at uncovering the geologic history of the lunar surface.
  In particular, it was immediately clear the that lunar surface is highly depleted in moderately volatile elements like Na and K relative to terrestrial rocks, likely pointing to a high-temperature past involving significant vaporization.
  As reviewed in @Sossi2018, vaporization experiments were carried out on lunar samples by @deMaria1969, @deMaria1971, @Naughton1971, @Gooding1976, and @Markova1986.
  These experimental efforts had both the aim of constraining the molecular abundances in the equilibrium vapor for lunar basalts and other terrestrial or meteorite samples, as well as understanding their chemical trajectory as they are modified by fractional vaporization.
  Obtaining not only qualitative results but quantitatively useful measurements from such experiments is extremely challenging, due to the difficulties of limiting or otherwise fully characterizing the confounding effects of fractional vaporization of the most volatile components of silicate rocks.
future-work:
  In a future post, we will explore these validation issues quantitatively, focusing in on a number of previous experimental studies as well as published computational predictions from the MAGMA code.
  These comparisons will enable us to better understand the comparative accuracy of the VapoRock code and build confidence in its predictions.
  In light of the issues raised here surrounding issues with attaining a well-defined thermodynamic equilibrium state, special care will be taken in selecting the experimental data used for comparison.
key-points:
  - Many lunar sample vaporization experiments were performed in 1970s to understand origin of Na/K-depleted lunar surface rocks; experimental constraints make many measurements difficult to use for model validation.
  - Lunar vaporization experiments attempt to shed light on both equilibrium and fractional vaporization---useful for model validation and understanding lunar evolution (respectively)---but typically lie somewhere between these endmembers.
  - High volatilities of Na and K allow sub-liquidus vaporization (in some cases to exhaustion of alkalis); quantitative analysis of such experiments is challenged by unconstrained phase assemblages & strong kinetic effects.
  - Oxygen fugacity plays a critical role in determining silicate vapor abundances, but constraining its value during experiments and understanding its evolution in natural systems is extremely challenging.
---

<!-- Motivation section source: [[202101230542]] -->
<!-- ## [[202101230542]] Validating VapoRock w/ lunar vaporization experiments -->



## Equilibrium vs fractional vaporization of lunar samples
<!-- # [[202101230617]] Equilibrium vs fractional vaporization of lunar samples -->

Interpreting the data produced in lunar vaporization experiments unfortunately poses significant issues stemming from sample heating procedures.
Whether samples were measured at particular target temperatures or progressively heated, precise details of the heating schedule can greatly impact experimental results.
From a model validation perspective, an ideal vaporization experiment would bring the sample immediately to a target temperature and heat it just long enough to obtain a precise measurement of the off-gassed vapors, after which a fresh sample would be brought to a new temperature.
Additionally, the residual samples themselves should be analytically characterized to demonstrate minimal change in their bulk compositions, demonstrating that the measurements reflect the true equilibrium vapor at the known sample composition.
Conversely, the experiments themselves were generally designed to explore the effects of fractional vaporization on the composition of the lunar surface, motivating the use of continuous heating procedures.
Thus these two opposing experimental designs both provide value for understanding the geological history of the lunar surface, but unsurprisingly the more challenging and less flashy attempts at near-equilibrium vaporization are more difficult to find in the literature.
Troublesome kinetic factors can also dramatically influence vapor abundances and outgassing rates.
While vaporization processes can in some cases approach near-equilibrium conditions for planetary-scale reservoirs of material, laboratory setups are constrained by small sample sizes and finite experimental runtimes which both tend to amplify the role of kinetic effects.


## Sub-liquidus vaporiziation and volatile loss
<!-- # [[202101240624]] Sub-liquidus vaporiziation and volatile loss -->

Much of the focus for vaporization processes is given (at least initially) to the most volatile oxide species (Na and K), as they comprise the bulk of the vapor and are thus most easily lost from the system.
The volatilities of Na and K are so much higher than all other major oxides, that they attain partial pressures generally many orders of magnitude higher than all other species, even though they represent important but relatively minor components of most silicate rocks.
Accurately modeling their vaporization pathway is thus a key area of focus, and yet careful validation of models predicting their vaporization is hindered by their eagerness to escape.
Not only do they pose major issues around equilibrium vs fractional vaporization, but they are prone to near-complete vaporization before the sample has a chance to fully melt (below the sample's liquidus temperature).
Sub-liquidus vaporization raises serious challenges to data interpretation, since the molten component of the sample is generally poorly characterized in terms of mass fraction and composition (which can differ strongly from the sample's bulk composition depending on degree of melting).
Straightforward vaporization modeling typically relies on a fully molten condensed phase (e.g. using either MAGMA or VapoRock codes), without the ability to properly address partially melted samples.
Even if the model does incorporate solid phases with appropriate (more sophisticated) methods of mixed-phase equilibrium, there are serious unavoidable issues surrounding kinetic effects.
Experiments involving simultaneous coexistence of vapors, liquids, and solids, are very likely to be influenced by kinetics, since the partial vaporization of material from the solid phases involves much higher energetic barries than the liquid, and will thus proceed more slowly.
Furthermore, only the surface of each solid grain is accessible for chemical interaction with the vapor phase, whereas the bulk of the liquid is reactive due to its ability to flow and homogenize.
These constraints pose significant barriers to quantitatively analyzing Na and K vaporization loss in materials with significant sub-liquidus vaporization, including unfortunately typical lunar basalt samples [see @Sossi2018 for review].



## Constraining oxygen fugacity conditions during vaporization
<!-- # [[202101230622]] Constraining oxygen fugacity conditions during vaporization -->

The oxygen fugacity conditions present during vaporization of rocky samples exert strong controls on vapor abundances, since oxygen appears as either a reactant or product in most liquid vaporization reactions (assuming oxides are used as system components).
And yet, due to extremely low abundances in most situations, determining the true oxygen fugacity conditions in either experiments or natural systems poses immense challenges.
Though some experiments do measure and report molecular (or atomic) oxygen abundances, these are only measurable over specific temperature intervals that do not cover the full range of the experiments and which shift depending on the composition of the sample (which itself can change due to fractional vaporization).
Oxygen fugacity conditions can also be inferred from the relative abundances of coupled vapor species with variable oxidation states (like $TiO_2$ and $TiO$) with the help of a thermochemical database of vapor species, though this calculation is rarely presented in most experimental studies.
Beyond constraining experimental conditions based on empirical measurements, building a true understanding of the underlying factors that govern evolving oxygen abundances in natural systems poses even greater challenges.
Much of the published modeling (work of Fegley and Schaefer, e.g. @Fegley1987, @Schaefer2004) proceed as if the samples themselves posses unique intrinsic oxygen fugacities that are well constrained at different vaporization temperatures.
But these models assume that the sample redox state dominates the oxygen budget in the vaporized portion of the system.
Due to the low oxygen abundances in the vapor, any process that can fractionate oxygen by molecular processing or removal by escape or deposition should be able to dramatically alter the availability of oxygen.
Even in cases where the sample redox state does dictate the oxygen fugacity, it is unclear whether published silicate liquid redox models (e.g. @Kress1991) are sufficiently accurate to accurately predict the evolving oxygen fugacity during isolated vaporization of these materials.




# References
