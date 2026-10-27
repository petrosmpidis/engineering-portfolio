close all;  
clc;        
clear;      

% Define the function to minimize as a symbolic expression
syms x y;
f(x, y) = (x.^3) .* exp(-x.^2 - y.^4); % Objective function

% Initial points for the optimization
X = [0 -1 1; 0 -1 1]; % Each column represents a starting point [x; y]

% List of optimization methods to test
method = ["st_desc_const", "st_desc_gamma", "st_desc_armijo"]; 
% Corresponding gamma computation methods
gamma_method = ["const", "minimized with modified golden section", "armijo"];

% Convergence tolerance and initial step size
epsilon = 0.01; % Convergence criterion for gradient norm
gamma = 0.5;    % Initial step size (used for "const" gamma method)


figno = 1;

% Nested loops: Iterate over starting points and methods
for i = 1:3  % Loop through the three starting points
    for j = 1:3  % Loop through the three steepest descent methods
        % Dynamically select the steepest descent function
        algorithm = str2func(method(j));
        
        % Call the selected method with the function, tolerance, step size, and starting point
        [xk, n] = algorithm(f, epsilon, gamma, X(:, i));
        
        plot_titles = sprintf(['Steepest Descent\nMethod for gamma: %s' ...
            ', Starting Point = (%d, %d)\n# Iterations = %d, Minimum = ' ...
            '(%.2f, %.2f)'], gamma_method(j), X(1, i), X(2, i), n, xk(1, end), xk(2, end));
        
        % Plot the contour of the function with the optimization path
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
        
        % Plot the value of the function as the iterations progress
        figure(figno); 
        hold on; 
        figno = figno + 1; 
        plot(0:n, f(xk(1, :), xk(2, :))); % Plot function value at each iteration
        
        % Add a text box with the final function value
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