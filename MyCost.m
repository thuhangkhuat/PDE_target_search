function costP=MyCost(position,model)
        % Input solution
        % Note: Position here is actually a search path consisting a number of
        % nodes
        x=position.x;
        y=position.y;
        theta = position.theta;
        % Input map
        N = model.n; % path length
        pNodetectionAll = 1; % Initialize the Probability of No detection at all
        pDetection = zeros(N); % Initialize the Probability of detection at each time step

        % Calculate the cost
        for i=1:N
            location.x = x(i);  
            location.y = y(i);
            location.theta = theta(i);
            [scaleFactor,model] = UpdateMap(i,location,model); % Update the probability map
            pNoDetection = scaleFactor; % Probability of No Detection at time t is Exactly the scaling factor
            pDetection(i) = pNodetectionAll*(1 - pNoDetection); % Probability of Detection for the first time at time i
            pNodetectionAll = pNodetectionAll * pNoDetection; 
        end
             
        costP = 1 - pNodetectionAll;  % Return the Cumulative Probability of detection up to now (P = 1 - R)
end
