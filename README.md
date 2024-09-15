# Cognostics: Metrics enabling detailed interactive visualization of big data

2017 Computational Science and Engineering Conference at Purdue University

Slides: https://github.com/schloerke/presentation-2017_04_14-cognostics/blob/master/csesc-2017-cognostics-barret-schloerke-slides.pdf

## Abstract

Multipanel display systems like Trellis Display have proven to be very effective tools for visualizing complex data sets in detail.  In Trellis Displays, data are broken into subsets and a visualization method is applied to each subset, resulting in a set of panels that are displayed in a grid, resembling a garden trellis.  When the size of the data becomes very large, it is often the case that there are too many panels for the analyst to consume at one time.  A simple idea put forth by John Tukey is to compute "cognostics", metrics that help bring different, interesting sets of panels in a display to the analyst's attention and allow the analyst to interactively sort and filter the panels.  Cognostics can include statistical summaries, descriptive variables, goodness-of-fit metrics, etc.  In this talk, I will discuss ideas regarding default cognostic choices based on what is being plotted and will discuss an implementation of a large-scale multipanel display system with cognostics called Trelliscope.
