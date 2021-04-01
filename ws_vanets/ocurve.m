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

function f_curve = ocurve(path_backup,pf_option)

    % Read backup of best parameters
    load(path_backup);
    last_index = size(best_parameters,1);
    MaxIt = size(best_parameters,2);
        
    % Mean of objetive functions on iterations
    f_curve=zeros(3,MaxIt);
    for k=1:last_index,
        % Mean of values on pareto front
        f_aux = [];
        for t=1:MaxIt,
            % IOrd = [x1 x2 x3 x4 f1 f2 f3 Rank Distance]
            switch pf_option
                case 1
                    iord_aaux_m = mean(best_parameters(k,t).IOrd);  
                    iord_aux_m = iord_aaux_m(5:7);
                case 2
                    iord_aux = best_parameters(k,t).IOrd;
                    % Deleting dominated paretos
                    w=1;
                    while w<=size(iord_aux,1)
                        if iord_aux(w,8)==1
                            w=w+1;                          
                        else
                            iord_aux(w,:) = []; 
                        end
                    end   
                    iord_aux_f=iord_aux(:,5:7);
                    iord_aux_m = mean(iord_aux_f); 
                case 3
                    iord_aux = best_parameters(k,t).IOrd;
                    % Deleting GWs outside of output restriction range
                    w=1;
                    while w<=size(iord_aux,1)
                        if (iord_aux(w,8)==1) && (iord_aux(w,5)<175) && ((1/iord_aux(w,7))>9)
                            w=w+1;                          
                        else
                            iord_aux(w,:) = []; 
                        end
                    end   
                    iord_aux_f=iord_aux(:,5:7);
                    % Arrary mean for all cases
                    if size(iord_aux_f,1)>1,
                        iord_aux_m = mean(iord_aux_f);
                    else
                        iord_aux_m = iord_aux_f;
                    end
                case 4                    
                    iord_aux = best_parameters(k,t).IOrd;
                    % Deleting dominated paretos
                    w=1;
                    while w<=size(iord_aux,1)
                        if iord_aux(w,8)==1
                            w=w+1;                          
                        else
                            iord_aux(w,:) = []; 
                        end
                    end
                    iord_aux_f=iord_aux(:,5:7);                         
                    iord_aux_m = min(iord_aux_f);                                                        
                case 5
                    iord_aux = best_parameters(k,t).IOrd;
                    % Deleting dominated paretos
                    w=1;
                    while w<=size(iord_aux,1)
                        if iord_aux(w,8)==1
                            w=w+1;                          
                        else
                            iord_aux(w,:) = []; 
                        end
                    end
                    iord_aux_f=iord_aux(:,5:7);
                    iord_aux_m = meuclidean(iord_aux_f);
            end
            % Obj function [f1 f2 f3] to [f1 f2 f3]'            
            f_aux(:,t) = iord_aux_m';
        end
        f_curve=f_curve+f_aux;
    end
    f_curve=f_curve/last_index;
    
    % Make 1/throughput
    f_curve(3,:) = 1./f_curve(3,:);
end