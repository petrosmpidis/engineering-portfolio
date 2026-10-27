function dx = project1a_func1(t, x, A, b1, b2, typ)
    u = project1a_func2(t, typ);
    g = [b1 + sin(x(1)) + x(2)^2; 
         b2 / (1 + x(1)^2)];
    dx = A * x + g * u;
end