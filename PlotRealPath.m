
 H = imread('E:/Moving target search/Cam-search-target/PDEcam-search-target/x.tif'); % Get elevation data
 H= H(1:800,1:800)/1000+1.9;
 MAPSIZE_X = size(H,2); % x index: columns of H
 MAPSIZE_Y = size(H,1); % y index: rows of H
 [X,Y] = meshgrid(1:MAPSIZE_X,1:MAPSIZE_Y); % Create all (x,y) points to plot
 mesh(X,Y,H);
 colormap winter;                    % Default color map.
 shading interp;                  % Interpolate color across faces.
 material dull;                   % Mountains aren't shiny
 camlight left;                   % Add a light over to the left somewhere.
 lighting gouraud;                % Use decent lighting.
 hold on
 %plot cmap
 model = CreateModel6;
 n = model.n;
 Sigma = model.Sigma(n,:);
 mu = model.mu(n,:);
 F = mvnpdf([X(:) Y(:)],mu,Sigma);
 F = reshape(F,size(H,2),size(H,1));  % Convert F to a matrix
 F = F/sum(F(:)); % normalize
 contour(X,Y,F,5,'r','LineWidth',1.5)
 %plot path
Realpath = importdata('E:/Moving target search/Cam-search-target/PDEcam-search-target/DE_Path6.txt');
n = length(Realpath)/2;
xf = Realpath(1:n);
yf = Realpath(n+1:2*n);
zf = ones(n,1)*(max(F(:))+0.05);
plot3(xf, yf, zf, 'black-o', 'LineWidth', 2, 'MarkerSize',4,...
    'MarkerEdgeColor','black',...
    'MarkerFaceColor','y');
plot3(xf(n),yf(n),zf(n),'-p','MarkerFaceColor','yellow',...
        'MarkerEdgeColor','y',...
        'MarkerSize',10);
plot3(xf(1),yf(1),zf(1),'-s','MarkerFaceColor','yellow',...
        'MarkerEdgeColor','y',...
        'MarkerSize',10);
 zmax = max(zf(:));
 zmin = min(H(:));
 axis([0 size(H,2) 0 size(H,1) zmin zmax])
 view(0,90)
 xlabel('x (m)');
 ylabel('y (m)');
 zlabel('Search area');
 set(gca,'ztick',[])