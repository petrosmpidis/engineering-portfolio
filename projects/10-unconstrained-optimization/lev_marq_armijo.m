function [xk, n] = lev_marq_armijo(f, epsilon, gamma, X)
% This function implements the Levenberg-Marquardt method with Armijo 
% rule-based step size adjustment to find a local minimum of the function 'f'.

% Input:
% f        - The function to minimize (symbolic expression).
% epsilon  - Convergence tolerance for the norm of the gradient.
% gamma    - Initial step size parameter (scalar).
% X        - Initial guess for the solution (column vector).

% Output:
% xk       - Matrix where each column is an iteration point.
% n        - Total number of iterations.

d = [];               % Initialize an array to store search directions.
k = 1;                % Iteration counter.
xk = X;               % Initialize the solution sequence with the initial guess.

% Compute symbolic gradient and Hessian of the function f
grad_f = gradient(f); % gradient of f
hess_f = hessian(f);  % Hessian of f

% Armijo rule parameters
mk = 0;               
a = 2 * 10^(-3);      
b = 1 / 4;            
s = gamma * b^mk;     

% Start the iteration loop
while (norm(double(subs(grad_f, symvar(grad_f), {xk(:, k)'}))) > epsilon)
    % Compute the Hessian matrix at the current point
    hess_mtx = double(subs(hess_f, symvar(hess_f), {xk(:, k)'}));
    
    % Compute the eigenvalues of the Hessian matrix
    eigen_values = eig(hess_mtx);
    
    % Adjust the matrix to ensure positive definiteness
    % If any eigenvalue is negative, add a regularization term
    if (sum(eigen_values < 0) > 0)
        uk = max(abs(eigen_values)) + 0.2; % Regularization parameter
    else
        uk = 0; % No regularization needed if the Hessian is already positive definite
    end
    
    % Modify the Hessian matrix to ensure positive definiteness
    A = hess_mtx + uk * eye(2); % Adjusted Hessian matrix
    
    % Compute the right-hand side of the equation
    B = -double(subs(grad_f, symvar(grad_f), {xk(:, k)'}));
    
    % Solve the linear system to compute the search direction
    d = [d, linsolve(A, B)];
    
    % Current function value at x_k
    f_xk = double(f(xk(1, k), xk(2, k)));
    
    % Armijo step size adjustment
    while (f_xk - double(f(xk(1, k) + gamma * d(1, k), xk(2, k) + gamma * d(2, k))) < ...
            -a * b^mk * s * d(:, k)' * (-B))
        mk = mk + 1;              % Increase the step size reduction counter
        gamma = s * b^mk;         % Update the step size
    end
    
    % Update the current solution point with the adjusted step size
    x_k = xk(:, k) + gamma * d(:, k);
    
    % Append the new point to the solution sequence
    xk = [xk, x_k];
    
    % Increment the iteration counter
    k = k + 1;
    
    % Reset Armijo parameters for the next iteration
    mk = 0;
    gamma = s * b^mk;
end

% The number of iterations is the final value of k minus 1
n = k - 1;

end