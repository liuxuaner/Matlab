% 题目: 导波测试信号的小波时频谱分析
% 参数: 
% 		降低采样倍数 q
% 		小波类型
% 		尺度序列的长度totalscal
% 		频率显示范围 kHz
% 功能：
%       csv数据导入
%       cheby1低通滤波
%       信号降低采样
%       小波分析、分辨率设置
%       时频图绘制
% 调用：
%       tools   -- 信号处理辅助函数
% 作者：马骋，丁昊青
% 2016.12.12 @HIT


%% 数据导入

clc,clear
close all

[M,dt] = tools.getcsv();                                                        % 读入csv信号和采样周期dt
fs = 1/dt;                                                                      % 采样频率

t   = M(:,1);                                                                   % 第一列，时间
t   = t - t(1);                                                                 % 减去初始值
inp = M(:,2);                                                                   % 第二列，输入信号
out = M(:,3);                                                                   % 第三列，输出信号
inp = tools.clean(inp,0.015);                                                   % 信号去均值
out = tools.clean(out);

figure                                                                          % 时程信号绘图
plot([t,t]*1e6,[inp,out]) 
tools.xyt({'t /\mu s','Voltage/V','原始发射与接收时程'})
legend({'原始发射信号','原始接收信号'})

%% 参数对话框设置

prompt0 = {                                                         % 对话框参数
    '低通滤波：带通频率 kHz', 500
    '低通滤波：带阻频率 kHz', 700
    '当前采样频率 fs0 kHz', fs/1e3
    '降低采样倍数 q', 10
    '小波类型','Morl'
    '尺度序列的长度totalscal',2048
    '频率显示范围 kHz',[0 600]
};

dlg0.title = '时频分析参数设置';
dlg0.save = 's17';
para = tools.paradlg(prompt0,dlg0);

para_lp.f1 = para{1}*1e3;                                                       % 低通滤波参数设置
para_lp.f3 = para{2}*1e3;
para_lp.rp = 0.1;
para_lp.rs = 30;
para_lp.fs = fs;
para_lp.type = 1;                                                               % 滤波器类型：切比雪夫-1

p = 1;
q = para{4};                                                                    % 降低采样的倍数
wavename = para{5};                                                             % 小波类型设置
totalscal = para{6};                                                            % 尺度序列的长度，即scal的长度
fzk_lim = para{7};                                                              % 时频图显示的频率范围

%% cheby1低通滤波

out = tools.lowp(out,para_lp);                                                  % 输出信号低通滤波
% inp = tools.lowp(inp,para_lp);                                                % 滤波

%% 信号重采样

inp2 = resample(inp,p,q);                                                       % 发射信号重采样
out2 = resample(out,p,q);                                                       % 接收信号重采样
t2 = (0:length(out2)-1)*dt*q/p;                                                 % 时间序列需要手动计算，不可重采样
t2 = t2';
fs2 = fs/q;                                                                     % 重采样频率

figure                                                                          % 时程信号绘图
plot([t2,t2]*1e6,[inp2,out2]) 
tools.xyt({'t /\mu s','Voltage/V','重采样发射信号与接收信号时程'})
legend({'发射信号','接收信号'})

%% 小波变换参数设置

wcf = centfrq(wavename);                                                        % 小波的中心频率
cparam = 2*wcf*totalscal;                                                       % 为得到合适的尺度所求出的参数
a = totalscal:-1:0.2; 
scal = cparam./a;                                                               % 得到各个尺度，以使转换得到频率序列为等差序列

tic
coefs=cwt(out2,scal,wavename);                                                  % 得到小波系数
f=scal2frq(scal,wavename,1/fs2);                                                % 将尺度转换为频率
fk = f/1e3;                                                                     % 频率，kHz
toc                                                                             % 计算计时

%% 绘图设置

figure
subplot(4,1,1)                                                                  % 时程信号绘图
plot([t2,t2]*1e6,[inp2,out2]) 
tools.xyt({'t /\mu s','Voltage/V','发射信号与接收信号时程'})
legend({'发射信号','接收信号'})

subplot(4,1,[2 3 4])                                                            % 占用子图位置
imagesc(t2*1e6,fk,abs(coefs));                                                  % 绘制色谱图
colorbar('east');                                                               % 色条在坐标轴内部显示，以便对齐
tools.xyt({'时间 t/s','频率 f/kHz','小波时频图'})
ylim(fzk_lim)                                                                   % 频域显示范围设置
set(gca, 'YDir', 'normal')
tools.white;