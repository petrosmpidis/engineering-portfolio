[← Project overview](README.md)

# Selected Code Excerpts

Team project. Petros Charalampidis served as Project Lead & Co-author, with primary responsibility for research questions 6 and 7. The complete study and shared code are collaborative work.

These are short extracts from the original project, selected for this public
portfolio. Imports, surrounding modules, helper implementations, data and
execution setup are outside the displayed context. The extracts are not
standalone programs. Source paths identify their origin in the complete project.

## Feature-family comparison for E6

The analysis compares prespecified FBN and HOS feature families, their combination, and supplementary PSD/cepstral feature sets. The extracted feature table is defined elsewhere.

Source excerpt: `project/ANALYSIS/PTES_E1_E9_COMPACT/e6.m`, lines 16–21.

```matlab
featureSets = {D.families.FBN, D.families.HOS, ...
    [D.families.FBN D.families.HOS], D.families.PSD, ...
    [D.families.PSD D.families.FBN], [D.families.PSD D.families.HOS], ...
    D.featureNames, D.families.H3, [D.families.H3 D.families.H4]};
labels = {'FBN','HOS','FBN_HOS','PSD','PSD_FBN','PSD_HOS', ...
    'ALL','Cepstrum','Cepstrum_Bicepstrum'};
```

## Baseline and regression comparisons for E7

The same evaluation interface registers mean/task-mean baselines and evaluates HOS and ALL features. The `models` list is configured elsewhere as Ridge, SVR, Random Forest and LSBoost. The cross-validation helper is outside this excerpt.

Source excerpt: `project/ANALYSIS/PTES_E1_E9_COMPACT/e7.m`, lines 30–43.

```matlab
Results{end+1}=analysis_common('cv',T,zeros(height(T),0),{}, ...
    'Performance','Mean','Baseline',C);
Results{end+1}=analysis_common('cv',T,zeros(height(T),0),{}, ...
    'Performance','TaskMean','Baseline',C);

featureSets={D.families.HOS,D.featureNames};
labels={'HOS','ALL'};
for k=1:numel(featureSets)
    for m=1:numel(models)
        Results{end+1}=analysis_common('cv',T,T{:,featureSets{k}},featureSets{k}, ... %#ok<AGROW>
            'Performance',models{m},labels{k},C);
    end
end
analysis_common('model_report',Results,fullfile(out,'Main_RecordingModels'),C);
```
