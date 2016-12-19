% 题目：根据波数分组，区分能量速度曲线
% 功能：对wn数据曲线分组，生成定位向量，对相应的Ev数据重排列
% 调用：
%       tools       -- 信号绘图工具箱，绘图优化
%       fun_sort    -- 根据定位矩阵I重新排列A
%       fun_plot0   -- 绘图中去掉Y中为0的点
% 马骋，20161219

%% 数据读取

clc,clear,close all
filename = 'data_demo.mat';                                                     % 读取试验数据
load(filename);                                                                 % 载入数据

%% 数据预处理

Ev = Energy_Velocity_m_s;                                                       % 能量速度
wn = Real_Wavenumber_1_m;                                                       % 波数

n_mode = size(wn,1);                                                            % 频率步数
n_f = size(wn,2);                                                               % 模态数目

fk = Frequency_Hz'/1e3;                                                         % 频率向量
fkn = repmat(fk,1,n_mode);                                                      % 频率数据矩阵

figure
subplot(211)                                                                    % 原始数据绘图
plot(fkn,wn','-*')
tools.xyt({'Frequency kHz','wave number','波数'})

subplot(212)
plot(fkn,Ev','-*')
tools.xyt({'Frequency kHz','Energy velocity m/s','能量速度'})

%% 散点聚类

[~,I] = sort(wn);                                                               % 获取定位矩阵 I
wn2 = fun_sort(wn,I)';                                                          % 冲排列 wn，Ev
Ev2 = fun_sort(Ev,I)';

figure
subplot(211)                                                                    % 冲排列数据绘图
plot(fkn,wn2,'-*')
tools.xyt({'Frequency kHz','wave number','波数'})

subplot(212)
plot(fkn,Ev2,'-*')
tools.xyt({'Frequency kHz','Energy velocity m/s','能量速度'})

%% 去除空数据，重新绘图

figure                                                                          % 去除空数据绘图
subplot(211)
fun_plot0(fkn,wn2,'-*')
tools.xyt({'Frequency kHz','wave number','波数'})

subplot(212)
fun_plot0(fkn,Ev2,'-*')
tools.xyt({'Frequency kHz','Energy velocity m/s','能量速度'})
