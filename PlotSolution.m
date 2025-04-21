function PlotSolution(sol,model)
%PLOTTOPVIEW
figure();
hold on;

resolution = 0.5;
x = model.xmin:resolution:model.xmax;
y = model.ymin:resolution:model.ymax;
[X,Y] = meshgrid(x,y);
start = model.start;
n = model.n;
xs = sol.x;
ys = sol.y;
psi = sol.theta;
psif = [psi(1),psi];
% Plot map
F = mvnpdf([X(:) Y(:)],model.mu(n,:),model.Sigma(n,:));
F = reshape(F,length(y),length(x));  % Convert F to a matrix
F = F/sum(F(:)); % normalize
surf(X,Y,F, 'EdgeColor', 'none');
caxis([min(F(:))-0.5*range(F(:)),max(F(:))]);
shading interp    % interpolate colors across lines and faces
hold on;
zmax = max(F(:))+0.0002;
axis([0 model.xmax 0 model.ymax 0   zmax])
xf = [start(1) xs];
yf = [start(2) ys];
zf = ones(n+1,1)*(max(F(:)));
% Plot path
plot3(xf, yf, zf, 'black-o', 'LineWidth', 2, 'MarkerSize',3,'MarkerFaceColor','r');
 plot3(xf(1),yf(1),zf(1),'r-o',...
        'MarkerSize',3,...
        'MarkerFaceColor','r',...
        'LineWidth',3);
% Plot camera footprint
for i = 1:model.n+1
    location.x = xf(i);
    location.y = yf(i);
    location.theta = psif(i);
    [A,B,C,D] = CameraFootprint(location, model);
    x = [A(1) B(1) C(1) D(1) A(1)];
    y = [A(2) B(2) C(2) D(2) A(2)];
    z = [0    0    0    0    0];
    fill3(x, y, z, 'c', 'FaceAlpha', 0.4, 'EdgeColor', 'r');
end

xlabel('x (m)');
ylabel('y (m)');
zlabel('Search area');

end

