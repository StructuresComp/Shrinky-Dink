function [FEMesh, cutOutElements] = cutoutMesh_butterfly(stlfile)
% model = createpde;
% 
% gm = importGeometry(model,stlfile);
% 
% scale(gm,0.001);
% center = mean(gm.Vertices);
% translate(gm,[-center(1),-center(2)])
% figure(1)
% pdegplot(model,"FaceLabels","on")
% figure(2)
% FEMesh = generateMesh(model,"Hedge",{1:gm.NumEdges,0.0001});
% pdemesh(FEMesh)
% hold on
% cutOutElements = findElements(FEMesh,'region','Face',[3 6 7 11]); % Define the kirigiami elements
% pdemesh(FEMesh.Nodes, FEMesh.Elements(:,cutOutElements),'EdgeColor','green');
% hold off

x_shrinky = [0 -0.024 -0.032 -0.033 -0.032 -0.03 -0.012 -0.008 -0.002];
x_shrinky = [x_shrinky flip(-x_shrinky(2:end))];

% y_shrinky = [0.02 0.045 0.046 -0.005 -0.010 -0.015 -0.034 -0.035 -0.036];
y_shrinky = [0.02 0.045 0.046 -0.005 -0.010 -0.015 -0.033 -0.035 -0.036];
y_shrinky = [y_shrinky flip(y_shrinky(2:end))];


x_top_out_left = [-0.021 -0.029 -0.03 -0.024 -0.0004 -0.001 -0.005 -0.022]-0.002;
y_top_out_left = [0.04 0.045 0.005 -0.002 -8e-6 0.007 0.01 0.031];

x_top_out_right = -x_top_out_left;
y_top_out_right = y_top_out_left;

x_top_in_1_left = [-0.025 -0.022 -0.026 -0.029]-0.002;
y_top_in_1_left = [0.024 0.019 0.0071 0.0076];

x_top_in_1_right= -x_top_in_1_left;
y_top_in_1_right = y_top_in_1_left;


x_top_in_2_left = [-0.025 -0.017 -0.014 -0.025]-0.002;
y_top_in_2_left = [0.005 0.013 0.007 0.001];

x_top_in_2_right = -x_top_in_2_left;
y_top_in_2_right = y_top_in_2_left;

% x_bot_out_left = [-0.031 -0.005 -0.001 -0.002 -0.011 -0.009 -0.023 -0.029];
% y_bot_out_left = [-0.0030   -0.0020   -0.0060   -0.0320   -0.0300   -0.0230   -0.0100   -0.0110];
% 
% x_bot_out_right = -x_bot_out_left;
% y_bot_out_right = y_bot_out_left;
% 
% x_bot_in_1_left = [-0.007 -0.0067 -0.015 -0.017];
% y_bot_in_1_left = [ -0.0040   -0.0070   -0.0120   -0.0070];
% 
% x_bot_in_1_right = -x_bot_in_1_left;
% y_bot_in_1_right = y_bot_in_1_left;
% 
% x_bot_in_2_left = [-0.005 -0.003 -0.006 -0.01];
% y_bot_in_2_left = [-0.0070   -0.0070   -0.0190   -0.0160];
% 
% x_bot_in_2_right = -x_bot_in_2_left;
% y_bot_in_2_right = y_bot_in_2_left;

x_bot_out_left = [-0.031 -0.005 -0.001 -0.002 -0.011 -0.009 -0.023 -0.029] - 0.002;
y_bot_out_left = [-0.0030   -0.0020   -0.0060   -0.0320   -0.0300   -0.0230   -0.0100   -0.0110];

x_bot_out_right = -x_bot_out_left;
y_bot_out_right = y_bot_out_left;

x_bot_in_1_left = [-0.007 -0.0067 -0.015 -0.017]-0.002;
y_bot_in_1_left = [ -0.0040   -0.0070   -0.0120   -0.0070];

x_bot_in_1_right = -x_bot_in_1_left;
y_bot_in_1_right = y_bot_in_1_left;

x_bot_in_2_left = [-0.005 -0.003 -0.006 -0.01]-0.002;
y_bot_in_2_left = [-0.0070   -0.0070   -0.0190   -0.0160];

x_bot_in_2_right = -x_bot_in_2_left;
y_bot_in_2_right = y_bot_in_2_left;



gd = zeros(1000,13);
gd(1:2+2*length(x_shrinky),1) = [2 length(x_shrinky) x_shrinky y_shrinky]';
gd(1:2+2*length(x_top_out_left),2) = [2 length(x_top_out_left) x_top_out_left y_top_out_left]';
gd(1:2+2*length(x_top_out_right),3) = [2 length(x_top_out_right) x_top_out_right y_top_out_right]';
gd(1:2+2*length(x_top_in_1_left),4) = [2 length(x_top_in_1_left) x_top_in_1_left y_top_in_1_left]';
gd(1:2+2*length(x_top_in_1_right),5) = [2 length(x_top_in_1_right) x_top_in_1_right y_top_in_1_right]';
gd(1:2+2*length(x_top_in_2_left),6) = [2 length(x_top_in_2_left) x_top_in_2_left y_top_in_2_left]';
gd(1:2+2*length(x_top_in_2_right),7) = [2 length(x_top_in_2_right) x_top_in_2_right y_top_in_2_right]';
gd(1:2+2*length(x_bot_out_left),8) = [2 length(x_bot_out_left) x_bot_out_left y_bot_out_left]';
gd(1:2+2*length(x_bot_out_right),9) = [2 length(x_bot_out_right) x_bot_out_right y_bot_out_right]';
gd(1:2+2*length(x_bot_in_1_left),10) = [2 length(x_bot_in_1_left) x_bot_in_1_left y_bot_in_1_left]';
gd(1:2+2*length(x_bot_in_1_right),11) = [2 length(x_bot_in_1_right) x_bot_in_1_right y_bot_in_1_right]';
gd(1:2+2*length(x_bot_in_2_left),12) = [2 length(x_bot_in_2_left) x_bot_in_2_left y_bot_in_2_left]';
gd(1:2+2*length(x_bot_in_2_right),13) = [2 length(x_bot_in_2_right) x_bot_in_2_right y_bot_in_2_right]';


g = decsg(gd);
model = createpde;
geometryFromEdges(model,g);


%% Plot the geometry (for simple check)

figure(1);
pdegplot(model,'FaceLabels','on')
axis equal

figure(2)
FEMesh = generateMesh(model);
pdemesh(FEMesh)
hold on
cutOutElements = findElements(FEMesh,'region','Face',[2 5 7 9]); % Define the kirigiami elements
pdemesh(FEMesh.Nodes, FEMesh.Elements(:,cutOutElements),'EdgeColor','green');
hold off

end

