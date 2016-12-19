% ��Ŀ�����ݲ������飬���������ٶ�����
% ���ܣ���wn�������߷��飬���ɶ�λ����������Ӧ��Ev����������
% ���ã�
%       tools       -- �źŻ�ͼ�����䣬��ͼ�Ż�
%       fun_sort    -- ���ݶ�λ����I��������A
%       fun_plot0   -- ��ͼ��ȥ��Y��Ϊ0�ĵ�
% ��ң�20161219

%% ���ݶ�ȡ

clc,clear,close all
filename = 'data_demo.mat';                                                     % ��ȡ��������
load(filename);                                                                 % ��������

%% ����Ԥ����

Ev = Energy_Velocity_m_s;                                                       % �����ٶ�
wn = Real_Wavenumber_1_m;                                                       % ����

n_mode = size(wn,1);                                                            % Ƶ�ʲ���
n_f = size(wn,2);                                                               % ģ̬��Ŀ

fk = Frequency_Hz'/1e3;                                                         % Ƶ������
fkn = repmat(fk,1,n_mode);                                                      % Ƶ�����ݾ���

figure
subplot(211)                                                                    % ԭʼ���ݻ�ͼ
plot(fkn,wn','-*')
tools.xyt({'Frequency kHz','wave number','����'})

subplot(212)
plot(fkn,Ev','-*')
tools.xyt({'Frequency kHz','Energy velocity m/s','�����ٶ�'})

%% ɢ�����

[~,I] = sort(wn);                                                               % ��ȡ��λ���� I
wn2 = fun_sort(wn,I)';                                                          % ������ wn��Ev
Ev2 = fun_sort(Ev,I)';

figure
subplot(211)                                                                    % ���������ݻ�ͼ
plot(fkn,wn2,'-*')
tools.xyt({'Frequency kHz','wave number','����'})

subplot(212)
plot(fkn,Ev2,'-*')
tools.xyt({'Frequency kHz','Energy velocity m/s','�����ٶ�'})

%% ȥ�������ݣ����»�ͼ

figure                                                                          % ȥ�������ݻ�ͼ
subplot(211)
fun_plot0(fkn,wn2,'-*')
tools.xyt({'Frequency kHz','wave number','����'})

subplot(212)
fun_plot0(fkn,Ev2,'-*')
tools.xyt({'Frequency kHz','Energy velocity m/s','�����ٶ�'})
