clear;
clc; 
close all;

u1_range = [-1, 2];
u2_range = [-2, 1];

N_samples = 1000; 

% Τυχαία επιλογή σημείων 
U1 = (u1_range(2) - u1_range(1)) * rand(N_samples, 1) + u1_range(1);
U2 = (u2_range(2) - u2_range(1)) * rand(N_samples, 1) + u2_range(1);

% Υπολογισμός πραγματικής εξόδου 
Y_true = sin(U1 + U2) .* sin(U2.^2);

% Διαχωρισμός σε Training και Validation
p = 0.70;
idx = randperm(N_samples);
n_train = round(p * N_samples);

train_idx = idx(1:n_train);
val_idx = idx(n_train+1:end);

X_train = [U1(train_idx), U2(train_idx)];
Y_train = Y_true(train_idx);

X_val = [U1(val_idx), U2(val_idx)];
Y_val = Y_true(val_idx);

num_gaussians = 15; 
pop_size = 100;     % Μέγεθος πληθυσμού
generations = 300;  % Αριθμός γενεών
mutation_rate = 0.1;
selection_pressure = 4; % Για Tournament Selection

% Κάθε Gaussian χρειάζεται 5 παραμέτρους: Weight, c1, c2, sigma1, sigma2

num_genes = num_gaussians * 5;

pop = rand(pop_size, num_genes);

for k = 1:num_gaussians
    idx_start = (k-1)*5 + 1;
    % Weight (w)
    pop(:, idx_start) = (pop(:, idx_start) - 0.5) * 10; 
    % Center 1 (c1)
    pop(:, idx_start+1) = pop(:, idx_start+1) * (u1_range(2)-u1_range(1)) + u1_range(1);
    % Center 2 (c2)
    pop(:, idx_start+2) = pop(:, idx_start+2) * (u2_range(2)-u2_range(1)) + u2_range(1);
    % Sigma 1 (s1) - αποφεύγουμε το 0
    pop(:, idx_start+3) = pop(:, idx_start+3) * 2 + 0.1;
    % Sigma 2 (s2)
    pop(:, idx_start+4) = pop(:, idx_start+4) * 2 + 0.1;
end

best_fitness_history = zeros(generations, 1);
best_solution = [];
min_error = inf;

for gen = 1:generations
    fitness = zeros(pop_size, 1);
    for i = 1:pop_size
        chromosome = pop(i, :);
        Y_pred = evaluate_model(chromosome, X_train, num_gaussians);
        mse = mean((Y_train - Y_pred).^2);
        fitness(i) = mse; 
    end
    
    % Εύρεση του καλύτερου της γενιάς
    [current_best_val, idx_best] = min(fitness);
    
    % Διατήρηση του καλύτερου 
    if current_best_val < min_error
        min_error = current_best_val;
        best_solution = pop(idx_best, :);
    end
    best_fitness_history(gen) = min_error;
    
    new_pop = zeros(size(pop));
    new_pop(1, :) = best_solution;
    start_idx = 2;
    
    for i = start_idx:pop_size
        % Επιλογή δύο γονέων
        p1 = tournament_select(pop, fitness, selection_pressure);
        p2 = tournament_select(pop, fitness, selection_pressure);
        
        alpha = rand();
        child = alpha * p1 + (1 - alpha) * p2;
        
        if rand() < mutation_rate
            mutation_point = randi(num_genes);
            noise = randn() * 0.5; 
            child(mutation_point) = child(mutation_point) + noise;
            
            rem_idx = mod(mutation_point, 5);
            if rem_idx == 4 || rem_idx == 0 
                 if child(mutation_point) < 0.01
                     child(mutation_point) = 0.1;
                 end
            end
        end
        new_pop(i, :) = child;
    end
    pop = new_pop;
end

fprintf('MSE στο Training Set: %.6f', min_error);

% Έλεγχος στο Validation Set (Ανεξάρτητα δεδομένα) 
Y_val_pred = evaluate_model(best_solution, X_val, num_gaussians);
val_mse = mean((Y_val - Y_val_pred).^2);
fprintf('\nMSE στο Validation Set: %.6f\n', val_mse);

% Plot 1: Καμπύλη Μάθησης
figure;
plot(best_fitness_history, 'LineWidth', 2);
xlabel('Generations'); ylabel('MSE');
title('Σύγκλιση Γενετικού Αλγορίθμου');
grid on;

% Plot 2: 3D Σύγκριση (Πραγματικό vs Προσεγγιστικό)
figure;
n_grid = 50;
u1_lin = linspace(u1_range(1), u1_range(2), n_grid);
u2_lin = linspace(u2_range(1), u2_range(2), n_grid);
[U1_mesh, U2_mesh] = meshgrid(u1_lin, u2_lin);

% Πραγματική επιφάνεια
Z_true = sin(U1_mesh + U2_mesh) .* sin(U2_mesh.^2);

% Προσεγγιστική επιφάνεια
X_mesh_flat = [U1_mesh(:), U2_mesh(:)];
Z_pred_flat = evaluate_model(best_solution, X_mesh_flat, num_gaussians);
Z_pred = reshape(Z_pred_flat, n_grid, n_grid);

subplot(1,2,1);
surf(U1_mesh, U2_mesh, Z_true);
title('Πραγματική Συνάρτηση f(u_1, u_2)');
xlabel('u_1'); ylabel('u_2'); zlabel('y');

subplot(1,2,2);
surf(U1_mesh, U2_mesh, Z_pred);
title(['Προσέγγιση (N=' num2str(num_gaussians) ')']);
xlabel('u_1'); ylabel('u_2'); zlabel('y');

fprintf('\n%-5s %-10s %-10s %-10s %-10s %-10s\n', 'k', 'Weight(w)', 'Center(c1)', 'Center(c2)', 'Sigma(s1)', 'Sigma(s2)');

for k = 1:num_gaussians
    idx = (k-1)*5 + 1;
    w  = best_solution(idx);
    c1 = best_solution(idx+1);
    c2 = best_solution(idx+2);
    s1 = best_solution(idx+3);
    s2 = best_solution(idx+4);
    
    fprintf('%-5d %-10.4f %-10.4f %-10.4f %-10.4f %-10.4f\n', k, w, c1, c2, s1, s2);
end

fprintf('\nΗ τελική εξίσωση είναι το άθροισμα των παραπάνω όρων G(u1,u2).\n');
