[← Portfolio index](../../README.md)

# Adaptive and Robust System Identification

**MATLAB · Adaptive Observers · Robust Estimation · Model Selection**

A final dynamic-systems assignment by Petros Charalampidis combining adaptive
parameter estimation, robustness experiments and model-structure selection.

## Problem Statement

Develop online parameter-estimation algorithms for nonlinear systems, incorporating projection and robustness to bounded disturbances. Compare candidate model structures using cross-validation and select a model that balances approximation error, complexity and generalization to independent test data.

## Part 1: Adaptive estimation and disturbances

- Estimate unknown parameters of a simulated nonlinear dynamic system.
- Compare persistently exciting and zero-input cases.
- Use projection bounds on parameter estimates.
- Examine a robust estimator with leakage under several disturbance bounds.
- Plot state reconstruction, parameter trajectories and estimation errors.

## Part 2: Model selection

The supplied code generates eight training trajectories and four test
trajectories. It compares candidate model structures using four-fold
cross-validation, considers a complexity penalty and evaluates the selected
model on the configured test trajectories.

## Files and how to run

| Current folder | Driver | Purpose |
| --- | --- | --- |
| `Thema_1a/` | `project_thema1a.m` | Adaptive estimation and excitation comparison |
| `Thema_1b/` | `project_thema1b.m` | Robust estimation under disturbances |
| `Thema_2/` | `project_thema2.m` | Candidate-model selection and evaluation |

Open MATLAB, make the chosen subfolder the current folder and run its driver.
For example, starting from this assignment folder:

```matlab
cd('Thema_2')
project_thema2
```

Keep each subfolder's helper functions alongside its driver. The experiments
generate their own simulated data and do not require an external dataset.

## Results and limitations

See the [original report](docs/report.pdf) for the estimator design, stability
discussion and supplied simulation figures. The code was not executed during
portfolio preparation; the repository makes no new numerical verification claim.
Performance is specific to the implemented models, inputs and parameter bounds.

Report author: Petros Charalampidis
