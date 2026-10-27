function [xk,n]= newton_armijo(f,epsilon,gamma,X)
% This function implements Newton's method with step size adjustment
% based on the Armijo rule to find a local minimum of the function 'f'.

% Input:
% f        - The function to minimize (symbolic expression).
% epsilon  - Convergence tolerance for the norm of the gradient.
% gamma    - Initial step size parameter (scalar).
% X        - Initial guess for the solution (column vector).

% Output:
% xk       - Matrix where each column is an iteration point.
% n        - Total number of iterations.
d=[]; % Initialize an array to store search directions.
k=1;
xk=X;

grad_f=gradient(f);
hess_f=hessian(f);
max_step=100;% Maximum allowed number of iterations.

%Defining Armijo rules constants
mk=0;
a=2*10^(-3);
b=1/4;
s=gamma*b^mk;
%starting the loop
while(norm(double(subs(grad_f,symvar(grad_f),{xk(:,k)'})))>epsilon)

    grad_mtx=double(subs(grad_f,symvar(grad_f),{xk(:,k)'}));%current grad
    hess_mtx=double(subs(hess_f,symvar(hess_f),{xk(:,k)'}));%current hess
    
    % Calculate the search direction using the Newton step
    % Direction d = -(Hessian)^(-1) * Gradient
    d=[d -hess_mtx\grad_mtx];

    % Evaluate the function value at the current point
    fx_k=double(f(xk(1,k),xk(2,k)));
    while(fx_k-double(f(xk(1,k)+gamma*d(1,k),xk(2,k)+gamma*d(2,k)))<-a*b^mk*s*d(:,k)'*grad_mtx)
         % Increase the Armijo counter and reduce the step size
        mk=mk+1;
        gamma=s*b^mk;
    end
    x_k=xk(:,k)+gamma*d(:,k);
    xk=[xk x_k]; %storing the values

    k=k+1; %increasing the counter
    % Terminate if the maximum step count is reached or if the function value 
    % does not decrease compared to the previous iteration
    if(k==max_step || f(xk(1,k),xk(2,k))>=f(xk(1,k-1),xk(2,k-1)))
        break
    end

    mk=0;
    gamma=s*b^mk;  % Reset the Armijo parameters for the next iteration
end
n=k-1;
end