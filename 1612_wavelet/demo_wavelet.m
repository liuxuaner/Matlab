% ��Ŀ: ���������źŵ�С��ʱƵ�׷���
% ����: 
% 		���Ͳ������� q
% 		С������
% 		�߶����еĳ���totalscal
% 		Ƶ����ʾ��Χ kHz
% ���ܣ�
%       csv���ݵ���
%       cheby1��ͨ�˲�
%       �źŽ��Ͳ���
%       С���������ֱ�������
%       ʱƵͼ����
% ���ã�
%       tools   -- �źŴ���������
% ���ߣ���ң������
% 2016.12.12 @HIT


%% ���ݵ���

clc,clear
close all

[M,dt] = tools.getcsv();                                                        % ����csv�źźͲ�������dt
fs = 1/dt;                                                                      % ����Ƶ��

t   = M(:,1);                                                                   % ��һ�У�ʱ��
t   = t - t(1);                                                                 % ��ȥ��ʼֵ
inp = M(:,2);                                                                   % �ڶ��У������ź�
out = M(:,3);                                                                   % �����У�����ź�
inp = tools.clean(inp,0.015);                                                   % �ź�ȥ��ֵ
out = tools.clean(out);

figure                                                                          % ʱ���źŻ�ͼ
plot([t,t]*1e6,[inp,out]) 
tools.xyt({'t /\mu s','Voltage/V','ԭʼ���������ʱ��'})
legend({'ԭʼ�����ź�','ԭʼ�����ź�'})

%% �����Ի�������

prompt0 = {                                                         % �Ի������
    '��ͨ�˲�����ͨƵ�� kHz', 500
    '��ͨ�˲�������Ƶ�� kHz', 700
    '��ǰ����Ƶ�� fs0 kHz', fs/1e3
    '���Ͳ������� q', 10
    'С������','Morl'
    '�߶����еĳ���totalscal',2048
    'Ƶ����ʾ��Χ kHz',[0 600]
};

dlg0.title = 'ʱƵ������������';
dlg0.save = 's17';
para = tools.paradlg(prompt0,dlg0);

para_lp.f1 = para{1}*1e3;                                                       % ��ͨ�˲���������
para_lp.f3 = para{2}*1e3;
para_lp.rp = 0.1;
para_lp.rs = 30;
para_lp.fs = fs;
para_lp.type = 1;                                                               % �˲������ͣ��б�ѩ��-1

p = 1;
q = para{4};                                                                    % ���Ͳ����ı���
wavename = para{5};                                                             % С����������
totalscal = para{6};                                                            % �߶����еĳ��ȣ���scal�ĳ���
fzk_lim = para{7};                                                              % ʱƵͼ��ʾ��Ƶ�ʷ�Χ

%% cheby1��ͨ�˲�

out = tools.lowp(out,para_lp);                                                  % ����źŵ�ͨ�˲�
% inp = tools.lowp(inp,para_lp);                                                % �˲�

%% �ź��ز���

inp2 = resample(inp,p,q);                                                       % �����ź��ز���
out2 = resample(out,p,q);                                                       % �����ź��ز���
t2 = (0:length(out2)-1)*dt*q/p;                                                 % ʱ��������Ҫ�ֶ����㣬�����ز���
t2 = t2';
fs2 = fs/q;                                                                     % �ز���Ƶ��

figure                                                                          % ʱ���źŻ�ͼ
plot([t2,t2]*1e6,[inp2,out2]) 
tools.xyt({'t /\mu s','Voltage/V','�ز��������ź�������ź�ʱ��'})
legend({'�����ź�','�����ź�'})

%% С���任��������

wcf = centfrq(wavename);                                                        % С��������Ƶ��
cparam = 2*wcf*totalscal;                                                       % Ϊ�õ����ʵĳ߶�������Ĳ���
a = totalscal:-1:0.2; 
scal = cparam./a;                                                               % �õ������߶ȣ���ʹת���õ�Ƶ������Ϊ�Ȳ�����

tic
coefs=cwt(out2,scal,wavename);                                                  % �õ�С��ϵ��
f=scal2frq(scal,wavename,1/fs2);                                                % ���߶�ת��ΪƵ��
fk = f/1e3;                                                                     % Ƶ�ʣ�kHz
toc                                                                             % �����ʱ

%% ��ͼ����

figure
subplot(4,1,1)                                                                  % ʱ���źŻ�ͼ
plot([t2,t2]*1e6,[inp2,out2]) 
tools.xyt({'t /\mu s','Voltage/V','�����ź�������ź�ʱ��'})
legend({'�����ź�','�����ź�'})

subplot(4,1,[2 3 4])                                                            % ռ����ͼλ��
imagesc(t2*1e6,fk,abs(coefs));                                                  % ����ɫ��ͼ
colorbar('east');                                                               % ɫ�����������ڲ���ʾ���Ա����
tools.xyt({'ʱ�� t/s','Ƶ�� f/kHz','С��ʱƵͼ'})
ylim(fzk_lim)                                                                   % Ƶ����ʾ��Χ����
set(gca, 'YDir', 'normal')
tools.white;