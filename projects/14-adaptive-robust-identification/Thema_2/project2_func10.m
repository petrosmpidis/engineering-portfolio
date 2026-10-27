function exp_output = project2_func10(power_val)
    power_val = max(min(power_val, 8), -8);
    exp_output = exp(power_val);
end