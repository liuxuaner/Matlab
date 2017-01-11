% 题目：标准化导波信号处理程序
% 功能：
%       csv信号读取
%       通道数量设置
%       低通滤波去噪
%       Hilbert变换
%       频谱分析
%       小波分析
% 程序：
%       tools        --  信号处理与绘图通用工具箱
%       guw          --  导波信号处理专用工具箱
% 作者：马骋
% 时间：2016.12.30

%% 测试-1

clc,clear,close all
s = guw();
s.input(1);
s.myfilter(1);                                                                   % 滤波器
s.timePlot(0);                                                                   % 时域绘图，绘制包络
s.freqPlot();                                                                   % 频域绘图，无频响函数
s.mycwt(1);                                                                     % 小波分析，显示对话框
% tools.saveGraph;

%% 测试-Overlay

% clc,clear,close all
% s = guw();
% s.overlay();

%% 测试-高频信号分析

% clc,clear,close all
% s = guw();
% s.input(0);
% s.myfilter(0);                                                                   % 滤波器
% s.freqAnalysis();                                                               % 傅立叶变换及频谱分析
% s.mycwt(0);                                                                      % 小波分析
% tools.saveGraph;

%% isShow测试

% clc,clear,close all
% s = guw();
% s.input();
