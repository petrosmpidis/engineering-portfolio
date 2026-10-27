clear all
close all
clc

% Παράμετροι συστήματος
g = 9.81;
l = 1.5;
c = 0.5;
am = 5;
gamma1 = 100;
gamma2 = 100;

tspan = [0,100];


% Θόρυβος
n0_values = linspace(0,0.1,11);   % [0-0.2]
e_l = zeros(size(n0_values));
e_c = zeros(size(n0_values));

for i=1:length(n0_values)
    n0 = n0_values(i);
    X0 = [0.1; 0; 0; 0; -3; -0.1];
    
    [t,X] = ode45(@(t,X)func2b(t,X,g,l,c,am,gamma1,gamma2,n0),tspan,X0);
    theta1_final = X(end,5);
    theta2_final = X(end,6);

    l_hat = -g/theta1_final;
    c_hat = -theta2_final;

    e_l(i) = abs(l_hat-l);
    e_c(i) = abs(c_hat-c);

    fprintf('n0 = %.2f | Σφάλμα l: %.4f | Σφάλμα c: %.4f\n', n0, e_l(i), e_c(i));
end

figure
subplot(2,1,1);
plot(n0_values, e_l, 'o-', 'LineWidth', 1.5);
title('Σφάλμα Εκτίμησης l σε συνάρτηση με το πλάτος θορύβου n_0');
xlabel('Πλάτος Θορύβου n_0'); 
ylabel('|e_l| (m)'); 
grid on;

subplot(2,1,2);
plot(n0_values, e_c, 's-', 'LineWidth', 1.5);
title('Σφάλμα Εκτίμησης c σε συνάρτηση με το πλάτος θορύβου n_0');
xlabel('Πλάτος Θορύβου n_0'); 
ylabel('|e_c|'); 
grid on;