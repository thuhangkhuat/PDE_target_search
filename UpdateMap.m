function [scaleFactor,newmodel] = UpdateMap(currentStep,location,model)
    if currentStep ~= 0
       mu = model.mu(currentStep,:);
       Sigma = model.Sigma(currentStep,:);
    end
    [fA,fB,fC,fD,l,w1,w2] = CameraFootprint(location,model);
    f = @(x_f,y_f) 1/(norm(Sigma)*sqrt(2*pi))*exp(-([x_f y_f]-mu).^2/(2*Sigma.^2));
    domain_cam = struct('type','polygon','x',[fA(1) fB(1) fC(1) fD(1)],'y',[fA(2) fB(2) fC(2) fD(2)]);
    domain_map = struct('type', 'polygon',...
                    'x',[model.xmin model.xmax model.xmax model.xmin],...
                    'y',[model.ymin model.ymin model.ymax model.ymax]);

    param = struct('method','gauss','points',2);
    pre_detect = doubleintegral(f, domain_cam, param)/doubleintegral(f, domain_map, param);
    S_footprint = abs((w1+w2)*l/2);
    now_detect = 0.7;
    scaleFactor = 1-(now_detect*pre_detect*S_footprint);
    newmodel = model;
end
