function fun_plot0(X,Y,marker)
% ��Ŀ��ȥ��Y�е�0����ͼ
% ��� 20161219 
% marker ���� ����ͼ�ı�ע���� '-*'��

nCol = size(X,2);                                                               % ����������

hold on                                                                         % ������ͼ
for iloop = 1:nCol
    y_temp = Y(:,iloop);
    index = (y_temp==0);                                                        % ����0������
    y_temp(index)= [];                                                          % ȥ��������
    x_temp = X(:,iloop);                                                        % ͬ������X                  
    x_temp(index) = [];
    plot(x_temp,y_temp,marker)
end

end

