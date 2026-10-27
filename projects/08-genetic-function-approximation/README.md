[← Portfolio index](../../README.md)

# Nonlinear Function Approximation with a Genetic Algorithm

**MATLAB · Optimization · Gaussian Basis Functions · Model Evaluation**

An academic project by Petros Charalampidis implementing a genetic algorithm
to fit a nonlinear two-input function with a weighted sum of Gaussian terms.


## Problem Statement

Approximate an unknown nonlinear two-input function using a weighted combination of at most 15 Gaussian basis functions. Implement a genetic algorithm without MATLAB’s built-in genetic algorithm solver, and evaluate approximation accuracy on data separate from those used for fitting.

## Model and algorithm

- Synthetic target: `sin(u1 + u2) * sin(u2^2)`.
- 1,000 randomly generated input/output samples; 70/30 train/validation split.
- 15 Gaussian basis functions, with 75 parameters in total.
- Population of 100, tournament selection, 300 generations and mutation rate 0.1.
- Mean squared error as the training fitness.

The genetic algorithm is implemented in the supplied MATLAB files rather than
delegated to MATLAB's built-in genetic algorithm solver.

## Reported result

The original report records training MSE **0.024184** and validation MSE
**0.023872** for its illustrated run. The script does not fix a random seed,
so a new run will generally differ. These numbers are not a new benchmark or
evidence of generalization outside the synthetic test setup.

## Running

Set MATLAB's current folder to this project folder
(`projects/08-genetic-function-approximation`) and run:

```matlab
main
```

`evaluate_model.m` evaluates Gaussian candidates and `tournament_select.m`
implements selection. This project generates its own data and does not need
an external dataset. MATLAB execution was not available during packaging.

For a future reproducibility update, add and document a fixed random seed
before sampling data and creating the initial population. The original script
is preserved unchanged in this version.

See the [report](docs/report.pdf)
