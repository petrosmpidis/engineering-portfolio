function [xk,n] = st_desc_const(f,epsilon,gamma,X)
%
%xk: the minimum point
%n: # of iterations
%
% This method is based on taking repeated steps in the opposite direction of the 
% gradient of the function at the current point, because this is
% the direction of steepest descent and by doing so we can find the local minimum.
% In this particular method we are using a constant value for our gamma.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d=[]; %Initiating an empty array for the dk vector
k=1;
xk=X;
grad_f=gradient(f); %calculating the gradient of f

%Starting a loop and setting the stop condition for the algorithm
while(norm(double(subs(grad_f,symvar(grad_f),{xk(:,k)'})))>epsilon)
    %calculating the (k+1)th value of dk and placing it in the 
    %originally empty matrix
    d=[d -double(subs(grad_f, symvar(grad_f),{xk(:,k)'}))];
    
    %same for the values of X vector
    x_k=xk(:,k)+gamma*d(:,k);
    xk=[xk x_k];
    
    %Increase the counter
    k=k+1;
end
n=k-1;
end