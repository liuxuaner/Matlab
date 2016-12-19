function A2 = fun_sort( A,I )
% 题目：按照I的顺序，重新排列A
% 马骋 20161219

nCol = size(A,2);                                                               % 列数
A2 = zeros(size(A));                                                            % 重新排列矩阵

for iloop = 1:nCol
   tempCol = A(:,iloop);                                                        % 原来的列
   A2(:,iloop) = tempCol(I(:,iloop));                                           % 重排列
end

end
