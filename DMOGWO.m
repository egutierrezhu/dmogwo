%___________________________________________________________________%
%  Discrete Multi-Objective Grey Wolf Optimizer (DMO-GWO)           %
%  Version 1.0 - March 2021                                         %
%                                                                   %
%  Developed in MATLAB R2017b                                       %
%                                                                   %
%  Author: Eulogio Gutierrez-Huampo                                 %
%  e-Mail: egh@cin.ufpe.br                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  This version of discrete MOGWO has been written using a large 
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

%% MOGWO parameters
clear all
close all
clc

global MB

fobj = fObjTable('ws_vanets/tabela3.csv');

nVar=4;

% Lower bound and upper bound
lb=0*ones(1,nVar);
ub=1*ones(1,nVar);

VarSize=[1 nVar];

GreyWolves_num=30;  % Number of Particles
MaxIt=50;  % Maximum Number of Iterations

path_bup = strcat('ws_vanets/GW',num2str(GreyWolves_num),'g',num2str(MaxIt),'/backup_parameters.mat');

alpha=0.1;  % Grid Inflation Parameter
nGrid=10;   % Number of Grids per each Dimension
beta=4;     % Leader Selection Pressure Parameter
gamma=2;    % Extra (to be deleted) Repository Member Selection Pressure

%% Particle initialization

GreyWolves=CreateEmptyParticle(GreyWolves_num);

for i=1:GreyWolves_num
    GreyWolves(i).Velocity=0;
    GreyWolves(i).Position=zeros(1,nVar);
    for j=1:nVar
        GreyWolves(i).Position(1,j)=unifrnd(lb(j),ub(j),1);
    end
    GreyWolves(i).Cost=fobj(GreyWolves(i).Position')';
end

%% Sort the initialized population
n = GreyWolves_num;
% Dimension of the search variables
d = nVar;
% Number of objectives
m = 3;
%% Sort the initialized population
for i=1:GreyWolves_num
    x(i,:)=[GreyWolves(i).Position GreyWolves(i).Cost];
end
% combined into a single input
% Non-dominated sorting for the initila population
Sorted=solutions_sorting(x, m,d);
% Decompose into solutions, fitness, rank and distances
Sol=Sorted(:,1:d);
f=Sorted(:,(d+1):(d+m));
RnD=Sorted(:,(d+m+1):end);
% GreyWolves=DetermineDomination(GreyWolves);
for i=1:GreyWolves_num
    GreyWolves(i).Position=Sol(i,:);
    GreyWolves(i).Cost=f(i,:);
    % Rank and distances
    GreyWolves(i).RankAndDistances=RnD(i,:);
end
Archive=GetNonDominatedParticlesByRank(GreyWolves);
Archive_costs=GetCosts(Archive);
% Archive grid index
G=CreateHypercubes(Archive_costs,nGrid,alpha);
for i=1:numel(Archive)
    [Archive(i).GridIndex Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end
%% Load backup of best parameters
if isfile(path_bup)
     % File exists.
     load(path_bup);
     index_backup = size(best_parameters,1);   
else
     % File does not exist.
     clear best_parameters
     best_parameters.IOrd=[];
     best_parameters.Simulation=[];
     index_backup = 0;
end

%% MOGWO main loop
for it=1:MaxIt
    a=2-it*((2)/MaxIt);
    for i=1:GreyWolves_num
        
        clear rep2
        clear rep3
        
        % Choose the alpha, beta, and delta grey wolves
        Delta=SelectLeader(Archive,beta);
        Beta=SelectLeader(Archive,beta);
        Alpha=SelectLeader(Archive,beta);
        
        % If there are less than three solutions in the least crowded
        % hypercube, the second least crowded hypercube is also found
        % to choose other leaders from.
        if size(Archive,1)>1
            counter=0;
            for newi=1:size(Archive,1)
                if sum(Delta.Position~=Archive(newi).Position)~=0
                    counter=counter+1;
                    rep2(counter,1)=Archive(newi);
                end
            end
            Beta=SelectLeader(rep2,beta);
        end
        
        % This scenario is the same if the second least crowded hypercube
        % has one solution, so the delta leader should be chosen from the
        % third least crowded hypercube.
        if size(Archive,1)>2
            counter=0;
            for newi=1:size(rep2,1)
                if sum(Beta.Position~=rep2(newi).Position)~=0
                    counter=counter+1;
                    rep3(counter,1)=rep2(newi);
                end
            end
            Alpha=SelectLeader(rep3,beta);
        end
        
        % Eq.(3.4) in the paper
        c=2.*rand(1, nVar);
        % Eq.(3.1) in the paper
        D=abs(c.*Delta.Position-GreyWolves(i).Position);
        % Eq.(3.3) in the paper
        A=2.*a.*rand(1, nVar)-a;
        % Eq.(3.8) in the paper
        X1=Delta.Position-A.*abs(D);
        
        
        % Eq.(3.4) in the paper
        c=2.*rand(1, nVar);
        % Eq.(3.1) in the paper
        D=abs(c.*Beta.Position-GreyWolves(i).Position);
        % Eq.(3.3) in the paper
        A=2.*a.*rand()-a;
        % Eq.(3.9) in the paper
        X2=Beta.Position-A.*abs(D);
        
        
        % Eq.(3.4) in the paper
        c=2.*rand(1, nVar);
        % Eq.(3.1) in the paper
        D=abs(c.*Alpha.Position-GreyWolves(i).Position);
        % Eq.(3.3) in the paper
        A=2.*a.*rand()-a;
        % Eq.(3.10) in the paper
        X3=Alpha.Position-A.*abs(D);
        
        % Eq.(3.11) in the paper
        GreyWolves(i).Position=(X1+X2+X3)./3;
        
        % Boundary checking
        GreyWolves(i).Position=min(max(GreyWolves(i).Position,lb),ub);
        
        GreyWolves(i).Cost=fobj(GreyWolves(i).Position')';
    end   
    %% Combine new solutions
    % Adding new wolves to archive
    for i=1:GreyWolves_num
        Archive_flag = 1;
        for j=1:numel(Archive)
            if all(GreyWolves(i).Cost==Archive(j).Cost)
                Archive_flag = 0;
            end            
        end
        if Archive_flag==1
            Archive=[Archive 
                GreyWolves(i)];
        end
    end   
    
    %% ! It's very important to combine both populations, otherwise,
    % the results may look odd and will be very inefficient. !     
    % The combined population consits of both the old and new solutions
    % So the total size of the combined population for sorting is 2*n    
    for i=1:numel(Archive),
        X(i,:)=[Archive(i).Position Archive(i).Cost];
    end          
    %Sorted=solutions_sorting(X, m, d);
    new_Sol=solutions_sorting(X, m, d);
    %% Select n solutions among a combined population of 2*n solutions
    %new_Sol=Select_pop(Sorted, m, d, n);
    % Decompose into solutions, fitness and ranking
    Sol=new_Sol(:,1:d);             % Sorted solutions
    f=new_Sol(:,(d+1):(d+m));       % Sorted objective values
    RnD=new_Sol(:,(d+m+1):end);     % Sorted ranks and distances   
    
    %% Archive=GetNonDominatedParticlesByRank(Archive);
    % for i=1:size(Sol,1)
    for i=1:numel(Archive)
        Archive(i).Position=Sol(i,:);
        Archive(i).Cost=f(i,:);
        % Rank and distances
        Archive(i).RankAndDistances=RnD(i,:);
    end
    Archive=GetNonDominatedParticlesByRank(Archive);
    Archive_costs=GetCosts(Archive);
    % Archive grid index    
    for i=1:numel(Archive)
        [Archive(i).GridIndex Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
    end

    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]); 
    
    % New solution to best_parameters
    % IOrd means [x1 x2 x3 x4 f1 f2 f3 Rank Distance]
    best_parameters(index_backup+1,it).IOrd = new_Sol;
    
    % N simulation to best_parameters
    best_parameters(index_backup+1,it).Simulation = size(MB,1);  
    
    if it == MaxIt,
        save(path_bup, 'best_parameters')
        disp('The optimization process has ended.')
    end        
end