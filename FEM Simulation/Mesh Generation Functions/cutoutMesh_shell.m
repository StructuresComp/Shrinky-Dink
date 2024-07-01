function [FEMesh, cutOutElements] = cutoutMesh_shell(stlfile)
model = createpde;

gm = importGeometry(model,stlfile);

pdegplot(model,"FaceLabels","on")
scale(gm,0.001);

center = mean(gm.Vertices);
translate(gm,[-center(1),-center(2)])
FEMesh = generateMesh(model,Hedge={1:87,0.001},Hmin=0.0001);
pdemesh(FEMesh,"NodeLabels","on")
hold on
cutOutElements = findElements(FEMesh,'region','Face',1); % Define the kirigiami elements
pdemesh(FEMesh.Nodes, FEMesh.Elements(:,cutOutElements),'EdgeColor','green');
hold off

end