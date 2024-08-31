function [FEMesh, cutOutElements] = cutoutMesh_mouse(stlfile)
% model = createpde;
% 
% gm = importGeometry(model,stlfile);
% 
% figure(1)
% pdegplot(model,"FaceLabels","on")
% scale(gm,0.001);
% center = mean(gm.Vertices);
% translate(gm,[-center(1),-center(2)])
% 
% pdegplot(model,"FaceLabels","on")
% figure(2)
% FEMesh = generateMesh(model,"Hedge",{1:gm.NumEdges,0.0001});
% pdemesh(FEMesh)
% hold on
% cutOutElements = findElements(FEMesh,'region','Face',1); % Define the kirigiami elements
% pdemesh(FEMesh.Nodes, FEMesh.Elements(:,cutOutElements),'EdgeColor','green');
% hold off

x_shrinky = [-0.026 -0.035 -0.036 -0.03 -0.02 -0.016 -0.008 0];
x_shrinky = [x_shrinky flip(-x_shrinky(1:end-1))];

y_shrinky = [-0.054 -0.034 0.012 0.037 0.038 0.038 0.037 0.02];
y_shrinky = [y_shrinky flip(y_shrinky(1:end-1))];


x_cut_left = [-0.035 -0.029 -0.026 -0.024 -0.027 -0.032 -0.036];
y_cut_left = [-0.034 -0.023 -0.016 -0.009 0 0.006 0.012];

x_cut_right = -x_cut_left;
y_cut_right = y_cut_left;

x_cut_top = [0 -0.008 -0.009 -0.009 -0.008 -0.006];
x_cut_top = [x_cut_top flip(-x_cut_top(2:end))];

y_cut_top = [0.02 0.037 0.027 0.024 0.018 0.013];
y_cut_top = [y_cut_top flip(y_cut_top(2:end))];

x_cut_bottom = [0 -0.007 -0.016 -0.026];
x_cut_bottom = [x_cut_bottom flip(-x_cut_bottom(2:end))];

y_cut_bottom = [-0.044 -0.045 -0.049 -0.054];
y_cut_bottom = [y_cut_bottom flip(y_cut_bottom(2:end))];




gd = zeros(2+2*length(x_shrinky),5);
gd(:,1) = [2 length(x_shrinky) x_shrinky y_shrinky]';
gd(1:2+2*length(x_cut_left),2) = [2,length(x_cut_left),x_cut_left,y_cut_left]';
gd(1:2+2*length(x_cut_right),3) = [2,length(x_cut_right),x_cut_right,y_cut_right]';
gd(1:2+2*length(x_cut_top),4) = [2,length(x_cut_top),x_cut_top,y_cut_top]';
gd(1:2+2*length(x_cut_bottom),5) = [2,length(x_cut_bottom),x_cut_bottom,y_cut_bottom]';

g = decsg(gd);
model = createpde;
geometryFromEdges(model,g);


%% Plot the geometry (for simple check)

figure(1);
pdegplot(model,'FaceLabels','on')
axis equal

figure(2)
FEMesh = generateMesh(model, "Hmax",0.001);
pdemesh(FEMesh)
hold on
cutOutElements = findElements(FEMesh,'region','Face',1); % Define the kirigiami elements
pdemesh(FEMesh.Nodes, FEMesh.Elements(:,cutOutElements),'EdgeColor','green');
hold off

end