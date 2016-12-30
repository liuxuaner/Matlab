% ��Ŀ��hilbert�����߻���
% ��� 2016.12.30

clc,clear,close all

%% ��������

A  = 1;                                                                         % �����źŷ�ֵ
N = 15;                                                                         % cycle�����������źŲ�����
fck = 100;                                                                      % ��������Ƶ�� kHz
fc = 100e3;                                                                     % �����ź�����Ƶ�ʣ�Hz 

T0 = 1e-4;                                                                      % ��������ʱ��
T = 4.0*T0;                                                                     % ��������ʱ��
dt = 1/(20*fc)/2;                                                               % ʱ�䲽��������󲽳������ϳ���2
t = [0:dt:T]';                                                                  % ʱ������

%% ���ι���

V = A*[heaviside(t)-heaviside(t-N/fc)].*...                                     % ʱ�������ź����         
    (1-cos(2*pi*fc*t/N)).*sin(2*pi*fc*t);
h = hilbert(V);                                                                 % Hilbert�任

%% �������

figure 
plot(t,V,t,abs(h),'-.')                                                         % ������
legend({'ԭ�ź�','������'})
grid on

