[← Portfolio index](../../README.md)

# One-Dimensional Optimization Methods

**MATLAB · Interval Search · Numerical Optimization**

An academic optimization assignment by Petros Charalampidis comparing four
methods for locating minima of test functions on a bounded interval.

## Methods

| Script | Method |
| --- | --- |
| `Thema1_Work1.m` | Dichotomous interval search using function values |
| `Thema2_Work1.m` | Golden-section search |
| `Thema3_Work1.m` | Fibonacci search |
| `Thema4_Work1.m` | Bisection based on the derivative sign |

The experiments start from the interval `[-1, 3]`. They vary the required final
interval width and compare function/derivative evaluation counts and the
evolution of the search interval.

## How to run

Use this assignment folder as MATLAB's current folder and run one script:

```matlab
Thema2_Work1
```

Test functions and parameters are embedded in the scripts. No external data
file is required. Run scripts separately, since they clear workspace state.

## Results

The [original report](docs/report.pdf) contains the supplied plots and discussion
of precision and evaluation cost. The scripts generate figures during execution.
These are academic comparisons on specified test functions, not a general
performance benchmark. MATLAB execution was not available during packaging.

## Attribution

Report author: Petros Charalampidis. Code and original comments remain unchanged.
