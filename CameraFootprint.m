function [A,B,C,D,l,w1,w2] = CameraFootprint(pos,model)
%CAMERAFOOTPRINT
psi = pos.theta;
% Distance two parallel sides
d1 = model.h*tan(model.phi - model.beta/2);
d2 = model.h*tan(model.phi + model.beta/2);

% Two width edge of camera footprint
w1 = 2*model.h*tan(model.alpha/2)/cos(model.phi-model.beta/2);
w2 = 2*model.h*tan(model.alpha/2)/cos(model.phi+model.beta/2);

% Define angles
delta1 = atan(w1/(2*d1));
delta2 = atan(w2/(2*d2));
x = pos.x;
y = pos.y;
% Camera footprint
A = [x,y] + [w1*cos(psi-delta1)/2/sin(delta1), w1*sin(psi-delta1)/2/sin(delta1)];
B = [x,y] + [w2*cos(psi-delta2)/2/sin(delta2), w2*sin(psi-delta2)/2/sin(delta2)];
C = [x,y] + [w2*cos(psi+delta2)/2/sin(delta2), w2*sin(psi+delta2)/2/sin(delta2)];
D = [x,y] + [w1*cos(psi+delta1)/2/sin(delta1), w1*sin(psi+delta1)/2/sin(delta1)];
l = d2-d1;
end
