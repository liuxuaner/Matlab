% ��Ŀ��getdataϵ�в���
% ������
%       tools.
%             getdir  
%             getfile
%             getcsv 
%             gettxt 
% ��ң�20160423

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
