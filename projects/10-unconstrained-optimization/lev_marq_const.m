function [xk, n] = lev_marq_const(f, epsilon, gamma, X)
% This function implements the Levenberg-Marquardt method with a constant
% step size to find a local minimum of the function 'f'.

% Input:
% f        - The function to minimize (symbolic expression).
% epsilon  - Convergence tolerance for the norm of the gradient.
% gamma    - Step size parameter (scalar).
% X        - Initial guess for the solution (column vector).

% Output:
% xk       - Matrix where each column is an iteration point.
% n        - Total number of iterations.

d = [];               % Initialize an array to store search directions.
k = 1;                % Iteration counter.
xk = X;               % Initialize the solution sequence with the initial guess.

% Compute symbolic gradient and Hessian of the function f
grad_f = gradient(f); % Symbolic gradient of f
hess_f = hessian(f);  % Symbolic Hessian of f

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
    
    % Update the current solution point
    x_k = xk(:, k) + gamma * d(:, k);
    
    % Append the new point to the solution sequence
    xk = [xk, x_k];
    
    % Increment the iteration counter
    k = k + 1;
end

% The number of iterations is the final value of k minus 1
n = k - 1;

end