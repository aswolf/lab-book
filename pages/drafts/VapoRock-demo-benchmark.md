---
layout: post
title: Post title
active: lab-book
author: Aaron S. Wolf
date: yyyy-mm-dd
prev:
  post:
  title:
next:
  post:
  title:
motivation:
future-work:
key-points:
  - VapoRock predictions for Na and K are compared with vaporization experiments of @Hastie1985 on mixed alkali glass; partial pressure trends are recovered and abundance match within 1/2 to 1 order of magnitude.
---


## Comparing VapoRock with Slag vaporization experiments
<!-- ## [[202101200609]] Comparing VapoRock with Slag vaporization experiments -->

Direct laboratory constraints on silicate melt (or glass) vaporization are fairly sparse in the literature due to the inherent experimental challenges.
Fortunately, there exists a body of literature focused on mixed-composition slag glasses, important for industrial and mining applications.
Slag glass vaporization experiments thus provide a potential source for experimental benchmarking for the silicate vaporization modeling.
The inherent challenge associated with this comparison is that most slag melting and vaporization experiments are focused on rather simplified or idealized compositions rather than natural samples.
This is a particular problem since the MELTS liquid model is specifically calibrated on natural igneous rock compositions, and is known to lose considerable accuracy when comparing with compositions that lie very far from the training data (like simpler subsystems).

Nevertheless, we perform a direct comparison with experiments on the most realistically complex slag glasses, carried out in a series of studies by J. W. Hastie and colleagues in the 1980s on mixed alkali glasses.
These experiments studied a range of synthetic glass compositions, the most complex and geo-relevant of which was a NIST standard glass SRM 621 [[*TK*]].
Experimental vaporization results for this mixed alkali glass are reported in @Hastie1985 and @Hastie1986, where partial pressures were simultaneously measured and reported for the higher volatility species $Na, O_2, \& K$.
Based on the recorded oxygen fugacities and the known glass composition, we thus use VapoRock to predict the vapor abundances of Na and K:

![VapoRock comparison for vaporization experiments on mixed alkali glasses.](figs/202101200631-VapoRock-Hastie1985-comparison.png){#fig:Hastie-validation width=100%}


As depicted in the figure, the points represent measurements reported in @Hastie1985, while the lines show model predictions from VapoRock.
For this calculation, the experimental oxygen fugacity trend was fitted with a quadratic curve, enabling continuous modeling of these data across the temperature range.
The dashed lines represent the results using the reported glass composition for the sample, showing the correct relative volatility of the Na and K vapor species, but under-predicting the volatility contrast.
For these high-volatility species, the vapor abundance predictions follow the same general trend and are generally within 1/2 to 1 order of magnitude of their experimental values.
For comparison, we also show in dotted lines the predicted volatility curves for a modified sample composition, where the $Na_2O$ and $K_2O$ sample compositions were adjusted (keeping all other oxides fixed) to best fit the observed vapor abundances.
This procedure provides an alternative way of conceptualizing the differences between these experiment and model results, indicating that the volatility differences correspond to a necessary adjustment of the Na and K2O abundances by a factor of 1.57 and 0.15, respectively.
It should be noted that this level of agreement, while imperfect, remains broadly on par with the MAGMA model, which performs better for Na (generally matching the experimental values as well as our adjusted calculation) but performs considerably worse for K, where the abundances are under-predicted by 1 to 1.5 orders of magnitude [@Schaefer2004].

# References
