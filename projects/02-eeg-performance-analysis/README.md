[← Portfolio index](../../README.md)


# EEG Features and Task Performance

**MATLAB · EEG · Feature Engineering · Regression · Statistical Evaluation**

A team research project investigating whether EEG-derived features can
describe or predict task performance at two difficulty levels of a
Matchboard exercise in a robotic surgery simulator.

## My role

**Project Lead & Co-author**

I led a five-member team, coordinating project activities, allocating tasks
and contributing to the final report. My primary technical responsibility
covered research questions 6 and 7: comparing EEG feature sets and evaluating
regression models for task-performance prediction. I also supported the team
across the remaining analyses and helped integrate the final deliverable.

## Technical focus

- Compare functional brain network (FBN), higher-order-statistics (HOS)
  and power spectral density (PSD) feature families.
- Evaluate Ridge Regression, Support Vector Regression, Random Forest
  and LSBoost for continuous performance prediction.
- Use participant-disjoint nested cross-validation and baseline comparisons.
- Distinguish exploratory associations from out-of-participant prediction.

The [code excerpts](CODE_EXCERPTS.md) show the feature-family definitions
and the registration of baseline/model comparisons for questions 6 and 7.

## Reported study and outcome

The study uses 81 reviewed recordings from 17 participants; 11 participants
have recordings at both task levels. Reviewed windows retain explicit
artifact uncertainty.

| Model | Reported R² | Reported RMSE |
| --- | ---: | ---: |
| FBN+HOS Ridge, primary E6 comparison | -0.043 | 17.19 |
| Task-mean baseline | 0.0005 | 16.82 |

The EEG models did not demonstrate improved generalization beyond the
task-mean baseline. More complex regression methods did not improve that
outcome. Workload prediction was not performed because genuine measured
workload labels were unavailable. These are original study results;
the experiments were not rerun for this presentation.

## Team

Report authors: Πέτρος Χαραλαμπίδης, Αλέξανδρος Δ. Παπαδόπουλος,
Φαίδων Ι. Χατζηβασιλείου, Γεώργιος Στεφανίδης and Θωμάς Τσέκας.
The study and shared code are collaborative work.

## Public contents

This folder contains the overview and two short code excerpts. The full
analysis/preprocessing code, participant-level data, report and presentation
are retained with the complete project.
