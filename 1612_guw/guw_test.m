% ��Ŀ����׼�������źŴ������
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
% ���ߣ����
% ʱ�䣺2016.12.30

%% ����

clc,clear,close all
s = guw();
s.myfilter();                                                                   % �˲���
s.myHilbert();                                                                  % Hilbert�任
s.freqAnalysis();                                                               % ����Ҷ�任��Ƶ�׷���
s.timePlot();                                                                   % ʱ���ͼ
s.freqPlot();                                                                   % Ƶ���ͼ
s.mycwt();                                                                      % С������