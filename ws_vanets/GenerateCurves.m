%___________________________________________________________________%
%  Discrete Multi-Objective Grey Wolf Optimizer (DMO-GWO)           %
%  Version 1.0 - March 2021                                         %
%                                                                   %
%  Developed in MATLAB R2017b                                       %
%                                                                   %
%  Author: Eulogio Gutierrez-Huampo                                 %
%  e-Mail: egh@cin.ufpe.br                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  The pareto front is determined by sorting of nondomninated
%  solutions used in MOFPA

%% _______________________________________________________________________% 
% Multiobjective flower pollenation algorithm (MOFPA)                     %
% Programmed by Xin-She Yang @ May 2012 and updated in Sept 2015          % 
%                                                                         %   
% Citation details:                                                       % 
%                                                                         % 
%  1) Xin-She Yang, Flower pollination algorithm for global optimization, %
%  Unconventional Computation and Natural Computation,                    %
%  Lecture Notes in Computer Science, Vol. 7445, pp. 240-249 (2012).      %
%  2) X.-S. Yang, M. Karamanoglu, X. S. He, Multi-objective flower        %
%  algorithm for optimization, Procedia in Computer Science,              %
%  vol. 18, pp. 861-868 (2013).                                           %
%  3) X.-S. Yang, M. Karamanoglu, X.-S. He, Flower pollination algorithm: % 
%  A novel approach for multiobjective optimization,                      %
%  Engineering Optimization, vol. 46, no. 9, 1222-1237 (2014).            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc

global obj_min
global obj_max   

MA = readtable('tabela3.csv');

% maximun and minimun cost
obj_min(1:3) = inf;
obj_max(1:3) = 0;
for i=1:size(MA,1)
    mi = table2cell(MA(i,5:7));
    mi = strrep(mi, ',' , '.');
    mi_cost = str2double(mi);
    % Make 1/throughput
    mi_cost(3) = 1/mi_cost(3);
    for j=1:3
        if mi_cost(j) < obj_min(j)
            obj_min(j) = mi_cost(j);
        end
    end
    for j=1:3
        if mi_cost(j) > obj_max(j)
            obj_max(j) = mi_cost(j);
        end
    end
end         
            
% PFoption
% 1: Mean on all Paretos
%    for GWXXg50 
% 2: Mean on Pareto Front
%    for GWXXg50 
% 3: Mean on Pareto Front with output restriction
%    for GWXXg50 
% 4: Selected GW by min on Pareto Front
%    for GWXXg50
% 5: Selected GW by Euclidean min distance
%    for GWXXg50 
PFoption = 4;

curve_o50 = ocurve('GW50g50/backup_parameters.mat',PFoption);
curve_o40 = ocurve('GW40g50/backup_parameters.mat',PFoption);
curve_o30 = ocurve('GW30g50/backup_parameters.mat',PFoption);
curve_o20 = ocurve('GW20g50/backup_parameters.mat',PFoption);
curve_o10 = ocurve('GW10g50/backup_parameters.mat',PFoption);

% MOGWO figures
% ----------------
figure
%subplot(3,1,1)
plot(curve_o50(1,:))
hold on
plot(curve_o40(1,:))
hold on
plot(curve_o30(1,:))
hold on
plot(curve_o20(1,:))
hold on
plot(curve_o10(1,:))
%title('Packet loss')
ylabel('Packet loss')
xlabel('Generation')
legend('GW.50','GW.40','GW.30','GW.20','GW.10')
% axis([1 50 50 80])
grid on
drawnow
hold off

figure
%subplot(3,1,2)
plot(curve_o50(2,:))
hold on
plot(curve_o40(2,:))
hold on
plot(curve_o30(2,:))
hold on
plot(curve_o20(2,:))
hold on
plot(curve_o10(2,:))
ylabel('Latency (ns)')
xlabel('Generation')
legend('GW.50','GW.40','GW.30','GW.20','GW.10')
% axis([1 50 0.7 1.0])
grid on
drawnow
hold off

figure
%subplot(3,1,3)
plot(curve_o50(3,:))
hold on
plot(curve_o40(3,:))
hold on
plot(curve_o30(3,:))
hold on
plot(curve_o20(3,:))
hold on
plot(curve_o10(3,:))
ylabel('Throughput (Mbps)')
xlabel('Generation')
% axis([1 50 10 11.5])
legend('GW.50','GW.40','GW.30','GW.20','GW.10')
grid on
drawnow
hold off

% Generate N simulation curve
% ----------------
curve_ns50 = nsimulation('GW50g50/backup_parameters.mat',2);
curve_ns40 = nsimulation('GW40g50/backup_parameters.mat',2);
curve_ns30 = nsimulation('GW30g50/backup_parameters.mat',2);
curve_ns20 = nsimulation('GW20g50/backup_parameters.mat',2);
curve_ns10 = nsimulation('GW10g50/backup_parameters.mat',2);

% N simulation figure
% ----------------
figure
plot(curve_ns50(1,:))
hold on
plot(curve_ns40(1,:))
hold on
plot(curve_ns30(1,:))
hold on
plot(curve_ns20(1,:))
hold on
plot(curve_ns10(1,:))
ylabel('Number of simulations')
xlabel('Generation')
legend('GW.50','GW.40','GW.30','GW.20','GW.10')
grid on
drawnow
hold off

%xlswrite('ws_vanets_previous/mycurve50.xlsx',[curve_o10' curve_o20' curve_o30' curve_o40' curve_o50'])
%xlswrite('ws_vanets_previous/mycurve50ns.xlsx',[curve_ns10' curve_ns20' curve_ns30' curve_ns40' curve_ns50'])
