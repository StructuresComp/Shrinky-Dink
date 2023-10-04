function [FEMesh, cutOutElements] = cutoutMesh_rectangle(L, Xk, Yk,maxMeshSize,minMeshSize)
gMatLength = 50; % Sufficiently Large

gd = zeros(gMatLength, 3);

%% Define the cross kirigami shape and the square substrate shape in 2D
c=1;
gd(1, c) = 2;
gd(1:10, c) = [2,4, -Xk,-Xk,Xk,Xk,Yk, -Yk, -Yk, Yk];dnn=50;
c=c+1;
gd(1:10, c) = [2,4, 0, (L/2)/dnn, 0, -(L/2)/dnn, (L/2)/dnn, 0, -(L/2)/dnn,0];

%% Define the model from the geometry
g = decsg(gd);
model = createpde;
geometryFromEdges(model,g);

%% Plot the geometry (for simple check)
figure(1)
pdegplot(model,'EdgeLabels','off')

%% Mesh the model

FEMesh = generateMesh(model,'Hmax', maxMeshSize, 'Hmin',minMeshSize);

kirigami_cutout=1; %Select the faces which form the kirigiami elements

figure(2)
pdeplot(model);
hold on
cutOutElements = findElements(FEMesh,'region','Face',kirigami_cutout); % Define the kirigiami elements
pdemesh(FEMesh.Nodes, FEMesh.Elements(:,cutOutElements),'EdgeColor','green');
hold off
axis equal
pp=1.1;
xlim([-pp*(L/2),pp*(L/2)])
ylim([-pp*(L/2),pp*(L/2)])
end