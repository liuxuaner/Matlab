% ��Ŀ��MATLAB��ͼ�ֿ����ʾ��
% ���

clc,clear
close all

t = linspace(0,2*pi,100);

%% ��ͼ����ʾ��

figure
for iloop = 1:9
   subplot(3,3,iloop) 
   plot(t,sin(t),'-','color',tools.colorOrder(iloop))
   title(['��ͼ-',num2str(iloop)])
end
tools.white;

%% ��ͼ�ֿ�ʾ��

figure
subplot(3,3,[1:3])
plot(t,sin(t),'-o')
title('��ͼ 1 2 3')

subplot(3,3,[4 7])
plot(t,sin(t),'-*')
title('��ͼ 4 7')

subplot(3,3,[5 6 8 9])
plot(t,sin(t),'->')
title('��ͼ 5 6 8 9')

tools.white;

