%This is the steepest descent method as used in the previous lab exercise
%so I will not add comments here.
clc;
close all;
clear

syms x1 x2;
f(x1,x2)=(1/3)*x1^2+3*x2^2;
X=[1;1];
epsilon=0.001;
gamma=[0.1 0.3 3 5];

figno=1;

for i=1:4
    [xk,n]=Steepest_Descent(f,epsilon,gamma(i),X);
    figure(figno);
    figno=figno+1;
    if(i==3 || i==4)
        semilogy(0:n,f(xk(1,:),xk(2,:)));
        hold on;
    else
        hold on;
        plot(0:n,f(xk(1,:),xk(2,:)));
    end

    scatter(n,f(xk(1,end),xk(2,end)),'x');
    graph_title= sprintf(['Steepest Descent\nStarting point = (%d,%d)\n'...
    '#iterations = %d g_k = %.2f'], X(1),X(2),n,gamma(i));
    title(graph_title);
    set(gca,'XTick',0:n);
    txt=sprintf('Minimum @(%.3f,%.2f)\n f = %.3f',xk(1,end),...
        xk(2,end),double(f(xk(1,end),xk(2,end))));
    if(i==1 || i==2)
        annotation('textbox', 'String', txt);
    end
    xlabel("k-th iteration");
    xticks([0:10:n-1 n]);
    ylabel("f(xk,yk)");
end

figno=5;
for j=1:2
    [xk,n]=Steepest_Descent(f,epsilon,gamma(j),X);
    figure(figno);
    figno=figno+1;
    fcontour(f,[-5 5]);
    hold on;
    title(sprintf('Convergence of (x_1,x_2) for γ_k = %1.2f',gamma(j)));
    xlabel('x_1');
    ylabel('x_2');
    plot(xk(1,1:end),xk(2,1:end),'-.r');
    scatter(xk(1,end),xk(2,end),'x','r');
    grid on;
end