function [FEMesh, cutOutElements] = cutoutMesh_butterfly(stlfile)
model = createpde;

gm = importGeometry(model,stlfile);

figure(1)
pdegplot(model,"FaceLabels","on")
scale(gm,0.001);
center = mean(gm.Vertices);
translate(gm,[-center(1),-center(2)])
figure(2)
FEMesh = generateMesh(model,"Hedge",{1:gm.NumEdges,0.0001});
pdemesh(FEMesh,"NodeLabels","on")
hold on
cutOutElements = findElements(FEMesh,'region','Face',[3 6 7 11]); % Define the kirigiami elements
pdemesh(FEMesh.Nodes, FEMesh.Elements(:,cutOutElements),'EdgeColor','green');
hold off
end