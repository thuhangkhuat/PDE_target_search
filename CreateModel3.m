
function model=CreateModel3()
    MAPSIZE_X = 800;
    MAPSIZE_Y = 800;
    [X,Y] = meshgrid(1:MAPSIZE_X,1:MAPSIZE_Y); % Create all (x,y) points to plot
    % Map limits
    xmin= 0;
    xmax= MAPSIZE_X;
    
    ymin= 0;
    ymax= MAPSIZE_Y;
    
    % Start position
    start_location = [100,760];
    heigth = 10;
    
    % Number of path nodes (not including the start position (start node))
    n=60;
    
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
    model.Sigma_init = [500 500]; %Deviation of Normal Distribution
    model.mu_init = [400 450]; %Mean of Normal Distribution
    % The motion of target
    model.v = 5;
    model.theta = -2.7*pi/4;
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



