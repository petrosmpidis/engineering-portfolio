function dX = func1(t,X,J,k,b,gamma1,gamma2)

    % Καταστάσεις
    phi = X(1);
    phi_dot = X(2);
    phi_hat = X(3);
    phi_hat_dot = X(4);
    k_hat = X(5);
    b_hat = X(6);
    
    % Είσοδος συστήματος
    u = 0.25*sin(0.5*pi*t);

    % Διαταραχή
    % d = 0;    % α) ερωτημα 
    d = 0.02*sin(2*t);  % β) ερωτημα

    % Πραγματικό σύστημα
    phi_ddot = (-k*phi_dot + b*u + d)/J;

    % Εκτιμώμενο σύστημα
    phi_hat_ddot = (-k_hat*phi_hat_dot + b_hat*u)/J;
    
    % Μέθοδος Κλίσης
    y = J*phi_ddot;
    y_hat = -k_hat*phi_dot + b_hat*u;
    epsilon_y = y - y_hat;

    k_hat_dot = gamma1 * epsilon_y * (-phi_dot);
    b_hat_dot = gamma2 * epsilon_y * u;
    
    dX = [phi_dot; phi_ddot; phi_hat_dot; phi_hat_ddot; k_hat_dot; b_hat_dot];
end