function update_rate = project1b_func4(param_vec, raw_rate, floor_limit, ceiling_limit)
    update_rate = raw_rate;
    for elem_idx = 1:length(param_vec)
        if (param_vec(elem_idx) <= floor_limit(elem_idx) && update_rate(elem_idx) < 0)
            update_rate(elem_idx) = 0;
        end
        if (param_vec(elem_idx) >= ceiling_limit(elem_idx) && update_rate(elem_idx) > 0)
            update_rate(elem_idx) = 0;
        end
    end
end