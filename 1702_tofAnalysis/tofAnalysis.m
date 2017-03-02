% ��Ŀ��������ʱ�仯�ʷ���
% ��� 20170225

% ��ȡ�����ļ�
clc,clear,close all
% filename = tools.getfile();
filename = 'd10_1000_L.fig';
open(filename)
h=findobj(gca,'Type','Line');                                               % ��ȡ�������ݶ���
x = get(h,'xdata');                                                         % ��������cell����
y = get(h,'ydata');    

v_group = y{4};                                                                 % Ƶɢ����������ȡ
freq = x{4};

%% �����Ի���

prompt0 = {                                                         % �Ի������
    '�ֽ�ֱ�� mm', 10
    'Ƶ�ʷ�Χ kHz', [50 200]
    'Ƶ�ʼ�� kHz',5
    '��ֵ΢��delta',0.1
    '�ֽ�� m',1
};

dlg0.title = '��ʱ������������';
dlg0.save = 'tof';
para = tools.paradlg(prompt0,dlg0);

% ������ȡ
d0 = para{1};                                                                   % mm
fRange = para{2};                                                               % ����Ƶ�ʵķ�Χ
df = para{3};                                                                   % Ƶ�ʼ��
fk = fRange(1):df:fRange(2);                                                    % ����Ƶ������
tof_d = zeros(size(fk));                                                        % tof �仯������
delta = para{4};                                                                % ��ֵ΢��delta
L = para{5};                                                                    % �ֽ��

tof = L./v_group*1e6;                                                           % ��ʱ���� us

%% TOF�仯�ʼ���

for iloop = 1:length(fk)
    d = freq*10/fk(iloop);
    d_q = [d0-delta,d0,d0+delta];                                               % ΢�ֲ�ֵ��ֱ������
    tof_q = interp1(d,tof,d_q,'spline');                                         % ��ֵ����ʱ����
    tof_d(iloop) = (tof_q(3)-tof_q(1))/(2*delta);                               % ��ʱ�仯��
end

%% ��ͼ

figure
subplot(211)                                                                    % Ƶɢ����
hold on
for iloop = 1:length(x)
    plot(x{iloop},y{iloop})
end
tools.xyt({'Ƶ�� kHz','Ⱥ�ٶ� m/s','Ƶɢ����'})
xlim([0 max(fk)])

subplot(212)                                                                    % TOF�仯������
plot(fk,tof_d)
str_title = ['TOF�仯�����ԣ�d=',num2str(d0),'mm��'];
tools.xyt({'Ƶ�� kHz','TOF�仯�� us/s',str_title})

[~,index] = max(tof_d);
tools.xGrid(fk(index));

hold on
plot(fk(index),max(tof_d),'ro')

