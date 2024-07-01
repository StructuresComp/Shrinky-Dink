function meshGen_shell_tri(nodesFile, bcFile, stress,...
    thickness_sub, thickness_kir,...
    FEMesh, cutOutElements_kir, cutOutElements_sub_bottom,cutOutElements_sub_top)

% This functions generates the 3D mesh of the structure from the 2D mesh input given

nodes2D = FEMesh.Nodes; % Nodes per sublayer
x2D = nodes2D(1, :);
y2D = nodes2D(2, :);
num_nodes2D = length(x2D);
el2D = FEMesh.Elements; % Elements per sublayer

nLayers = 1;
zLayers = zeros(3*nLayers+1,1); % Z-coordinate of every sublayer
for i=1:3*nLayers+1
    if i==1
        zLayers(i)=0;
    elseif i<=nLayers+1
        zLayers(i)=(thickness_sub/nLayers)*(i-1);
    elseif i<=2*nLayers+1
        zLayers(i) = thickness_sub + (thickness_kir/nLayers)*(i-nLayers-1);
    elseif i<=3*nLayers+1
        zLayers(i) = thickness_sub + thickness_kir + (thickness_sub/nLayers)*(i-2*nLayers-1);
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
num_el_sub_bottom = numel(cutOutElements_sub_bottom);
num_el_sub_top = numel(cutOutElements_sub_top);
num_el_kir = numel(cutOutElements_kir);
num_el = num_el_sub_bottom + num_el_sub_top + num_el_kir;

el3D = zeros(6, num_el);

for cHeight = 1:nLayers    % Bottom Substrate Layer
    for c2D = 1:numel(cutOutElements_sub_bottom)

        cEl = cutOutElements_sub_bottom(c2D);% element number

        elNo = c2D+num_el_sub_bottom*(cHeight-1);

        offset = num_nodes2D*(cHeight-1);

        el3D(1, elNo) = el2D(1, cEl) + offset;
        el3D(2, elNo) = el2D(2, cEl) + offset;
        el3D(3, elNo) = el2D(3, cEl) + offset;
        el3D(4, elNo) = el2D(1, cEl) + offset + num_nodes2D;
        el3D(5, elNo) = el2D(2, cEl) + offset + num_nodes2D;
        el3D(6, elNo) = el2D(3, cEl) + offset + num_nodes2D;
    end
end

for cHeight = 1:nLayers    % Kirigami Layer
    for c2D = 1:numel(cutOutElements_kir)

        cEl = cutOutElements_kir(c2D);% element number

        elNo = c2D+num_el_kir*(cHeight-1)+nLayers*num_el_sub_bottom;

        offset = num_nodes2D*nLayers +num_nodes2D*(cHeight-1);

        el3D(1, elNo) = el2D(1, cEl) + offset;
        el3D(2, elNo) = el2D(2, cEl) + offset;
        el3D(3, elNo) = el2D(3, cEl) + offset;
        el3D(4, elNo) = el2D(1, cEl) + offset + num_nodes2D;
        el3D(5, elNo) = el2D(2, cEl) + offset + num_nodes2D;
        el3D(6, elNo) = el2D(3, cEl) + offset + num_nodes2D;
    end
end

% Top Substrate Layer
for cHeight = 1:nLayers
    for c2D = 1:numel(cutOutElements_sub_top)

        cEl = cutOutElements_sub_top(c2D); % element number

        elNo = c2D + num_el_kir*(cHeight-1)+nLayers*num_el_kir+nLayers*num_el_sub_bottom;

        offset = num_nodes2D*2*nLayers+num_nodes2D*(cHeight-1);

        el3D(1, elNo) = el2D(1, cEl) + offset;
        el3D(2, elNo) = el2D(2, cEl) + offset;
        el3D(3, elNo) = el2D(3, cEl) + offset;
        el3D(4, elNo) = el2D(1, cEl) + offset + num_nodes2D;
        el3D(5, elNo) = el2D(2, cEl) + offset + num_nodes2D;
        el3D(6, elNo) = el2D(3, cEl) + offset + num_nodes2D;
    end
end


fprintf(fid, '*Element, type=C3D6\n');%% 6-node prismatic solid elements
for c = 1:num_el
    fprintf(fid, '%d, %d, %d, %d, %d, %d, %d \n', c, el3D(1, c),el3D(2, c), ...
        el3D(3, c),el3D(4, c),el3D(5, c), ...
        el3D(6, c));
end
%% Element and Node sets

fprintf(fid, '*Elset, elset=elSubstrateBot, generate\n'); % All elements in the bottom substrate layer
fprintf(fid, '%d, %d, 1\n', 1, num_el_sub_bottom*nLayers);

fprintf(fid, '*Elset, elset=elSubstrateTop, generate\n'); % All elements in the top substrate layer
fprintf(fid, '%d, %d, 1\n', (num_el_sub_bottom+num_el_kir)*nLayers+1,...
    (num_el_sub_bottom+num_el_kir)*nLayers+num_el_sub_top*nLayers);

fprintf(fid, '*Elset, elset = elKir, generate\n'); % All elements in the kirigami layer
fprintf(fid,'%d, %d, 1\n',num_el_sub_bottom*nLayers+1,num_el_sub_bottom*nLayers+num_el_kir*nLayers);

fprintf(fid,'*Nset, nset = NodeAll, generate\n'); % All nodes
fprintf(fid,'%d, %d, 1\n', 1, num_nodes);

% List of nodes that are connected to atleast one element
list_nodes = unique(el3D(:,nLayers*num_el_sub_bottom+1:num_el_sub_bottom*nLayers+num_el_kir*nLayers));
temp = list_nodes-nLayers*num_nodes2D;

x2D_connected = x2D(temp<num_nodes2D);
y2D_connected = y2D(temp<num_nodes2D);

%  Center Node
% Find node located at (0,0) at the center of the composite
xDesired = 0.0;
yDesired = 0.0;
dist = sqrt( (x2D_connected- xDesired).^2 + (y2D_connected - yDesired).^2 );
[~, minInd] = min(dist);
for i=1:nLayers
    fprintf(fid, '*Nset, nset=centerNode%d\n%d\n', i, minInd+num_nodes2D*(i-1));
end

fprintf(fid, '*Solid Section, elset=elSubstrateTop, material=Material-Substrate, orientation=OR1\n');
fprintf(fid, '*Solid Section, elset=elSubstrateBot, material=Material-Substrate, orientation=OR1\n');
fprintf(fid, '*Solid Section, elset=elKir, material=Material-Kirigami, orientation=OR1\n');

fclose(fid);


%% Boundary Conditions and Stresses

fid = fopen(bcFile,'w');
% Fix the center node of the composite
fprintf(fid,'**Name: BC1 Type: Displacement/Rotation\n');
fprintf(fid,'*Boundary\n');
for i = 1:nLayers
    fprintf(fid,'centerNode%d, 3, 3, %f\n',i,0.0);
end


% % Initiate Pre-stretch in terms of initial stress conditions
fprintf(fid,'**\n** PREDIFINED FIELDS\n**\n');
fprintf(fid,'*Initial Conditions, type = stress\n');
fprintf(fid,'ElSubstrateTop, %f, %f, %f\n', stress,stress,0);
fprintf(fid,'ElSubstrateBot, %f, %f, %f\n', stress,stress,0);

fclose(fid);
