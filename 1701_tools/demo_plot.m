% ��Ŀ��tools�������ͼ��������ʾ��
% ���

%% xyt

figure
tools.plot0;                                                                    % ����һ��������sine

tools.xyt({'ʱ�� s','λ�� mm','A typical sine wave'})                           % ͼ���ע

% ��Ч�����´���
% xlabel('ʱ�� s')
% ylabel('λ�� mm')
% title('A typical sine wave')
% grid on
% set(gcf,'color','white')

%% white

figure
tools.plot0;     

tools.white;

%% xline

figure
tools.plot0;   

tools.xline([pi/2,0],'r--')                                                     % ����ֱ��
tools.xline([0,sin(pi/4)],'m-.')                                                % ����ֱ��

%% xGrid��yGrid

figure
tools.plot0;   

tools.xGrid(pi/2,45)
tools.yGrid(sin(pi/4))

%% saveGragh

figure
tools.plot0;  
tools.saveGraph;                                                                % ͼƬ����Ի���
