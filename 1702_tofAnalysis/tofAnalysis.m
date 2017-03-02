% 题目：导波走时变化率分析
% 马骋 20170225

% 获取数据文件
clc,clear,close all
% filename = tools.getfile();
filename = 'd10_1000_L.fig';
open(filename)
h=findobj(gca,'Type','Line');                                               % 提取曲线数据对象
x = get(h,'xdata');                                                         % 坐标数据cell数据
y = get(h,'ydata');    

v_group = y{4};                                                                 % 频散曲线数据提取
freq = x{4};

%% 参数对话框

prompt0 = {                                                         % 对话框参数
    '钢筋直径 mm', 10
    '频率范围 kHz', [50 200]
    '频率间距 kHz',5
    '数值微分delta',0.1
    '钢筋长度 m',1
};

dlg0.title = '走时分析参数设置';
dlg0.save = 'tof';
para = tools.paradlg(prompt0,dlg0);

% 参数读取
d0 = para{1};                                                                   % mm
fRange = para{2};                                                               % 计算频率的范围
df = para{3};                                                                   % 频率间距
fk = fRange(1):df:fRange(2);                                                    % 计算频率序列
tof_d = zeros(size(fk));                                                        % tof 变化率序列
delta = para{4};                                                                % 数值微分delta
L = para{5};                                                                    % 钢筋长度

tof = L./v_group*1e6;                                                           % 走时序列 us

%% TOF变化率计算

for iloop = 1:length(fk)
    d = freq*10/fk(iloop);
    d_q = [d0-delta,d0,d0+delta];                                               % 微分插值的直径序列
    tof_q = interp1(d,tof,d_q,'spline');                                         % 插值的走时序列
    tof_d(iloop) = (tof_q(3)-tof_q(1))/(2*delta);                               % 走时变化率
end

%% 绘图

figure
subplot(211)                                                                    % 频散曲线
hold on
for iloop = 1:length(x)
    plot(x{iloop},y{iloop})
end
tools.xyt({'频率 kHz','群速度 m/s','频散曲线'})
xlim([0 max(fk)])

subplot(212)                                                                    % TOF变化敏感性
plot(fk,tof_d)
str_title = ['TOF变化敏感性（d=',num2str(d0),'mm）'];
tools.xyt({'频率 kHz','TOF变化率 us/s',str_title})

[~,index] = max(tof_d);
tools.xGrid(fk(index));

hold on
plot(fk(index),max(tof_d),'ro')

