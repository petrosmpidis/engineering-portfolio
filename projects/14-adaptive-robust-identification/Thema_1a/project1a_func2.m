function u = project1a_func2(t, typ)
    if strcmp(typ, 'pe')
        u = 1.5 * sin(1.2 * t) + 1.0 * sin(3.1 * t) + 0.5 * cos(5.3 * t) + 0.4 * sin(0.5 * t);
    else
        u = 0;
    end
end