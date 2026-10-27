function state_dot = project1b_func1(t_val, current_state, A_mat, scalar_b1, scalar_b2, max_w)
    excitation_u = project1b_func2(t_val);
    nonlinear_g = [scalar_b1 + sin(current_state(1)) + current_state(2)^2; 
                   scalar_b2 / (1 + current_state(1)^2)];
    active_disturbance = project1b_func3(t_val, max_w);
    
    state_dot = A_mat * current_state + nonlinear_g * excitation_u + active_disturbance;
end