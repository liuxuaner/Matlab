classdef guw < handle
% ��Ŀ�������źŷ�����������
% ��̬��
%       version    -- �汾˵��
% ���죺
%       guw        --  ���ɶ��󣬳�ʼ��
% ��̬��
%       myfilter   --  ��ͨ�˲���
%       myHilbert  --  Hilbert�任
%       freqAnalysis -- Ƶ���źŷ���
%       timePlot   --  ʱ���ͼ
%       freqPlot   --  Ƶ���ͼ
% ���ã�
%       tools.m    --  ������
% ���ߣ����
% 2016.12.30 @ HIT  

% ����������
%   ���ݴ洢

%% ����
properties

M                                                                               % ԭʼ���ݾ���
dt                                                                              % �������
fs                                                                              % ����Ƶ��
t0                                                                              % ʱ������-ԭʼ
t                                                                               % ʱ������
Nz                                                                              % ���е���

inp                                                                             % ���뼤��
inp0                                                                            % ���뼤��-ԭʼ
out                                                                             % ����ź�
out0                                                                            % ����ź�-ԭʼ

inp_h                                                                           % ���뼤��-Hilbert�任
out_h                                                                           % ����ź�-Hilbert�任

% �Ի����������
para                                                                            % �Ի�������Ĳ���
str_output                                                                      % ������
str_task                                                                        % ��������ļ���
fc                                                                              % �����ź�����Ƶ�� Hz
fck                                                                             % �����ź�����Ƶ�� kHz
N_ch                                                                            % ����ͨ������
fk_range                                                                        % Ƶ�׷�����Χ kHz

% Ƶ��ͼ����

fzk                                                                             % Ƶ����ᣬ��λ kHz
X                                                                               % Ƶ��-�����ź�
Y                                                                               % Ƶ��-����ź�
XNorm                                                                           % ��һ��Ƶ��-�����ź�
YNorm                                                                           % ��һ��Ƶ��-����ź�
FRF                                                                             % Ƶ�캯��
fzk_Ymax                                                                         % ��ֵƵ��

end % properties

%% ��̬����
methods(Static)
function s = version(s)
% ��Ŀ��������汾˵��
% ʱ�䣺2016.12.30

clc
strVersion =  '�汾˵���������źŷ�����������\n���,2016.12.30 \n\n';
fprintf(strVersion)

strUpdatelog = {
    '������־��'
    '2016.12.30,�źŴ��������ɣ�'
    '2016.12.31,��������ģ�鿪����myfilter��myHilbert��freqAnalysis��timePlotfreqPlot��'
    '2017.01.03,�Ի�����룬������С������mycwt��'
    };

for iloop = 1:length(strUpdatelog)
    fprintf([strUpdatelog{iloop},'\n']);
end	
end % version

end % Static
    
%% ��̬����
methods 

%%    ��ʼ��
function s = guw()
% ��Ŀ�����캯����ģ�ͳ�ʼ��

% s.input();                                                                      % ���ݶ�ȡ

% ------------------------------�źŴ���----------------------------------------
% s.myfilter();
% s.myHilbert();
% s.freqAnalysis();
% s.timePlot();
% s.freqPlot();

end     % guw     

function s = input(s,flag)
% ��Ŀ�����ݺͺ���������ģ��
% ������flag���Ƿ񵯳��Ի���
% ʾ��
%       s = s.input();    % �����Ի������ò���
%       s = s.input(0);   % �������Ի���ֱ�Ӹ����ϴ��趨

if nargin < 2
    flag = 1;                                                                   % Ĭ�ϵ����Ի���
end

prompt0 = {                                                                     % �Ի������
    '����ͨ������',2
    'Ƶ�׷�Χ��kHz��',1000
};
dlg0.title = '���ݶ�ȡ����-���';
dlg0.save = 'input';
s.para = tools.paradlg(prompt0,dlg0,flag); 
s.N_ch = s.para{1};                                                         % ����ͨ������
s.fk_range = s.para{2};                                                     % Ƶ�׷�����Χ

% ------------------------------���ݶ�ȡ----------------------------------------

[s.M,s.dt] = tools.getcsv();                                                    % ����csv�źźͲ�������dt
s.fs = 1/s.dt;                                                                  % ����Ƶ��

s.t0 = s.M(:,1);                                                                % ��1�У�ʱ��s.t = s.t0 - s.t0(1);                                                           % ��ȥ��ʼֵ
s.t = s.t0;                                                                     % ���ּ���0��

s.inp0 = s.M(:,2);                                                              % ���뼤��
[~,index_t0] = max(s.inp0);
s.t = s.t0 - s.t0(index_t0);                                                    % ��ȥ��ʼֵ

s.out0 = s.M(:,3:1+s.N_ch);                                                     % ����ź�

s.inp = tools.clean(s.inp0);                                                    % �ź�ȥ��ֵ
s.out0 = tools.clean(s.out0);                                                   % ������ã���������myfilter
for iloop = 1:s.N_ch-1
    s.out{iloop} = s.out0(:,iloop);                                             % ת��������
end

end

%% �źŴ���

function s = myfilter(s,flag)
% ��Ŀ���ź��˲�Ԥ����
% ʱ�䣺2016.12.31

if nargin < 2
    flag = 1;                                                                   % Ĭ�ϵ����Ի���
end

prompt0 = {
    '��ͨ�˲� fp-fs kHz', [500 700]
    '��ͨ�˲� Rp',0.1
    '�Ƿ���ʾ�˲���Ƶ��',1   
};

dlg0.save = 'myfilter';
para0 = tools.paradlg(prompt0,dlg0,flag);                                       % �Ի������

para_lp.f1 = para0{1}(1)*1e3;                                                   % �˲��� fp
para_lp.f3 = para0{1}(2)*1e3;                                                   % �˲��� fs
para_lp.rp = para0{2};                                                          % �˲��� rp
para_lp.rs = 30;                                                                % �˲��� rs
para_lp.fs = s.fs;

para_lp.type = 1;                                                               % �˲������ͣ��б�ѩ��-1
flag = para0{3};                                                                % �Ƿ�����˲���Ƶ������

s.inp = tools.lowp(s.inp,para_lp,flag);                                      % �����ź�-�˲�

for iloop = 1:s.N_ch-1
    out_temp = tools.lowp(s.out0(:,iloop),para_lp,flag);                     % ����ź�-�˲�
    s.out{iloop} = tools.row2mat(out_temp);                                     % ת��������
end

end % myfilter

function s = myHilbert(s)
% ��Ŀ�������źŵ�Hilbert�任
% ʱ�䣺2016.12.31

s.inp_h  = hilbert(s.inp);                                                      % hilbert�任

for iloop = 1:s.N_ch-1
    s.out_h{iloop} = hilbert(s.out{iloop});                                     % ����ź�-hilbert�任
end

end % myHilbert

function s = freqAnalysis(s)
% ��Ŀ��Ƶ�����
% ���ܣ�����Ҷ�任��Ƶ�캯������
% ʱ�䣺2016.12.31

s.Nz = length(s.t);                                                             % ���ݳ���
fz= s.fs*(0:s.Nz-1)/s.Nz;                                                       % Ƶ�����
s.fzk = fz/1000;                                                                % Ƶ����ᣬ��λ kHz

s.X = fft(s.inp);                                                               % �����ź�Ƶ��
s.Y = cell(3,1);                                                                % ��ʼ������ź�Ƶ��

for iloop = 1:s.N_ch-1
    s.Y{iloop} = fft(s.out{iloop});                                             % ����ź�Ƶ��
end

% ��ȡһ����Χ��Ƶ��
index = s.fzk < s.fk_range;                                                     % Ƶ�׷�Χ����
s.fzk = s.fzk(index);
s.X = s.X(index);                                                               % ��ʾ��Ƶ��
for iloop = 1:s.N_ch-1
    s.Y{iloop} = s.Y{iloop}(index);                                             % ����ź�Ƶ��
end

s.fzk_Ymax = cell(s.N_ch-1,1);                                                 % ��ֵƵ�ʼ�¼
s.XNorm = tools.norm(s.X);                                                      % ��һ��Ƶ��
for iloop = 1:s.N_ch-1
    s.YNorm{iloop} = tools.norm(s.Y{iloop});                                    % ����ź�Ƶ��
    [~,index_temp] = max(s.YNorm{iloop});
    s.fzk_Ymax{iloop} = s.fzk(index_temp);                                      % ��ֵƵ�ʼ�¼
end

index_FRF = abs(s.XNorm) < max(abs(s.XNorm))*0.05;                              % ɾ������Ƶ�׼�С����FRF�����⼫��ֵ����
for iloop = 1:s.N_ch-1
    s.FRF{iloop} = s.Y{iloop}./s.X;                                             % Ƶ�캯��
    s.FRF{iloop}(index_FRF) = 0;
    s.FRF{iloop} = tools.norm(s.FRF{iloop});                                    % Ƶ�캯���Ĺ�һ��
end 

end % freqAnalysis

%% ��ͼ��ʾ

function s = overlay(s)
% ��Ŀ��ʱ������źŵĵ���

prompt0 = {
    '�����ź�����',2
    '����ͨ��',1
};

dlg0.save = 'overlay';
para0 = tools.paradlg(prompt0,dlg0);                                            % �Ի������

n = para0{1};
out_overlay = cell(n,1);
for iloop = 1:n
    [M_temp,~] = tools.getcsv();                                                % ����csv�źźͲ�������dt
    out_overlay{iloop} = M_temp(:,3);                                           % �������
end

figure,hold on
for iloop = 1:n
    plot(out_overlay{iloop});
end

str_legend = tools.paste([1:n],'test-');                                        % legend ��ע
legend(str_legend)
tools.white;

end

function s = timePlot(s,flag)
% ��Ŀ��ʱ���źŻ�ͼ
% ���ܣ�
%       ʱ��ͼ��
%       ����ͼ
% ʱ�䣺2016.12.31

if nargin < 2                                                                   
   flag = 1;                                                                    % Ĭ�ϻ��ư���ͼ
   s.myHilbert();
end

figure
subplot(s.N_ch+1,1,1)                                                           % ����ͼ
t_us = s.t*1e6;                                                                 % ʱ��-us
plot(repmat(t_us,1,s.N_ch),[s.inp,s.out{1:end}]) 
tools.xyt({'t /\mu s','Voltage/V','�����ź�������ź�ʱ��'})

subplot(s.N_ch+1,1,2)  
plot(t_us,s.inp) 
tools.xyt({'t /\mu s','Voltage/V','�����ź�ʱ��'})
legend({'�����ź�'})

if flag
    for iloop = 3:s.N_ch+1                                                      % �����ź�ʱ�̻���
        subplot(s.N_ch+1,1,iloop)   
        plot(t_us,s.out{iloop-2}),hold on
        plot(t_us,abs(s.out_h{iloop-2}))                                        % �������
        legend({'�����ź�','����'})                                                 
        tools.xyt({'t /\mu s','Voltage/V','�����ź�ʱ��ͼ'})
    end
else
     for iloop = 3:s.N_ch+1                                                     % �����ź�ʱ�̻���
        subplot(s.N_ch+1,1,iloop)   
        plot(t_us,s.out{iloop-2})
        legend({'�����ź�'})                                                 
        tools.xyt({'t /\mu s','Voltage/V','�����ź�ʱ��ͼ'})
    end   
end

s.dispAmpl();

end % timePlot

function s = dispAmpl(s)
    Ampl = max(abs(s.out{1}));                                                  % ��ֵ˵��
    disp('�����źŷ�ֵΪ��')
    disp(Ampl)
end
    
function s = freqPlot(s,flag)
% ��Ŀ��Ƶ��ͼ����
% ������ flag == 1,����Ƶ�캯��ͼ
% 2016.12.31

s.freqAnalysis();                                                               % ����Ҷ�任��Ƶ�׷���
if nargin < 2                                                                   % Ĭ�ϲ�����Ƶ�캯��
    flag =0;
end

% -------------Ƶ��ͼ-------------
figure
subplot(s.N_ch+1,1,1)
t_us = s.t*1e6;                                                                 % ʱ�̻���
plot(repmat(t_us,1,s.N_ch),[s.inp,s.out{1:end}]) 
tools.xyt({'t /\mu s','Voltage/V','�����ź�������ź�ʱ��'})

subplot(s.N_ch+1,1,2)                                                           % �����ź�Ƶ��
plot(s.fzk,abs(s.XNorm))
xlim([0 s.fk_range])
tools.xyt({'Freq/kHz','Magnitude','�����ź�Ƶ��'})

for iloop = 3:s.N_ch+1                                                          % �����ź�ʱ�̻���
    subplot(s.N_ch+1,1,iloop)   
    plot(s.fzk,abs(s.YNorm{iloop-2}))
    xlim([0 s.fk_range])
    tools.xyt({'Freq/kHz','Magnitude','�����ź�Ƶ��'})
%     tools.xline([0 s.fzk_Ymax{iloop-2}],'m-');                                    % ��ʾ��ֵ
    tools.xGrid(s.fzk_Ymax{iloop-2},45);
end

% -------------Ƶ�캯��ͼ-------------
if flag
    figure
    for iloop = 1:s.N_ch-1
        subplot(s.N_ch-1,1,1)                                                       % �����ź�Ƶ��
        plot(s.fzk,abs(s.FRF{iloop}))
        xlim([0 s.fk_range])
        str_legend = ['Ƶ�캯��','-���ͨ��',num2str(iloop)];
        tools.xyt({'Freq/kHz','Magnitude',str_legend})
        tools.xGrid(s.fzk_Ymax{iloop});
    end
end

end % freqPlot


function s = mycwt(s,flag)
% ��Ŀ��С���任ʱƵͼ����
% ������flag �Ƿ񵯳��Ի���

if nargin < 2
    flag = 1;                                                                   % Ĭ�ϵ����Ի���
end

% -------------�����Ի�������-------------
prompt0 = {                                                         % �Ի������
    '��ǰ����Ƶ�� fs0 kHz', s.fs/1e3
    '���Ͳ������� q', 10
    'С������','Morl'
    '�߶����еĳ���totalscal',2048
    'Ƶ����ʾ��Χ kHz',[0 600]
    '�Ƿ����Ƶɢ����',0
};

dlg0.title = 'ʱƵ������������';
dlg0.save = 'mycwt';
para0 = tools.paradlg(prompt0,dlg0,flag);

% -------------������ȡ-------------
p = 1;
q = para0{2};                                                                   % ���Ͳ����ı���
wavename = para0{3};                                                            % С����������
totalscal = para0{4};                                                           % �߶����еĳ��ȣ���scal�ĳ���
fzk_lim = para0{5};                                                             % ʱƵͼ��ʾ��Ƶ�ʷ�Χ
flag_pcdisp = para0{6};                                                         % �Ƿ����Ƶɢ����

% -------------�ź��ز���-------------
inp_res = resample(s.inp,p,q);                                                  % �����ź��ز���
out_res = cell(s.N_ch-1,1);
for iloop = s.N_ch - 1
    out_res{iloop} = resample(s.out{iloop},p,q);                                % �����ź��ز���
end

t_res = (0:length(inp_res)-1)*s.dt*q/p;                                         % ʱ��������Ҫ�ֶ����㣬�����ز���
t_res = t_res + s.t(1);                                                         % ʱ��0��
t_res =tools.row2mat(t_res);
t_res_us = t_res*1e6;                                                           % �ز���ʱ��
t_us_lim = tools.range(t_res_us);                                               % ʱ��������
fs_res = s.fs/q;                                                                % �ز���Ƶ��

% -------------С���任��������-------------

wcf = centfrq(wavename);                                                        % С��������Ƶ��
cparam = 2*wcf*totalscal;                                                       % Ϊ�õ����ʵĳ߶�������Ĳ���
a = totalscal:-1:0.2; 
scal = cparam./a;                                                               % �õ������߶ȣ���ʹת���õ�Ƶ������Ϊ�Ȳ�����

coefs = cell(s.N_ch-1,1);
index_coef_max = cell(s.N_ch-1,1);
coef_max = cell(s.N_ch-1,1);

tic
for iloop = 1:s.N_ch-1
    coefs{iloop}=cwt(out_res{iloop},scal,wavename);                             % �õ�С��ϵ��
    f=scal2frq(scal,wavename,1/fs_res);                                         % ���߶�ת��ΪƵ��
    fk = f/1e3;                                                                 % Ƶ�ʣ�kHz

    [coef_max{iloop},index_coef_max{iloop}] = max(max(abs(coefs{iloop})));      % С��ϵ�����ĵ�    

end
toc                                                                             % �����ʱ

% -------------С���任��ͼ-------------

for iloop = 1:s.N_ch-1
    figure
    subplot(5,4,[2:4])                                                          % ʱ���źŻ�ͼ
    plot(t_res_us*[1 1],[inp_res,out_res{iloop}]) 
    tools.xyt({'t /\mu s','Voltage/V',''})                                      % --�����ź�������ź�ʱ��
    legend({'�����ź�','�����ź�'})
    xlim(t_us_lim)

    subplot(5,4,[6:8])                                                          % ʱ���źŻ�ͼ
    plot(t_res_us,out_res{iloop}) 
    tools.xyt({'t /\mu s','Voltage/V',''})                                      % --�����ź�ʱ��
    legend({'�����ź�'})   
    xlim(t_us_lim)    
    
    subplot(5,4,[9 13 17])                                                      % ����ҶƵ��
    plot(abs(s.YNorm{iloop}),s.fzk)
    ylim(fzk_lim)
    tools.xyt({'Magnitude','Freq/kHz',''})                                      % -- �����ź�Ƶ��
    set(gca,'xdir','reverse')
    
    subplot(5,4,[10:12,14:16,18:20])                                            % ռ����ͼλ��
    imagesc(t_res_us,fk,abs(coefs{iloop}));                                    % ����ɫ��ͼ
    colorbar('east');                                                           % ɫ�����������ڲ���ʾ���Ա����
    tools.xyt({'ʱ�� t/\mu s','Ƶ�� f/kHz',''})                                 % --С��ʱƵͼ
    xlim(t_us_lim)
    ylim(fzk_lim)                                                               % Ƶ����ʾ��Χ����
    set(gca, 'YDir', 'normal')
    tools.white;
    
    hold on 
    tools.xline([t_res_us(index_coef_max{iloop}),0],'m-');                      % ��ֵ��������ֱ��
    tools.xline([0 s.fzk_Ymax{iloop}],'m-');        
    
    tools.xGrid(t_res_us(index_coef_max{iloop}),45);                            % ��ֵ��������ֱ��
    tools.yGrid(s.fzk_Ymax{iloop});                                             % ͬ��
end

% Ƶɢ���ߵ���
if flag_pcdisp
    load('D10_F1000_L.mat')                                                     % �ݲ�Ƶɢ��������
    hold on
    for iloop = 1:length(x)
        ytemp = 1./y{iloop};                                                    % ��ʱ����
        plot(ytemp*1e6,x{iloop},'-','color','w')
    end
    % set(gca, 'YDir', 'reverse')                                               % ��תy��    
end

s.dispAmpl();                                                                   % ��ֵ��ʾ

end
end % method

end % classdef