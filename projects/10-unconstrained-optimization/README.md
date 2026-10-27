[← Portfolio index](../../README.md)

# Unconstrained Multivariable Optimization

**MATLAB · Steepest Descent · Newton · Levenberg-Marquardt · Line Search**

An academic assignment by Petros Charalampidis examining iterative minimization
of the two-variable test function `f(x,y) = x^3 * exp(-x^2 - y^4)`.

## Methods and experiments

- Steepest descent, Newton and Levenberg-Marquardt iterations.
- Different starting points and step-size choices.
- Constant steps, line-search variants and Armijo-based rules.
- Objective curves and contour plots illustrating the iteration paths.

This objective is not globally convex; the repository does not inherit a
global-convexity claim from wording in the original coursework report.

## Files

| File family | Purpose |
| --- | --- |
| `func.m` | Surface and contour visualization of the objective |
| `st_desc*.m` | Steepest-descent driver and variants |
| `newton*.m` | Newton driver and variants |
| `leven_marq.m`, `lev_marq_*.m` | Levenberg-Marquardt driver and variants |
| `gold_sect_modified.m` | Supporting golden-section search |
| `docs/report.pdf` | Original report |

## How to run

Use this folder as MATLAB's current folder. The symbolic definitions and
derivatives used by the scripts require the Symbolic Math Toolbox. For example:

```matlab
func
st_desc
```

The method drivers configure their own experiments. Read their parameters
before selecting variants or changing initial points. No external dataset
is needed; keep same-named helper files from other assignments off the path.

## Results and limitations

See the [original report](docs/report.pdf) for supplied convergence figures.
No MATLAB experiments were rerun during portfolio preparation. Numerical
outcomes depend on initialization, step-size rules and stopping criteria.

Report author: Petros Charalampidis.
