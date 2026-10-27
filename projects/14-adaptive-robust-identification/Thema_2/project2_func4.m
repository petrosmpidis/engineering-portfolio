function x0_val = project2_func4(dataset_id, data_label)
    if strcmp(data_label, 'train')
        pool = [-0.7, -0.45, -0.2, 0.1, 0.35, 0.6, -0.55, 0.75];
    else
        pool = [-0.65, 0.55, -0.35, 0.85];
    end
    pointer = project2_func1(dataset_id - 1, length(pool)) + 1;
    x0_val = pool(pointer);
end