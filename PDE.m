%
% Find a path that maximizes the probability of finding object
% 

clc;
clear;
close all;
tic

%% Problem Definition

model = CreateModel6(); % Create search map and parameters

CostFunction=@(x) MyCost(x,model);    % Cost Function

nVar = model.n;       % Number of Decision Variables = searching dimension of PSO = number of movements

VarSize=[1 nVar];   % Size of Decision Variables Matrix
%Upper Bound of particles and Lower Bound of particles (Variables)
VarMin.x=model.xmin;           
VarMax.x=model.xmax;           
VarMin.y=model.ymin;           
VarMax.y=model.ymax;         

VarMax.r=3*model.v;           
VarMin.r=0;

% Inclination (elevation)
AngleRange = pi; % Limit the angle range for better solutions
VarMin.phi= -AngleRange;           
VarMax.phi= AngleRange;              

%% DE Parameters

MaxIt=5;          % Maximum Number of Iterations

nPop=500;           % Population Size (Swarm Size)

beta_min=0.1;   % Lower Bound of Scaling Factor
beta_max=0.4;   % Upper Bound of Scaling Factor

pCR=0.9;        % Crossover Probability

%% Initialization

empty_individual.Position=[];
empty_individual.Cost=[];

BestSol.Cost=-inf;

pop=repmat(empty_individual,nPop,1);


    for i=1:nPop

        % Initialize Position
        pop(i).Position=CreateRandomSolution(VarSize,VarMin,VarMax);

        % Evaluation
        pop(i).Cost = MyCost(PolarToCart(pop(i).Position,model),model);
        
        if pop(i).Cost > BestSol.Cost
            BestSol=pop(i);
        end
    end
    BestSol.Cost;
    BestCost=zeros(MaxIt,1);

%% DE Main Loop

for it=1:MaxIt
    
    for i=1:nPop
        
        currentPos=pop(i).Position;
        
        A=randperm(nPop);
        
        A(A==i)=[]; % Remove the current position
        
        a=A(1);
        b=A(2);
        c=A(3);
        
        % Mutation
        beta = unifrnd(beta_min,beta_max,VarSize);
        mutPos.r = pop(a).Position.r + beta.*(pop(b).Position.r - pop(c).Position.r);
        mutPos.r = max(mutPos.r, VarMin.r);
		mutPos.r = min(mutPos.r, VarMax.r);

        mutPos.phi = pop(a).Position.phi + beta.*(pop(b).Position.phi - pop(c).Position.phi);
        mutPos.phi = max(mutPos.phi, VarMin.phi);
		mutPos.phi = min(mutPos.phi, VarMax.phi);
        
        
        % Crossover
        crossPos=[];
        for j=1:numel(currentPos.r)
            if rand <= pCR
                crossPos.r(j)=mutPos.r(j);
                crossPos.phi(j)=mutPos.phi(j);
            else
                crossPos.r(j)=currentPos.r(j);
                crossPos.phi(j)=currentPos.phi(j);
            end
        end
        
        NewSol.Position=crossPos;
        NewSol.Cost=MyCost(PolarToCart(NewSol.Position,model),model);
        if NewSol.Cost > pop(i).Cost
            pop(i)=NewSol;
            if pop(i).Cost > BestSol.Cost
               BestSol=pop(i);
            end
        end
        
    end
    % Update Best Cost
    BestCost(it)=BestSol.Cost;
% Show Iteration Information
  disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
end

timeElapsed = toc
%% Results

% Updade Map in Accordance to the Target Moves
% Plot Solution
path=PolarToCart(BestSol.Position,model); % Convert from Polar to Cartesian Space 
PlotSolution(path,model)

% figure;
plot(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;
% 
% % Write Best cost to file
% fileID = fopen('BestCostDataDE7.txt','w');
% fprintf(fileID,'%4.8f\n',BestCost*10);
% fclose(fileID);
% % Write Best Position to file
% realpath(1,1) = model.start(1);
% realpath(1,2) = model.start(2);
% realpath(1,3) = path.theta(1);
% for i = 2:model.n+1
%     realpath(i,1) = path.x(i-1);
%     realpath(i,2) = path.y(i-1);
%     realpath(i,3) = path.theta(i-1);
% end
% fileID = fopen('DE_Path8.txt','w');
% fprintf(fileID,'%4.4f\n',realpath);
% fclose(fileID);
