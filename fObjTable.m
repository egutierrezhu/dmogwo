%___________________________________________________________________%
%  Discrete Multi-Objective Grey Wolf Optimizer (DMO-GWO)           %
%  Version 1.0 - March 2021                                         %
%                                                                   %
%  Developed in MATLAB R2017b                                       %
%                                                                  %
%  Author: Eulogio Gutierrez-Huampo                                 %
%  e-Mail: egh@cin.ufpe.br                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fobj = fObjTable(file_path)

    global MA
    global MB

    MA = readtable(file_path);
    MB = [];                       
    fobj = @UF0;  
            
end

%% UF0
% x and y are are inside tabela3.csv
function y = UF0(x)
    global MA
    global MB   
    [dim, num]  = size(x);
    if dim == 4        
        % Minimum-Euclidean-norm distance to input
        % input Nx4 (1:4)  : parameters
        % output Nx3 (5:7) : cost functions
        
        % Discrete parameters
        p1 = [75 100 150 200];
        p2 = [16 24 32 40];
        p3 = [5 20 35];
        p4 = [5 10 15 20 25 30 35 40 45 50];
        
        % Linear transform
        % out=(in-in_min)*(out_max-out_min)/(in_max-in_min)+out_min
        x1=round((x(1)-0)*(3-0)/(1-0)+0);
        x2=round((x(2)-0)*(3-0)/(1-0)+0);
        x3=round((x(3)-0)*(2-0)/(1-0)+0);
        x4=round((x(4)-0)*(9-0)/(1-0)+0);
        % x to inout parameter
        xp=[p1(x1+1) p2(x2+1) p3(x3+1) p4(x4+1)];      
        
        % Objetive function
        % ------------------
        % Using memory
        simulation_flag = 1;
        for i=1:size(MB,1)
            mi_input = MB(i,1:4);
            if all(mi_input==xp)              
                mi_cost = MB(i,5:7);                                   
                simulation_flag = 0;
                break
            end
        end
        
        % Using simulation
        if simulation_flag == 1
            for i=1:size(MA,1)
                mi_input = table2array(MA(i,1:4));
                if all(mi_input==xp)
                    index_B = size(MB,1)+1;
                    mi = table2cell(MA(i,5:7));
                    mi = strrep(mi, ',' , '.');
                    mi_cost = str2double(mi);                      
                    MB(index_B,:) = [mi_input mi_cost];
                    MA(i,:) = [];
                    break
                end
            end
        end
                   
        % Make 1/throughput
        mi_cost(3) = 1/mi_cost(3);
        
        y(1,:)      = mi_cost(1);
        y(2,:)      = mi_cost(2);
        y(3,:)      = mi_cost(3);       
        clear norm_eq parm_i mi mi_input mi_cost;        
    else
        disp('Dim should be 4')
        return
    end    
end