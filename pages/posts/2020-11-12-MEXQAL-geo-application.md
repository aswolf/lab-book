---
layout: post
title: Benchmarking MEXQAL method for geologically-relevant phases
active: lab-book
author: Aaron S. Wolf
date: 2020-11-12
prev:
  post: posts/2020-11-05-MEXQAL
  title: Calculating phase composition with the Metastable eXchange EQuilibrium ALgorithm (MEXQAL)
next:
  post: posts/2020-11-19-MEXQAL-rapid-geo-benchmark
  title: Least-squares-optimized MEXQAL calculations for geo-phases
key-points:
  - Typical igneous phases (liquid, Clinopyroxene, Feldspar, and Spinel) are used to test the MEXQAL method
  - Realistic compositions are determined using batch crystallization of primitive MORB liquid
  - Complex solutions with multi-site mixing require negative components to reach all of composition space; MEXQAL thus needs to work with dependent species (rather than independent components) to ensure all positive compositional variables, enabling usage of ideal mixing correction ($RTm*logX_i$)
  - Tests for all phases show excellent convergence to the correct compositions using the MEXQAL method
  - Only clinopyroxene shows some deviation (at the 10 J affinity level) that needs further exploration
---

## Testing MEXQAL on geologically-relevant phases
To demonstrate its general power and utility, we test the MEXQAL method for determining saturation affinities and compositions on a variety of geologically-relevant phases.
These phases span the range from small simple regular solution models (like ternary feldspar) up to large reciprocal solutions with multiple ordering parameters (like spinel).
Typical igneous phases that we selected for testing are presented here---roughly in order of increasing complexity:

* **Feldspar**: regular ternary solution
* **Silicate Liquid**: regular 14-component solution
* **Clinopyroxene**: ordered solution with 7-components & 2 ordering parameters
* **Spinel**: complex ordered solution with 5-components & 4 ordering parameters

For each of these phases, we perform a challenging set of tests utilizing geologically-realistic phase compositions.
To sample a region of composition space that is important for geological processes, we simulate near-complete (~95%) batch crystallization of MORB-composition liquid at 1300 K and 1 kbar, relatively close to the solidus.
The resulting simulated phase compositions represent realistic compositions for all of the simulated phases, and provide a good indication of expected performance during typical theoretical geochemistry simulations.
The simulated compositions used for this study are given in the table below:

### Primitive MORB Liquid & Crystallized Mineral Phases

| Oxide       |  wt% | Endmember |mol%| Endmember      | mol% |
|-------------|:----:|:----------:|:-:|:-----------------:|:-:|
| **Liquid**        || **Feldspar**  || **Clinopyroxene**    ||
| SiO$_2$     |48.68 | albite   |34.98| diopside         |45.2|
| TiO$_2$     | 1.01 | anorthite|64.88| clinoenstatite   |17.1|
| Al$_2$O$_3$ |17.64 | sanidine | 0.14| hedenbergite     |23.7|
| Fe$_2$O$_3$ | 0.89 |   ---         || Al-buffonite     | 8.0|
| Cr$_2$O$_3$ |0.0425| **Spinel**    || buffonite        |-1.1|
| FeO         | 7.59 | chromite | 2.3 | essenite         | 4.9|
| MgO         | 9.1  | hercynite|-30.1| jadeite          | 2.2|
| CaO         |12.45 | magnetite| 24.9|
| Na$_2$O     | 2.65 | spinel   | 36.3|
| K$_2$O      | 0.03 | ulvospinel|66.6|
| P$_2$O$_5$  | 0.08 |
| H$_2$O      | 0.2  |


It is important to note that not all of these components are strictly positive.
This arises as a simple consequence of multiple crystallographic sites for mixing, which causes non-positive components to be required in order to represent all possible solution phase compositions.
This complication actually leads directly into an important nuanced point about the implementation of the MEXQAL method not previously discussed.


## Exchange equilibrium using dependent species w/ MEXQAL
<!-- [[202011111445]] Exchange equilibrium using dependent species w/ MEXQAL -->

One of the critical nuances not fully appreciated previously is that the MEXQAL method requires that all calculations be performed in dependent species space.
This arises because the equilibrium affinity condition applies an ideal mixing correction to the saturation affinity to best match the estimated chemical potential offsets $\phi_i$.
The entropic mixing term has the familiar form of $RTm \log X_i$, and thus implicitly assumes that the components are all positive and bounded between 0 and 1.
No complications ever arise from this assumption for simple solutions, like the MELTS liquid phase or the Feldspars, because their solution endmembers are independent and fully span the physically realizable composition space.

More complex solutions involving multi-site coupled-substitution, however, like for the clinopyroxenes or spinels, require the ability to describe compositions involving negative amounts of some components.
These negative quantities are necessary to represent all possible dependent species for the solution phase.
A simple and straightforward fix for this problem is to simply transpose it into the larger dependent species space, rather than the original independent endmember component space.
The full set of dependent species for any solution phase has the important property that any physically meaningful composition can be represented as a positive combination of the dependent species, reflecting the fact that they fully span the relevant composition space.
By making this change, we guarantee that the fractions of each dependent species are always positive and we can make use of all of the same mathematical architecture developed for simpler solutions.
This strategy for handling complex reciprocal solution phases is likewise discussed in the original @Ghiorso2013 paper, and we follow the same procedure outlined there.

## Accuracy Benchmark testing on Igneous phases
Using the phase compositions given in the table above, we are then prepared to test out the efficacy of the MEXQAL method for this set of solution models of varying complexity.
Tests are performed using these compositions by directly calculating the true chemical potentials for each phase, evaluated at this representative equilibrium state.
For complex phases with multi-site substitution, these phase compositions and corresponding chemical potentials are converted into the larger degenerate space of species mol fractions.
Though this description is redundant, as discussed above, it is critical to MEXQAL approach, enabling the representation of an ideal mixing contribution.
The MEXQAL method is then applied to these chemical potentials to invert for a nominally unknown composition.
Convergence is assessed by comparing the inferred composition with the true input values, as well as verifying that the estimated phase affinity falls close to zero as expected for phases in the equilibrium assemblage.

Using this approach for all four of the phases described above, we find excellent recovery of the known correct phase composition using the MEXQAL algorithm.
It is important to note that translation into dependent species space is critical to the success of these tests, and progress is impossible without that step.
For 3 of the 4 phases explored, the algorithm converges on a composition with a corresponding affinity of less that .001 J, fully consistent with being a member of the equilibrium assemblage.
Notably, this includes the most complex phase of the set, spinel; even with four ordering parameters, MEXQAL was able to retrieve the correct composition to better than 2 parts in 10^4 for all components.
The only phase to show some minor difficulties is clinopyroxene, which converged with an affinity excess of ~10 J, and an error in composition at the 1% level for the buffonite endmember.
This level of convergence is passable for many applications, but likely results merely from a need to use multiple initial guesses for the MEXQAL method (starting from each dependent species).
We will explore this curiosity and how to remedy it in future reports.
