classdef tools < handle
% ��Ŀ���źŴ�����������
% ��̬����
%       version  --  �汾˵��
%       white    --  ͼ�񴰿�ˢ��
%       norm     --  ����������һ��
%       paradlg  --  ������׼�������Ի���
%       paste    --  ��ֵ�������ַ���ճ��
%       envelope --  ��ȡ�źŰ����ߣ�û����
%       lowp     --  ��ͨ�˲���
%       getdir   --  ��ȡһ���ļ���Ŀ¼
%       getfile  --  ��ȡһ���ļ���
%       getcsv   --  ʾ������׼csv���ݶ�ȡ
%       gettxt   --  ��ȡtxt�����ļ�
%       getmat   --  ��ȡmat�ļ�
%       xyt      --  ����xlabel,ylabel,title
%       range    --  ����һ������/�������ֵ��Χ
%       row2mat  --  ������ת������
%       html     --  ����ָ�����ļ�������html�ļ�
%       cleanSignal  Ԥ��������������ź�
%       colorOrder   MATLABĬ�ϵ�������ɫ����
%       xline    --  ���ƹ�ֱͨ��
%       saveGragh--  ͼ�񱣴�
%       xGrid,yGrid  ����������
%       plot0   --   ����������߻���
% ���ߣ����
% 2016.12.13 @ HIT

properties
% Basic Parameter

end % properties

methods(Static) % ��̬����
        
function version()   
% ��Ŀ���汾�Զ�˵��
    clc
    str_version =  '�汾˵�������ݴ������źŻ�ͼ����������\n���,������2016.04.29 \n\n';
    fprintf(str_version)
    
    str_updatelog = {
        '������־��'
        '2016.04.29,����xyt������'  
        '2016.04.30,����getmat������'
        '2016.04.30,����paradlg��ͻbug��'
        '2016.05.03,����paradlg�ո�bug��'
        '2016.05.03,����range������'
        '2016.05.04,����row2mat������'
        '2016.05.06,����html������'
        '2016.05.06,����clean������'
        '2016.12.13,����colorOrder������'
        '2016.12.21,����xline������'
        '2017.01.05,�޸�paradlg���������ܵ�����'
        '2017.01.05,����saveGragh������'
        '2017.01.08,����xGrid,yGrid������'
        '2017.01.08,����plot0������'
        '2017.01.10,����intersection������'
        '2017.01.10,����getband3db������'
        '2017.01.10,����toneburst������'
    };

    for iloop = 1:length(str_updatelog)
        fprintf([str_updatelog{iloop},'\n']);        
    end   
    
end     % version
    
function white()    
% ��Ŀ:ͼ��ˢ��
    set(gcf,'color','white');
    grid on;
    shg;
end      % white  

function xNorm = norm(x)
% ��Ŀ:����������һ��
% ����:
%       x           -- ��������
% �����
%       xNorm       -- ��һ���������
% ����: ���
% 2016.04.17 @HIT
x = tools.row2mat(x);
nRow = size(x,1);                                                               % ��ȡ����
xMax = max(abs(x)); 
xMax = repmat(xMax,nRow,1);                                                     % ���ֵ��ά
xNorm = x./xMax;                                                                % ��һ��
end % norm

function para = paradlg(prompt0,dlg0,isShow)
% ��Ŀ:��׼���Ի��򴴽�����
% ����:
%       prompt0     -- ��ʾ���Լ�Ĭ�ϲ�����n*2
%       dlg0        -- ��ѡ���ƻ�����
%       	.width  -- �Ի�����
%           .title  -- ����
%           .save   -- data_dlg��׺��
%       isShow      -- �Ƿ񵯳��Ի���
% �����
%       para        -- �Ի������������Ĭ�ϵ�������isShow=0���򲻵�������ֵȡ�ϴ�Ĭ��ֵ
% ���ܣ�
%       ������׼����������Ի���
%       ֧�� �������������ַ���
%       �����������
%       �����ϴ�����
% ����: ���
% 2016.04.17 @HIT

% prompt����

if nargin < 3
    isShow = 1;                                                                 % Ĭ����Ҫ�����Ի���
end

n = size(prompt0,1);                                                            % ��������
prompt = cell(n,1);                                                             % ��ʾ��
def0 = cell(n,1);                                                               % Ĭ�ϲ���ֵ

for iloop = 1:n
    prompt{iloop} = prompt0{iloop,1};                                           % ��������
    def0{iloop} = num2str(prompt0{iloop,2});                                    % Ĭ�ϲ�������Ϊ�ַ�����ʽ
end

aux_filename = 'data_dlg';                                                      % �����洢�����ļ�
dlg0.issave = false;
try
    aux_filename = [aux_filename,'_',dlg0.save];                                % ���ָ����׺�����򱣴����
    dlg0.issave = true;
catch

end

try
    load(aux_filename)                                                          % �����ϴ���������def
    if size(def,1) ~= size(def0,1)
        def = def0;                                                             % ��def����Ϊ�������µ��趨
    end
catch
    def =def0;
end

% dlg����
try                                                                             % �������
    dlg.width = dlg0.width;
catch
    dlg.width = 60;
end

try                                                                             % ��������
    dlg.title = dlg0.title;
catch
    dlg.title = '��������';
end

% �Ի���

linewidth = ones(n,2);                                                          % �������
linewidth(:,2) = linewidth(:,2)*dlg.width;                                      % �����������
options.Interpreter='tex';
para = cell(n,1);                                                           % �������


if isShow
    para_dlg = inputdlg(prompt,dlg.title,linewidth,def,options);                % �򿪶Ի��򣬻�ȡ�����ַ���
else 
    para_dlg = def;                                                             % isShow=0���������Ի���ȡ�ϴ��趨ֵ
end

% ����ת�����ַ���ת��
for iloop = 1:n
    temp = ['[',para_dlg{iloop},']'];                                           % Ĭ�ϰ�����ת��
    para{iloop} = str2num(temp);

    if isempty(para{iloop})                                                     % ���ת����Ϊ�գ���Ϊ�ַ���
        para{iloop} = para_dlg{iloop};
    end

    if all(isspace(para_dlg{iloop}))                                            % ����ո�����
        para{iloop} = [];
    end
end

try                                                                             % ���dlg.issave==1���������ݵ�aux_filename
    if(dlg0.issave)
        def = para_dlg;
        save(aux_filename,'def');                                               % ����Ի������ݣ������´ε���
    end
catch
    
end

end  % paradlg

function str_x = paste(x,prefix,suffix)
% ��Ŀ������ֵ����ճ��ǰ��׺�������ַ���
% ����:
%       x      -- ��ֵ����
%       prefix -- ǰ׺
%       suffix -- ��׺
% �����
%       str_x  -- �ϲ����ַ���
% ����: ���
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

end %��paste

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
% ��Ŀ: ��ͨ�˲���
% ����:
%       x       -- ԭʼ�ź�����
%		para.
%           f1  -- ͨ����ֹƵ��
%           f3  -- �����ֹƵ��
%           rp  -- �ߴ���˥��DB������
%           rs  -- ��ֹ��˥��DB������
%           fs  -- ����x�Ĳ���Ƶ��
%           type-- �˲�������
%       isFreqz -- �Ƿ�����˲�������
% �����
%       y      -- �˲�����ź�
% ���ܣ�
%       ��ͨ�˲����˳���Ƶ����
%       Cheby1
%       Butterworth
% ע�⣺
%       ͨ��������Ľ�ֹƵ�ʵ�ѡȡ��Χ�ǲ��ܳ��������ʵ�һ��
%       f1,f3��ֵ��ҪС��fs/2
%       rp=0.1;rs=30;%ͨ����˥��DBֵ�������˥��DBֵ
% ����: δ֪
% �޸�: ���
% 2016.04.21 @HIT

%% ��������

f1 = para.f1;
f3 = para.f3;
Rp = para.rp;
Rs = para.rs;
fs = para.fs;

if nargin < 3                                                                   % �Ƿ���ʾ�˲�������
    isFreqz = 1;
end

%% �˲������
Wp = f1/(fs/2);                                                     % ����fs/2��һ��,Nyquist frequency.
Ws = f3/(fs/2);

if para.type==1
    [n,Wp]=cheb1ord(Wp,Ws,Rp,Rs);                                   % Cheby1
    [b,a]=cheby1(n,Rp,Wp);
    
    if isFreqz
        freqz(b,a,2048,fs);                                             % �鿴����˲���������    
        title(sprintf('n = %d Cheby1 Lowpass Filter',n))
        xlim([0 f3])
    end    
else
    
    [n,Wn] = buttord(Wp,Ws,Rp,Rs,'s');                              % Butterworth
    [b,a] = butter(n,Wn,'s');                                       % �����˲���ϵͳ�������ӷ�ĸ����ʽ
    
    [z,p,k] = butter(n,Wn);
    sos = zp2sos(z,p,k);    
    freqz(sos,2048,fs)
    title(sprintf('n = %d Butterworth Lowpass Filter',n))
    xlim([0 f3])    
end

%% �˲�
y = filter(b,a,x);                                                  % ������x�˲���õ�������y

end  % lowp

function [dir_name] = getdir()
% ��Ŀ����ȡ�ļ�������
% �����
%       dir_name -- �ļ���·��
% ����: ���
% 2016.04.23 @HIT

    
data_dir = ['data_dir','_',getdir];                                             % ����·����������


try
    load(data_dir)
    dir_name = uigetdir(start_path);
catch
    dir_name = uigetdir;                                                        % ��ȡ�ļ��е�ַ
end

start_path = dir_name;

save(data_dir,'start_path');                                                    % �����ļ���·��

end % getdir

function [fullname,pathname,filename] = getfile(type,ext)
% ��Ŀ����ȡ�ļ�ȫ����·�����ļ���
% ���룺
%       type        -- ���ͱ�ʶ
% �����
%       fullname    -- ȫ��
%       pathname    -- ·��
%       filename    -- �ļ���
% ��ң�2016.04.23

if nargin == 0                                                      % ��������Ԥ����
    type = 'getfile';
    FilterSpec = '*.*';
elseif nargin == 1
    FilterSpec = '*.*';
elseif nargin == 2
    FilterSpec = ['*.',ext];
end

data_path = ['data_path','_',type];                                 % ����·����������

try
    load(data_path)                                                 % ����·����������
    [filename,pathname,~] = uigetfile(FilterSpec,'ѡ���ļ�',fullname);    %#ok<*NODEF>
catch
    [filename,pathname,~] = uigetfile(FilterSpec,'ѡ���ļ�');
end

fullname = [pathname,filename];                                     % ȫ��
save(data_path,'fullname');                                         % �����ļ�·��

end % getfile

function data = gettxt(nrow_start)
% ��Ŀ: ��ȡtxt�����ļ�����Ծ�ļ�ͷ˵����
% ����:
%       nrow_start  -- ��ʼ��
% �����
%       data        -- �ź�����
% ����: ���
% 2016.04.23 @HIT
% bug: dlmread��ȡtxt�ļ������ܳ��ִ���

fullname = tools.getfile('gettxt','txt');                                       % ��ȡ�����ļ���

if nargin < 1
    rowoff = 0;
    data = load(filename);
else                                                                            % �������е���������ܳ������ݴ���
    rowoff = nrow_start -1;
    data = dlmread(fullname,' ',rowoff,0);
end

end % gettxt

function [data,para0] = getcsv(flag)
% ��Ŀ: ʾ�������csv���ݱ�׼��ȡ
% ����:
%       flag   -- flag==1���򵯳��Ի��򣬷���Ĭ�ϱ�׼����
%       R0     -- ��ȡ�ź�������ʼ����
%       R1��C1 -- �ض���Ԫ���λ�ò���
% �����
%       data   -- �ź�����
%       para0  -- �ض���Ԫ�����
% ���ܣ�
%       ��R0�п�ʼ��ȡ�ź����ݣ�ֱ��ĩβ
%       ��ȡ(R1��C1)��Ԫ��Ĳ���
% ����: ���
% 2016.04.17 @HIT

% ��ȡ�����ļ���
 
if nargin < 1                                                       % �Ƿ��λ�ò����Ի���
    flag = 1;
end

fullname = tools.getfile('guw','csv');

% �Ի����л�
if flag
    prompt0 = {                                                     % �Ի����������
        '�ź�������ʼ����',17
        'Ŀ�����ڵ�Ԫλ��[R1 C1]',[7 2]
        };
    para = tools.paradlg(prompt0);                                  % ��Ԫ�����
    R0 = para{1}-1;
    R1 = para{2}(1)-1;
    C1 = para{2}(2)-1;
else
    R0 = 17-1;                                                      % Ĭ�ϲ���
    R1 = 7-1;
    C1 = 2-1;
end

% ���ݶ���          
data = csvread(fullname,R0,0);                                      % ��R0��ʼ����ȡ��������
para0 =  csvread(fullname,R1,C1,[R1 C1 R1 C1]);                     % �������ڶ�ȡ

end % getcsv

function data = getmat()
% ��Ŀ����ȡֻ��һ�������ľ�������mat�ļ�

filename = tools.getfile('mat');
temp1 = load(filename);                                                         % ���룬�ṹ��
temp2 = struct2cell(temp1);                                                     % ת��cell
data = temp2{1};                                                                % ת������
end % getmat

function xyt(str_xyt)
% ��Ŀ������xlabel,ylabel,title
xlabel(str_xyt{1});                                                             % label
ylabel(str_xyt{2});
title(str_xyt{3});
grid on                                                                         % ��ʾ����
set(gcf,'color','white');                                                       % ˢ��
shg;
end % xyt

function rg = range(data)
% ��Ŀ������һ������/�������ֵ��Χ

data = tools.row2mat(data);

[~,nCol] = size(data);
rg = zeros(2,nCol);
rg(1,:) = min(data);                                                            % �����Χ
rg(2,:) = max(data);

end % range

function mat = row2mat(row)
% ��Ŀ����������������������ɵľ���ת��Ϊ��������ʽ
% ʱ�䣺2017.01.11

if size(row,2)> size(row,1)                                                     % ������������
    mat = row';                                                                 % ������ת��
else
    mat = row;
end

end % row2mat

function html(mFile1,mFile2,htmlFile)
% ��Ŀ������ָ�����ļ�������html�ļ�

close all
copyfile(mFile1,mFile2)                                                         % ����mFile2��m�ļ�
publish(mFile2,'format','html', 'showCode',false);                              % ��ʽ�趨,����ʾ����

htmlFile0 = [mFile2(1:end-1),'html'];
if nargin == 3
    cd1 = cd;                                                                   % �����ʼ·��
    cd('.\html')                                                                % �л�·��
    movefile(htmlFile0,htmlFile)                                                % �ı�html�ļ���
    cd(cd1)                                                                     % ·���ָ�
    disp(['���������ɣ�',htmlFile])
else
    disp(['���������ɣ�',htmlFile0])
end
delete(mFile2);                                                                 % ɾ�������ļ�

end % html

function data = clean(data0,tol)
% ��Ŀ���ź�ȥ�������������������㣩
% ���ܣ�ȥ���������ֵһ�µ��źŹ���
% ���룺
%       data0 -- ԭʼ�����ź�
%       tol   -- ��ֵ

data = detrend(data0);                                                          % ȥ����
if nargin == 1
   tol = 1/100;                                                                 % Ĭ����ֵ
end

for iLoop = 1:size(data,2)
    tempCol = data(:,iLoop);                                                    % ����ȥ��
    data(:,iLoop) = tools.clean2(tempCol,tol);
end

end % cleanSignal

function dataCol = clean2(dataCol0,tol)
% ��Ŀ���ź�ȥ��������������������
% ���룺
%       data0 -- ԭʼ�����ź�
%       tol   -- ��ֵ

if nargin == 1
   tol = 1/100;                                                                 % Ĭ����ֵ
end

dataAbs = abs(dataCol0);
index = dataAbs>max(dataAbs)*tol;                                               % ������ֵ�ж�

temp = index'.*(1:length(index));
nMin = min(temp(temp>0));                                                       % ������ֵ�����
nMax = max(temp(temp>0));                                                       % ������ֵ���յ�

windows = ones(size(dataCol0));                                                 % �˲���
windows(1:nMin) = 0;
windows(nMax:end) = 0;

dataCol = dataCol0.*windows;                                                    % �Ӵ�����

end % cleanSignal2

function mycolor = colorOrder(index)
% ��Ŀ������MATLABĬ����ɫ����
% ���룺��ɫ���к�
% �������ɫ����
% ʾ����
%       t = linspace(0,2*pi,100);y = sin(t);
%       plot(t,y,'color',tools.colorOrder(1))

defaultColor = [                                                                % MATLABĬ��������ɫ
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

mycolor = defaultColor(index,:);                                                    % ��ɫ����

end % end of mycolor

function xline(position,lineSpec)
% ��Ŀ������MATLABĬ����ɫ����
% ���룺
%       position    -- [x y]��[1 0]��x=1���������ߣ�[0 1]��y=1�����ƺ���
%       lineSpec   -- 'r-*'
% ���������ֱ��
% ʾ����
%       xline([0 6],'r-')

if nargin < 2                                                                   % �Զ�����lineSpec
    lineSpec = 'k-.';
end

if position(1) == 0                                                             % ����
    y0 = position(2)*[1 1]';
    x0 = get(gca,'Xlim')';
else                                                                            % ����
    x0 = position(1)*[1 1]';
    y0 = get(gca,'Ylim')';
end
hold on
plot(x0,y0,lineSpec);                                                   % ����
end % end of xline

function xGrid(x0,angle)
% ��Ŀ��ͼ������x������
% �����
%       x0  -- ���������ߵ����꣬������������֧��
%       angle- �����ǩ�ı��Ƕȵ���
% ʱ�䣺2017.01.08

if nargin < 2
    angle = 0;                                                                  % ��ע��ת�Ƕ�
end

h = gca;
tick_old = h.XTick;
tick_new = sort([tick_old,x0]);
set(h,'xtick',tick_new)
set(h,'xTickLabelRotation',angle)
grid on

end % xGrid

function yGrid(y0,angle)
% ��Ŀ��ͼ������y������
% �����
%       y0  -- ���������ߵ����꣬������������֧��
%       angle- �����ǩ�ı��Ƕȵ���
% ʱ�䣺2017.01.08
% ʱ�䣺2017.01.08

if nargin < 2
    angle = 0;                                                                  % ��ע��ת�Ƕ�
end

h = gca;
tick_old = h.YTick;
tick_new = sort([tick_old,y0]);
set(h,'ytick',tick_new)
set(h,'yTickLabelRotation',angle)
grid on

end % yGrid

function saveGraph()
% ��Ŀ������gcfͼ��
% ���ܣ�
%       �Զ���ͼƬ��ʽ
%       �Զ���ͼƬ�ļ������
% ʱ�䣺2017.01.05

prompt0 = {                                                         % �Ի������
    '���',1
    'ǰ׺','E004a' 
    '��׺','wavelet'
    'ͼƬ��ʽ��png/jpg��', 'png'
};

dlg0.title = 'ͼ�񱣴�';
dlg0.save = 'saveGraph';
para0 = tools.paradlg(prompt0,dlg0);

filename = [para0{2},'-',num2str(para0{1}),'-',para0{3},'.',para0{4}];
% print(gcf,'-dpng','abc.png') 
saveas(gcf,filename);  

end % saveGraph

function plot0()
% ��Ŀ��������һ�ͼʾ��
% ʱ�䣺2017.01.08

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
% ��Ŀ����������źŵ�3db����
% ���룺
%       fs  -- ����Ƶ��
%       S   -- �ź�ʱ��
%       flag-- �Ƿ����ͼ��
% ʱ�䣺2017.01.10

if nargin < 3
    flag = 1;
end

Nz = length(S);                                                                 % ���ݳ���
fz= fs*(0:Nz-1)/Nz;                                                             % Ƶ�����
X = abs(fft(S));                                                                % fft�任

x1 = [0,fs/2];                                                                  % 3db����
y1 = [1 1]*max(X)/sqrt(2);

x2 = fz;                                                                        % �ź�
y2 = X;

[x0,y0,~,~] = intersections(x1,y1,x2,y2);                                       % �������
band3db = x0(2)-x0(1);                                                          % �������

if flag                                                                         % ͼ����Ƽ��
    figure
    plot(x1,y1,x2,y2,x0,y0,'ok');
    xlim([0 fs/2])
end                                           

end % get3band3db

function [S,fs] = toneburst()
% ��Ŀ: �������������źŵ�������Ƶ�׷���
% ����:
%       N  - cycle�����������źŲ�����
%       fc - �����ź�����Ƶ��
% ���ܣ�
%       ���ɼ����ź�����
%       ����ʱ��ͼ��Ƶ��ͼ
%       �ԱȲ�ͬcycle���źŵ�����
%       ���txt�ļ�
% ����: ���
% 2016.03.18 @HIT    

% -----------------------��������-----------------------

prompt0 = {                                                                     % �Ի������
    '�����źŷ�ֵ(Vpp)',1
    '�ź�����Ƶ�ʣ�kHz��',200
    '��������cylces��',1
    '�źų���ʱ�䣨\mu s��',100
    '�Ƿ�����ź������ļ�',0
};
dlg0.title = '�����ź�����-���';
dlg0.save = 'toneburst';
para = tools.paradlg(prompt0,dlg0); 

A = para{1};                                                                    % �����źŷ�ֵ
fck = para{2};                                                                  % ��������Ƶ�� kHz
N = para{3};                                                                    % cycle�����������źŲ�����
fc = fck*1e3;                                                                   % �����ź�����Ƶ�ʣ�Hz 
T = para{4}*1e-6;                                                               % ��������ʱ��s
dt = 1/(20*fc)/2;                                                               % ʱ�䲽��������󲽳������ϳ���2
t = [0:dt:T-dt]';                                                               % ʱ������
t_us = T*1e6; 

flag_output = para{5};                                                          % �Ƿ�����ź�����

% -----------------------�ź�ʱ����-----------------------

S = A/2*[heaviside(t)-heaviside(t-N/fc)].*...                                    % �ź�ʱ����         
    (1-cos(2*pi*fc*t/N)).*sin(2*pi*fc*t);
% #Change the range according to your settings
% range(0,50us)
% #Your equation goes here
% (1-Cos(2*pi*W/5))*Sin(2*pi*W)
% -----------------------Ƶ���ź�-----------------------

fs = 1/dt;                                                                      % ����Ƶ��
Nz = length(t);                                                                 % ���ݳ���
fz= fs*(0:Nz-1)/Nz;                                                             % Ƶ�����
X = fft(S);                                                                     % fft�任

[band,x0] = tools.getband3db(fs,S,0);                                           % �������
bwk = band/1e3;

% -----------------------��ͼ-----------------------

figure
subplot(211)
plot(t,S)
str_title = ['����Ƶ��',num2str(fck),'kHz'];
tools.xyt({'t(s)','Mangitude(N)',str_title})
xlim([0 T]),grid on

subplot(212)
plot(fz/1000,abs(X))
str_title = ['�źŴ���',num2str(bwk),'kHz'];
tools.xyt({'frequency(kHz)','Amplitude',str_title})
xlim([0 fs/2/1000]),grid on                                                     % �������fs/2
X_3db = max(abs(X))/sqrt(2);
tools.xline([0 X_3db],'m-')
tools.yGrid(X_3db)
tools.white;

% -----------------------�ź����-----------------------

str_time = [num2str(T/1e-6),'US'];                                              % �ź������ļ�������
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