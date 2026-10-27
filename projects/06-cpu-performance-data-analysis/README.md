[← Portfolio index](../../README.md)


# Statistical Analysis of CPU Performance

**MATLAB · Statistical Inference · Bootstrap · Regression**

Collaborative data-analysis coursework by Petros Charalampidis and
Thomas Tsekas examining CPU performance and its relationship to hardware
characteristics.

## Questions explored

- Empirical distributions, sampling and logarithmic transformations.
- Goodness-of-fit tests and confidence intervals.
- Parametric, bootstrap and permutation-based methods.
- Correlation analysis and regression diagnostics.
- Multiple/stepwise regression, principal component regression and LASSO.

The [code excerpts](CODE_EXCERPTS.md) show confidence-interval construction
and LASSO model selection followed by held-out prediction.

## Evaluation approach

The original assignments compare statistical procedures across sampled
subsets and investigate regression performance on observations excluded
from model fitting. The supplied dataset has 209 observations, and the
regression comparison uses a 65/35 training/test split within eligible
manufacturer groups.

No new numerical benchmark is presented here. Interpretation of the
statistical results depends on the dataset and the assumptions of each test.

## Public contents and team attribution

This folder contains an overview and two selected code fragments. The
complete scripts and input spreadsheet remain with the full project.
The work is credited jointly; the public excerpts do not imply sole
authorship of the original scripts.
