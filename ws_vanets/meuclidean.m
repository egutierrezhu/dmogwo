%___________________________________________________________________%
%  Discrete Multi-Objective Grey Wolf Optimizer (DMO-GWO)           %
%  Version 1.0 - March 2021                                         %
%                                                                   %
%  Developed in MATLAB R2017b                                       %
%                                                                   %
%  Author: Eulogio Gutierrez-Huampo                                 %
%  e-Mail: egh@cin.ufpe.br                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The minimun of objetive functions using Euclidean distance

function f_index_min = meuclidean(f_objs)

    global obj_min
    global obj_max

    % Minimum-Euclidean-norm cost per iteration
    % f_objs
    % f1(1) f2(1) f3(1)
    % f1(2) f2(2) f3(2)
    % ...
    norm_min = inf;
    for i=1:size(f_objs,1)
        fi_objs = f_objs(i,:);
        % Normalization to 0 and 1    
        for j=1:size(obj_min,2)
            fi_objs(j)= (fi_objs(j)-obj_min(j))/(obj_max(j)-obj_min(j));
        end    
        norm_i = norm(fi_objs);
        if norm_i < norm_min
            norm_min = norm_i;
            index_min = i;            
        end
    end
    f_index_min = f_objs(index_min,:);
end