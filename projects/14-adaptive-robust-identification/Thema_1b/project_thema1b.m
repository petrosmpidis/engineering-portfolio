clear; 
close all; 
clc;

A_nominal = [-3.5,  0.25; 
             -0.35, -2.8];
b1_nominal = 1.8;
b2_nominal = 1.25;

delta_t = 0.005;
t_final = 40;
timeline = (0:delta_t:t_final)';
max_nodes = length(timeline);

state_init = [1.1; -0.7];
est_state_init = state_init;

w1_start = [-2.5;  0.0;  1.5];
w2_start = [ 0.0; -2.5;  0.8];

inf_limit1 = [-5.0; -0.5; 1.0];
sup_limit1 = [-2.0;  0.5; 2.5];
inf_limit2 = [-0.5; -5.0; 0.5];
sup_limit2 = [ 0.5; -2.0; 2.0];

center_ref1 = (inf_limit1 + sup_limit1) / 2;
center_ref2 = (inf_limit2 + sup_limit2) / 2;

gain_observer = diag([15, 15]);       
gain_adapt1 = diag([20, 20, 15]);  
gain_adapt2 = diag([20, 20, 15]);  

sigma_leak = 0.15; 

disturbance_bounds = [0, 0.05, 0.15, 0.3];
performance_summary = zeros(length(disturbance_bounds), 3);

for q_idx = 1:length(disturbance_bounds)
    active_wbar = disturbance_bounds(q_idx);
    
    % Δέσμευση Μνήμης
    array_states = zeros(max_nodes, 2);
    array_est_states = zeros(max_nodes, 2);
    array_weights1 = zeros(max_nodes, 3);
    array_weights2 = zeros(max_nodes, 3);
    array_inputs = zeros(max_nodes, 1);
    array_dist_norm = zeros(max_nodes, 1);
    
    array_states(1, :) = state_init';
    array_est_states(1, :) = est_state_init';
    array_weights1(1, :) = w1_start';
    array_weights2(1, :) = w2_start';
    
    % Κύριος Αλγόριθμος Προσομοίωσης
    for n = 1:max_nodes-1
        t_now = timeline(n);
        u_now = project1b_func2(t_now);
        w_now = project1b_func3(t_now, active_wbar);
        
        array_inputs(n) = u_now;
        array_dist_norm(n) = norm(w_now);
        
        x_now = array_states(n, :)';
        x_est_now = array_est_states(n, :)';
        theta_vec1 = array_weights1(n, :)';
        theta_vec2 = array_weights2(n, :)';
        error_vector = x_now - x_est_now; 
        
        phi_vec1 = [x_now(1); x_now(2); u_now];
        phi_vec2 = [x_now(1); x_now(2); u_now / (1 + x_now(1)^2)];

        nl_vector = [(sin(x_now(1)) + x_now(2)^2) * u_now; 0];

        state_deriv = [theta_vec1'*phi_vec1; theta_vec2'*phi_vec2] + nl_vector + gain_observer * error_vector;

        dtheta_vec1 = gain_adapt1 * phi_vec1 * error_vector(1) - sigma_leak * gain_adapt1 * (theta_vec1 - center_ref1);
        dtheta_vec2 = gain_adapt2 * phi_vec2 * error_vector(2) - sigma_leak * gain_adapt2 * (theta_vec2 - center_ref2);

        dtheta_vec1 = project1b_func4(theta_vec1, dtheta_vec1, inf_limit1, sup_limit1);
        dtheta_vec2 = project1b_func4(theta_vec2, dtheta_vec2, inf_limit2, sup_limit2);

        array_states(n+1, :) = project1b_func5(@(time, state) project1b_func1(time, state, A_nominal, b1_nominal, b2_nominal, active_wbar), t_now, x_now, delta_t)';

        array_est_states(n+1, :) = (x_est_now + delta_t * state_deriv)';

        theta_vec1 = theta_vec1 + delta_t * dtheta_vec1;
        theta_vec2 = theta_vec2 + delta_t * dtheta_vec2;
        theta_vec1 = min(max(theta_vec1, inf_limit1), sup_limit1);
        theta_vec2 = min(max(theta_vec2, inf_limit2), sup_limit2);
        
        array_weights1(n+1, :) = theta_vec1';
        array_weights2(n+1, :) = theta_vec2';
    end
    
    % Υπολογισμός Σφαλμάτων
    diff_states = array_states - array_est_states;
    diff_matrix = [array_weights1(:, 1) - A_nominal(1, 1), array_weights1(:, 2) - A_nominal(1, 2), ...
                   array_weights2(:, 1) - A_nominal(2, 1), array_weights2(:, 2) - A_nominal(2, 2)];
    diff_scalars = [array_weights1(:, 3) - b1_nominal, array_weights2(:, 3) - b2_nominal];

    tail_span = round(0.75 * max_nodes):max_nodes;
    performance_summary(q_idx, 1) = active_wbar;
    performance_summary(q_idx, 2) = sqrt(mean(sum(diff_states(tail_span, :).^2, 2)));
    performance_summary(q_idx, 3) = norm([diff_matrix(end, :), diff_scalars(end, :)]);

    % Γραφικές Παραστάσεις
    figure();
    subplot(3, 1, 1); plot(timeline, array_states(:, 1), 'b', timeline, array_est_states(:, 1), 'r--', 'LineWidth', 1.3); grid on;
    ylabel('x_1(t)'); legend('Πραγματική', 'Εκτιμώμενη');
    title(['Απόκριση υπό Διαταραχή: ||w|| \\leq ', num2str(active_wbar)]);
    subplot(3, 1, 2); plot(timeline, array_states(:, 2), 'b', timeline, array_est_states(:, 2), 'r--', 'LineWidth', 1.3); grid on;
    ylabel('x_2(t)'); legend('Πραγματική', 'Εκτιμώμενη');
    subplot(3, 1, 3); plot(timeline, array_dist_norm, 'm', 'LineWidth', 1.2); grid on;
    xlabel('Χρόνος t (s)'); ylabel('||w(t)||');
    
    figure();
    subplot(2, 1, 1); plot(timeline, diff_states(:, 1), 'b', timeline, diff_states(:, 2), 'g', 'LineWidth', 1.3); grid on;
    ylabel('Σφάλμα Κατάστασης'); legend('e_{x1}', 'e_{x2}');
    title(['Εξέλιξη Σφαλμάτων: wbar = ', num2str(active_wbar)]);
    subplot(2, 1, 2); plot(timeline, diff_scalars, 'LineWidth', 1.3); grid on;
    xlabel('Χρόνος t (s)'); ylabel('Σφάλμα b_i'); legend('e_{b1}', 'e_{b2}');
    
    figure();
    plot(timeline, diff_matrix, 'LineWidth', 1.3); grid on;
    xlabel('Χρόνος t (s)'); ylabel('e_A(t)'); legend('e_{a11}', 'e_{a12}', 'e_{a21}', 'e_{a22}');
    title(['Παραμετρική Απόκλιση Πίνακα A: wbar = ', num2str(active_wbar)]);
    
    fprintf('\nΌριο Διαταραχής wbar = %.3f', active_wbar);
    fprintf('\nTail RMS Σφάλματος Κατάστασης: %.6f', performance_summary(q_idx, 2));
    fprintf('\nΤελικό Παραμετρικό Σφάλμα:    %.6f\n', performance_summary(q_idx, 3));
end

% Συγκεντρωτικός Πίνακας Αποτελεσμάτων
disp(' ');
disp('ΣΥΓΚΕΝΤΡΩΤΙΚΑ ΑΠΟΤΕΛΕΣΜΑΤΑ ΕΥΡΩΣΤΙΑΣ');
disp(array2table(performance_summary, 'VariableNames', {'Bound_wbar', 'Tail_RMS_ex', 'Final_Param_Error'}));

% Διάγραμμα επίδρασης του wbar στις μετρικές
figure();
subplot(2, 1, 1); plot(performance_summary(:, 1), performance_summary(:, 2), '-o', 'Color', 'b', 'LineWidth', 1.5); grid on;
xlabel('Ανώτατο Όριο Διαταραχής \\bar{w}'); ylabel('Tail RMS e_x');
title('Επίδραση της Διαταραχής στο Σφάλμα Κατάστασης');
subplot(2, 1, 2); plot(performance_summary(:, 1), performance_summary(:, 3), '-o', 'Color', 'r', 'LineWidth', 1.5); grid on;
xlabel('Ανώτατο Όριο Διαταραχής \\bar{w}'); ylabel('Παραμετρικό Σφάλμα ||e_{\\theta}||');
title('Επίδραση της Διαταραχής στο Παραμετρικό Σφάλμα');
