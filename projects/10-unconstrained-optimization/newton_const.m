function [xk,n]=newton_const(f,epsilon,gamma,X)
% This function implements Newton's method with a constant step size to
% find a local minimum of a given function 'f'.

% Input:
% f        - The function to minimize (symbolic expression).
% epsilon  - Convergence tolerance for the norm of the gradient.
% gamma    - Step size parameter (scalar).
% X        - Initial guess for the solution (column vector).

% Output:
% xk       - Matrix where each column is an iteration point.
% n        - Total number of iterations.
d=[]; % Initialize an empty array to store search directions.
k=1;
xk=X;

grad_f=gradient(f);
hess_f=hessian(f);
% Start the iteration loop
while((norm(double(subs(grad_f,symvar(grad_f),{xk(:,k)'}))))>epsilon)
    grad_mtx=double(subs(grad_f,symvar(grad_f),{xk(:,k)'})); %current gradient
    hess_mtx=double(subs(hess_f,symvar(hess_f),{xk(:,k)'})); %current hessian
    
    % Calculate the search direction using the Newton step
    % Direction d = -(Hessian)^(-1) * Gradient
    d=[d -hess_mtx\grad_mtx];
    x_k=xk(:,k)+gamma*d(:,k); % Update the current solution point with the constant step size
    xk=[xk x_k];
    k=k+1; %increase counter
end
n=k-1;
end