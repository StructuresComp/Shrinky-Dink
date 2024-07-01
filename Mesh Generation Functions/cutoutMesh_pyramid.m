function [FEMesh, cutOutElements] = cutoutMesh_pyramid(stlfile)
model = createpde;

gm = importGeometry(model,stlfile);

pdegplot(model,"FaceLabels","on")
scale(gm,0.001);
center = mean(gm.Vertices);
translate(gm,[-center(1),-center(2)])
FEMesh = generateMesh(model,"GeometricOrder","quadratic");
pdemesh(FEMesh)
hold on
cutOutElements = findElements(FEMesh,'region','Face',1); % Define the kirigiami elements
pdemesh(FEMesh.Nodes, FEMesh.Elements(:,cutOutElements),'EdgeColor','green');
hold off

end