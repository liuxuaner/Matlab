classdef tools < handle
% 题目：信号处理函数工具箱
% 静态函数
%       version  --  版本说明
%       white    --  图像窗口刷白
%       norm     --  复数向量归一化
%       paradlg  --  创建标准化参数对话框
%       paste    --  数值向量与字符串粘贴
%       envelope --  提取信号包络线，没用了
%       lowp     --  低通滤波器
%       getdir   --  读取一个文件夹目录
%       getfile  --  读取一个文件名
%       getcsv   --  示波器标准csv数据读取
%       gettxt   --  读取txt数据文件
%       getmat   --  读取mat文件
%       xyt      --  生成xlabel,ylabel,title
%       range    --  给出一个向量/矩阵的数值范围
%       row2mat  --  行向量转列向量
%       html     --  按照指定的文件名发布html文件
%       cleanSignal  预处理导波输入输出信号
%       colorOrder   MATLAB默认的线条颜色序列
%       xline    --  绘制贯通直线
%       saveGragh--  图像保存
%       xGrid,yGrid  增加网格线
%       plot0   --   最简正弦曲线绘制
% 作者：马骋
% 2016.12.13 @ HIT

properties
% Basic Parameter

end % properties

methods(Static) % 静态方法
        
function version()   
% 题目：版本自动说明
    clc
    str_version =  '版本说明：数据处理与信号绘图辅助工具箱\n马骋,创建于2016.04.29 \n\n';
    fprintf(str_version)
    
    str_updatelog = {
        '更新日志：'
        '2016.04.29,增加xyt函数；'  
        '2016.04.30,增加getmat函数；'
        '2016.04.30,更新paradlg冲突bug；'
        '2016.05.03,更新paradlg空格bug；'
        '2016.05.03,增加range函数；'
        '2016.05.04,增加row2mat函数；'
        '2016.05.06,增加html函数；'
        '2016.05.06,增加clean函数；'
        '2016.12.13,增加colorOrder函数；'
        '2016.12.21,增加xline函数；'
        '2017.01.05,修改paradlg函数，智能弹出；'
        '2017.01.05,增加saveGragh函数；'
        '2017.01.08,增加xGrid,yGrid网格线'
        '2017.01.08,增加plot0函数；'
        '2017.01.10,增加intersection函数；'
        '2017.01.10,增加getband3db函数；'
        '2017.01.10,增加toneburst函数；'
    };

    for iloop = 1:length(str_updatelog)
        fprintf([str_updatelog{iloop},'\n']);        
    end   
    
end     % version
    
function white()    
% 题目:图像刷白
    set(gcf,'color','white');
    grid on;
    shg;
end      % white  

function xNorm = norm(x)
% 题目:复数向量归一化
% 输入:
%       x           -- 复数向量
% 输出：
%       xNorm       -- 归一化后的向量
% 作者: 马骋
% 2016.04.17 @HIT
x = tools.row2mat(x);
nRow = size(x,1);                                                               % 获取行数
xMax = max(abs(x)); 
xMax = repmat(xMax,nRow,1);                                                     % 最大值扩维
xNorm = x./xMax;                                                                % 归一化
end % norm

function para = paradlg(prompt0,dlg0,isShow)
% 题目:标准化对话框创建程序
% 输入:
%       prompt0     -- 提示语以及默认参数，n*2
%       dlg0        -- 可选定制化参数
%       	.width  -- 对话框宽度
%           .title  -- 标题
%           .save   -- data_dlg后缀名
%       isShow      -- 是否弹出对话框，
% 输出：
%       para        -- 对话框输入参数，默认弹出，若isShow=0，则不弹出，数值取上次默认值
% 功能：
%       创建标准化参数输入对话框
%       支持 标量、向量、字符串
%       导出输入参数
%       记忆上次输入
% 作者: 马骋
% 2016.04.17 @HIT

% prompt参数

if nargin < 3
    isShow = 1;                                                                 % 默认需要弹出对话框
end

n = size(prompt0,1);                                                            % 参数组数
prompt = cell(n,1);                                                             % 提示语
def0 = cell(n,1);                                                               % 默认参数值

for iloop = 1:n
    prompt{iloop} = prompt0{iloop,1};                                           % 参数分离
    def0{iloop} = num2str(prompt0{iloop,2});                                    % 默认参数必须为字符串格式
end

aux_filename = 'data_dlg';                                                      % 参数存储辅助文件
dlg0.issave = false;
try
    aux_filename = [aux_filename,'_',dlg0.save];                                % 如果指定后缀名，则保存参数
    dlg0.issave = true;
catch

end

try
    load(aux_filename)                                                          % 导入上次运行数据def
    if size(def,1) ~= size(def0,1)
        def = def0;                                                             % 将def更新为程序最新的设定
    end
catch
    def =def0;
end

% dlg参数
try                                                                             % 宽度设置
    dlg.width = dlg0.width;
catch
    dlg.width = 60;
end

try                                                                             % 标题设置
    dlg.title = dlg0.title;
catch
    dlg.title = '参数输入';
end

% 对话框

linewidth = ones(n,2);                                                          % 宽度设置
linewidth(:,2) = linewidth(:,2)*dlg.width;                                      % 可以输入控制
options.Interpreter='tex';
para = cell(n,1);                                                           % 输出参数


if isShow
    para_dlg = inputdlg(prompt,dlg.title,linewidth,def,options);                % 打开对话框，获取参数字符串
else 
    para_dlg = def;                                                             % isShow=0，不弹出对话框，取上次设定值
end

% 向量转换，字符串转换
for iloop = 1:n
    temp = ['[',para_dlg{iloop},']'];                                           % 默认按向量转换
    para{iloop} = str2num(temp);

    if isempty(para{iloop})                                                     % 如果转换后为空，则为字符串
        para{iloop} = para_dlg{iloop};
    end

    if all(isspace(para_dlg{iloop}))                                            % 多个空格的情况
        para{iloop} = [];
    end
end

try                                                                             % 如果dlg.issave==1，记忆数据到aux_filename
    if(dlg0.issave)
        def = para_dlg;
        save(aux_filename,'def');                                               % 保存对话框数据，用于下次导入
    end
catch
    
end

end  % paradlg

function str_x = paste(x,prefix,suffix)
% 题目：对数值序列粘贴前后缀，构成字符串
% 输入:
%       x      -- 数值序列
%       prefix -- 前缀
%       suffix -- 后缀
% 输出：
%       str_x  -- 合并后字符串
% 作者: 马骋
% 2016.04.17 @HIT

str_x = cell(size(x));
for iloop = 1:length(x)
	if nargin == 2
		temp = [prefix,num2str(x(iloop))];
	elseif nargin ==3
		temp = [prefix,num2str(x(iloop)),suffix];
	else                    
	end
	str_x{iloop} = temp;
end

end %　paste

function [up,down] = envelope(x,y,interpMethod)
%ENVELOPE gets the data of upper and down envelope of the known input (x,y).
%   Input :
%    x               the abscissa of the given data
%    y               the ordinate of the given data
%    interpMethod    the interpolation method
%   Output parameters:
%    up      the upper envelope, which has the same length as x.
%    down    the down envelope, which has the same length as x.
%
%   See also DIFF INTERP1

%   Designed by: Lei Wang, <WangLeiBox@hotmail.com>, 11-Mar-2003.
%   Last Revision: 21-Mar-2003.
%   Dept. Mechanical & Aerospace Engineering, NC State University.
% $Revision: 1.1 $  $Date: 3/21/2003 10:33 AM $

if length(x) ~= length(y)
    error('Two input data should have the same length.');
end

if (nargin < 2)|(nargin > 3),
 error('Please see help for INPUT DATA.');
elseif (nargin == 2)
    interpMethod = 'linear';
end

extrMaxValue = y(find(diff(sign(diff(y)))==-2)+1);
extrMaxIndex =   find(diff(sign(diff(y)))==-2)+1;

extrMinValue = y(find(diff(sign(diff(y)))==+2)+1);
extrMinIndex =   find(diff(sign(diff(y)))==+2)+1;

up = extrMaxValue;
up_x = x(extrMaxIndex);

down = extrMinValue;
down_x = x(extrMinIndex);

up = interp1(up_x,up,x,interpMethod); 
down = interp1(down_x,down,x,interpMethod); 
end % envelope

function y=lowp(x,para,isFreqz)
% 题目: 低通滤波器
% 输入:
%       x       -- 原始信号序列
%		para.
%           f1  -- 通带截止频率
%           f3  -- 阻带截止频率
%           rp  -- 边带区衰减DB数设置
%           rs  -- 截止区衰减DB数设置
%           fs  -- 序列x的采样频率
%           type-- 滤波器类型
%       isFreqz -- 是否绘制滤波器曲线
% 输出：
%       y      -- 滤波后的信号
% 功能：
%       低通滤波，滤除高频噪音
%       Cheby1
%       Butterworth
% 注意：
%       通带或阻带的截止频率的选取范围是不能超过采样率的一半
%       f1,f3的值都要小于fs/2
%       rp=0.1;rs=30;%通带边衰减DB值和阻带边衰减DB值
% 作者: 未知
% 修改: 马骋
% 2016.04.21 @HIT

%% 参数输入

f1 = para.f1;
f3 = para.f3;
Rp = para.rp;
Rs = para.rs;
fs = para.fs;

if nargin < 3                                                                   % 是否显示滤波器曲线
    isFreqz = 1;
end

%% 滤波器设计
Wp = f1/(fs/2);                                                     % 采用fs/2归一化,Nyquist frequency.
Ws = f3/(fs/2);

if para.type==1
    [n,Wp]=cheb1ord(Wp,Ws,Rp,Rs);                                   % Cheby1
    [b,a]=cheby1(n,Rp,Wp);
    
    if isFreqz
        freqz(b,a,2048,fs);                                             % 查看设计滤波器的曲线    
        title(sprintf('n = %d Cheby1 Lowpass Filter',n))
        xlim([0 f3])
    end    
else
    
    [n,Wn] = buttord(Wp,Ws,Rp,Rs,'s');                              % Butterworth
    [b,a] = butter(n,Wn,'s');                                       % 计算滤波器系统函数分子分母多项式
    
    [z,p,k] = butter(n,Wn);
    sos = zp2sos(z,p,k);    
    freqz(sos,2048,fs)
    title(sprintf('n = %d Butterworth Lowpass Filter',n))
    xlim([0 f3])    
end

%% 滤波
y = filter(b,a,x);                                                  % 对序列x滤波后得到的序列y

end  % lowp

function [dir_name] = getdir()
% 题目：获取文件夹名称
% 输出：
%       dir_name -- 文件夹路径
% 作者: 马骋
% 2016.04.23 @HIT

    
data_dir = ['data_dir','_',getdir];                                             % 保存路径的数据名


try
    load(data_dir)
    dir_name = uigetdir(start_path);
catch
    dir_name = uigetdir;                                                        % 获取文件夹地址
end

start_path = dir_name;

save(data_dir,'start_path');                                                    % 保存文件夹路径

end % getdir

function [fullname,pathname,filename] = getfile(type,ext)
% 题目：读取文件全名、路径、文件名
% 输入：
%       type        -- 类型标识
% 输出：
%       fullname    -- 全名
%       pathname    -- 路径
%       filename    -- 文件名
% 马骋，2016.04.23

if nargin == 0                                                      % 输入数据预处理
    type = 'getfile';
    FilterSpec = '*.*';
elseif nargin == 1
    FilterSpec = '*.*';
elseif nargin == 2
    FilterSpec = ['*.',ext];
end

data_path = ['data_path','_',type];                                 % 保存路径的数据名

try
    load(data_path)                                                 % 导入路径的数据名
    [filename,pathname,~] = uigetfile(FilterSpec,'选择文件',fullname);    %#ok<*NODEF>
catch
    [filename,pathname,~] = uigetfile(FilterSpec,'选择文件');
end

fullname = [pathname,filename];                                     % 全名
save(data_path,'fullname');                                         % 保存文件路径

end % getfile

function data = gettxt(nrow_start)
% 题目: 读取txt数据文件，跳跃文件头说明行
% 输入:
%       nrow_start  -- 起始行
% 输出：
%       data        -- 信号数据
% 作者: 马骋
% 2016.04.23 @HIT
% bug: dlmread读取txt文件，可能出现错乱

fullname = tools.getfile('gettxt','txt');                                       % 获取数据文件名

if nargin < 1
    rowoff = 0;
    data = load(filename);
else                                                                            % 考虑跳行的情况，可能出现数据错乱
    rowoff = nrow_start -1;
    data = dlmread(fullname,' ',rowoff,0);
end

end % gettxt

function [data,para0] = getcsv(flag)
% 题目: 示波器输出csv数据标准读取
% 输入:
%       flag   -- flag==1，则弹出对话框，否则默认标准参数
%       R0     -- 读取信号数据起始行数
%       R1、C1 -- 特定单元格的位置参数
% 输出：
%       data   -- 信号数据
%       para0  -- 特定单元格参数
% 功能：
%       从R0行开始读取信号数据，直到末尾
%       读取(R1，C1)单元格的参数
% 作者: 马骋
% 2016.04.17 @HIT

% 获取数据文件名
 
if nargin < 1                                                       % 是否打开位置参数对话框
    flag = 1;
end

fullname = tools.getfile('guw','csv');

% 对话框切换
if flag
    prompt0 = {                                                     % 对话框输入参数
        '信号数据起始行数',17
        '目标所在单元位置[R1 C1]',[7 2]
        };
    para = tools.paradlg(prompt0);                                  % 单元格参数
    R0 = para{1}-1;
    R1 = para{2}(1)-1;
    C1 = para{2}(2)-1;
else
    R0 = 17-1;                                                      % 默认参数
    R1 = 7-1;
    C1 = 2-1;
end

% 数据读入          
data = csvread(fullname,R0,0);                                      % 从R0开始，读取后续所有
para0 =  csvread(fullname,R1,C1,[R1 C1 R1 C1]);                     % 采样周期读取

end % getcsv

function data = getmat()
% 题目：读取只有一个变量的矩阵数据mat文件

filename = tools.getfile('mat');
temp1 = load(filename);                                                         % 载入，结构体
temp2 = struct2cell(temp1);                                                     % 转换cell
data = temp2{1};                                                                % 转换矩阵
end % getmat

function xyt(str_xyt)
% 题目：生成xlabel,ylabel,title
xlabel(str_xyt{1});                                                             % label
ylabel(str_xyt{2});
title(str_xyt{3});
grid on                                                                         % 显示网格
set(gcf,'color','white');                                                       % 刷白
shg;
end % xyt

function rg = range(data)
% 题目：给出一个向量/矩阵的数值范围

data = tools.row2mat(data);

[~,nCol] = size(data);
rg = zeros(2,nCol);
rg(1,:) = min(data);                                                            % 输出范围
rg(2,:) = max(data);

end % range

function mat = row2mat(row)
% 题目：将行向量或者行向量组成的矩阵转换为列向量形式
% 时间：2017.01.11

if size(row,2)> size(row,1)                                                     % 列数大于行数
    mat = row';                                                                 % 行向量转置
else
    mat = row;
end

end % row2mat

function html(mFile1,mFile2,htmlFile)
% 题目：按照指定的文件名发布html文件

close all
copyfile(mFile1,mFile2)                                                         % 复制mFile2的m文件
publish(mFile2,'format','html', 'showCode',false);                              % 格式设定,不显示代码

htmlFile0 = [mFile2(1:end-1),'html'];
if nargin == 3
    cd1 = cd;                                                                   % 保存初始路径
    cd('.\html')                                                                % 切换路径
    movefile(htmlFile0,htmlFile)                                                % 改变html文件名
    cd(cd1)                                                                     % 路径恢复
    disp(['报告输出完成：',htmlFile])
else
    disp(['报告输出完成：',htmlFile0])
end
delete(mFile2);                                                                 % 删除辅助文件

end % html

function data = clean(data0,tol)
% 题目：信号去除环境噪声（矩阵运算）
% 功能：去趋势项，对阈值一下的信号归零
% 输入：
%       data0 -- 原始激励信号
%       tol   -- 阈值

data = detrend(data0);                                                          % 去趋势
if nargin == 1
   tol = 1/100;                                                                 % 默认阈值
end

for iLoop = 1:size(data,2)
    tempCol = data(:,iLoop);                                                    % 逐列去噪
    data(:,iLoop) = tools.clean2(tempCol,tol);
end

end % cleanSignal

function dataCol = clean2(dataCol0,tol)
% 题目：信号去除环境噪声（列向量）
% 输入：
%       data0 -- 原始激励信号
%       tol   -- 阈值

if nargin == 1
   tol = 1/100;                                                                 % 默认阈值
end

dataAbs = abs(dataCol0);
index = dataAbs>max(dataAbs)*tol;                                               % 激发阈值判断

temp = index'.*(1:length(index));
nMin = min(temp(temp>0));                                                       % 激发阈值的起点
nMax = max(temp(temp>0));                                                       % 激发阈值的终点

windows = ones(size(dataCol0));                                                 % 滤波窗
windows(1:nMin) = 0;
windows(nMax:end) = 0;

dataCol = dataCol0.*windows;                                                    % 加窗过滤

end % cleanSignal2

function mycolor = colorOrder(index)
% 题目：输入MATLAB默认颜色向量
% 输入：颜色序列号
% 输出：颜色向量
% 示例：
%       t = linspace(0,2*pi,100);y = sin(t);
%       plot(t,y,'color',tools.colorOrder(1))

defaultColor = [                                                                % MATLAB默认线条颜色
         0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840
         0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840    
    ];

mycolor = defaultColor(index,:);                                                    % 颜色向量

end % end of mycolor

function xline(position,lineSpec)
% 题目：输入MATLAB默认颜色向量
% 输入：
%       position    -- [x y]，[1 0]在x=1处绘制竖线，[0 1]在y=1处绘制横线
%       lineSpec   -- 'r-*'
% 输出：辅助直线
% 示例：
%       xline([0 6],'r-')

if nargin < 2                                                                   % 自动补充lineSpec
    lineSpec = 'k-.';
end

if position(1) == 0                                                             % 横线
    y0 = position(2)*[1 1]';
    x0 = get(gca,'Xlim')';
else                                                                            % 竖线
    x0 = position(1)*[1 1]';
    y0 = get(gca,'Ylim')';
end
hold on
plot(x0,y0,lineSpec);                                                   % 绘制
end % end of xline

function xGrid(x0,angle)
% 题目：图中增加x网格线
% 输出：
%       x0  -- 增加网格线的坐标，标量、向量均支持
%       angle- 坐标标签文本角度调整
% 时间：2017.01.08

if nargin < 2
    angle = 0;                                                                  % 标注旋转角度
end

h = gca;
tick_old = h.XTick;
tick_new = sort([tick_old,x0]);
set(h,'xtick',tick_new)
set(h,'xTickLabelRotation',angle)
grid on

end % xGrid

function yGrid(y0,angle)
% 题目：图中增加y网格线
% 输出：
%       y0  -- 增加网格线的坐标，标量、向量均支持
%       angle- 坐标标签文本角度调整
% 时间：2017.01.08
% 时间：2017.01.08

if nargin < 2
    angle = 0;                                                                  % 标注旋转角度
end

h = gca;
tick_old = h.YTick;
tick_new = sort([tick_old,y0]);
set(h,'ytick',tick_new)
set(h,'yTickLabelRotation',angle)
grid on

end % yGrid

function saveGraph()
% 题目：保存gcf图像
% 功能：
%       自定义图片格式
%       自定义图片文件名编号
% 时间：2017.01.05

prompt0 = {                                                         % 对话框参数
    '编号',1
    '前缀','E004a' 
    '后缀','wavelet'
    '图片格式（png/jpg）', 'png'
};

dlg0.title = '图像保存';
dlg0.save = 'saveGraph';
para0 = tools.paradlg(prompt0,dlg0);

filename = [para0{2},'-',num2str(para0{1}),'-',para0{3},'.',para0{4}];
% print(gcf,'-dpng','abc.png') 
saveas(gcf,filename);  

end % saveGraph

function plot0()
% 题目：最简正弦绘图示例
% 时间：2017.01.08

close all
t = 0:0.01:2*pi;
plot(t,sin(t))
end % plot0

function [x0,y0,iout,jout] = intersections(x1,y1,x2,y2,robust)
%INTERSECTIONS Intersections of curves.
%   Computes the (x,y) locations where two curves intersect.  The curves
%   can be broken with NaNs or have vertical segments.
%
% Example:
%   [X0,Y0] = intersections(X1,Y1,X2,Y2,ROBUST);
% Input checks.
error(nargchk(2,5,nargin))

% Adjustments when fewer than five arguments are supplied.
switch nargin
	case 2
		robust = true;
		x2 = x1;
		y2 = y1;
		self_intersect = true;
	case 3
		robust = x2;
		x2 = x1;
		y2 = y1;
		self_intersect = true;
	case 4
		robust = true;
		self_intersect = false;
	case 5
		self_intersect = false;
end


% x1 and y1 must be vectors with same number of points (at least 2).
if sum(size(x1) > 1) ~= 1 || sum(size(y1) > 1) ~= 1 || ...
		length(x1) ~= length(y1)
	error('X1 and Y1 must be equal-length vectors of at least 2 points.')
end
% x2 and y2 must be vectors with same number of points (at least 2).
if sum(size(x2) > 1) ~= 1 || sum(size(y2) > 1) ~= 1 || ...
		length(x2) ~= length(y2)
	error('X2 and Y2 must be equal-length vectors of at least 2 points.')
end

% Force all inputs to be column vectors.
x1 = x1(:);
y1 = y1(:);
x2 = x2(:);
y2 = y2(:);

% Compute number of line segments in each curve and some differences we'll
% need later.
n1 = length(x1) - 1;
n2 = length(x2) - 1;
xy1 = [x1 y1];
xy2 = [x2 y2];
dxy1 = diff(xy1);
dxy2 = diff(xy2);

% Determine the combinations of i and j where the rectangle enclosing the
% i'th line segment of curve 1 overlaps with the rectangle enclosing the
% j'th line segment of curve 2.
[i,j] = find(repmat(min(x1(1:end-1),x1(2:end)),1,n2) <= ...
	repmat(max(x2(1:end-1),x2(2:end)).',n1,1) & ...
	repmat(max(x1(1:end-1),x1(2:end)),1,n2) >= ...
	repmat(min(x2(1:end-1),x2(2:end)).',n1,1) & ...
	repmat(min(y1(1:end-1),y1(2:end)),1,n2) <= ...
	repmat(max(y2(1:end-1),y2(2:end)).',n1,1) & ...
	repmat(max(y1(1:end-1),y1(2:end)),1,n2) >= ...
	repmat(min(y2(1:end-1),y2(2:end)).',n1,1));

% Force i and j to be column vectors, even when their length is zero, i.e.,
% we want them to be 0-by-1 instead of 0-by-0.
i = reshape(i,[],1);
j = reshape(j,[],1);

if self_intersect
	remove = isnan(sum(dxy1(i,:) + dxy2(j,:),2)) | j <= i + 1;
else
	remove = isnan(sum(dxy1(i,:) + dxy2(j,:),2));
end
i(remove) = [];
j(remove) = [];

n = length(i);
T = zeros(4,n);
AA = zeros(4,4,n);
AA([1 2],3,:) = -1;
AA([3 4],4,:) = -1;
AA([1 3],1,:) = dxy1(i,:).';
AA([2 4],2,:) = dxy2(j,:).';
B = -[x1(i) x2(j) y1(i) y2(j)].';

if robust
	overlap = false(n,1);
	warning_state = warning('off','MATLAB:singularMatrix');
	% Use try-catch to guarantee original warning state is restored.
	try
		lastwarn('')
		for k = 1:n
			T(:,k) = AA(:,:,k)\B(:,k);
			[unused,last_warn] = lastwarn;
			lastwarn('')
			if strcmp(last_warn,'MATLAB:singularMatrix')
				% Force in_range(k) to be false.
				T(1,k) = NaN;
				% Determine if these segments overlap or are just parallel.
				overlap(k) = rcond([dxy1(i(k),:);xy2(j(k),:) - xy1(i(k),:)]) < eps;
			end
		end
		warning(warning_state)
	catch err
		warning(warning_state)
		rethrow(err)
	end
	% Find where t1 and t2 are between 0 and 1 and return the corresponding
	% x0 and y0 values.
	in_range = (T(1,:) >= 0 & T(2,:) >= 0 & T(1,:) <= 1 & T(2,:) <= 1).';
	% For overlapping segment pairs the algorithm will return an
	% intersection point that is at the center of the overlapping region.
	if any(overlap)
		ia = i(overlap);
		ja = j(overlap);
		% set x0 and y0 to middle of overlapping region.
		T(3,overlap) = (max(min(x1(ia),x1(ia+1)),min(x2(ja),x2(ja+1))) + ...
			min(max(x1(ia),x1(ia+1)),max(x2(ja),x2(ja+1)))).'/2;
		T(4,overlap) = (max(min(y1(ia),y1(ia+1)),min(y2(ja),y2(ja+1))) + ...
			min(max(y1(ia),y1(ia+1)),max(y2(ja),y2(ja+1)))).'/2;
		selected = in_range | overlap;
	else
		selected = in_range;
	end
	xy0 = T(3:4,selected).';
	
	% Remove duplicate intersection points.
	[xy0,index] = unique(xy0,'rows');
	x0 = xy0(:,1);
	y0 = xy0(:,2);
	
	% Compute how far along each line segment the intersections are.
	if nargout > 2
		sel_index = find(selected);
		sel = sel_index(index);
		iout = i(sel) + T(1,sel).';
		jout = j(sel) + T(2,sel).';
	end
else % non-robust option
	for k = 1:n
		[L,U] = lu(AA(:,:,k));
		T(:,k) = U\(L\B(:,k));
	end
	
	% Find where t1 and t2 are between 0 and 1 and return the corresponding
	% x0 and y0 values.
	in_range = (T(1,:) >= 0 & T(2,:) >= 0 & T(1,:) < 1 & T(2,:) < 1).';
	x0 = T(3,in_range).';
	y0 = T(4,in_range).';
	
	% Compute how far along each line segment the intersections are.
	if nargout > 2
		iout = i(in_range) + T(1,in_range).';
		jout = j(in_range) + T(2,in_range).';
	end
end

% Plot the results (useful for debugging).
% plot(x1,y1,x2,y2,x0,y0,'ok');

end % intersection

function [band3db,x0] = getband3db(fs,S,flag)
% 题目：计算给定信号的3db带宽
% 输入：
%       fs  -- 采样频率
%       S   -- 信号时程
%       flag-- 是否绘制图像
% 时间：2017.01.10

if nargin < 3
    flag = 1;
end

Nz = length(S);                                                                 % 数据长度
fz= fs*(0:Nz-1)/Nz;                                                             % 频域横轴
X = abs(fft(S));                                                                % fft变换

x1 = [0,fs/2];                                                                  % 3db横线
y1 = [1 1]*max(X)/sqrt(2);

x2 = fz;                                                                        % 信号
y2 = X;

[x0,y0,~,~] = intersections(x1,y1,x2,y2);                                       % 交点求解
band3db = x0(2)-x0(1);                                                          % 带宽计算

if flag                                                                         % 图像绘制检查
    figure
    plot(x1,y1,x2,y2,x0,y0,'ok');
    xlim([0 fs/2])
end                                           

end % get3band3db

function [S,fs] = toneburst()
% 题目: 超声导波激励信号的生成与频谱分析
% 参数:
%       N  - cycle数，即激励信号波峰数
%       fc - 激励信号中心频率
% 功能：
%       生成激励信号序列
%       绘制时域图和频域图
%       对比不同cycle数信号的特征
%       输出txt文件
% 作者: 马骋
% 2016.03.18 @HIT    

% -----------------------基本参数-----------------------

prompt0 = {                                                                     % 对话框参数
    '激励信号幅值(Vpp)',1
    '信号中心频率（kHz）',200
    '波峰数（cylces）',1
    '信号持续时间（\mu s）',100
    '是否输出信号数据文件',0
};
dlg0.title = '激励信号生成-马骋';
dlg0.save = 'toneburst';
para = tools.paradlg(prompt0,dlg0); 

A = para{1};                                                                    % 激励信号幅值
fck = para{2};                                                                  % 激励中心频率 kHz
N = para{3};                                                                    % cycle数，即激励信号波峰数
fc = fck*1e3;                                                                   % 激励信号中心频率，Hz 
T = para{4}*1e-6;                                                               % 导波传播时间s
dt = 1/(20*fc)/2;                                                               % 时间步长，在最大步长基础上除以2
t = [0:dt:T-dt]';                                                               % 时间序列
t_us = T*1e6; 

flag_output = para{5};                                                          % 是否输出信号数据

% -----------------------信号时域波形-----------------------

S = A/2*[heaviside(t)-heaviside(t-N/fc)].*...                                    % 信号时域波形         
    (1-cos(2*pi*fc*t/N)).*sin(2*pi*fc*t);
% #Change the range according to your settings
% range(0,50us)
% #Your equation goes here
% (1-Cos(2*pi*W/5))*Sin(2*pi*W)
% -----------------------频域信号-----------------------

fs = 1/dt;                                                                      % 采样频率
Nz = length(t);                                                                 % 数据长度
fz= fs*(0:Nz-1)/Nz;                                                             % 频域横轴
X = fft(S);                                                                     % fft变换

[band,x0] = tools.getband3db(fs,S,0);                                           % 带宽计算
bwk = band/1e3;

% -----------------------绘图-----------------------

figure
subplot(211)
plot(t,S)
str_title = ['中心频率',num2str(fck),'kHz'];
tools.xyt({'t(s)','Mangitude(N)',str_title})
xlim([0 T]),grid on

subplot(212)
plot(fz/1000,abs(X))
str_title = ['信号带宽',num2str(bwk),'kHz'];
tools.xyt({'frequency(kHz)','Amplitude',str_title})
xlim([0 fs/2/1000]),grid on                                                     % 防混叠，fs/2
X_3db = max(abs(X))/sqrt(2);
tools.xline([0 X_3db],'m-')
tools.yGrid(X_3db)
tools.white;

% -----------------------信号输出-----------------------

str_time = [num2str(T/1e-6),'US'];                                              % 信号数据文件名构造
str_num = ['S',num2str(length(S))];
filename = ['V',num2str(fc/1000),'K_C',num2str(N),...
    '_',str_time,'_',str_num,'.TXT'];

if  flag_output
    fid = fopen(filename, 'w');
    for iloop=1:length(S)
        fprintf(fid, '%15.10f \r\n', S(iloop));
    end
    fclose(fid);
end

end % toneburst

end % static
end % classdef