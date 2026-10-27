function xn = project1a_func4(f, t, x, dt)
    k1 = f(t, x);
    k2 = f(t + dt/2, x + dt * k1 / 2);
    k3 = f(t + dt/2, x + dt * k2 / 2);
    k4 = f(t + dt, x + dt * k3);
    xn = x + dt * (k1 + 2 * k2 + 2 * k3 + k4) / 6;
end