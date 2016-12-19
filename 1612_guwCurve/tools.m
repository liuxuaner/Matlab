classdef tools < handle
% 题目：信号处理函数工具箱
% 静态函数
%       version  --  版本说明
%       white    --  图像窗口刷白
%       norm     --  复数向量归一化
%       paradlg  --  创建标准化参数对话框
%       paste    --  数值向量与字符串粘贴
%       envelope --  提取信号包络线
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
% 作者：马骋
% 2016.04.23 @ HIT

properties
% Basic Parameter

end % properties

methods(Static) % 静态方法
        
function version()   
    % 版本自动说明
    str_version =  '版本说明：信号处理函数工具箱\n马骋,2016.04.29 \n\n';
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
    };

    for iloop = 1:length(str_updatelog)
        fprintf([str_updatelog{iloop},'\n']);        
    end   
    
end     % version
    
function white()    
% 题目:图像刷白
    set(gcf,'color','white');
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

function para = paradlg(prompt0,dlg0 )
% 题目:标准化对话框创建程序
% 输入:
%       prompt0     -- 提示语以及默认参数，n*2
%       dlg0        -- 可选定制化参数
%       	.width  -- 对话框宽度
%           .title  -- 标题
%           .save   -- data_dlg后缀名
% 输出：
%       para        -- 对话框输入参数
% 功能：
%       创建标准化参数输入对话框
%       支持 标量、向量、字符串
%       导出输入参数
%       记忆上次输入
% 作者: 马骋
% 2016.04.17 @HIT

% prompt参数

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
para_dlg = inputdlg(prompt,dlg.title,linewidth,def,options);                    % 打开对话框，获取参数字符串

% 参数转换
% 向量转换，字符串转换

para = cell(n,1);                                                               % 输出参数
for iloop = 1:n
    temp = ['[',para_dlg{iloop},']'];                                           % 默认按向量转换
    para{iloop} = str2num(temp);
    
    if isempty(para{iloop})                                                     % 如果转换后为空，则为字符串
        para{iloop} = para_dlg{iloop};
    end
    
    if all(isspace(para_dlg{iloop}))	        								% 多个空格的情况
        para{iloop} = [];
    end
end

% 参数保存

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

function y=lowp(x,para)
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

%% 滤波器设计
Wp = f1/(fs/2);                                                     % 采用fs/2归一化,Nyquist frequency.
Ws = f3/(fs/2);

if para.type==1
    [n,Wp]=cheb1ord(Wp,Ws,Rp,Rs);                                   % Cheby1
    [b,a]=cheby1(n,Rp,Wp);
    freqz(b,a,2048,fs);                                             % 查看设计滤波器的曲线    
    title(sprintf('n = %d Cheby1 Lowpass Filter',n))
    xlim([0 f3])
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

function [dir_name] = getdir(type)

if nargin == 0
    type = 'new';
end   
    
data_dir = ['data_dir','_',type];                                   % 保存路径的数据名
% 题目：获取文件夹名称
% 输入:
%       type     -- 记忆数据标识
% 输出：
%       dir_name -- 文件夹路径
% 作者: 马骋
% 2016.04.23 @HIT

try
    load(data_dir)
    dir_name = uigetdir(start_path);
catch
    dir_name = uigetdir;                                            % 获取文件夹地址
end

start_path = dir_name;

save(data_dir,'start_path');                                        % 保存文件夹路径

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
    type = 'new';
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

if nargin == 0
    rowoff = 0;
else
    rowoff = nrow_start -1;
end

fullname = tools.getfile('signal','txt');
data = dlmread(fullname,' ',rowoff,0);

end % gettxt

function [data,para0] = getcsv(flag0)
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

flag = 0;                                                           % 是否打开位置参数对话框
if nargin == 1
    flag = flag0;
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
temp1 = load(filename);                                             % 载入，结构体
temp2 = struct2cell(temp1);                                         % 转换cell
data = temp2{1};                                                    % 转换矩阵
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
% 题目：行向量转换为矩阵

if isrow(row)
    mat = row';                                                               % 行向量转置
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

end % static
end % classdef