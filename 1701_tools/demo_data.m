% 题目：tools工具箱-数据处理功能示例
% 马骋

%% paste

x = [1:10]';
str = tools.paste(x,'通道','原始信号');

%% range

x = 1:10;
x_range = tools.range(x);


%% row2mat

a = rand(2,4);
a2 = tools.row2mat(a);

%% norm

a = 2*rand(2,4)+rand(2,4)*i
a_norm= tools.norm(a)
a_norm_abs = abs(a_norm)
