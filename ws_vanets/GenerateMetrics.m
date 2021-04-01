%___________________________________________________________________%
%  Discrete Multi-Objective Grey Wolf Optimizer (DMO-GWO)           %
%  Version 1.0 - March 2021                                         %
%                                                                   %
%  Developed in MATLAB R2017b                                       %
%                                                                   %
%  Author: Eulogio Gutierrez-Huampo                                 %
%  e-Mail: egh@cin.ufpe.br                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  This version of metrics for discrete MOGWO is based on metrics
%  of PlatEMO

%___________________________________________________________________%
%  Evolutionary multi-objective optimization platform (PlatEMO)     %
%  Version 3.1                                                      %
%                                                                   %
%  Citation details:                                                %
%                                                                   %
%  Ye Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A     %
%  MATLAB Platform for Evolutionary Multi-Objective Optimization    %
%  [Educational Forum], IEEE Computational Intelligence Magazine,   %
%  2017, 12(4): 73-87                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all

% mo_metric select the multiobjective metric 
% '_HV' : Hypervolume
% '_GD' : Generational distance
% '_IGD': Inverted generational distance
% '_SP' : Spacing

mo_metric = '_HV'
m_score = [];

load('GW30g50/backup_parameters.mat')
last_index = size(best_parameters,1);
MaxIt = size(best_parameters,2);

% q is score index
q=0;
for k=1:last_index
    % Pareto 1
    iord_aux1 = best_parameters(k,MaxIt).IOrd;
    w=1;
    while w<=size(iord_aux1,1)
        if iord_aux1(w,8)==1
            w=w+1;                          
        else
            iord_aux1(w,:) = []; 
        end
    end
    
    % Pareto 2    
    iord_aux2 = best_parameters(k,MaxIt).IOrd;
    w=1;
    while w<=size(iord_aux2,1)
        if iord_aux2(w,8)==2
            w=w+1;                          
        else
            iord_aux2(w,:) = []; 
        end
    end
    
    if isempty(iord_aux2)
        disp('There is no dominated Pareto')
    else
        % dominated_wolves and non_dominated_wolves
        % f1(1) f2(1) f3(1)
        % f1(2) f2(2) f3(2)
        % ...
        dominated_wolves.best.objs = iord_aux2(:,5:7);
        non_dominated_wolves_objs = iord_aux1(:,5:7);
        
        % update score
        q=q+1;        
        switch mo_metric
            case '_HV',
                m_score(q) = HV(dominated_wolves,non_dominated_wolves_objs);
            case '_GD',
                m_score(q) = GD(dominated_wolves,non_dominated_wolves_objs);
            case '_IGD',
                m_score(q) = IGD(dominated_wolves,non_dominated_wolves_objs);
           case '_SP',
                m_score(q) = Spacing(dominated_wolves,non_dominated_wolves_objs);                
        end        
    end
end

[mean(m_score) median(m_score) std(m_score) max(m_score) min(m_score) size(m_score,2)]'
