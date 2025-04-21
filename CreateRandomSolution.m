
%% Create random solutions

function solution=CreateRandomSolution(VarSize,VarMin,VarMax) 
    % Random path nodes
    solution.r=unifrnd(VarMin.r,VarMax.r,VarSize);
    solution.phi=unifrnd(VarMin.phi,VarMax.phi,VarSize);
end
