function state_next = project2_func11(ode_function, time_t, state_x, step_size)
    k1 = ode_function(time_t, state_x);
    k2 = ode_function(time_t + step_size/2, state_x + step_size * k1 / 2);
    k3 = ode_function(time_t + step_size/2, state_x + step_size * k2 / 2);
    k4 = ode_function(time_t + step_size, state_x + step_size * k3);
    state_next = state_x + step_size * (k1 + 2 * k2 + 2 * k3 + k4) / 6;
end