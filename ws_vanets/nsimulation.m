%___________________________________________________________________%
%  Discrete Multi-Objective Grey Wolf Optimizer (DMO-GWO)           %
%  Version 1.0 - March 2021                                         %
%                                                                   %
%  Developed in MATLAB R2017b                                       %
%                                                                   %
%  Author: Eulogio Gutierrez-Huampo                                 %
%  e-Mail: egh@cin.ufpe.br                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function n_simulation = nsimulation(path_backup,bp_option)

    % Read backup of best parameters
    load(path_backup);    
    switch bp_option
        case 1
            last_index = numel(best_parameters);
            n_simulation = zeros(1,size(best_parameters(1).Simulation,1));
            for i=1:last_index
                n_simulation = n_simulation+best_parameters(i).Simulation;
            end
            n_simulation = n_simulation/last_index;
        case 2
            last_index = size(best_parameters,1);
            MaxIt = size(best_parameters,2);
            for i=1:last_index
                for j=1:MaxIt
                    n_sim_aux(i,j) = best_parameters(i,j).Simulation;
                end
            end
            n_simulation = mean(n_sim_aux);    
    end
end