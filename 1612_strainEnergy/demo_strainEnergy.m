% 题目: T002-导波模态的应变能分析
% 参数: 无
% 功能：
%       读取fig文件
%       提取位移曲线数据
%       求解应变、应变能
%       总能量积分、能量比例分析与绘图
% 调用：
%       tools   -- 信号处理辅助函数
% 作者：马骋
% 2016.12.21 @HIT

%% 弹性参数计算

clc,clear,close all
E = 208e9;                                                                      % 弹性模量-钢筋
nu = 0.29;                                                                      % 泊松比-钢筋

mu = E/(2*(1+nu));                                                              % shear modulus
lambda = nu*E/((1+nu)*(1-2*nu));                                                % Lame constant

E2 = 19.89e9;                                                                   % 弹性模量-混凝土
nu2 = 0.1923;                                                                   % 泊松比-混凝土

mu2 = E2/(2*(1+nu2));                                                           % shear modulus
lambda2 = nu2*E2/((1+nu2)*(1-2*nu2));                                           % Lame constant

r0 = 6;                                                                         % 钢筋直径

%% 读取位移坐标

fig = open(tools.getfile);                                                      % 打开fig文件

h=findobj(gca,'Type','Line');                                                   % 提取曲线数据对象
x = get(h,'xdata');                                                             % 坐标数据cell数据
y = get(h,'ydata');

ur = x{6};                                                                      % ur
uz = x{5};                                                                      % uz
rvect = y{5};                                                                   % 位移位置向量
rvect0 = rvect(1:end-1);                                                        % 应变位置向量

% 位移曲线确认
figure                                                                          % 模态验证
hold on 
plot(ur,rvect,uz,rvect);
legend({'ur','uz'})
tools.xline([0 6],'r-.')

%% 应变与应变能计算

eps_rr = diff(ur);                                                              % 位移微分求应变
eps_zz = diff(uz);

strainEnergy1 = 0.5*(lambda+2*mu).*(eps_rr.^2+eps_zz.^2)+lambda*(eps_rr.*eps_zz);   % 应变能-钢筋
strainEnergy2 = 0.5*(lambda2+2*mu2).*(eps_rr.^2+eps_zz.^2)+lambda2*(eps_rr.*eps_zz);% 应变能-混凝土

strainEnergy = strainEnergy1.*(rvect0<= r0) + strainEnergy2.*(rvect0 > r0);         % 分段函数叠加
strainEnergy = tools.norm(strainEnergy)';

%% 应变能占比分析

E_steel = trapz(rvect0,strainEnergy1);                                          % 钢筋应变能积分
E_concrete = trapz(rvect0,strainEnergy2);                                       % 混凝土应变能积分

E_total = E_steel+E_concrete;                                                   % 总能量
E_steel_percent = E_steel/E_total;
E_concrete_percent = E_concrete/E_total;

str1 = sprintf('钢筋%0.2f ',E_steel_percent);
str2 = sprintf('混凝土%0.2f',E_concrete_percent);

%% 应变能绘图

figure
subplot(121)                                                                    % 应变曲线,xy互换
area(rvect0,strainEnergy)                                                       % 绘制阴影面积图
tools.xyt({'radius [mm]','normalized strain energy','Strain Energy'})
ylim([0 1]),xlim([0 max(rvect)])
tools.xline([6 0],'r-.')
view(90,-90)                                                                    % 旋转视图
legend([str1,',',str2],'Location','north')

subplot(122)                                                                    % 应变能曲线
plot(ur,rvect,uz,rvect);
legend({'ur','uz'})
xlim([-1 1]),ylim([0 max(rvect)])
tools.xyt({'normalized displacement','radius [mm]','displacement'})
tools.xline([0 6],'r-.')                                                        % 绘制边界线
