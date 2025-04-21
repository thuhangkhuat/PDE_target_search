
function model=CreateModel7()
    MAPSIZE_X = 2100;
    MAPSIZE_Y = 2100;
    [X,Y] = meshgrid(1:MAPSIZE_X,1:MAPSIZE_Y); % Create all (x,y) points to plot
    % Map limits
    xmin= 0;
    xmax= MAPSIZE_X;
    
    ymin= 0;
    ymax= MAPSIZE_Y;
    
    % Start position
    start_location = [400,400];
    heigth = 15;
    
    % Number of path nodes (not including the start position (start node))
    n=200;
    
    % Incorporate map and searching parameters to a model
    model.start=start_location;
    model.n=n;
    model.xmin=xmin;
    model.xmax=xmax;
    model.ymin=ymin;
    model.ymax=ymax;
    model.MAPSIZE_X = MAPSIZE_X;
    model.MAPSIZE_Y = MAPSIZE_Y;
    model.X = X;
    model.Y = Y;
    model.h = heigth;
    
    %% Probality
    model.Sigma_init = [2000 2000]; %Deviation of Normal Distribution
    model.mu_init = [950 650]; %Mean of Normal Distribution
    % The motion of target
    model.v = 5;
    model.theta = pi/4;
    % Store the predict target
    model.mu = [];
    model.Sigma = [];
    for i=1:model.n
        if i == 1
            x = model.mu_init(1) + model.v*cos(model.theta);
            y = model.mu_init(2) + model.v*sin(model.theta);
        else
            x = model.mu(i-1,1) + model.v*cos(model.theta);
            y = model.mu(i-1,2) + model.v*sin(model.theta);
        end
        model.mu = [model.mu; [x y]];
        model.Sigma = [model.Sigma; model.Sigma_init];
    end
% Camera parameter
model.alpha = 80*pi/180;
model.beta = 60*pi/180;
model.phi = pi/6;
end



