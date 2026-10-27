function [xk,n]=newton_gamma(f,epsilon,~,X)
% This function implements Newton's method with a dynamically optimized 
% step size (using line search) to find a local minimum of the function 'f'.

% Input:
% f        - The function to minimize (symbolic expression).
% epsilon  - Convergence tolerance for the norm of the gradient.
% ~        - Unused parameter for compatibility.
% X        - Initial guess for the solution (column vector).

% Output:
% xk       - Matrix where each column is an iteration point.
% n        - Total number of iterations.
d=[]; % Initialize an array to store search directions.
k=1;
xk=X;

grad_f=gradient(f);
hess_f=hessian(f);
max_step=100; % Maximum allowed number of iterations.


syms gamma_value; % Define a symbolic variable for step size optimization.
% Start the iteration loop
while(norm(double(subs(grad_f,symvar(grad_f),{xk(:,k)'})))>epsilon)
    grad_mtx=double(subs(grad_f,symvar(grad_f),{xk(:,k)'}));%curent grad
    hess_mtx=double(subs(hess_f,symvar(hess_f),{xk(:,k)'}));%current hess
    % Calculate the search direction using the Newton step
    % Direction d = -(Hessian)^(-1) * Gradient
    
    d=[d -hess_mtx\grad_mtx];
    % Define the line search function along the direction d
    
    func_min(gamma_value)=f(xk(1,k)+gamma_value*d(1,k),xk(2,k)+gamma_value*d(2,k));
    
    % Use a modified golden section method to find the optimal step size gamma
    gamma=gold_sect_modified(func_min,0.001,0,1);
    
    x_k=xk(:,k)+gamma*d(:,k);
    xk=[xk x_k];

    k=k+1;
    % Terminate if the maximum step count is reached or if the function value 
    % does not decrease compared to the previous iteration
    if(k==max_step || f(xk(1,k),xk(2,k))>=f(xk(1,k),xk(2,k-1)))
        break
    end
end
n=k-1;
end