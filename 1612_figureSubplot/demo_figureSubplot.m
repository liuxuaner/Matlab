% ��Ŀ�����fiure�ļ�����ͼ����ʽ�ػ浽һ��figure��
% ��������
% ���ܣ�
% 		��ȡ�����ͼ��figure�ļ�
% 		��subplot��ʽ���ػ浽һ��figureͼ����
% 		����Ӧ�ĵ���Ev����������
% ���ã���
% ���ߣ����
% 2016.12.20 @HIT

%% ��ͼ����

clc,clear,close all

fig(1) = open('fig1.fig');                                                      % ��fig�ļ�
fig(2) = open('fig2.fig');

ax(1) = get(fig(1), 'CurrentAxes');                                             % ��ȡ���������
ax(2) = get(fig(2), 'CurrentAxes');

%% �ػ�ͼ���µ�figure

str_title = {'780 kHz, 51 db','780 kHz, 279 db'};                               % Ԥ����ͼ��������

figure
for iloop = 1:2
    subplot(1,2,iloop)                                                          % ��ͼѭ��
    axChildren = get(ax(iloop),'Children');                                     % ��ȡaxes�����Ӷ���
    copyobj(axChildren, gca);                                                   % ���ƶ�����ͼ��axes
    
%     ylim([0 20]),grid on                                                        % ͼ���������
%     xlabel('normalized mode shape')
%     ylabel('radius [mm]')
%     title(str_title{iloop})
end

close(fig)                                                                      % �ر�ԭʼͼ��