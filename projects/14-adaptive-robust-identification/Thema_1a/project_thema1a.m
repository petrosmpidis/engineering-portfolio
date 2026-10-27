clear;
close all;
clc;

A = [-3.5,  0.25; -0.35, -2.8];
b1 = 1.8;
b2 = 1.25;

dt = 0.005;
T = 40;
t = (0:dt:T)';
N = length(t);

x0 = [1.1; -0.7];
xh0 = x0; 

th10 = [-2.5;  0.0;  1.5]; % [a11, a12, b1]
th20 = [ 0.0; -2.5;  0.8]; % [a21, a22, b2]
 
l1 = [-5.0; -0.5; 1.0];
u1 = [-2.0;  0.5; 2.5];
l2 = [-0.5; -5.0; 0.5];
u2 = [ 0.5; -2.0; 2.0];

L = diag([15, 15]);       
G1 = diag([20, 20, 15]);  
G2 = diag([20, 20, 15]);  

% Περιπτώσεις Εισόδου: 'pe' (Πλούσια Διέγερση), 'zero' (Μηδενική Είσοδος)
cases = {'pe', 'zero'};

for c = 1:2
    typ = cases{c};
    
    x = zeros(N, 2);
    xh = zeros(N, 2);
    th1 = zeros(N, 3);
    th2 = zeros(N, 3);
    uu = zeros(N, 1);
    
    x(1, :) = x0';
    xh(1, :) = xh0';
    th1(1, :) = th10';
    th2(1, :) = th20';
    
    for k = 1:N-1
        tk = t(k);
        uk = project1a_func2(tk, typ);
        uu(k) = uk;
        
        xx = x(k, :)';
        xxh = xh(k, :)';
        p1 = th1(k, :)';
        p2 = th2(k, :)';
        e = xx - xxh; 
        
        f1 = [xx(1); xx(2); uk];
        f2 = [xx(1); xx(2); uk / (1 + xx(1)^2)];
        
        known = [(sin(xx(1)) + xx(2)^2) * uk; 0];
        
        dxh = [p1'*f1; p2'*f2] + known + L * e;
        
        dp1 = G1 * f1 * e(1);
        dp2 = G2 * f2 * e(2);
        
        dp1 = project1a_func3(p1, dp1, l1, u1);
        dp2 = project1a_func3(p2, dp2, l2, u2);

        x(k+1, :) = project1a_func4(@(tt, zz) project1a_func1(tt, zz, A, b1, b2, typ), tk, xx, dt)';
        
        xh(k+1, :) = (xxh + dt * dxh)';
        
        p1 = p1 + dt * dp1;
        p2 = p2 + dt * dp2;
        p1 = min(max(p1, l1), u1);
        p2 = min(max(p2, l2), u2);
        
        th1(k+1, :) = p1';
        th2(k+1, :) = p2';
    end
    
    uu(N) = project1a_func2(t(N), typ);
    
    % Υπολογισμός Σφαλμάτων
    ex = x - xh;
    eA = [th1(:, 1) - A(1, 1), th1(:, 2) - A(1, 2), th2(:, 1) - A(2, 1), th2(:, 2) - A(2, 2)];
    eb = [th1(:, 3) - b1, th2(:, 3) - b2];
    
    % Γραφικές Παραστάσεις
    figure();
    subplot(3, 1, 1); plot(t, x(:, 1), 'b', t, xh(:, 1), 'r--', 'LineWidth', 1.5); grid on;
    ylabel('x_1(t)'); legend('x_1', 'x{hat}_1', 'Location', 'best');
    subplot(3, 1, 2); plot(t, x(:, 2), 'b', t, xh(:, 2), 'r--', 'LineWidth', 1.5); grid on;
    ylabel('x_2(t)'); legend('x_2', 'x{hat}_2', 'Location', 'best');
    subplot(3, 1, 3); plot(t, uu, 'g', 'LineWidth', 1.2); grid on;
    xlabel('Χρόνος t (s)'); ylabel('Είσοδος u(t)');
    
    figure();
    subplot(2, 1, 1); plot(t, ex(:, 1), 'b', 'LineWidth', 1.5); grid on; ylabel('e_{x1}(t)');
    subplot(2, 1, 2); plot(t, ex(:, 2), 'b', 'LineWidth', 1.5); grid on; xlabel('Χρόνος t (s)'); ylabel('e_{x2}(t)');
    
    figure();
    subplot(2, 1, 1); plot(t, eA, 'LineWidth', 1.5); grid on;
    ylabel('Σφάλματα Πίνακα A'); legend('e_{a11}', 'e_{a12}', 'e_{a21}', 'e_{a22}', 'Location', 'best');
    subplot(2, 1, 2); plot(t, eb, 'LineWidth', 1.5); grid on;
    xlabel('Χρόνος t (s)'); ylabel('Σφάλματα b_i'); legend('e_{b1}', 'e_{b2}', 'Location', 'best');
    
    perr = [eA(end, :), eb(end, :)];
    fprintf('\nΠΕΡΙΠΤΩΣΗ ΕΙΣΟΔΟΥ: %s', upper(typ));
    fprintf('\n||ex(T)||: %.6f', norm(ex(end, :)));
    fprintf('\nΝόρμα Παραμετρικού Σφάλματος: %.6f', norm(perr));
    fprintf('\nΕκτιμήσεις Α: \n [%.3f  %.3f  %.3f  %.3f]', th1(end,1), th1(end,2), th2(end,1), th2(end,2));
    fprintf('\nΕκτιμήσεις b1, b2:   \n b1_hat = %.3f (True = %.2f), b2_hat = %.3f (True = %.2f)\n', th1(end,3), b1, th2(end,3), b2);
end