% ��Ŀ: T002-����ģ̬��Ӧ���ܷ���
% ����: ��
% ���ܣ�
%       ��ȡfig�ļ�
%       ��ȡλ����������
%       ���Ӧ�䡢Ӧ����
%       ���������֡����������������ͼ
% ���ã�
%       tools   -- �źŴ���������
% ���ߣ����
% 2016.12.21 @HIT

%% ���Բ�������

clc,clear,close all
E = 208e9;                                                                      % ����ģ��-�ֽ�
nu = 0.29;                                                                      % ���ɱ�-�ֽ�

mu = E/(2*(1+nu));                                                              % shear modulus
lambda = nu*E/((1+nu)*(1-2*nu));                                                % Lame constant

E2 = 19.89e9;                                                                   % ����ģ��-������
nu2 = 0.1923;                                                                   % ���ɱ�-������

mu2 = E2/(2*(1+nu2));                                                           % shear modulus
lambda2 = nu2*E2/((1+nu2)*(1-2*nu2));                                           % Lame constant

r0 = 6;                                                                         % �ֽ�ֱ��

%% ��ȡλ������

fig = open(tools.getfile);                                                      % ��fig�ļ�

h=findobj(gca,'Type','Line');                                                   % ��ȡ�������ݶ���
x = get(h,'xdata');                                                             % ��������cell����
y = get(h,'ydata');

ur = x{6};                                                                      % ur
uz = x{5};                                                                      % uz
rvect = y{5};                                                                   % λ��λ������
rvect0 = rvect(1:end-1);                                                        % Ӧ��λ������

% λ������ȷ��
figure                                                                          % ģ̬��֤
hold on 
plot(ur,rvect,uz,rvect);
legend({'ur','uz'})
tools.xline([0 6],'r-.')

%% Ӧ����Ӧ���ܼ���

eps_rr = diff(ur);                                                              % λ��΢����Ӧ��
eps_zz = diff(uz);

strainEnergy1 = 0.5*(lambda+2*mu).*(eps_rr.^2+eps_zz.^2)+lambda*(eps_rr.*eps_zz);   % Ӧ����-�ֽ�
strainEnergy2 = 0.5*(lambda2+2*mu2).*(eps_rr.^2+eps_zz.^2)+lambda2*(eps_rr.*eps_zz);% Ӧ����-������

strainEnergy = strainEnergy1.*(rvect0<= r0) + strainEnergy2.*(rvect0 > r0);         % �ֶκ�������
strainEnergy = tools.norm(strainEnergy)';

%% Ӧ����ռ�ȷ���

E_steel = trapz(rvect0,strainEnergy1);                                          % �ֽ�Ӧ���ܻ���
E_concrete = trapz(rvect0,strainEnergy2);                                       % ������Ӧ���ܻ���

E_total = E_steel+E_concrete;                                                   % ������
E_steel_percent = E_steel/E_total;
E_concrete_percent = E_concrete/E_total;

str1 = sprintf('�ֽ�%0.2f ',E_steel_percent);
str2 = sprintf('������%0.2f',E_concrete_percent);

%% Ӧ���ܻ�ͼ

figure
subplot(121)                                                                    % Ӧ������,xy����
area(rvect0,strainEnergy)                                                       % ������Ӱ���ͼ
tools.xyt({'radius [mm]','normalized strain energy','Strain Energy'})
ylim([0 1]),xlim([0 max(rvect)])
tools.xline([6 0],'r-.')
view(90,-90)                                                                    % ��ת��ͼ
legend([str1,',',str2],'Location','north')

subplot(122)                                                                    % Ӧ��������
plot(ur,rvect,uz,rvect);
legend({'ur','uz'})
xlim([-1 1]),ylim([0 max(rvect)])
tools.xyt({'normalized displacement','radius [mm]','displacement'})
tools.xline([0 6],'r-.')                                                        % ���Ʊ߽���
