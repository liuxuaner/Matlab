% ��Ŀ����׼�������źŴ�������
% ���ܣ�
%       csv�źŶ�ȡ
%       ͨ����������
%       ��ͨ�˲�ȥ��
%       Hilbert�任
%       Ƶ�׷���
%       С������
% ����
%       tools        --  �źŴ������ͼͨ�ù�����
%       guw          --  �����źŴ���ר�ù�����
% ���ߣ�����
% ʱ�䣺2016.12.30

%% ����-1

clc,clear,close all
s = guw();
s.input(0);
s.myfilter(0);                                                                   % �˲���
s.timePlot();                                                                   % ʱ���ͼ�����ư���
% s.timePlot(1);                                                                  % ʱ���ͼ�����ư���
% s.timePlot(0);                                                                  % ʱ���ͼ�������ư���

s.freqPlot();                                                                   % Ƶ���ͼ����Ƶ�캯��
s.freqPlot(0);                                                                  % Ƶ���ͼ����Ƶ�캯��
s.freqPlot(1);                                                                  % Ƶ���ͼ������Ƶ�캯��

s.mycwt(0);                                                                     % С����������ʾ�Ի���
s.mycwt(1);                                                                     % С������������ʾ�Ի���
% tools.saveGraph;

%% ����-Overlay

% clc,clear,close all
% s = guw();
% s.overlay();

%% ����-��Ƶ�źŷ���

% clc,clear,close all
% s = guw();
% s.input(0);
% s.myfilter(0);                                                                   % �˲���
% s.freqAnalysis();                                                               % ����Ҷ�任��Ƶ�׷���
% s.mycwt(0);                                                                      % С������
% tools.saveGraph;

%% isShow����

% clc,clear,close all
% s = guw();
% s.input();