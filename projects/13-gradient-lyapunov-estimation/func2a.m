function dX=func2a(t,X,g,l,c,am,gamma1,gamma2)

    % Καταστάσεις
    theta = X(1);
    x = X(2);    %% theta_dot
    theta_hat = X(3);
    x_hat = X(4); 
    theta1_hat = X(5);
    theta2_hat = X(6);

    % Είσοδος
    u = 0.5*sin(t);

    % Πραγματικό σύστημα
    theta_ddot = (-g/l)*sin(theta) - c*x + u;

    epsilon = x - x_hat;
    epsilon_theta = theta-theta_hat;

    % Εκτιμητής
    x_hat_dot = theta1_hat*sin(theta) + theta2_hat*x + u + am*epsilon;

    theta_hat_dot = x_hat + am*epsilon_theta;
    
    % Νόμοι προσαρμογής
    theta1_hat_dot = gamma1*epsilon*sin(theta);
    theta2_hat_dot = gamma2*epsilon*x;
    
    theta_dot=x;

    dX = [theta_dot; theta_ddot; theta_hat_dot ;x_hat_dot; theta1_hat_dot; theta2_hat_dot];

end