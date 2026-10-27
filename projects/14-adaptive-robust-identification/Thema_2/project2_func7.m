function theta_estimate = project2_func7(struct_model, full_data, target_ids, dt, L_gain, gamma_gain, leak_factor, cap_bound, total_epochs)
    theta_estimate = zeros(struct_model.num_params, 1);
    
    for epoch = 1:total_epochs
        for sub_idx = 1:length(target_ids)
            current_trajectory = full_data(target_ids(sub_idx));
            state_estimator = current_trajectory.state_vec(1);
            
            for k = 1:length(current_trajectory.time_axis)-1
                true_x = current_trajectory.state_vec(k);
                applied_u = current_trajectory.input_vec(k);
                state_error = true_x - state_estimator;
                
                evaluated_phi = project2_func9(struct_model, true_x, applied_u);
                
                est_dynamics = theta_estimate' * evaluated_phi + L_gain * state_error;
                theta_dot = gamma_gain * evaluated_phi * state_error / (1 + evaluated_phi' * evaluated_phi) - leak_factor * theta_estimate;
                
                theta_estimate = theta_estimate + dt * theta_dot;
                theta_estimate = min(max(theta_estimate, -cap_bound), cap_bound);
                
                state_estimator = state_estimator + dt * est_dynamics;
                
                if ~isfinite(state_estimator) || abs(state_estimator) > 20
                    state_estimator = true_x;
                end
            end
        end
    end
end