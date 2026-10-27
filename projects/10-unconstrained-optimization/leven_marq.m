close all;
clc;
clear;

% Define the function to minimize as a symbolic expression
syms x y;
f(x, y) = (x.^3) .* exp(-x.^2 - y.^4); % Objective function

% Define initial points for the optimization
X = [0 -1 1; 0 -1 1]; % Columns represent [x; y] starting points

% Define the list of Levenberg-Marquardt method variants and gamma computation methods
method = ["lev_marq_const", "lev_marq_gamma", "lev_marq_armijo"];
gamma_method = ["const", "minimized with modified golden section", "armijo"];

% Set optimization parameters
epsilon = 0.01; % Convergence criterion for the gradient norm
gamma = 0.5;    % Initial step size (used for "const" gamma method)
figno = 1;      % Initialize figure numbering

% Iterate over starting points and Levenberg-Marquardt method variants
for i = 1:3  % Loop through the three starting points
    for j = 1:3  % Loop through the three Levenberg-Marquardt variants
        % Dynamically call the appropriate Levenberg-Marquardt function
        algorithm = str2func(method(j));
        
        % Apply the method with the function, tolerance, step size, and starting point
        [xk, n] = algorithm(f, epsilon, gamma, X(:, i));
        
        plot_titles = sprintf(['Levenberg-Marquardt\nMethod for gamma: %s' ...
            ', Starting Point = (%d, %d)\n# Iterations = %d, Minimum = ' ...
            '(%.2f, %.2f)'], gamma_method(j), X(1, i), X(2, i), n, xk(1, end), xk(2, end));
        
        % Plot the contours of the function and the optimization path
        figure(figno); 
        figno = figno + 1; 
        fcontour(f, [-3, 3]); 
        hold on; 
        grid on; 
        title(plot_titles); 
        xlabel('x'); 
        ylabel('y'); 
        plot(xk(1, 1:end), xk(2, 1:end)); % Plot the optimization path
        scatter(xk(1, end), xk(2, end), '*'); % Mark the final point
        
        % Plot the value of the objective function at each iteration
        figure(figno); 
        hold on; 
        figno = figno + 1; 
        plot(0:n, f(xk(1, :), xk(2, :))); % Plot function values at each iteration
        
        % Add a text box displaying the final function value
        text = sprintf('Minimum @(%.3f, %.3f)\n f = %.3f', ...
                       xk(1, end), xk(2, end), double(f(xk(1, end), xk(2, end))));
        annotation('textbox', 'String', text); 
        
        graph_title = sprintf(['Value of the Function as Iterations Progress\n' ...
            'Using %s Method for Gamma, Starting Point (%d, %d)'], ...
            gamma_method(j), X(1, i), X(2, i));
        title(graph_title); 
        set(gca, 'XTick', 0:n); % Set x-axis ticks to match iteration count
        xlabel('k-th Iteration'); 
        ylabel('f(x_k, y_k)'); 
    end
end