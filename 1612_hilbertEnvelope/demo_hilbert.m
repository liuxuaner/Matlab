% 题目：hilbert包络线绘制
% 马骋 2016.12.30

clc,clear,close all

%% 基本参数

A  = 1;                                                                         % 激励信号幅值
N = 15;                                                                         % cycle数，即激励信号波峰数
fck = 100;                                                                      % 激励中心频率 kHz
fc = 100e3;                                                                     % 激励信号中心频率，Hz 

T0 = 1e-4;                                                                      % 导波传播时间
T = 4.0*T0;                                                                     % 激励持续时长
dt = 1/(20*fc)/2;                                                               % 时间步长，在最大步长基础上除以2
t = [0:dt:T]';                                                                  % 时间序列

%% 波形构造

V = A*[heaviside(t)-heaviside(t-N/fc)].*...                                     % 时域输入信号求解         
    (1-cos(2*pi*fc*t/N)).*sin(2*pi*fc*t);
h = hilbert(V);                                                                 % Hilbert变换

%% 包络绘制

figure 
plot(t,V,t,abs(h),'-.')                                                         % 包络线
legend({'原信号','包络线'})
grid on

