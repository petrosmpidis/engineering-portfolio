function data_packet = project2_func3(param_theta, sim_time, step_h, routine_id, partition_type)
    time_nodes = (0:step_h:sim_time)';
    steps_total = length(time_nodes);
    states_out = zeros(steps_total, 1);
    inputs_out = zeros(steps_total, 1);
    
    states_out(1) = project2_func4(routine_id, partition_type);
    
    for k = 1:steps_total-1
        t_k = time_nodes(k);
        inputs_out(k) = project2_func6(t_k, routine_id, partition_type);
        
        states_out(k+1) = project2_func11(@(t, z) project2_func5(z, project2_func6(t, routine_id, partition_type), param_theta), t_k, states_out(k), step_h);
        
        if ~isfinite(states_out(k+1))
            states_out(k+1) = states_out(k);
        end
        
        if abs(states_out(k+1)) > 6
            states_out(k+1) = 6 * sign(states_out(k+1));
        end
    end
    
    inputs_out(steps_total) = project2_func6(time_nodes(steps_total), routine_id, partition_type);
    
    data_packet.time_axis = time_nodes;
    data_packet.state_vec = states_out;
    data_packet.input_vec = inputs_out;
end