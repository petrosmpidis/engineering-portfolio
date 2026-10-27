function [cumulative_error, predictions] = project2_func8(struct_model, theta_coefficients, full_data, target_ids, dt)
    cumulative_error = 0;
    predictions = cell(length(target_ids), 1);
    
    for sub_idx = 1:length(target_ids)
        current_trajectory = full_data(target_ids(sub_idx));
        simulated_xh = zeros(size(current_trajectory.state_vec));
        simulated_xh(1) = current_trajectory.state_vec(1);
        simulation_corrupted = 0;
        
        for k = 1:length(current_trajectory.time_axis)-1
            evaluated_phi = project2_func9(struct_model, simulated_xh(k), current_trajectory.input_vec(k));
            next_state_derivative = theta_coefficients' * evaluated_phi;
            simulated_xh(k+1) = simulated_xh(k) + dt * next_state_derivative;
            
            if ~isfinite(simulated_xh(k+1)) || abs(simulated_xh(k+1)) > 20
                simulation_corrupted = 1;
                break;
            end
        end
        
        if simulation_corrupted == 1
            trajectory_cost = 1e8;
            simulated_xh(:) = nan;
        else
            trajectory_cost = trapz(current_trajectory.time_axis, (current_trajectory.state_vec - simulated_xh).^2);
        end
        
        predictions{sub_idx} = simulated_xh;
        cumulative_error = cumulative_error + trajectory_cost;
    end
end