% ��Ŀ��Ƶɢ���ߵĵ���pcdisp��GUIGUW
% 2017.02.21

clc,clear,close all 

for iloop =1:2                                                                  % ��ȡ����
    filename = tools.getfile();
    open(filename)
    h=findobj(gca,'Type','Line');                                               % ��ȡ�������ݶ���
    x{iloop} = get(h,'xdata');                                                  % ��������cell����
    y{iloop} = get(h,'ydata');     
end

close all 

figure                                                                          % ��ͼ
hold on 
for iloop = 1:2
    for jloop = 1:length(x{iloop})
        plot(x{iloop}{jloop},y{iloop}{jloop})    
    end
end 
xlim([0 500])
tools.white;
