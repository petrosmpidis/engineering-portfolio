[← Project overview](README.md)

# Selected Code Excerpts

Internship project associated with Petros Charalampidis at CERTH/ITI. These excerpts show model structure and evaluation boundaries; they do not include firmware or trained parameters.

These are short extracts from the original project, selected for this public
portfolio. Imports, surrounding modules, helper implementations, data and
execution setup are outside the displayed context. The extracts are not
standalone programs. Source paths identify their origin in the complete project.

## Compact classification model

The model uses two small hidden layers and a sigmoid output for binary tremor classification. `input_dim` is determined by the training-fold feature selection.

Source excerpt: `Edge_AI_Model/src/05_train_nn.py`, lines 41–51.

```python
model = keras.Sequential([
    keras.layers.Input(shape=(input_dim,)),
    keras.layers.Dense(32, activation="relu"),
    keras.layers.Dense(16, activation="relu"),
    keras.layers.Dense(1, activation="sigmoid"),
])
model.compile(
    optimizer=keras.optimizers.Adam(learning_rate=1e-3),
    loss="binary_crossentropy",
    metrics=["accuracy"],
)
```

## Group-disjoint training and validation

Group-overlap assertions separate raw segments/recordings in the outer evaluation and inner validation split. These groups do not establish patient-independent testing.

Source excerpt: `Edge_AI_Model/src/05_train_nn.py`, lines 70–82.

```python
for fold_idx, (train_idx, test_idx) in enumerate(outer.split(X, y, groups)):
    assert len(set(groups[train_idx]) & set(groups[test_idx])) == 0
    X_outer_train, X_test = X[train_idx], X[test_idx]
    y_outer_train, y_test = y[train_idx], y[test_idx]
    g_outer_train = groups[train_idx]

    # INNER SPLIT: επιλογή epochs + classification threshold
    # Ο scaler, feature pruning και class weights βλέπουν μόνο inner-subtrain
    inner = StratifiedGroupKFold(
        n_splits=INNER_SPLITS, shuffle=True, random_state=RANDOM_STATE + fold_idx
    )
    sub_idx, val_idx = next(inner.split(X_outer_train, y_outer_train, g_outer_train))
    assert len(set(g_outer_train[sub_idx]) & set(g_outer_train[val_idx])) == 0
```
