---
layout: post
title: Quantitative modeling of rock formation histories
active: lab-book
author: Aaron S. Wolf
date: 2021-02-03
next:
  post: posts/2021-02-06-meaningful-data-weights
  title: 'Data weights for meaningful models: inferring rock-formation histories'
motivation:
  One of the key challenges associated with analyzing the rock record is that samples taken from a petrologic sequence are known to have some genetic origin, but the nature and timing of that evolutionary link are only revealed through the modeling process.
  The usual assumptions made to enable modeling are that the fine-grained matrix of these samples represents the liquid composition in the magma chamber, while the phenocrysts represent saturated phases crystalizing from their parent liquid; the entire package is then erupted and delivered to the surface where they are added to the rock record.
  This straightforward interpretation can be complicated by the presence of xenocrysts (perhaps entrained from an earlier epoch of crystallization), but fortunately these xenocrysts usually stand out as clear outliers on the basis of texture and composition, allowing them to be identified and screened from the analysis (or otherwise incorporated into more complex models including partial disequilibrium).
  For typical cases, initial 'modeling' efforts can be fairly informal, taking the form of graphical analysis of compositional trends that can suggest some standard igneous process like fractional crystallization, assimilation, or magma mixing.
  But at this point, such assessments largely represent educated guesses which must be tested with quantitative modeling if further progress is to be made.
  The initial stages of such modeling often proceed using a *'chi-by-eye'* approach (where chi-square, $\chi^2$, is a typical symbol used for the goodness-of-fit metric).
  Though these analyses can provide results that are quite compelling, this process should be viewed as only the initial exploratory phase of a more in depth statistical analysis, providing early support for one or more working hypotheses, rather than a offering up finalized evidence.
  Having a quantitative metric to evaluate the quality of a modeling result is thus a critical obstacle to evaluating and comparing different competing formation hypotheses for a particular suite of rock samples. # [[202101310621]]
future-work:
  In a future post, we will explore the philosophical implications and potential consequences of assigning errors to the data in this newly proposed rock-fitting metric.
  Such statistical concerns highlight a general phenomenon associated with model-building---arising whenever a model cannot simultaneously capture every aspect of the dataset---in which the model calibration is pulled simultaneously toward multiple plausible solutions.
  This is especially common when calibrating against multiple data types or more broadly when the data can be split into groups, each of which is largely sensitive to a different subset of the model parameters.
  In science, imperfect models are the norm rather than the exception, and therefore our particular example of geologic modeling will serve as a concrete illustration of a general challenge common to nearly all data-based model-building exercises.
key-points:
  - A general rock mineralogy fitness metric is proposed that captures the quality of a modeled mineral assemblage for an analyzed rock sample.
  - Fitness metric accounts for bulk-rock composition, phase assemblage, modal abundances, phase composition, and trace/isotopic trends.
  - Passive chemical tracers, like stable and radiogenic isotopes and trace elements, provide additional direct constraints on the evolutionary path of each sample.
  - Model fitness for an entire suite of rock samples is determined by identifying corresponding point in simulation to each rock sample (using Hausdorff distance optimization).
---

<!-- Outline Note index stored in [[202101260640]] *Fitness metric for modeling rock mineral assemblages* -->
<!-- # [[202101260640]] *Fitness metric for modeling rock mineral assemblages* -->

<!-- Motivation section is taken from [[202102020609]]-->
<!-- [[202102020609]] Inferring formation histories from rock sample suites -->

## Rock mineralogy fitness metric
<!-- [[202101310621]] Overview of rock mineralogy fitness metric -->

To explore the family of petrologic histories likely to produce a chosen set of rock samples, we need a quantitative metric that captures how well the model fits the mineralogical assemblage.
Such a fitness metric must take into consideration many details reflecting the mineral assemblage and incorporate sensible relative weightings between different data types.
This goodness-of-fit metric is then used to provide quantitative feedback to a Monte Carlo fitting procedure that identifies the family of models consistent with the data.
We propose the following general purpose rock mineralogy fitness metric to capture the fidelity of a predicted mineral phase assemblage:
$$
\chi^2_s =\chi^2(\textrm{bulk-comp}) + \chi^2(\textrm{assem}) + \chi^2(\textrm{mode}) \\
+\sum_\phi^{\textrm{phases}} \chi^2_\phi(\textrm{comp})
+\chi^2(\textrm{chem-tracers})
$$
<!-- +\sum_{\epsilon}^{\textrm{tracers}}\chi^2_{\epsilon}(\textrm{chem}) -->
where each term highlights a different contribution to the overall fitness of our model for rock sample ($s$).
The quality of the predicted mineral assemblage is thus judged on how it matches the overall bulk (or whole-rock) composition, $\chi^2(\textrm{bulk-comp})$, the phases present in the mineral assemblage, $\chi^2(\textrm{assem})$, the modal amounts for each mineral, $\chi^2(\textrm{mode})$, and the individual composition of each phase, $\chi^2_\phi(\textrm{comp})$<!-- [[202101310624]] -->, with additional possible constraints from passive chemical tracers, $\chi^2(\textrm{chem-tracers})$.


<!-- ## Rock mineralogy fitness metric terms -->
<!-- [[202101310624]] Rock mineralogy fitness metric terms -->

For each term in the mineral-rock assemblage fitting metric, we introduce a least-squares type fitness criterion that is specifically designed to capture that particular data type.
We quantify the contribution of each of these fitness terms in the following Table:

| term | summation |  term  |
| :------- | :----: | :----: |
| $\chi^2(\textrm{bulk-comp})$ | system components | $\sum\limits_i \left( \Delta \hat{X}_i^{sys} /\sigma_{\hat{X}}^{sys} \right)^2$ |
| $\chi^2(\textrm{assem})$ | phases | $\sum\limits_\phi \left( \mathcal{A}_\phi / \sigma_{\mathcal{A}_\phi} \right)^2$ |
| $\chi^2(\textrm{mode})$ | phases | $\sum\limits_\phi \left( \Delta f_\phi / \sigma_{f_\phi} \right)^2$ |
| $\chi^2_\phi(\textrm{comp})$ | phase components | $\sum\limits_j \left( \Delta \hat{X}_j^{\phi} / \sigma_{\hat{X}}^{\phi} \right)^2$ |
| $\chi^2(\textrm{chem-tracers})$ | passive chemical tracers | $\sum\limits_\epsilon \left( \Delta y_{\epsilon} / \sigma_{y_\epsilon} \right)^2$ |
  :Table 1: Rock Fitness Metric Terms

where $\hat{X}_i^{sys}$ and $\hat{X}^\phi_j$ are the compositional vectors for the system and phase $\phi$, $f_\phi$ and $\mathcal{A}_\phi$ are the phase fraction and saturation affinities for phase $\phi$, and $y_\epsilon$ are the chemical abundances for passive tracer $\epsilon$.
Most terms depend on the difference ($\Delta$) between the measured and model values, except for the saturation affinity which inherently reflects an energetic deviation from equilibrium.
The relative weightings of each of these data-types is controlled by the error weighting factors $\sigma$ present in every fitness term.
<!--[[202102011633]]-->
We have identified five major contributions to this fitness, and outlined how they can be easily quantified using a petrological formation model like the Magma Chamber Simulator.
These comparisons range from broad summary data (like the whole rock composition) down to comprehensive detail-oriented data (like the compositions of each individual phase).
At either end of this spectrum, we have direct comparison of predicted and measured compositions---of individual phases or the rock as a whole---which can use straightforward oxide wt. fractions or more sophisticated methods that account for natural variability generated by igneous processes.
<!-- [[202102020605]] -->
At an intermediate level of detail, we have comparisons of the phase assemblage (which minerals are present) and the modal mineral abundances (comparing phase fractions by weight or moles of oxides).
This intermediate scale is critical, since it ensures that correct phases are actually present in the rock (or at least very nearly stable based on their saturation affinities) and in generally the right amounts.
Taken together, these four terms encapsulate the major and minor components of the rock that largely control the phase equilibria as the rock is formed.
Additional constraints can be imposed by trace element and isotopic data, which are distinct in that they represent passive tracers in the system and thus play no role in the phase equilibria that the determine the major mineralogy of the rock samples.
 <!-- [[202102021055]] -->

## Passive tracers as records of formation pathway
<!-- ## Fitness metric for passive chemical tracers -->
<!-- # [[202102021055]] Fitness metric for passive chemical tracers -->

Passive chemical tracers like stable or radiogenic isotopes and trace elements provide powerful constraints on path-dependent rock formation histories, since their preferential partitioning into either the liquid or solid mineral phases provides a record of the evolving mass balance between the liquid and fractionating crystals being lost from the system.
<!-- The additional terms quantifying these passive tracers adopt a form similar to the phase composition constraints:
$$
\chi^2(\textrm{chem-tracers}) = \sum\limits_\epsilon^\textrm{tracers} \left(\Delta y_\epsilon / \sigma_{y_\epsilon}\right)^2
$$
where $y_\epsilon$ is the abundance of passive tracer $\epsilon$ to be modeled, $\Delta y_\epsilon$ is the difference in its measured value from the model results, and $\sigma_{y_\epsilon}$ is the model error term for that tracer. -->
This basic approach should apply for a variety of tracers, from radiogenic isotopic ratios like $(^{87}Sr/^{86}Sr)$, to the abundance of trace components like zirconia $(ZrO_2)$.
A major advantage of these passive tracers is that, since they do not directly influence the evolution of the system, their simulated values can be calculated in a post-processing step after the simulation is complete, easing computational requirements (especially if their evaluation is reserved only for otherwise well-fitting models).

<!-- ## Passive tracers as records of formation pathway -->
<!-- [[202102021421]] Passive tracers record rock formation histories -->

From a scientific modeling perspective, these tracers impose key independent constraints on the problem of inferring rock formation histories, as mineral assemblages generally only constrain the state of the magma chamber that produced that particular erupted rock sample.
This is a basic consequence of the path-independence of thermodynamic equilibrium.
Inference of the entire formation history therefore relies heavily upon following the chemical trajectory of the eruptive sequence of rocks, often combined with assumptions about the compositions and properties of the magma reservoirs involved (e.g. size and chemistry of magmatic recharge pulses or the degree of interaction with surrounding wall rock).
In contrast, passive chemical tracers with their high sensitivity to mineral-liquid fractionation allows them to retain memory of the fractionation pathway that is reflected in the measured values even within a single sample.
This effect is further amplified for radiogenic isotope systems with relevant decay lifetimes, which constrain an absolute timescale for the formation process.
Thus, the combination of passive tracer data and major component mineral assemblage constraints can dramatically improve inference of the earliest stages of formation and also provide independent checks on the simplifying assumptions often adopted during analysis of the major element chemistry and mineral phase assemblages.

## Mapping a modeled magmatic history onto a rock sample suite

Even given such a metric, we must determine how best to apply it to the sample suite, since while evolutionary progress is well-constrained within the model (e.g. the temperature cooling sequence), it is largely unknown for the natural rocks.
Clues like stratigraphic sequence can help provide an ordering to the data, but precise markers for evolutionary progress remain a mystery, thereby clouding our ability to uniquely identify each piece of analytical data with a unique corresponding point in the model simulation.
We must therefore turn to numerical tools that mimic our own intuitive 'by-eye' approach, utilizing pattern-matching techniques designed to quantify the differences between measurement and model trends in data space.

The most straightforward of these techniques (Hausdorff distance optimization) relies on a nested two-stage process for minimizing the differences between the measurements and model predictions in terms of their 'distance' in data-space.
A key insight to understanding this approach is to recognize that weighted least-squares type fitness metrics, like the rock mineralogy metric $\chi^2_s$ proposed here, itself takes the form of a (squared) distance.
 <!-- [[202101310621]] -->
Such fitness metrics mathematically represent the squared-distance between two points in 'data-space', composed of the complete set of sample measurements each scaled by an appropriate model-error estimate.
The error-scalings are discussed in more detail in a future post, but their main purpose is to place every measurement constraint on a common statistical deviance scale (e.g. in terms of number of sigma from their expected model value) and allow distinct data types to be combined in a single metric.
<!-- [[202102011633]] -->
The pattern-matching scheme leverages this distance interpretation to identify the appropriate point of comparison from a particular simulation as the nearest point in the simulation data-array to every measurement:
$$
\chi^2_s = \min_{t_{sim}} \{ \chi^2_s(t_{sim}) \}
$$
where the minimum of the fitness metric is calculated for sample $s$ with respect to the simulation timestep ($t_{sim}$), revealing the most representative point in the simulation history for the current sample.
This provides a direct mapping between observations and simulation results, and the total fitness of this simulation is then just the sum of each of these squared distances across every sample:
$$
\chi^2 = \sum\limits_s^\textrm{samples} \chi^2_s
$$
The end result of this straightforward procedure is an ability to assign a single fitness value to every model simulation, reflecting how well it collectively captures the trends observed in the suite of sample measurements.


# References
