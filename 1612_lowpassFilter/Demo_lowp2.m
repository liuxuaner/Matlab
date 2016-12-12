% ��Ŀ: ��ͨ�˲�ʾ��
% ����: ��
% ���ܣ�
%       ��ͨȥ��
% ������
%       tools   -- �źŴ���������
% ����: ���
% 2016.04.21 @HIT

%% ���ݶ���

clc,clear,close all
[M,dt] = tools.getcsv();                                            % ����csv�źźͲ�������dt

fs = 1/dt;                                                          % ����Ƶ��
t = M(:,1);
s = detrend(M(:,3));                                                % ȥ���Ƶ��ź�

figure
plot(t,s)
legend('ԭʼ�ź�')
grid on 
xlim([min(t) max(t)])

%% ��������

prompt0 = {                                                         % �Ի������
    '��ͨƵ�� f-pass(kHz)', 300
    '����Ƶ�� f-stop(kHz)', 500
    'Passband ripple in decibels Rp',0.1
    '˥��ֵRs(Db)',30
};

dlg0.title = '�˲���������-���';
dlg0.save = 'lp';

para_input = tools.paradlg(prompt0,dlg0);

para.f1 = para_input{1}*1e3;
para.f3 = para_input{2}*1e3;
para.rp = para_input{3};
para.rs = para_input{4};
para.fs = fs;

%% cheby1��ͨ�˲�ͼʾ

para.type = 1;                                                      % �˲������ͣ��б�ѩ��-1
s_lp = tools.lowp(s,para);                                          % �˲�

%% �����źŻ�ͼ

figure
plot([t t],[s s_lp])
legend({'ԭʼ�ź�','��ͨ�˲��ź�'})
title('cheby1��ͨ�˲�Ч��ʾ��'),grid on
xlim([min(t) max(t)])

figure
subplot(211)
plot(t,s)
legend('ԭʼ�ź�'),grid on 
xlim([min(t) max(t)])

subplot(212)
plot(t,s_lp)
legend('�˲��ź�'),grid on 
xlim([min(t) max(t)])



