function val = steepest_Descent_proj(f,x,epsilon,gamma,X,sk,flag)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Steepest Descent with projection
%Function to execute the Steepest Descent with projection method that
%minimizes a function using its projection.
% inputs:
% (f): our function to be minimized
% (x): syms x
% (epsilon): the termination constant
% (gamma): initial step value for g_k
% (X): (x_1,x_2) starting point for the method
% (sk): constant step to find the xbar
% (flag): max step if the method is not converging
%
% (val): [min(x_1),min(x_2),iterations]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k=1;
xk=projection(X);
grad_f=gradient(f);
x1=xk(1);
x2=xk(2);
fval=f(xk(1),xk(2));

while(norm(grad_f(xk(1),xk(2)))>epsilon && k<flag)
    xk=xk+gamma*(projection(xk-(sk*grad_f(xk(1),xk(2))).')-xk);
    fval=[fval,f(xk(1),xk(2))];
    x1=[x1,xk(1)];
    x2=[x2,xk(2)];
    k=k+1;
end

val=[vpa(x1(k)),vpa(x2(k)),k-1];

figure;
plot(x1,x2,'-o','Color','red');
hold on;
fcontour(f,[-10 5 -8 12],'LineWidth',1.5);
title1 = sprintf(['Gradient Descent with Projection - Convergence of'...
        ' x_1,x_2\nγ_k = %.2f,  ε = %.2f, s_k = %.1f\nStarting Point ='...
        ' (%d,%d),  #iterations = %d'],gamma,epsilon,sk,X(1),X(2),k-1);
title(title1);
xlabel('x_1 values');
ylabel('x_2 values');
legend('(x1,x2) convergence');
rectangle('Position',[-10 -8 15 20],'LineStyle','--','EdgeColor','r','LineWidth',0.8);

if flag==100
    figure;
    plot(x1,x2,'-o','Color','red');
    xlim([-1 .4]);
    ylim([-.06 .06]);
    hold on;
    fcontour(f,'LineWidth',1.5);
    title1_2 = sprintf(['Gradient Descent with Projection - Convergence of'...
        ' x_1,x_2 (zoomed in)\nγ_k = %.2f,  ε = %.2f, s_k = %.1f\nStarting'...
        ' Point = (%d,%d),  #iterations = %d'],gamma,epsilon,sk,X(1),X(2),k-1);
    title(title1_2);
    xlabel('x_1 values');
    ylabel('x_2 values');
    legend('(x1,x2) convergence');
end

figure;
plot(fval,'-o','LineWidth',1.5)
title2 = sprintf(['Gradient Descent with Projection - Values of f('...
        'x_1,x_2)\nγ_k = %.2f, ε = %.2f, s_k = %.1f\nStarting Point ='...
        ' (%d,%d),  #iterations = %d'],gamma,epsilon,sk,X(1),X(2),k-1);
title(title2);

txt = sprintf("Minimum @(%.5f,%.5f)\n f = %.3f",val(1),val(2),fval(k));
annotation('textbox', 'String', txt,'Position',[0.5 0.7 0.1 0.1]);
xlabel('k values'); ylabel('f(x_k) values');
grid on; 
    
end