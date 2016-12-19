function fun_plot0(X,Y,marker)
% 题目：去掉Y中的0，绘图
% 马骋 20161219 
% marker —— 即绘图的标注，如 '-*'等

nCol = size(X,2);                                                               % 向量的列数

hold on                                                                         % 连续绘图
for iloop = 1:nCol
    y_temp = Y(:,iloop);
    index = (y_temp==0);                                                        % 等于0的数据
    y_temp(index)= [];                                                          % 去除空数据
    x_temp = X(:,iloop);                                                        % 同样处理X                  
    x_temp(index) = [];
    plot(x_temp,y_temp,marker)
end

end

