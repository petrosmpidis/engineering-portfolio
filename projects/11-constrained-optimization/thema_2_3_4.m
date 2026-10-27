clc;
close all;
clear;
%Defining Parameters
x=sym('x',[1,2]);
f(x)=(1/3)*x(1)^2+3*x(2)^2;
X=[5, -5; -5, 10; 8, -10];
epsilon=0.01;
gamma=[0.5 0.1 0.2];
sk=[5 1.5 0.1];
flag=[100,20,200];
values=zeros(3,3);
%running a loop for the method so that we can calculate the results of
%2,3,4 all at the same script 
for i=1:3
    values(i,:) = steepest_Descent_proj(f, x, epsilon, gamma(i),...
        X(i,:), sk(i),flag(i));
end
disp(values);

% uncomment for comparison of the 2 methods in part 2
% figure;
% [xk,n] = Steepest_Descent(f,0.01,0.5,[5;-5]);
% plot(0:n,f(xk(1,:),xk(2,:)));
% hold on;
% scatter(n,f(xk(1,end),xk(2,end)),'x');
% graph_title = sprintf(['Steepest Descent\nStarting point = (%d,%d)\n'...
%   '#iterations = %d g_k = %.2f'], 5,-5,n,0.5);
% title(graph_title);
% set(gca, 'XTick', 0:n);
% txt = sprintf('Minimum @(%.3f,%.2f)\n f = %.3f',xk(1,end),...
%        xk(2,end),double(f(xk(1,end),xk(2,end))));
% annotation('textbox', 'String', txt);   
% xlabel("k-th iteration");
% xticks([0:15:n-1 n]);
% ylabel("f(xk,yk)");