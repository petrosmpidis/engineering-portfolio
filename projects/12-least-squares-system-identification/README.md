[← Portfolio index](../../README.md)

# Least-Squares Identification of a Mass-Spring-Damper System

**MATLAB · Dynamic Systems · ODE Simulation · Least Squares**

An academic modeling assignment by Petros Charalampidis estimating parameters
of a mass-spring-damper system from simulated input/output measurements.


## Problem Statement

Model and simulate a mass–spring–damper system, then estimate its unknown mass, damping and stiffness using least squares. Investigate how the sampling period and additive Gaussian measurement noise affect parameter estimates and the reconstructed system response.

## What the project covers

- State-space and transfer-function modeling of the mechanical system.
- ODE-based simulation under a configured input force.
- Least-squares parameter estimation from sampled signals.
- The effect of sampling period on estimation quality.
- The effect of added Gaussian noise on estimated parameters.

## Files and how to run

`lab01.m` contains the simulation and identification experiments.
Use this folder as MATLAB's current folder and run:

```matlab
lab01
```

The system parameters, signals and experiment settings are defined in the
script. No external measurement dataset was supplied or is needed for those
configured simulations. Inspect the script and report for any MATLAB
toolbox-specific functions required by the selected sections.

## Results

The [original report](docs/report.pdf) presents model derivation, response
plots and parameter-estimation errors. Its figures are supplied coursework
results; no new MATLAB execution was performed during packaging.

## Scope

The observations concern a simulated mechanical system. They do not establish
identification accuracy on an instrumented physical device.

Report author: Petros Charalampidis.
