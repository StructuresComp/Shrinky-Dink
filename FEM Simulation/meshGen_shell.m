function meshGen_shell(shape, outerRadius, nodesFile, bcFile, stress,...
    thickness_sub, thickness_kir,...
    FEMesh, cutOutElements_kir)

% This functions generates the 3D mesh of the structure from the 2D mesh input given

nodes2D = FEMesh.Nodes; % Nodes per sublayer
x2D = nodes2D(1, :);
y2D = nodes2D(2, :);
num_nodes2D = length(x2D);
el2D = FEMesh.Elements; % Elements per sublayer
[~,num_el2D] = size(el2D);

nLayers = 1;
zLayers = zeros(3*nLayers+1,1); % Z-coordinate of every sublayer
for i=1:3*nLayers+1
    if i==1
        zLayers(i)=0;
    elseif i<=nLayers+1
        zLayers(i)=(thickness_kir/nLayers)*(i-1);
    elseif i<=2*nLayers+1
        zLayers(i) = thickness_kir + (thickness_sub/nLayers)*(i-nLayers-1);
    elseif i<=3*nLayers+1
        zLayers(i) = thickness_kir + thickness_sub + (thickness_kir/nLayers)*(i-2*nLayers-1);
    end
end

%%
fid = fopen(nodesFile, 'w'); %% write nodes and elements to file

%% Nodes
fprintf(fid, '*Node\n');

for cHeight=1:length(zLayers)
    for c2D = 1:num_nodes2D
        nodeNo = c2D + (cHeight-1)*num_nodes2D;
        z = zLayers(cHeight); % z = 0 for shell element

        fprintf(fid, '%d, %f, %f, %f\n', nodeNo, x2D(c2D), y2D(c2D), z);
    end
end
num_nodes = (3*nLayers+1)*num_nodes2D;
%% Elements
num_el_kir = numel(cutOutElements_kir);
num_el = nLayers*(num_el2D + num_el_kir);


el3D = zeros(6, num_el);

for cHeight = 1:nLayers    % Bottom Kirigami Layer
    for c2D = 1:numel(cutOutElements_kir)

        cEl = cutOutElements_kir(c2D);% element number

        elNo = c2D+num_el_kir*(cHeight-1);

        offset = num_nodes2D*(cHeight-1);

        el3D(1, elNo) = el2D(1, cEl) + offset;
        el3D(2, elNo) = el2D(2, cEl) + offset;
        el3D(3, elNo) = el2D(3, cEl) + offset;
        el3D(4, elNo) = el2D(1, cEl) + offset + num_nodes2D;
        el3D(5, elNo) = el2D(2, cEl) + offset + num_nodes2D;
        el3D(6, elNo) = el2D(3, cEl) + offset + num_nodes2D;
    end
end

for cHeight = 1:nLayers   %Substrate Layer
    for c2D = 1:num_el2D
        elNo = c2D +num_el2D*(cHeight-1)+nLayers*num_el_kir;

        offset = num_nodes2D*nLayers+num_nodes2D*(cHeight-1);

        el3D(1, elNo) = el2D(1, c2D) + offset;
        el3D(2, elNo) = el2D(2, c2D) + offset;
        el3D(3, elNo) = el2D(3, c2D) + offset;
        el3D(4, elNo) = el2D(1, c2D) + offset + num_nodes2D;
        el3D(5, elNo) = el2D(2, c2D) + offset + num_nodes2D;
        el3D(6, elNo) = el2D(3, c2D) + offset + num_nodes2D;
    end
end


fprintf(fid, '*Element, type=C3D6\n'); %% 6-node prismatic solid elements
for c = 1:num_el
    fprintf(fid, '%d, %d, %d, %d, %d, %d, %d \n', c, el3D(1, c),el3D(2, c), ...
        el3D(3, c),el3D(4, c),el3D(5, c), ...
        el3D(6, c));
end
%% Element and Node sets

fprintf(fid, '*Elset, elset=elSubstrate, generate\n'); % all elements in the substrate layer
fprintf(fid, '%d, %d, 1\n', num_el_kir*nLayers+1, num_el_kir*nLayers+num_el2D*nLayers);

fprintf(fid, '*Elset, elset = elBot, generate\n'); % all elements in the Kirigami layer
fprintf(fid,'%d, %d, 1\n',1, num_el_kir*nLayers);

fprintf(fid,'*Nset, nset = NodeAll, generate\n'); % all nodes
fprintf(fid,'%d, %d, 1\n', 1, num_nodes);

% List of nodes that are connected to atleast one element
list_nodes = unique(el3D(:,nLayers*num_el_kir+1:nLayers*num_el_kir+num_el2D));
temp = list_nodes-nLayers*num_nodes2D;

x2D_connected = x2D(temp<=num_nodes2D);
y2D_connected = y2D(temp<=num_nodes2D);

%  Center Node
% Find node located at (0,0) at the center of the composite
xDesired = 0.0;
yDesired = 0.0;
dist = sqrt( (x2D_connected- xDesired).^2 + (y2D_connected - yDesired).^2 );
[~, minInd] = min(dist);
for i = 1: nLayers
    fprintf(fid, '*Nset, nset=centerNode%d\n%d\n', i, minInd+num_nodes2D*(nlayers*i-1));
end


if shape == "bowl"
    yDesired = outerRadius*sind(22.5);
    xDesired = outerRadius*cosd(22.5);
    dist = sqrt( (x2D_connected - xDesired).^2 + (y2D_connected - yDesired).^2 );
    [~, minInd1] = min(dist);

    yDesired = outerRadius*sind(-22.5);
    xDesired = outerRadius*cosd(-22.5);
    dist = sqrt( (x2D_connected - xDesired).^2 + (y2D_connected - yDesired).^2 );
    [~, minInd2] = min(dist);

    yDesired = outerRadius*sind(112.5);
    xDesired = outerRadius*cosd(112.5);
    dist = sqrt( (x2D_connected - xDesired).^2 + (y2D_connected - yDesired).^2 );
    [~, minInd3] = min(dist);

    yDesired = outerRadius*sind(-112.5);
    xDesired = outerRadius*cosd(-112.5);
    dist = sqrt( (x2D_connected - xDesired).^2 + (y2D_connected - yDesired).^2 );
    [~, minInd4] = min(dist);

    yDesired = outerRadius*sind(67.5);
    xDesired = outerRadius*cosd(67.5);
    dist = sqrt( (x2D_connected - xDesired).^2 + (y2D_connected - yDesired).^2 );
    [~, minInd5] = min(dist);

    yDesired = outerRadius*sind(-67.5);
    xDesired = outerRadius*cosd(-67.5);
    dist = sqrt( (x2D_connected - xDesired).^2 + (y2D_connected - yDesired).^2 );
    [~, minInd6] = min(dist);

    yDesired = outerRadius*sind(-157.5);
    xDesired = outerRadius*cosd(-157.5);
    dist = sqrt( (x2D_connected - xDesired).^2 + (y2D_connected - yDesired).^2 );
    [~, minInd7] = min(dist);

    yDesired = outerRadius*sind(157.5);
    xDesired = outerRadius*cosd(157.5);
    dist = sqrt( (x2D_connected - xDesired).^2 + (y2D_connected - yDesired).^2 );
    [~, minInd8] = min(dist);
    fprintf(fid, '*Nset, nset=NodesBoundary\n%d,%d,%d,%d,%d,%d,%d,%d\n'...
        ,minInd1,minInd2,minInd3,minInd4 ,minInd5,minInd6,minInd7,minInd8);

end
fprintf(fid, '*Solid Section, elset=elSubstrate, material=Material-Substrate, orientation=OR1\n');
fprintf(fid, '*Solid Section, elset=elBot, material=Material-Kirigami, orientation=OR1\n');



fclose(fid);


%% Boundary Conditions and Stresses


fid = fopen(bcFile,'w');
% Fix the center node of the composite
fprintf(fid,'**Name: BC1 Type: Displacement/Rotation\n');
if shape == "bowl" % Only for bowl
    fprintf(fid,'*Boundary\n');
    fprintf(fid,'NodesBoundary, 3, 3, %f\n',0.0);
else
    fprintf(fid,'*Boundary\n');
    for i = 1:nLayers
        fprintf(fid,'centerNode%d, 3, 3, %f\n',i,0.0);
    end
end



% % Initiate Pre-stretch in terms of initial stress conditions
fprintf(fid,'**\n** PREDIFINED FIELDS\n**\n');
fprintf(fid,'*Initial Conditions, type = stress\n');
fprintf(fid,'ElSubstrate, %f, %f, %f\n', stress,stress,0);

fclose(fid);
