function[xk,n]=st_desc_gamma(f,epsilon,~,X)
%
%xk: the minimum point
%n: # of iterations
%
% This method is based on taking repeated steps in the opposite direction of the 
% gradient of the function at the current point, because this is
% the direction of steepest descent and by doing so we can find the local minimum.
% In this particular method we are using the optimal value of gamma
% as calculated with the help of the golden section method from the first assignment.
%We find the value of gamma that minimizes f(xk+gamma*dk)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d=[];  %Initiating an empty array for the dk vector
k=1;
xk=X;
grad_f=gradient(f);%calculating the gradient of f

syms gamma_value %syms variable for gamma in order for the golden section to work

%Starting a loop and setting the stop condition for the algorithm
while(norm(double(subs(grad_f,symvar(grad_f),{xk(:,k)'})))>epsilon)
    %calculating the (k+1)th value of dk and placing it in the 
    %originally empty matrix
    d=[d -double(subs(grad_f,symvar(grad_f),{xk(:,k)'}))];
    
    %minimizing the function of gamma
    func_min(gamma_value)=f(xk(1,k)+gamma_value*d(1,k),xk(2,k)+gamma_value*d(2,k));

    gamma=gold_sect_modified(func_min,0.001,0,1);
    %same as dk for the values of X vector
    x_k=xk(:,k)+gamma*d(:,k);
    xk=[xk x_k];
    k=k+1; %increasing the counter
end

n=k-1;
end