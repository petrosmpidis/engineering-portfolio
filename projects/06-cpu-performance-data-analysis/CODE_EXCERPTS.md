[← Project overview](README.md)

# Selected Code Excerpts

Collaborative coursework by Petros Charalampidis and Thomas Tsekas. These excerpts illustrate selected statistical workflows and do not assign sole authorship of the original scripts.

These are short extracts from the original project, selected for this public
portfolio. Imports, surrounding modules, helper implementations, data and
execution setup are outside the displayed context. The extracts are not
standalone programs. Source paths identify their origin in the complete project.

## Parametric and bootstrap intervals

For each sampled group, the code constructs a t-based confidence interval for the mean and compares it with a bootstrap percentile interval. Sampling and parameters are configured earlier.

Source excerpt: `Group52Exe4Prog1.m`, lines 37–48.

```matlab
for i = 1:M
    s = pin(i,:);
    m = mean(s);
    se = std(s)/sqrt(n);
    tcrit = tinv(1-alpha/2, n-1);   
    ci(i,1) = m - tcrit*se;
    ci(i,2) = m + tcrit*se;

    B = bootstrp(nBoot, @mean, s);  % eipwthike sto mathima
    ci_boot(i,1) = prctile(B, 100*alpha/2);
    ci_boot(i,2) = prctile(B, 100*(1-alpha/2));
end
```

## LASSO selection and held-out prediction

The regularization choice uses training-set cross-validation. The selected coefficients are then evaluated on held-out observations using mean squared error.

Source excerpt: `Group52Exe10Prog1.m`, lines 75–84.

```matlab
%LASSO:
K = min(10, size(Xtrain,1)-1);
[bLASSOv, FitInfo] = lasso(Xtrain, ytrain, 'CV', K);

idxLambdaMinMSE = FitInfo.IndexMinMSE;
bLassoIntercept = FitInfo.Intercept(idxLambdaMinMSE);
bLASSO = bLASSOv(:, idxLambdaMinMSE);

yfitLASSO_test = bLassoIntercept + Xtest*bLASSO;
MSE_LASSO = mean((ytest - yfitLASSO_test).^2);
```
