Bayes Point Machine toolbox
===========================

This toolbox implements the EP algorithms described in ["A family of algorithms for approximate Bayesian inference"](https://tminka.github.io/papers/ep) and ["Expectation Propagation for approximate Bayesian inference"](https://tminka.github.io/papers/ep).

This toolbox requires the [Lightspeed toolbox](https://github.com/tminka/lightspeed).

See Contents.m for a list of functions.  This toolbox uses the
object-oriented features of Matlab.  You first create a 'task'
structure, then create a 'bpm_ep' object.  This object has methods
like 'train' and 'classify'.  See the 'test' scripts for examples.

Tom Minka
