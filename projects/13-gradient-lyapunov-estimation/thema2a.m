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

% Αρχικές συνθήκες
theta1_true = -g/l;
theta2_true = -c;
X0 = [0.1; 0; 0; 0; -3; -0.1]; 

tspan = [0,100];

% Προσομοίωση
[t,X] = ode45(@(t,X) func2a(t,X,g,l,c,am,gamma1,gamma2),tspan,X0);

theta = X(:,1);
x = X(:,2);     %theta_dot
theta_hat = X(:,3);
x_hat = X(:,4);
theta1_hat = X(:,5);
theta2_hat = X(:,6);

l_hat =  -g ./ theta1_hat;
c_hat = -theta2_hat;

epsilon_theta = theta - theta_hat;
epsilon_l = l_hat-l;
epsilon_c = c_hat-c;

fprintf('Αποτελέσματα Εκτίμησης Παραμέτρων\n');
fprintf('Πραγματικό l: %.3f | Εκτιμώμενο l: %.5f (Σφάλμα: %.2e)\n', l, l_hat(end), epsilon_l(end));
fprintf('Πραγματικό c: %.3f | Εκτιμώμενο c: %.5f (Σφάλμα: %.2e)\n', c, c_hat(end), epsilon_c(end));

figure;
plot(t, theta, 'b', 'LineWidth', 1.5); 
hold on;
plot(t, theta_hat, 'r--', 'LineWidth', 1.5);
title('Πραγματική θ(t) vs Εκτιμώμενη θ_{hat}(t)');
xlabel('t (s)'); 
ylabel('Γωνία (rad)');
legend('θ(t)', 'θ_{hat}(t)'); 
grid on;

figure;
plot(t, epsilon_theta, 'k', 'LineWidth', 1.5);
title('Σφάλμα Γωνίας e_θ(t)');
xlabel('t (s)'); 
ylabel('e_θ (rad)'); 
grid on;

figure;
subplot(2,1,1);
plot(t, epsilon_l, 'm', 'LineWidth', 1.5);
title('Σφάλμα Εκτίμησης l');
xlabel('t (s)'); 
ylabel('e_l(t)'); 
grid on;

subplot(2,1,2);
plot(t, epsilon_c, 'c', 'LineWidth', 1.5);
title('Σφάλμα Εκτίμησης c');
xlabel('t (s)'); 
ylabel('e_c(t)'); 
grid on;



