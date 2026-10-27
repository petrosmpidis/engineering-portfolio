[← Portfolio index](../../README.md)

# Constrained Optimization with Projected Gradient

**MATLAB · Steepest Descent · Projection · Box Constraints**

An academic assignment by Petros Charalampidis studying gradient iterations
for the quadratic objective `f(x1,x2) = x1^2/3 + 3*x2^2`.

## Problem and approach

The constrained problem uses `-10 <= x1 <= 5` and `-8 <= x2 <= 12`.
The implementation compares ordinary steepest descent with a projected
variant and explores how step sizes and initial conditions affect behavior.

## Files

| File | Purpose |
| --- | --- |
| `func.m` | Objective surface, contours and constraint rectangle |
| `thema_1.m` | Unconstrained descent experiments |
| `thema_2_3_4.m` | Configured projected-gradient experiments |
| `Steepest_Descent.m` | Ordinary steepest-descent implementation |
| `steepest_Descent_proj.m` | Projected-gradient implementation |
| `projection.m` | Projection helper |
| `docs/report.pdf` | Original report |

## How to run

With MATLAB and the Symbolic Math Toolbox, set this folder as the current
folder and run the required driver, for example:

```matlab
thema_1
```

Run `thema_2_3_4` for the projected cases. Test functions and settings are
contained in the code; no external data is needed. Keep assignment-specific
helpers together to avoid collisions with other `func.m` files.

## Results and limitations

The [report](docs/report.pdf) contains the original objective/iteration plots
and discussion. Large step sizes are part of the experiment and may illustrate
unstable iterations rather than successful convergence. MATLAB was not run
during preparation. The supplied source is preserved unchanged.

Report author: Petros Charalampidis.
