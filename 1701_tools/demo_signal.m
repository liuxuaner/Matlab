% ��Ŀ��tools�������źŴ���ʾ��
% ʱ��2017.01.11

%% clean

M = tools.getcsv(0);                                                               % ��ȡcsv�ļ�
s = M(:,3);                                                                     % ��ȡ�����ź�
s2 = tools.clean(s);                                                            % �ź�ȥ����������

figure
plot(s),hold on
plot(s2)
legend({'ԭʼ�ź�','ȥ�����ź�'})
grid on

%% lowp

[M,dt] = tools.getcsv(0);                                                       % ��ȡcsv�ļ�
s = M(:,3);                                                                     % ��ȡ�����ź�

% �����Ի���
prompt0 = {
    '��ͨ�˲� fp-fs kHz', [500 700]
    '��ͨ�˲� Rp',0.1
    '�Ƿ���ʾ�˲���Ƶ��',1   
};

dlg0.save = 'myfilter';
para0 = tools.paradlg(prompt0,dlg0);                                            % �Ի������

para_lp.f1 = para0{1}(1)*1e3;                                                   % �˲��� fp
para_lp.f3 = para0{1}(2)*1e3;                                                   % �˲��� fs
para_lp.rp = para0{2};                                                          % �˲��� rp
para_lp.rs = 30;                                                                % �˲��� rs
para_lp.fs = 1/dt;                                                              % �źŲ���Ƶ��

para_lp.type = 1;                                                               % �˲������ͣ��б�ѩ��-1
flag = para0{3};                                                                % �Ƿ�����˲���Ƶ������

s_lp = tools.lowp(s,para_lp,flag);                                              % �����ź�-�˲�

figure                                                                          % �˲�ǰ��Ա�
plot(s),hold on
plot(s_lp)
legend({'ԭʼ�ź�','�˲����ź�'})
tools.white;

%% toneburst

[s,fs] = tools.toneburst;

%% getband3db

[s,fs] = tools.toneburst;
[band3db,x0] = tools.getband3db(fs,s);
band3db_fk = band3db/1000;

