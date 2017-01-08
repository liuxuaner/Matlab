classdef guw < handle
% 题目：导波信号分析处理工具箱
% 静态：
%       version    -- 版本说明
% 构造：
%       guw        --  生成对象，初始化
% 动态：
%       myfilter   --  低通滤波器
%       myHilbert  --  Hilbert变换
%       freqAnalysis -- 频域信号分析
%       timePlot   --  时域绘图
%       freqPlot   --  频域绘图
% 调用：
%       tools.m    --  工具箱
% 作者：马骋
% 2016.12.30 @ HIT  

% 后续开发：
%   数据存储

%% 属性
properties

M                                                                               % 原始数据矩阵
dt                                                                              % 采样间隔
fs                                                                              % 测样频率
t0                                                                              % 时间序列-原始
t                                                                               % 时间序列
Nz                                                                              % 序列点数

inp                                                                             % 输入激励
inp0                                                                            % 输入激励-原始
out                                                                             % 输出信号
out0                                                                            % 输出信号-原始

inp_h                                                                           % 输入激励-Hilbert变换
out_h                                                                           % 输出信号-Hilbert变换

% 对话框输入参数
para                                                                            % 对话框输入的参数
str_output                                                                      % 任务编号
str_task                                                                        % 输出数据文件名
fc                                                                              % 激励信号中心频率 Hz
fck                                                                             % 激励信号中心频率 kHz
N_ch                                                                            % 分析通道数量
fk_range                                                                        % 频谱分析范围 kHz

% 频谱图参数

fzk                                                                             % 频域横轴，单位 kHz
X                                                                               % 频谱-输入信号
Y                                                                               % 频谱-输出信号
XNorm                                                                           % 归一化频谱-输入信号
YNorm                                                                           % 归一化频谱-输出信号
FRF                                                                             % 频响函数
fzk_Ymax                                                                         % 峰值频率

end % properties

%% 静态方法
methods(Static)
function s = version(s)
% 题目：工具箱版本说明
% 时间：2016.12.30

clc
strVersion =  '版本说明：导波信号分析处理工具箱\n马骋,2016.12.30 \n\n';
fprintf(strVersion)

strUpdatelog = {
    '更新日志：'
    '2016.12.30,信号处理技术集成；'
    '2016.12.31,基本功能模块开发：myfilter，myHilbert，freqAnalysis，timePlotfreqPlot；'
    '2017.01.03,对话框分离，集成了小波分析mycwt；'
    };

for iloop = 1:length(strUpdatelog)
    fprintf([strUpdatelog{iloop},'\n']);
end	
end % version

end % Static
    
%% 动态方法
methods 

%%    初始化
function s = guw()
% 题目：构造函数，模型初始化

% s.input();                                                                      % 数据读取

% ------------------------------信号处理----------------------------------------
% s.myfilter();
% s.myHilbert();
% s.freqAnalysis();
% s.timePlot();
% s.freqPlot();

end     % guw     

function s = input(s,flag)
% 题目：数据和函数的输入模块
% 参数：flag，是否弹出对话框
% 示例
%       s = s.input();    % 弹出对话框设置参数
%       s = s.input(0);   % 不弹出对话框，直接根据上次设定

if nargin < 2
    flag = 1;                                                                   % 默认弹出对话框
end

prompt0 = {                                                                     % 对话框参数
    '分析通道数量',2
    '频谱范围（kHz）',1000
};
dlg0.title = '数据读取参数-马骋';
dlg0.save = 'input';
s.para = tools.paradlg(prompt0,dlg0,flag); 
s.N_ch = s.para{1};                                                         % 分析通道数量
s.fk_range = s.para{2};                                                     % 频谱分析范围

% ------------------------------数据读取----------------------------------------

[s.M,s.dt] = tools.getcsv();                                                    % 读入csv信号和采样周期dt
s.fs = 1/s.dt;                                                                  % 采样频率

s.t0 = s.M(:,1);                                                                % 第1列，时间s.t = s.t0 - s.t0(1);                                                           % 减去初始值
s.t = s.t0;                                                                     % 保持激发0点

s.inp0 = s.M(:,2);                                                              % 输入激励
[~,index_t0] = max(s.inp0);
s.t = s.t0 - s.t0(index_t0);                                                    % 减去初始值

s.out0 = s.M(:,3:1+s.N_ch);                                                     % 输出信号

s.inp = tools.clean(s.inp0);                                                    % 信号去均值
s.out0 = tools.clean(s.out0);                                                   % 如此设置，可以跳过myfilter
for iloop = 1:s.N_ch-1
    s.out{iloop} = s.out0(:,iloop);                                             % 转换列向量
end

end

%% 信号处理

function s = myfilter(s,flag)
% 题目：信号滤波预处理
% 时间：2016.12.31

if nargin < 2
    flag = 1;                                                                   % 默认弹出对话框
end

prompt0 = {
    '低通滤波 fp-fs kHz', [500 700]
    '低通滤波 Rp',0.1
    '是否显示滤波器频谱',1   
};

dlg0.save = 'myfilter';
para0 = tools.paradlg(prompt0,dlg0,flag);                                       % 对话框参数

para_lp.f1 = para0{1}(1)*1e3;                                                   % 滤波器 fp
para_lp.f3 = para0{1}(2)*1e3;                                                   % 滤波器 fs
para_lp.rp = para0{2};                                                          % 滤波器 rp
para_lp.rs = 30;                                                                % 滤波器 rs
para_lp.fs = s.fs;

para_lp.type = 1;                                                               % 滤波器类型：切比雪夫-1
flag = para0{3};                                                                % 是否绘制滤波器频域曲线

s.inp = tools.lowp(s.inp,para_lp,flag);                                      % 输入信号-滤波

for iloop = 1:s.N_ch-1
    out_temp = tools.lowp(s.out0(:,iloop),para_lp,flag);                     % 输出信号-滤波
    s.out{iloop} = tools.row2mat(out_temp);                                     % 转换列向量
end

end % myfilter

function s = myHilbert(s)
% 题目：所有信号的Hilbert变换
% 时间：2016.12.31

s.inp_h  = hilbert(s.inp);                                                      % hilbert变换

for iloop = 1:s.N_ch-1
    s.out_h{iloop} = hilbert(s.out{iloop});                                     % 输出信号-hilbert变换
end

end % myHilbert

function s = freqAnalysis(s)
% 题目：频域分析
% 功能：傅立叶变换，频响函数分析
% 时间：2016.12.31

s.Nz = length(s.t);                                                             % 数据长度
fz= s.fs*(0:s.Nz-1)/s.Nz;                                                       % 频域横轴
s.fzk = fz/1000;                                                                % 频域横轴，单位 kHz

s.X = fft(s.inp);                                                               % 输入信号频谱
s.Y = cell(3,1);                                                                % 初始化输出信号频谱

for iloop = 1:s.N_ch-1
    s.Y{iloop} = fft(s.out{iloop});                                             % 输出信号频谱
end

% 截取一定范围的频谱
index = s.fzk < s.fk_range;                                                     % 频谱范围控制
s.fzk = s.fzk(index);
s.X = s.X(index);                                                               % 显示的频谱
for iloop = 1:s.N_ch-1
    s.Y{iloop} = s.Y{iloop}(index);                                             % 输出信号频谱
end

s.fzk_Ymax = cell(s.N_ch-1,1);                                                 % 峰值频率记录
s.XNorm = tools.norm(s.X);                                                      % 归一化频谱
for iloop = 1:s.N_ch-1
    s.YNorm{iloop} = tools.norm(s.Y{iloop});                                    % 输出信号频谱
    [~,index_temp] = max(s.YNorm{iloop});
    s.fzk_Ymax{iloop} = s.fzk(index_temp);                                      % 峰值频率记录
end

index_FRF = abs(s.XNorm) < max(abs(s.XNorm))*0.05;                              % 删除输入频谱极小处的FRF，避免极大值干扰
for iloop = 1:s.N_ch-1
    s.FRF{iloop} = s.Y{iloop}./s.X;                                             % 频响函数
    s.FRF{iloop}(index_FRF) = 0;
    s.FRF{iloop} = tools.norm(s.FRF{iloop});                                    % 频响函数的归一化
end 

end % freqAnalysis

%% 绘图显示

function s = overlay(s)
% 题目：时域输出信号的叠绘

prompt0 = {
    '叠绘信号数量',2
    '叠绘通道',1
};

dlg0.save = 'overlay';
para0 = tools.paradlg(prompt0,dlg0);                                            % 对话框参数

n = para0{1};
out_overlay = cell(n,1);
for iloop = 1:n
    [M_temp,~] = tools.getcsv();                                                % 读入csv信号和采样周期dt
    out_overlay{iloop} = M_temp(:,3);                                           % 输出激励
end

figure,hold on
for iloop = 1:n
    plot(out_overlay{iloop});
end

str_legend = tools.paste([1:n],'test-');                                        % legend 标注
legend(str_legend)
tools.white;

end

function s = timePlot(s,flag)
% 题目：时程信号绘图
% 功能：
%       时程图像
%       包络图
% 时间：2016.12.31

if nargin < 2                                                                   
   flag = 1;                                                                    % 默认绘制包络图
   s.myHilbert();
end

figure
subplot(s.N_ch+1,1,1)                                                           % 汇总图
t_us = s.t*1e6;                                                                 % 时间-us
plot(repmat(t_us,1,s.N_ch),[s.inp,s.out{1:end}]) 
tools.xyt({'t /\mu s','Voltage/V','发射信号与接收信号时程'})

subplot(s.N_ch+1,1,2)  
plot(t_us,s.inp) 
tools.xyt({'t /\mu s','Voltage/V','发射信号时程'})
legend({'发射信号'})

if flag
    for iloop = 3:s.N_ch+1                                                      % 接收信号时程绘制
        subplot(s.N_ch+1,1,iloop)   
        plot(t_us,s.out{iloop-2}),hold on
        plot(t_us,abs(s.out_h{iloop-2}))                                        % 包络绘制
        legend({'接收信号','包络'})                                                 
        tools.xyt({'t /\mu s','Voltage/V','接收信号时程图'})
    end
else
     for iloop = 3:s.N_ch+1                                                     % 接收信号时程绘制
        subplot(s.N_ch+1,1,iloop)   
        plot(t_us,s.out{iloop-2})
        legend({'接收信号'})                                                 
        tools.xyt({'t /\mu s','Voltage/V','接收信号时程图'})
    end   
end

s.dispAmpl();

end % timePlot

function s = dispAmpl(s)
    Ampl = max(abs(s.out{1}));                                                  % 峰值说明
    disp('接收信号峰值为：')
    disp(Ampl)
end
    
function s = freqPlot(s,flag)
% 题目：频谱图绘制
% 参数： flag == 1,绘制频响函数图
% 2016.12.31

s.freqAnalysis();                                                               % 傅立叶变换及频谱分析
if nargin < 2                                                                   % 默认不绘制频响函数
    flag =0;
end

% -------------频谱图-------------
figure
subplot(s.N_ch+1,1,1)
t_us = s.t*1e6;                                                                 % 时程汇总
plot(repmat(t_us,1,s.N_ch),[s.inp,s.out{1:end}]) 
tools.xyt({'t /\mu s','Voltage/V','发射信号与接收信号时程'})

subplot(s.N_ch+1,1,2)                                                           % 发射信号频谱
plot(s.fzk,abs(s.XNorm))
xlim([0 s.fk_range])
tools.xyt({'Freq/kHz','Magnitude','发射信号频谱'})

for iloop = 3:s.N_ch+1                                                          % 接收信号时程绘制
    subplot(s.N_ch+1,1,iloop)   
    plot(s.fzk,abs(s.YNorm{iloop-2}))
    xlim([0 s.fk_range])
    tools.xyt({'Freq/kHz','Magnitude','接收信号频谱'})
%     tools.xline([0 s.fzk_Ymax{iloop-2}],'m-');                                    % 显示峰值
    tools.xGrid(s.fzk_Ymax{iloop-2},45);
end

% -------------频响函数图-------------
if flag
    figure
    for iloop = 1:s.N_ch-1
        subplot(s.N_ch-1,1,1)                                                       % 发射信号频谱
        plot(s.fzk,abs(s.FRF{iloop}))
        xlim([0 s.fk_range])
        str_legend = ['频响函数','-输出通道',num2str(iloop)];
        tools.xyt({'Freq/kHz','Magnitude',str_legend})
        tools.xGrid(s.fzk_Ymax{iloop});
    end
end

end % freqPlot


function s = mycwt(s,flag)
% 题目：小波变换时频图绘制
% 参数：flag 是否弹出对话框

if nargin < 2
    flag = 1;                                                                   % 默认弹出对话框
end

% -------------参数对话框设置-------------
prompt0 = {                                                         % 对话框参数
    '当前采样频率 fs0 kHz', s.fs/1e3
    '降低采样倍数 q', 10
    '小波类型','Morl'
    '尺度序列的长度totalscal',2048
    '频率显示范围 kHz',[0 600]
    '是否绘制频散曲线',0
};

dlg0.title = '时频分析参数设置';
dlg0.save = 'mycwt';
para0 = tools.paradlg(prompt0,dlg0,flag);

% -------------参数读取-------------
p = 1;
q = para0{2};                                                                   % 降低采样的倍数
wavename = para0{3};                                                            % 小波类型设置
totalscal = para0{4};                                                           % 尺度序列的长度，即scal的长度
fzk_lim = para0{5};                                                             % 时频图显示的频率范围
flag_pcdisp = para0{6};                                                         % 是否绘制频散曲线

% -------------信号重采样-------------
inp_res = resample(s.inp,p,q);                                                  % 发射信号重采样
out_res = cell(s.N_ch-1,1);
for iloop = s.N_ch - 1
    out_res{iloop} = resample(s.out{iloop},p,q);                                % 接收信号重采样
end

t_res = (0:length(inp_res)-1)*s.dt*q/p;                                         % 时间序列需要手动计算，不可重采样
t_res = t_res + s.t(1);                                                         % 时间0点
t_res =tools.row2mat(t_res);
t_res_us = t_res*1e6;                                                           % 重采样时间
t_us_lim = tools.range(t_res_us);                                               % 时间轴区间
fs_res = s.fs/q;                                                                % 重采样频率

% -------------小波变换参数设置-------------

wcf = centfrq(wavename);                                                        % 小波的中心频率
cparam = 2*wcf*totalscal;                                                       % 为得到合适的尺度所求出的参数
a = totalscal:-1:0.2; 
scal = cparam./a;                                                               % 得到各个尺度，以使转换得到频率序列为等差序列

coefs = cell(s.N_ch-1,1);
index_coef_max = cell(s.N_ch-1,1);
coef_max = cell(s.N_ch-1,1);

tic
for iloop = 1:s.N_ch-1
    coefs{iloop}=cwt(out_res{iloop},scal,wavename);                             % 得到小波系数
    f=scal2frq(scal,wavename,1/fs_res);                                         % 将尺度转换为频率
    fk = f/1e3;                                                                 % 频率，kHz

    [coef_max{iloop},index_coef_max{iloop}] = max(max(abs(coefs{iloop})));      % 小波系数最大的点    

end
toc                                                                             % 计算耗时

% -------------小波变换绘图-------------

for iloop = 1:s.N_ch-1
    figure
    subplot(5,4,[2:4])                                                          % 时程信号绘图
    plot(t_res_us*[1 1],[inp_res,out_res{iloop}]) 
    tools.xyt({'t /\mu s','Voltage/V',''})                                      % --发射信号与接收信号时程
    legend({'发射信号','接收信号'})
    xlim(t_us_lim)

    subplot(5,4,[6:8])                                                          % 时程信号绘图
    plot(t_res_us,out_res{iloop}) 
    tools.xyt({'t /\mu s','Voltage/V',''})                                      % --接收信号时程
    legend({'接收信号'})   
    xlim(t_us_lim)    
    
    subplot(5,4,[9 13 17])                                                      % 傅立叶频谱
    plot(abs(s.YNorm{iloop}),s.fzk)
    ylim(fzk_lim)
    tools.xyt({'Magnitude','Freq/kHz',''})                                      % -- 接收信号频谱
    set(gca,'xdir','reverse')
    
    subplot(5,4,[10:12,14:16,18:20])                                            % 占用子图位置
    imagesc(t_res_us,fk,abs(coefs{iloop}));                                    % 绘制色谱图
    colorbar('east');                                                           % 色条在坐标轴内部显示，以便对齐
    tools.xyt({'时间 t/\mu s','频率 f/kHz',''})                                 % --小波时频图
    xlim(t_us_lim)
    ylim(fzk_lim)                                                               % 频域显示范围设置
    set(gca, 'YDir', 'normal')
    tools.white;
    
    hold on 
    tools.xline([t_res_us(index_coef_max{iloop}),0],'m-');                      % 峰值出处绘制直线
    tools.xline([0 s.fzk_Ymax{iloop}],'m-');        
    
    tools.xGrid(t_res_us(index_coef_max{iloop}),45);                            % 峰值出处绘制直线
    tools.yGrid(s.fzk_Ymax{iloop});                                             % 同上
end

% 频散曲线叠绘
if flag_pcdisp
    load('D10_F1000_L.mat')                                                     % 纵波频散曲线数据
    hold on
    for iloop = 1:length(x)
        ytemp = 1./y{iloop};                                                    % 走时计算
        plot(ytemp*1e6,x{iloop},'-','color','w')
    end
    % set(gca, 'YDir', 'reverse')                                               % 倒转y轴    
end

s.dispAmpl();                                                                   % 幅值显示

end
end % method

end % classdef