%___________________________________________________________________%
%  Discrete Multi-Objective Grey Wolf Optimizer (DMO-GWO)           %
%  Version 1.0 - March 2021                                         %
%                                                                   %
%  Developed in MATLAB R2017b                                       %
%                                                                   %
%  Author: Eulogio Gutierrez-Huampo                                 %
%  e-Mail: egh@cin.ufpe.br                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  The pareto of the discrete MOGWO has been generated using a large 
%  portion of the following codes:

%% _________________________________________________________________%
%  Multi-Objective Grey Wolf Optimizer (MOGWO)                      %
%  Source codes demo version 1.0                                    %
%                                                                   %
%  Developed in MATLAB R2011b(7.13)                                 %
%                                                                   %
%  Author and programmer: Seyedali Mirjalili                        %
%                                                                   %
%         e-Mail: ali.mirjalili@gmail.com                           %
%                 seyedali.mirjalili@griffithuni.edu.au             %
%                                                                   %
%       Homepage: http://www.alimirjalili.com                       %
%                                                                   %
%   Main paper:                                                     %
%                                                                   %
%    S. Mirjalili, S. Saremi, S. M. Mirjalili, L. Coelho,           %
%    Multi-objective grey wolf optimizer: A novel algorithm for     %
%    multi-criterion optimization, Expert Systems with Applications,%
%    in press, DOI: http://dx.doi.org/10.1016/j.eswa.2015.10.039    %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% _________________________________________________________________%
%  MATLAB Code for                                                  %
%                                                                   %
%  Multi-Objective Particle Swarm Optimization (MOPSO)              %
%  Version 1.0 - Feb. 2011                                          %
%                                                                   %
%  According to:                                                    %
%  Carlos A. Coello Coello et al.,                                  %
%  "Handling Multiple Objectives with Particle Swarm Optimization," %
%  IEEE Transactions on Evolutionary Computation, Vol. 8, No. 3,    %
%  pp. 256-279, June 2004.                                          %
%                                                                   %
%  Developed Using MATLAB R2009b (Version 7.9)                      %
%                                                                   %
%  Programmed By: S. Mostapha Kalami Heris                          %
%                                                                   %
%         e-Mail: sm.kalami@gmail.com                               %
%                 kalami@ee.kntu.ac.ir                              %
%                                                                   %
%       Homepage: http://www.kalami.ir                              %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% _______________________________________________________________________% 
% Multiobjective flower pollenation algorithm (MOFPA)                     %
% Programmed by Xin-She Yang @ May 2012 and updated in Sept 2015          % 
%                                                                         %   
% Citation details:                                                       % 
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

clc
clear all
close all

% Load final results
load('GW30g50/backup_parameters.mat')

% Exhaustive fobjs
MA = readtable('tabela3.csv');
for i=1:size(MA,1)
    mi = table2cell(MA(i,5:7));
    mi = strrep(mi, ',' , '.');
    costs(:,i) = str2double(mi)';
end

%% Pareto front fobjs
last_index = size(best_parameters,1);
MaxIt = size(best_parameters,2);

k=round(1+(last_index-1)*rand);

iord_aux = best_parameters(k,MaxIt).IOrd;
% Deleting dominated paretos
w=1;
while w<=size(iord_aux,1)
    if iord_aux(w,8)==1
        w=w+1;                          
    else
        iord_aux(w,:) = []; 
    end
end
Archive_costs=iord_aux(:,5:7)';
% Make 1/throughput
Archive_costs(3,:)=1./Archive_costs(3,:);

%% Pareto 3D
% ----------------
figure
plot3(costs(1,:),costs(2,:),costs(3,:),'k.');
hold on
plot3(Archive_costs(1,:),Archive_costs(2,:),Archive_costs(3,:),'rd');
legend('Exhaustive','Non-dominated solutions 3D');
xlabel('Packet loss')
ylabel('Latency (ns)')
zlabel('Throughput (Mbps)')
grid on
drawnow  

%% Pareto 2D
% ----------------
figure
plot(costs(1,:),costs(2,:),'k.');
hold on
plot(Archive_costs(1,:),Archive_costs(2,:),'d');
legend('Exhaustive','Non-dominated solutions 1-2');
xlabel('Packet loss')
ylabel('Latency (ns)')
drawnow
hold off

figure
plot(costs(1,:),costs(3,:),'k.');
hold on
plot(Archive_costs(1,:),Archive_costs(3,:),'d');
legend('Exhaustive','Non-dominated solutions 1-3');
xlabel('Packet loss')
ylabel('Throughput (Mbps)')
drawnow  
hold off

figure
plot(costs(2,:),costs(3,:),'k.');
hold on
plot(Archive_costs(2,:),Archive_costs(3,:),'d');
legend('Exhaustive','Non-dominated solutions 2-3');
xlabel('Latency (ns)')
ylabel('Throughput (Mbps)')
drawnow
hold off