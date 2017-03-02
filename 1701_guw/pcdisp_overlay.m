% 题目：频散曲线的叠绘pcdisp与GUIGUW
% 2017.02.21

clc,clear,close all 

for iloop =1:2                                                                  % 提取数据
    filename = tools.getfile();
    open(filename)
    h=findobj(gca,'Type','Line');                                               % 提取曲线数据对象
    x{iloop} = get(h,'xdata');                                                  % 坐标数据cell数据
    y{iloop} = get(h,'ydata');     
end

close all 

figure                                                                          % 绘图
hold on 
for iloop = 1:2
    for jloop = 1:length(x{iloop})
        plot(x{iloop}{jloop},y{iloop}{jloop})    
    end
end 
xlim([0 500])
tools.white;
