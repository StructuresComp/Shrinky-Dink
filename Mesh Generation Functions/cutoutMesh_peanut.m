function [FEMesh, cutOutElements] = cutoutMesh_peanut(stlfile)
model = createpde;

gm = importGeometry(model,stlfile);

pdegplot(model,"FaceLabels","on")
scale(gm,0.001);
center = mean(gm.Vertices);
translate(gm,[-center(1),-center(2)])
FEMesh = generateMesh(model,"Hedge",{1,0.001}, "GeometricOrder","quadratic");
pdemesh(FEMesh,"NodeLabels","on")
hold on
cutOutElements = findElements(FEMesh,'region','Face',1:2); % Define the kirigiami elements
pdemesh(FEMesh.Nodes, FEMesh.Elements(:,cutOutElements),'EdgeColor','green');
hold off

end