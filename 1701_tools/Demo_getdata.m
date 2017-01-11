% 题目：getdata系列测试
% 函数：
%       tools.
%             getdir  
%             getfile
%             getcsv 
%             gettxt 
% 马骋，20160423

%% getdir
clc,clear
mydir1 = tools.getdir();
mydir2 = tools.getdir('guw');

%% getfile
clc,clear
[fullname,pathname,filename] = tools.getfile();
[fullname,pathname,filename] = tools.getfile('guw');
[fullname,pathname,filename] = tools.getfile('guw','csv');

%% getcsv
clc,clear
[M,dt] = tools.getcsv(); 
[M,dt] = tools.getcsv(1); 

%% gettxt

clc,clear
[data] = tools.gettxt();
[data] = tools.gettxt(25);
