function [FEMesh, cutOutElements_kir] = cutoutMesh_lotus100(outerRadius,...
    maxMeshSize, minMeshSize)
% plot a circle for the geometry for radius ratio = 1
gd = [1;0;0;outerRadius];

%%
g = decsg(gd);
model = createpde;
geometryFromEdges(model,g);

%% Plot the geometry (for simple check)

figure(1);
pdegplot(model,'VertexLabels','on')
axis equal


%% Mesh it
FEMesh = generateMesh(model,'Hmax', maxMeshSize, 'Hmin', ...
    minMeshSize);
%% Identify which region is the main circular part
cutOutElements_kir = findElements(FEMesh,'region','Face', 1);
figure(2);
% F = pdegplot(model, 'FaceLabels','on');
pdeplot(model);
hold on
% pdemesh(FEMesh.Nodes, FEMesh.Elements(:,cutOutElements),'EdgeColor','green');
hold off
% size(FEMesh.Nodes)
return