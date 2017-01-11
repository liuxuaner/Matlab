% 题目：tools工具箱绘图辅助功能示例
% 马骋

%% xyt

figure
tools.plot0;                                                                    % 绘制一个基本的sine

tools.xyt({'时间 s','位移 mm','A typical sine wave'})                           % 图像标注

% 等效于以下代码
% xlabel('时间 s')
% ylabel('位移 mm')
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

tools.xline([pi/2,0],'r--')                                                     % 竖向直线
tools.xline([0,sin(pi/4)],'m-.')                                                % 横向直线

%% xGrid，yGrid

figure
tools.plot0;   

tools.xGrid(pi/2,45)
tools.yGrid(sin(pi/4))

%% saveGragh

figure
tools.plot0;  
tools.saveGraph;                                                                % 图片保存对话框

%% colorOrder
t = linspace(0,2*pi,100);
figure,hold on
plot(t,sin(t),'color',tools.colorOrder(1))
plot(t,sin(2*t),'color',tools.colorOrder(2))
