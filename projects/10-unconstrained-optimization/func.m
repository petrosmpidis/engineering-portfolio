%This script plots the given function to visualize its form and
%give us a first information of what to expect
clc;
clf;
clear;

syms x y;
f(x,y)=(x.^3).*exp(-x.^2-y.^4); %Defining the function

%generating the plots
figno=1;
figure(figno)
grid on;
fsurf(f,'ShowContours','on');
title('3D plot of $f(x,y)$ ','Interpreter','latex');
xlabel('x');
ylabel('y');
zlabel('f(x,y)');
box on;
figno=figno+1;

figure(figno)
fcontour(f,[-3,3]); %contour lines of the function
grid on;
title('Contour lines of $f(x,y)$ ','Interpreter','latex');
xlabel('x');
ylabel('y');