% 题目: 低通滤波示例
% 参数: 无
% 功能：
%       低通去噪
% 函数：
%       tools   -- 信号处理辅助函数
% 作者: 马骋
% 2016.04.21 @HIT

%% 数据读入

clc,clear,close all
[M,dt] = tools.getcsv();                                            % 读入csv信号和采样周期dt

fs = 1/dt;                                                          % 采样频率
t = M(:,1);
s = detrend(M(:,3));                                                % 去趋势的信号

figure
plot(t,s)
legend('原始信号')
grid on 
xlim([min(t) max(t)])

%% 参数设置

prompt0 = {                                                         % 对话框参数
    '带通频率 f-pass(kHz)', 300
    '带阻频率 f-stop(kHz)', 500
    'Passband ripple in decibels Rp',0.1
    '衰减值Rs(Db)',30
};

dlg0.title = '滤波参数输入-马骋';
dlg0.save = 'lp';

para_input = tools.paradlg(prompt0,dlg0);

para.f1 = para_input{1}*1e3;
para.f3 = para_input{2}*1e3;
para.rp = para_input{3};
para.rs = para_input{4};
para.fs = fs;

%% cheby1低通滤波图示

para.type = 1;                                                      % 滤波器类型：切比雪夫-1
s_lp = tools.lowp(s,para);                                          % 滤波

%% 处理信号绘图

figure
plot([t t],[s s_lp])
legend({'原始信号','低通滤波信号'})
title('cheby1低通滤波效果示例'),grid on
xlim([min(t) max(t)])

figure
subplot(211)
plot(t,s)
legend('原始信号'),grid on 
xlim([min(t) max(t)])

subplot(212)
plot(t,s_lp)
legend('滤波信号'),grid on 
xlim([min(t) max(t)])



