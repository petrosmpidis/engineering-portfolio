%This script is used to plot the given f function in the 3d space to
% help visualize the problem
clc;
close all;
clear;

syms x1 x2;
f(x1,x2)=(1/3)*x1^2+3*x2^2;

figno=1;
figure(figno);
fsurf(f,[-20,20],'ShowContours','on');
title('3D plot of f');
xlabel('x1');
ylabel('x2');
zlabel('f(x1,x2)');
grid on;

figno=figno+1;
figure(figno);
fcontour(f,[-20 20 -25 25], 'linewidth', 1.5);
title('Restriction rectangle visible on f contour');
xlabel('x1 values');
ylabel('x2 values');
hold on;
s=scatter([-10 5 -10 5],[-8 -8 12 12]); %creating the rectangle of the limits for our x1 x2 variables and adding it to the contour
r = rectangle('position',[-10 -8 15 20],  'LineStyle', '-', 'edgecolor', 'r',...
    'linewidth', 1.5);
dt1 = datatip(s,-10,-8,'FontSize',8,'Location','northwest'); 
dt2 = datatip(s,5,-8,'FontSize',8); 
dt3 = datatip(s,-10,12,'FontSize',8,'Location','northwest');
dt4 = datatip(s,5,12,'FontSize',8);
grid on;