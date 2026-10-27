clear; 
clc; 
close all;

%% ΘΕΜΑ 1

m = 1;    % [0.75 1]
c = 0.25; % [0.15 0.35]
k = 15;   % [10 15]

A = [0 1; -k/m -c/m];
B = [0; 1/m];

dt = 0.0005; % Δt < 10^-3
tspan = 0:dt:20;
u = @(t) 5*sin(2.5*t);
system = @(t,x) A*x + B*u(t);

[t, x] = ode45(system, tspan, [0; 0]);

figure();
subplot(2,1,1); plot(t, x(:,1), 'b', 'LineWidth', 2);
title('Μετατόπιση'); xlabel('t (s)'); ylabel('x(t) [m]'); grid on;
subplot(2,1,2); plot(t, x(:,2), 'r', 'LineWidth', 2);
title('Ταχύτητα'); xlabel('t (s)'); ylabel('dx/dt(t) [m/s]'); grid on;

%% ΘΕΜΑ 2

%% (α)

Ts = 0.05;
t_samp = (0:Ts:20)';
N = length(t_samp);

% Δειγματοληψία
x_samp = interp1(t, x(:,1), t_samp);
v_samp = interp1(t, x(:,2), t_samp);
u_samp = u(t_samp);

% Υπολογισμός Επιτάχυνσης
a_samp = zeros(length(v_samp), 1);
    for j = 2:(length(v_samp) - 1)
        a_samp(j) = (v_samp(j + 1) - v_samp(j - 1)) / (2 * Ts);
    end

% Μέθοδος Ελαχίστων Τετραγώνων
Phi = [a_samp, v_samp, x_samp];
Y = u_samp;
theta_hat = (Phi' * Phi) \ (Phi' * Y);

m_hat = theta_hat(1);
c_hat = theta_hat(2);
k_hat = theta_hat(3);

fprintf('Θέμα 2(α)\n');
fprintf('Εκτιμήσεις: m=%.4f, c=%.4f, k=%.4f\n\n', m_hat, c_hat, k_hat);

% Εκτιμήσεις
A_hat = [0 1; -k_hat/m_hat -c_hat/m_hat];
B_hat = [0; 1/m_hat];
system_hat = @(t, x) A_hat*x + B_hat*u(t);
[~, x_hat] = ode45(system_hat, t, [0; 0]);

e_x = x(:,1) - x_hat(:,1);

figure();
subplot(2,1,1);
plot(t, x(:,1), 'k', t, x_hat(:,1), 'y--', 'LineWidth', 2.5);
legend('Πραγματικό x(t)', 'Εκτιμώμενο x_{hat}(t)');
title('Σύγκριση Αποκρίσεων'); xlabel('t (s)'); ylabel('x(t) [m]'); grid on;
subplot(2,1,2);
plot(t, e_x, 'r', 'LineWidth', 2);
title('e_x(t) = x(t) - x_{hat}(t)'); xlabel('t (s)'); grid on;

%% (β)

Ts_range = 0.05:0.01:0.5; 
errors = zeros(length(Ts_range),3);

for i=1:length(Ts_range)
    Ts = Ts_range(i);
    t_samp = 0:Ts:20;

    x_samp = interp1(t, x(:,1), t_samp)';
    v_samp = interp1(t, x(:,2), t_samp)';  
    u_samp = (5 * sin(2.5 * t_samp))';
    
    % Υπολογισμός Επιτάχυνσης
    a_samp = zeros(length(v_samp), 1);
    for j = 2:(length(v_samp) - 1)
        a_samp(j) = (v_samp(j + 1) - v_samp(j - 1)) / (2 * Ts);
    end

    % Πίνακας Φ και Διάνυσμα Υ
    Phi = [a_samp(2:end - 1), v_samp(2:end - 1), x_samp(2:end - 1)];
    Y = u_samp(2:end - 1);
    
    % Θ = (Φ' * Φ)^(-1) * Φ' * Y
    theta_hat= (Phi'*Phi)^(-1) * Phi' * Y;

    % Αποθήκευση Σφαλμάτων
    errors(i, 1) = abs(m - theta_hat(1)) / m;
    errors(i, 2) = abs(c - theta_hat(2)) / c;
    errors(i, 3) = abs(k - theta_hat(3)) / k;

end

figure;
subplot(3,1,1);
plot(Ts_range, errors(:,1), 'b', 'LineWidth', 2);
title('Σφάλμα Εκτίμησης Παραμέτρων συναρτήσει T_{s}');
ylabel('Σφάλμα m'); grid on;
subplot(3,1,2);
plot(Ts_range, errors(:,2), 'y', 'LineWidth', 2);
ylabel('Σφάλμα c'); grid on;
subplot(3,1,3);
plot(Ts_range, errors(:,3), 'r', 'LineWidth', 2);
xlabel('T_{s} (s)');ylabel('Σφάλμα k'); grid on;

%% (γ)

% Αυθαίρετη επιλογή τιμής θορύβου
noise = 0.05; 

% Προσθήκη λευκού γκαουσιανού θορύβου
x_noise = x_samp + noise * randn(size(x_samp));
v_noise = v_samp + noise * randn(size(v_samp));
u_noise = u_samp + noise * randn(size(u_samp));

% Υπολογισμός Επιτάχυνσης
a_noise = zeros(length(v_noise), 1);
    for j = 2:(length(v_noise) - 1)
        a_noise(j) = (v_noise(j + 1) - v_noise(j - 1)) / (2 * Ts);
    end

Phi_noise = [a_noise(:), v_noise(:), x_noise(:)];
Y_noise = u_noise(:);

theta_hat_noise = (Phi_noise' * Phi_noise) \ (Phi_noise' * Y_noise);

m_hat_noise = theta_hat_noise(1);
c_hat_noise = theta_hat_noise(2);
k_hat_noise = theta_hat_noise(3);

fprintf('Εκτιμώμενες Παράμετροι με θόρυβο:\n');
fprintf('m_hat = %.4f, c_hat = %.4f, k_hat = %.4f\n', m_hat_noise, c_hat_noise, k_hat_noise);
