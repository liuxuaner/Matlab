classdef tools < handle
% ��Ŀ���źŴ�����������
% ��̬����
%       version  --  �汾˵��
%       white    --  ͼ�񴰿�ˢ��
%       norm     --  ����������һ��
%       paradlg  --  ������׼�������Ի���
%       paste    --  ��ֵ�������ַ���ճ��
%       envelope --  ��ȡ�źŰ�����
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
% ���ߣ����
% 2016.04.23 @ HIT

properties
% Basic Parameter

end % properties

methods(Static) % ��̬����
        
function version()   
    % �汾�Զ�˵��
    str_version =  '�汾˵�����źŴ�����������\n���,2016.04.29 \n\n';
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
    };

    for iloop = 1:length(str_updatelog)
        fprintf([str_updatelog{iloop},'\n']);        
    end   
    
end     % version
    
function white()    
% ��Ŀ:ͼ��ˢ��
    set(gcf,'color','white');
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

function para = paradlg(prompt0,dlg0 )
% ��Ŀ:��׼���Ի��򴴽�����
% ����:
%       prompt0     -- ��ʾ���Լ�Ĭ�ϲ�����n*2
%       dlg0        -- ��ѡ���ƻ�����
%       	.width  -- �Ի�����
%           .title  -- ����
%           .save   -- data_dlg��׺��
% �����
%       para        -- �Ի����������
% ���ܣ�
%       ������׼����������Ի���
%       ֧�� �������������ַ���
%       �����������
%       �����ϴ�����
% ����: ���
% 2016.04.17 @HIT

% prompt����

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
para_dlg = inputdlg(prompt,dlg.title,linewidth,def,options);                    % �򿪶Ի��򣬻�ȡ�����ַ���

% ����ת��
% ����ת�����ַ���ת��

para = cell(n,1);                                                               % �������
for iloop = 1:n
    temp = ['[',para_dlg{iloop},']'];                                           % Ĭ�ϰ�����ת��
    para{iloop} = str2num(temp);
    
    if isempty(para{iloop})                                                     % ���ת����Ϊ�գ���Ϊ�ַ���
        para{iloop} = para_dlg{iloop};
    end
    
    if all(isspace(para_dlg{iloop}))	        								% ����ո�����
        para{iloop} = [];
    end
end

% ��������

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

function y=lowp(x,para)
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

%% �˲������
Wp = f1/(fs/2);                                                     % ����fs/2��һ��,Nyquist frequency.
Ws = f3/(fs/2);

if para.type==1
    [n,Wp]=cheb1ord(Wp,Ws,Rp,Rs);                                   % Cheby1
    [b,a]=cheby1(n,Rp,Wp);
    freqz(b,a,2048,fs);                                             % �鿴����˲���������    
    title(sprintf('n = %d Cheby1 Lowpass Filter',n))
    xlim([0 f3])
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

function [dir_name] = getdir(type)

if nargin == 0
    type = 'new';
end   
    
data_dir = ['data_dir','_',type];                                   % ����·����������
% ��Ŀ����ȡ�ļ�������
% ����:
%       type     -- �������ݱ�ʶ
% �����
%       dir_name -- �ļ���·��
% ����: ���
% 2016.04.23 @HIT

try
    load(data_dir)
    dir_name = uigetdir(start_path);
catch
    dir_name = uigetdir;                                            % ��ȡ�ļ��е�ַ
end

start_path = dir_name;

save(data_dir,'start_path');                                        % �����ļ���·��

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
    type = 'new';
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

if nargin == 0
    rowoff = 0;
else
    rowoff = nrow_start -1;
end

fullname = tools.getfile('signal','txt');
data = dlmread(fullname,' ',rowoff,0);

end % gettxt

function [data,para0] = getcsv(flag0)
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

flag = 0;                                                           % �Ƿ��λ�ò����Ի���
if nargin == 1
    flag = flag0;
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
temp1 = load(filename);                                             % ���룬�ṹ��
temp2 = struct2cell(temp1);                                         % ת��cell
data = temp2{1};                                                    % ת������
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
% ��Ŀ��������ת��Ϊ����

if isrow(row)
    mat = row';                                                               % ������ת��
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

end % static
end % classdef