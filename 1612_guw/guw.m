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

prompt0 = {                                                                     % �Ի������
    '������(��T001)', 1
    '��������ļ���Ĭ��Ϊ��������',''
    '����ͨ������',2
    '�����ź�����Ƶ�ʣ�kHz��', 200
    'Ƶ�׷�Χ��kHz��',1000
};

dlg0.title = '�����źŴ�������-���';
dlg0.save = 'guwtool';
s.para = tools.paradlg(prompt0,dlg0);                                           % �Ի������

s.str_task = s.para{1};                                                         % ��������
s.str_output = s.para{2};                                                       % ��������ļ���
s.N_ch = s.para{3};                                                             % ����ͨ������
s.fck = s.para{4};                                                              % ��������Ƶ�� kHz
s.fc = s.fck*1e3;                                                               % ��������Ƶ�� Hz
s.fk_range = s.para{5};                                                         % Ƶ�׷�����Χ

% ------------------------------���ݶ�ȡ----------------------------------------

[s.M,s.dt] = tools.getcsv();                                                    % ����csv�źźͲ�������dt
s.fs = 1/s.dt;                                                                  % ����Ƶ��

s.t0 = s.M(:,1);                                                                % ��1�У�ʱ��
s.t = s.t0 - s.t0(1);                                                           % ��ȥ��ʼֵ
s.inp = s.M(:,2);                                                               % ���뼤��
s.out0 = s.M(:,3:1+s.N_ch);                                                     % �������

% ------------------------------�źŴ���----------------------------------------
% s.myfilter();
% s.myHilbert();
% s.freqAnalysis();
% s.timePlot();
% s.freqPlot();

end     % guw     

%% �źŴ���

function s = myfilter(s)
% ��Ŀ���ź��˲�Ԥ����
% ʱ�䣺2016.12.31

prompt0 = {
    '��ͨ�˲� fp-fs kHz', [500 700]
    '��ͨ�˲� Rp',0.1
    '�Ƿ���ʾ�˲���Ƶ��',1   
};

dlg0.save = 'myfilter';
para0 = tools.paradlg(prompt0,dlg0);                                            % �Ի������


s.inp = tools.clean(s.inp,0.015);                                               % �ź�ȥ��ֵ
s.out0 = tools.clean(s.out0);

para_lp.f1 = para0{1}(1)*1e3;                                                   % �˲��� fp
para_lp.f3 = para0{1}(2)*1e3;                                                   % �˲��� fs
para_lp.rp = para0{2};                                                          % �˲��� rp
para_lp.rs = 30;                                                                % �˲��� rs
para_lp.fs = s.fs;

para_lp.type = 1;                                                               % �˲������ͣ��б�ѩ��-1
isFreqz = para0{3};                                                             % �Ƿ�����˲���Ƶ������

s.inp = tools.lowp(s.inp,para_lp,isFreqz);                                      % �����ź�-�˲�

for iloop = 1:s.N_ch-1
    out_temp = tools.lowp(s.out0(:,iloop),para_lp,isFreqz);                     % ����ź�-�˲�
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

s.XNorm = tools.norm(s.X);                                                      % ��һ��Ƶ��
for iloop = 1:s.N_ch-1
    s.YNorm{iloop} = tools.norm(s.Y{iloop});                                    % ����ź�Ƶ��
end

index_FRF = abs(s.XNorm) < max(abs(s.XNorm))*0.05;                              % ɾ������Ƶ�׼�С����FRF�����⼫��ֵ����
for iloop = 1:s.N_ch-1
    s.FRF{iloop} = s.Y{iloop}./s.X;                                             % Ƶ�캯��
    s.FRF{iloop}(index_FRF) = 0;
    s.FRF{iloop} = tools.norm(s.FRF{iloop});                                    % Ƶ�캯���Ĺ�һ��
end 

end % freqAnalysis

%% ��ͼ��ʾ

function s = timePlot(s)
% ��Ŀ��ʱ���źŻ�ͼ
% ���ܣ�
%       ʱ��ͼ��
%       ����ͼ
% ʱ�䣺2016.12.31

figure
subplot(s.N_ch+1,1,1)                                                           % ����ͼ
t_us = s.t*1e6;                                                                 % ʱ��-us
plot(repmat(t_us,1,s.N_ch),[s.inp,s.out{1:end}]) 
tools.xyt({'t /\mu s','Voltage/V','�����ź�������ź�ʱ��'})

subplot(s.N_ch+1,1,2)  
plot(t_us,s.inp) 
tools.xyt({'t /\mu s','Voltage/V','�����ź�ʱ��'})
legend({'�����ź�'})

for iloop = 3:s.N_ch+1                                                          % �����ź�ʱ�̻���
    subplot(s.N_ch+1,1,iloop)   
    plot(t_us,s.out{iloop-2}),hold on
    plot(t_us,abs(s.out_h{iloop-2}))                                            % �������
    legend({'�����ź�','����'})                                                 
	tools.xyt({'t /\mu s','Voltage/V','�����ź�ʱ��ͼ'})
end

Ampl = max(abs(s.out{1}));                                                      % ��ֵ˵��
disp('�����źŷ�ֵΪ��')
disp(Ampl)

end % timePlot

function s = freqPlot(s)
% ��Ŀ��Ƶ��ͼ����
% 2016.12.31

% -------------Ƶ��ͼ-------------
figure
subplot(s.N_ch,1,1)                                                             % �����ź�Ƶ��
plot(s.fzk,abs(s.XNorm))
xlim([0 s.fk_range])
tools.xyt({'Freq/kHz','Magnitude','�����ź�Ƶ��'})

for iloop = 2:s.N_ch                                                            % �����ź�ʱ�̻���
    subplot(s.N_ch,1,iloop)   
    plot(s.fzk,abs(s.YNorm{iloop-1}))
    xlim([0 s.fk_range])
    tools.xyt({'Freq/kHz','Magnitude','�����ź�Ƶ��'})
end

% -------------Ƶ�캯��ͼ-------------
figure
for iloop = 1:s.N_ch-1
    subplot(s.N_ch-1,1,1)                                                       % �����ź�Ƶ��
    plot(s.fzk,abs(s.FRF{iloop}))
    xlim([0 s.fk_range])
    str_legend = ['Ƶ�캯��','-���ͨ��',num2str(iloop)];
    tools.xyt({'Freq/kHz','Magnitude',str_legend})
end

end % freqPlot


function s = mycwt(s)
% ��Ŀ��С���任ʱƵͼ����

% -------------�����Ի�������-------------
prompt0 = {                                                         % �Ի������
    '��ǰ����Ƶ�� fs0 kHz', s.fs/1e3
    '���Ͳ������� q', 10
    'С������','Morl'
    '�߶����еĳ���totalscal',2048
    'Ƶ����ʾ��Χ kHz',[0 600]
};

dlg0.title = 'ʱƵ������������';
dlg0.save = 'mycwt';
para0 = tools.paradlg(prompt0,dlg0);

% -------------������ȡ-------------
p = 1;
q = para0{2};                                                                   % ���Ͳ����ı���
wavename = para0{3};                                                            % С����������
totalscal = para0{4};                                                           % �߶����еĳ��ȣ���scal�ĳ���
fzk_lim = para0{5};                                                             % ʱƵͼ��ʾ��Ƶ�ʷ�Χ

% -------------�ź��ز���-------------
inp_res = resample(s.inp,p,q);                                                  % �����ź��ز���
out_res = cell(s.N_ch-1,1);
for iloop = s.N_ch - 1
    out_res{iloop} = resample(s.out{iloop},p,q);                                % �����ź��ز���
end
t_res = (0:length(inp_res)-1)*s.dt*q/p;                                              % ʱ��������Ҫ�ֶ����㣬�����ز���
t_res =tools.row2mat(t_res);
fs_res = s.fs/q;                                                                % �ز���Ƶ��

% -------------С���任��������-------------

wcf = centfrq(wavename);                                                        % С��������Ƶ��
cparam = 2*wcf*totalscal;                                                       % Ϊ�õ����ʵĳ߶�������Ĳ���
a = totalscal:-1:0.2; 
scal = cparam./a;                                                               % �õ������߶ȣ���ʹת���õ�Ƶ������Ϊ�Ȳ�����

coefs = cell(s.N_ch-1,1);
tic
for iloop = 1:s.N_ch-1
    coefs{iloop}=cwt(out_res{iloop},scal,wavename);                             % �õ�С��ϵ��
    f=scal2frq(scal,wavename,1/fs_res);                                         % ���߶�ת��ΪƵ��
    fk = f/1e3;                                                                 % Ƶ�ʣ�kHz
end
toc                                                                             % �����ʱ

% -------------С���任��ͼ-------------

for iloop = 1:s.N_ch-1
    figure
    subplot(5,1,1)                                                              % ʱ���źŻ�ͼ
    plot(t_res*[1 1]*1e6,[inp_res,out_res{iloop}]) 
    tools.xyt({'t /\mu s','Voltage/V','�����ź�������ź�ʱ��'})
    legend({'�����ź�','�����ź�'})

    subplot(5,1,2)                                                              % ʱ���źŻ�ͼ
    plot(t_res*1e6,out_res{iloop}) 
    tools.xyt({'t /\mu s','Voltage/V','�����ź�ʱ��'})
    legend({'�����ź�'})    
    
    subplot(5,1,[3 4 5])                                                        % ռ����ͼλ��
    imagesc(t_res*1e6,fk,abs(coefs{iloop}));                                    % ����ɫ��ͼ
    colorbar('east');                                                           % ɫ�����������ڲ���ʾ���Ա����
    tools.xyt({'ʱ�� t/\mu s','Ƶ�� f/kHz','С��ʱƵͼ'})
    ylim(fzk_lim)                                                               % Ƶ����ʾ��Χ����
    set(gca, 'YDir', 'normal')
    tools.white;
end

end
end % method

end % classdef