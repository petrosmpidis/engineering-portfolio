function dX=func2(t,X,g,l,c,am,gamma1,gamma2,n0)

    % Καταστάσεις
    theta = X(1);
    x = X(2);    %% theta_dot
    theta_hat = X(3);
    x_hat = X(4); 
    theta1_hat = X(5);
    theta2_hat = X(6);
    
    % Είσοδος
    u = 0.5*sin(t);

    % Ορισμός θορύβου
    n = n0*sin(20*pi*t);

    theta_measured = theta+n;
    x_measured = x+n;
    u_measured = u+n;

    % Πραγματικό σύστημα
    theta_ddot = (-g/l)*sin(theta) - c*x + u;

    epsilon = x_measured-x_hat;
    epsilon_theta = theta_measured-theta_hat;

    % Εκτιμητής
    x_hat_dot = theta1_hat*sin(theta_measured) + theta2_hat*x_measured + u_measured + am*epsilon;

    theta_hat_dot = x_hat + am*epsilon_theta;

    % Νόμοι προσαρμογής
    theta1_hat_dot = gamma1*epsilon*sin(theta_measured);
    theta2_hat_dot = gamma2*epsilon*x_measured;

    theta_dot=x;

    dX = [theta_dot; theta_ddot; theta_hat_dot; x_hat_dot; theta1_hat_dot; theta2_hat_dot];
end