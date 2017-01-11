% 题目：MATLAB子图分块绘制示例
% 马骋

clc,clear
close all

t = linspace(0,2*pi,100);

%% 子图布局示例

figure
for iloop = 1:9
   subplot(3,3,iloop) 
   plot(t,sin(t),'-','color',tools.colorOrder(iloop))
   title(['子图-',num2str(iloop)])
end
tools.white;

%% 子图分块示例

figure
subplot(3,3,[1:3])
plot(t,sin(t),'-o')
title('子图 1 2 3')

subplot(3,3,[4 7])
plot(t,sin(t),'-*')
title('子图 4 7')

subplot(3,3,[5 6 8 9])
plot(t,sin(t),'->')
title('子图 5 6 8 9')

tools.white;

