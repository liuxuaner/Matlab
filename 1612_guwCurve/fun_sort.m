function A2 = fun_sort( A,I )
% ��Ŀ������I��˳����������A
% ��� 20161219

nCol = size(A,2);                                                               % ����
A2 = zeros(size(A));                                                            % �������о���

for iloop = 1:nCol
   tempCol = A(:,iloop);                                                        % ԭ������
   A2(:,iloop) = tempCol(I(:,iloop));                                           % ������
end

end
