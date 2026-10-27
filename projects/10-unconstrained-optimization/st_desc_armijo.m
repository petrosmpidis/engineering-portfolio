function [xk,n]= st_desc_armijo(f,epsilon,gamma,X)
%
%xk: the minimum point
%n: # of iterations
%
% This method is based on taking repeated steps in the opposite direction of the 
% gradient of the function at the current point, because this is
% the direction of steepest descent and by doing so we can find the local minimum.
% In this particular method we are using the armijo method for gamma with
%a=0.002 b=0.25
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d=[];%Initiating an empty array for the dk vector
k=1;
xk=X;

grad_f=gradient(f);%calculating the gradient of f

%armijo method constants
mk=0;
a=2*10^(-3);
b=1/4;
s=gamma*b^mk;

%Starting a loop and setting the stop condition for the algorithm
while(norm(double(subs(grad_f,symvar(grad_f),{xk(:,k)'})))>epsilon)
    %calculating the (k+1)th value of dk and placing it in the 
    %originally empty matrix
    d=[d -double(subs(grad_f,symvar(grad_f),{xk(:,k)'}))];

    fx_k=double(f(xk(1,k),xk(2,k)));
    grad_mtx=double(subs(grad_f,symvar(grad_f),{xk(:,k)'}));
    %find the mk value for which the inequality is satisfied
    while(fx_k-double(f(xk(1,k)+gamma*d(1,k),xk(2,k)+gamma*d(2,k)))<-a*b^mk*s*d(:,k)'*grad_mtx)
        mk=mk+1;
        gamma=s*b^mk;
    end
    
    %calculate the xk+1 value
    x_k=xk(:,k)+gamma*d(:,k);
    xk=[xk x_k];

    k=k+1; %increase counter

    mk=0; %set mk=0 for next iteration
    gamma=s*b^mk;
end
n=k-1;
end