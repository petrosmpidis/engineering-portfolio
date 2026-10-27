clear;
close all; 
clc;

true_theta = [-1.05; 3.2; 0.55];

sampling_period = 0.01;
horizon_time = 18;

num_train_sets = 8;
num_test_sets = 4;

% Αρχικοποίηση δομών δεδομένων
training_database = struct('time_axis', {}, 'state_vec', {}, 'input_vec', {});
testing_database = struct('time_axis', {}, 'state_vec', {}, 'input_vec', {});

for idx = 1:num_train_sets
    training_database(idx) = project2_func3(true_theta, horizon_time, sampling_period, idx, 'train');
end
for idx = 1:num_test_sets
    testing_database(idx) = project2_func3(true_theta, horizon_time, sampling_period, idx, 'test');
end

candidate_models = project2_func2();
total_models = length(candidate_models);

observer_L = 10;
learning_gamma = 70;
sigma_leakage = 1e-4;
theta_saturation = 30;
training_epochs = 2;

folds_count = 4;
assigned_folds = project2_func1(0:num_train_sets-1, folds_count) + 1;

validation_score = zeros(total_models, 1);
validation_std = zeros(total_models, 1);
complexity_penalty_score = zeros(total_models, 1);
lambda_reg = 0.02;

for m_idx = 1:total_models
    fold_errors = zeros(folds_count, 1);
    
    for f_idx = 1:folds_count
        train_indices = find(assigned_folds ~= f_idx);
        val_indices = find(assigned_folds == f_idx);
        
        estimated_theta = project2_func7(candidate_models(m_idx), training_database, train_indices, ...
            sampling_period, observer_L, learning_gamma, sigma_leakage, theta_saturation, training_epochs);
            
        fold_errors(f_idx) = project2_func8(candidate_models(m_idx), estimated_theta, training_database, val_indices, sampling_period);
    end
    
    validation_score(m_idx) = mean(fold_errors);
    validation_std(m_idx) = std(fold_errors);
    complexity_penalty_score(m_idx) = validation_score(m_idx) + lambda_reg * candidate_models(m_idx).num_params;
end

model_labels = cell(total_models, 1);
param_counts = zeros(total_models, 1);
for m_idx = 1:total_models
    model_labels{m_idx} = candidate_models(m_idx).description;
    param_counts(m_idx) = candidate_models(m_idx).num_params;
end

disp(' ');
disp('ΑΠΟΤΕΛΕΣΜΑΤΑ ΔΙΑΣΤΑΥΡΩΤΙΚΗΣ ΑΞΙΟΛΟΓΗΣΗΣ (CROSS VALIDATION)');
for m_idx = 1:total_models
    fprintf('%d) %s , Παράμετροι=%d , CV σφάλμα=%.6f , std=%.6f , Συνολικό Score=%.6f\n', ...
        m_idx, model_labels{m_idx}, param_counts(m_idx), validation_score(m_idx), validation_std(m_idx), complexity_penalty_score(m_idx));
end

[~, optimal_idx] = min(complexity_penalty_score);
best_structure = candidate_models(optimal_idx);

fprintf('\nΕπιλεγμένο Μοντέλο Βάσει Score: %s\n', best_structure.description);
fprintf('Πλήθος Παραμέτρων: %d\n', best_structure.num_params);

% Τελική εκπαίδευση με όλα τα δεδομένα εκπαίδευσης
final_theta = project2_func7(best_structure, training_database, 1:num_train_sets, ...
    sampling_period, observer_L, learning_gamma, sigma_leakage, theta_saturation, training_epochs);

disp(' ');
disp('ΤΕΛΙΚΟΙ ΕΚΤΙΜΗΜΕΝΟΙ ΣΥΝΤΕΛΕΣΤΕΣ');
for i = 1:length(final_theta)
    fprintf('%s : %.6f\n', best_structure.features{i}, final_theta(i));
end

[total_test_K, predicted_trajectories] = project2_func8(best_structure, final_theta, testing_database, 1:num_test_sets, sampling_period);
fprintf('\nΣυνολικό Σφάλμα Γενίκευσης στα Test Data K = %.6f\n', total_test_K);

% Γραφικές Παραστάσεις

figure();
bar(validation_score); grid on;
set(gca, 'XTick', 1:total_models, 'XTickLabel', model_labels);
xtickangle(25); ylabel('Κριτήριο CV K');
title('Cross Validation Error');

figure();
bar(complexity_penalty_score); grid on;
set(gca, 'XTick', 1:total_models, 'XTickLabel', model_labels);
xtickangle(25); ylabel('CV K + Ποινή \lambda \cdot n');
title('Διαδικασία Επιλογής Δομής Μοντέλου');

sample_test_data = testing_database(1);
estimated_xh = predicted_trajectories{1};

figure();
subplot(2, 1, 1);
plot(sample_test_data.time_axis, sample_test_data.state_vec, 'b', 'LineWidth', 1.2); hold on;
plot(sample_test_data.time_axis, estimated_xh, 'r--', 'LineWidth', 1.2);
grid on; ylabel('Κατάσταση x(t)');
legend('Πραγματικό Σύστημα', 'Προβλεπόμενο Μοντέλο');
title(['Σύγκριση στο Test Set 1 - Μοντέλο: ', best_structure.description]);

subplot(2, 1, 2);
plot(sample_test_data.time_axis, sample_test_data.state_vec - estimated_xh, 'm', 'LineWidth', 1.2);
grid on; xlabel('Χρόνος t (s)'); ylabel('Σφάλμα e(t)');