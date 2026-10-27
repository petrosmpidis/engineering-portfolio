function integrated_state = project1b_func5(differential_equation, current_t, current_x, step)
    step_half = step / 2;
    slope1 = differential_equation(current_t, current_x);
    slope2 = differential_equation(current_t + step_half, current_x + step_half * slope1);
    slope3 = differential_equation(current_t + step_half, current_x + step_half * slope2);
    slope4 = differential_equation(current_t + step, current_x + step * slope3);
    
    integrated_state = current_x + (step / 6) * (slope1 + 2 * slope2 + 2 * slope3 + slope4);
end