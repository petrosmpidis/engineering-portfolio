[← Portfolio index](../../README.md)

# Gradient and Lyapunov-Based Parameter Estimation

**MATLAB · Adaptive Estimation · ODE Simulation · Disturbances and Noise**

An academic dynamic-systems assignment by Petros Charalampidis implementing
online parameter estimators and examining their response to disturbances.

## Problem Statement

Develop and simulate online parameter estimators using gradient and Lyapunov-based methods for an aerial vehicle’s rotational dynamics and a pendulum. Assess convergence, stability and estimation accuracy under external disturbances and measurement noise.

## Experiments

1. Gradient-based estimation for a rotational dynamic model, comparing actual
   and estimated motion and model parameters.
2. Lyapunov-based estimation for a pendulum model, including estimated length
   and damping-related parameters.
3. A sweep over disturbance/noise amplitude to examine parameter-error changes.

## Files

| Driver | Supporting function | Subject |
| --- | --- | --- |
| `thema1.m` | `func1.m` | Gradient estimator and rotational model |
| `thema2a.m` | `func2a.m` | Pendulum parameter estimation |
| `thema2b.m` | `func2b.m` | Disturbance/noise-amplitude sweep |

Each driver uses `ode45` to integrate the configured system/estimator equations.

## How to run

Use this folder as MATLAB's current folder and select a driver:

```matlab
thema1
```

Run `thema2a` and `thema2b` separately for the pendulum experiments.
The simulated inputs, gains, initial conditions and true parameters are defined
in the code. No external dataset is required.

## Results and limitations

The [report](docs/report.pdf) compares estimated trajectories, parameters and
errors for the original simulations. Convergence and offsets depend on model
assumptions, excitation, gains and initial conditions. The project is a
simulation study; MATLAB was not executed during portfolio preparation.

Report author: Petros Charalampidis
