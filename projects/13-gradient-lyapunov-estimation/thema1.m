clear all
close all
clc

% Παράμετροι συστήματος
J = 0.025;
k = 0.3;
b = 1;

% γ για την Μέθοδο Κλίσης
gamma1 = 250;
gamma2 = 250;

tspan = [0 100];

% Αρχικές συνθήκες
X0 = [0; 0; 0; 0; 0; 0];

% Προσομοίωση
[t, X] = ode45( @(t,X)func1(t,X,J,k,b,gamma1,gamma2),tspan,X0 );

phi = X(:,1);
phi_dot = X(:,2);
phi_hat = X(:,3);
phi_hat_dot = X(:,4);
k_hat = X(:,5);
b_hat = X(:,6);

% Σφάλματα
e_phi = phi - phi_hat;
e_k = k_hat - k;
e_b = b_hat - b;

fprintf('Αποτελέσματα Εκτίμησης Παραμέτρων\n');
fprintf('Πραγματικό k: %.3f | Εκτιμώμενο k: %.5f (Σφάλμα: %.2e)\n', k, k_hat(end), e_k(end));
fprintf('Πραγματικό b: %.3f | Εκτιμώμενο b: %.5f (Σφάλμα: %.2e)\n', b, b_hat(end), e_b(end));

figure;
plot(t,phi,'b','LineWidth',1.5);
hold on;
plot(t,phi_hat,'r--','LineWidth',1.5);
title('Πραγματική \phi(t) vs Εκτιμώμενη \phi_{hat}(t)');
xlabel('t (s)');
ylabel('Γωνία (rad)');
legend('\phi(t)', '\phi_{hat}(t)');
grid on;

figure;
plot(t, e_phi, 'k', 'LineWidth', 1.5);
title('Σφάλμα Γωνίας e_\phi(t)');
xlabel('t (s)');
ylabel('Σφάλμα e_\phi (rad)');
grid on;

figure;
subplot(2,1,1);
plot(t, e_k, 'm', 'LineWidth', 1.5);
title('Σφάλμα Εκτίμησης Παραμέτρου k');
xlabel('t (s)');
ylabel('e_k(t)');
grid on;

subplot(2,1,2);
plot(t, e_b, 'c', 'LineWidth', 1.5);
title('Σφάλμα Εκτίμησης Παραμέτρου b');
xlabel('t (s)');
ylabel('e_b(t)');
grid on;


