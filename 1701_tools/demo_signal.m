% 题目：tools工具箱信号处理示例
% 时间2017.01.11

%% clean

M = tools.getcsv(0);                                                               % 读取csv文件
s = M(:,3);                                                                     % 提取典型信号
s2 = tools.clean(s);                                                            % 信号去除环境噪声

figure
plot(s),hold on
plot(s2)
legend({'原始信号','去趋势信号'})
grid on

%% lowp

[M,dt] = tools.getcsv(0);                                                       % 读取csv文件
s = M(:,3);                                                                     % 提取典型信号

% 参数对话框
prompt0 = {
    '低通滤波 fp-fs kHz', [500 700]
    '低通滤波 Rp',0.1
    '是否显示滤波器频谱',1   
};

dlg0.save = 'myfilter';
para0 = tools.paradlg(prompt0,dlg0);                                            % 对话框参数

para_lp.f1 = para0{1}(1)*1e3;                                                   % 滤波器 fp
para_lp.f3 = para0{1}(2)*1e3;                                                   % 滤波器 fs
para_lp.rp = para0{2};                                                          % 滤波器 rp
para_lp.rs = 30;                                                                % 滤波器 rs
para_lp.fs = 1/dt;                                                              % 信号采样频率

para_lp.type = 1;                                                               % 滤波器类型：切比雪夫-1
flag = para0{3};                                                                % 是否绘制滤波器频域曲线

s_lp = tools.lowp(s,para_lp,flag);                                              % 输入信号-滤波

figure                                                                          % 滤波前后对比
plot(s),hold on
plot(s_lp)
legend({'原始信号','滤波后信号'})
tools.white;

%% toneburst

[s,fs] = tools.toneburst;

%% getband3db

[s,fs] = tools.toneburst;
[band3db,x0] = tools.getband3db(fs,s);
band3db_fk = band3db/1000;

