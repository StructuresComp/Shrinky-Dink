function [FEMesh, cutOutElements_kir, cutOutElements_sub_bottom, cutOutElements_sub_top]...
    = cutoutMesh_spoon(innerRadius,outerRadius,length_handle, ...
    Nstrips, dTheta, ...
    maxMeshSize, minMeshSize)

% innerRadius = inner radius of the cutout circle
% outerRadius = outer radius of the cutout circle
% Nstrips = number of strips/cuts
% dTheta = radial angle of each cut
% maxMeshSize = max size of an element
% minMeshSize = min size of an element
% length_handle = outerRadius*4;
theta = linspace(0, 2*pi, Nstrips+1);
theta = theta(1:end-1); % 0 and 2*pi overlaps

%% Figure out the points on the quadrilateral cuts

% Additional points to capture the circular nature of the circle
Ndiscrete = 4;

ptQuads_x = zeros(Nstrips, (2*Ndiscrete));
ptQuads_y = zeros(Nstrips, (2*Ndiscrete));

for c=1:Nstrips
    th_1 = theta(c) - dTheta/2;
    th_2 = theta(c) + dTheta/2;
    
    th_arr = linspace(th_1, th_2, Ndiscrete);
    innerEdge_x = innerRadius * cos(th_arr);
    innerEdge_y = innerRadius * sin(th_arr);

    th_arr = linspace(th_2, th_1, Ndiscrete);
    outerEdge_x = outerRadius * cos(th_arr);
    outerEdge_y = outerRadius * sin(th_arr);
    
    % Store
    ptQuads_x(c, 1:Ndiscrete) = innerEdge_x;
    ptQuads_x(c, Ndiscrete+1:2*Ndiscrete) = outerEdge_x;
    ptQuads_y(c, 1:Ndiscrete) = innerEdge_y;
    ptQuads_y(c, Ndiscrete+1:2*Ndiscrete) = outerEdge_y;
end

%% Figure out the points on the circle minus quads
% Create a polygon
ptPoly_x = zeros(Nstrips*(2*Ndiscrete), 1);
ptPoly_y = zeros(Nstrips*(2*Ndiscrete), 1);

for c=1:Nstrips
    
    c2 = c + 1;
    if c==Nstrips
        c2 = 1;
    end
    
    th_1 = theta(c)  + dTheta/2;
    th_2 = theta(c2) - dTheta/2;
    if (th_2 < 0)
        th_2 = th_2 + 2*pi;
    end
    
    th_arr = linspace(th_1, th_2, Ndiscrete);
    outerEdge_x = outerRadius * cos(th_arr);
    outerEdge_y = outerRadius * sin(th_arr);
    
    % Store
    counter_i = (c-1)*(2*Ndiscrete) + 1;
    counter_f = (c-1)*(2*Ndiscrete) + Ndiscrete;
    ptPoly_x(counter_i:counter_f) = ptQuads_x(c, 1:Ndiscrete);
    ptPoly_y(counter_i:counter_f) = ptQuads_y(c, 1:Ndiscrete);

    ptPoly_x(counter_f+1:counter_f+Ndiscrete) = outerEdge_x;
    ptPoly_y(counter_f+1:counter_f+Ndiscrete) = outerEdge_y;
end

gMatLength =  1 + 1 + numel(ptPoly_x) * 2;
gd = zeros(gMatLength, Nstrips+2);
% Embed the quadrilateral cuts in the geometry
for c=1:Nstrips
    gd(1, c) = 2;
    gd(2, c) = numel(ptQuads_x(c,:));
    
    counter_i = 3;
    counter_f = 2 + numel(ptQuads_x(c,:));
    gd(counter_i:counter_f, c) = ptQuads_x(c,:);

    counter_i = counter_f + 1;
    counter_f = (counter_i-1) + numel(ptQuads_y(c,:));
    gd(counter_i:counter_f, c) = ptQuads_y(c, :);

end

% Embed the cut-out circle in the geometry
c = Nstrips+1;
gd(1, c) = 2;
gd(2, c) = numel(ptPoly_x);
gd(3:2+numel(ptPoly_x), c) = ptPoly_x(:);
gd(3+numel(ptPoly_y):end, c) = ptPoly_y(:);

ww = outerRadius*dTheta;
start_pt = 0;
end_pt = length_handle;
c= Nstrips + 2;
gd(1, c) = 2;
gd(2, c) = 4;
gd(3:6, c) = [start_pt*cos(dTheta)-ww*sin(dTheta)/2, end_pt*cos(dTheta)-ww*sin(dTheta)/2,...
    end_pt*cos(dTheta)+ww*sin(dTheta)/2, start_pt*cos(dTheta)+ww*sin(dTheta)/2];
gd(7:10, c) = [start_pt*sin(dTheta)+ww*cos(dTheta)/2, end_pt*sin(dTheta)+ww*cos(dTheta)/2,...
    end_pt*sin(dTheta)-ww*cos(dTheta)/2, start_pt*sin(dTheta)-ww*cos(dTheta)/2];

% ww = outerRadius*dTheta*0.6;
% start_pt = outerRadius + (length_handle - outerRadius)/5;
% end_pt = length_handle - (length_handle - outerRadius)/5;
% c= Nstrips + 3;
% gd(1, c) = 2;
% gd(2, c) = 4;
% gd(3:6, c) = [start_pt*cos(dTheta)-ww*sin(dTheta)/2, end_pt*cos(dTheta)-ww*sin(dTheta)/2,...
%     end_pt*cos(dTheta)+ww*sin(dTheta)/2, start_pt*cos(dTheta)+ww*sin(dTheta)/2];
% gd(7:10, c) = [start_pt*sin(dTheta)+ww*cos(dTheta)/2, end_pt*sin(dTheta)+ww*cos(dTheta)/2,...
%     end_pt*sin(dTheta)-ww*cos(dTheta)/2, start_pt*sin(dTheta)-ww*cos(dTheta)/2];

%%
g = decsg(gd);
model = createpde;
geometryFromEdges(model,g);

%% Plot the geometry (for simple check)

figure(1);
pdegplot(model,'FaceLabels','on')
axis equal
Nstrips

%% Mesh it
FEMesh = generateMesh(model,'Hmax', maxMeshSize, 'Hmin', ...
    minMeshSize, 'GeometricOrder', 'linear');
nodes2D = FEMesh.Nodes;

%% Identify which region is the main circular part
add_to_kir_array = [];
add_to_sub_array_top = [];
add_to_sub_array_bottom = [];
for c=[1:Nstrips Nstrips+2:Nstrips+5]
    % Check if there is an element that is very close to zero
    add_to_sub_array_bottom = [add_to_sub_array_bottom;c];
end

for c=[Nstrips+1:Nstrips+3 Nstrips+5] 
    % Check if there is an element that is very close to zero
    add_to_sub_array_top = [add_to_sub_array_top;c];
end

for c=[Nstrips+1:Nstrips+5]
    % Check if there is an element that is very close to zero
    add_to_kir_array = [add_to_kir_array;c];
end
add_to_kir_array

add_to_sub_array_top 
add_to_sub_array_bottom
cutOutElements_kir = findElements(FEMesh,'region','Face', add_to_kir_array);
cutOutElements_sub_top = findElements(FEMesh,'region','Face', add_to_sub_array_top);
cutOutElements_sub_bottom = findElements(FEMesh,'region','Face', add_to_sub_array_bottom);

figure(2);
% F = pdegplot(model, 'FaceLabels','on');

pdeplot(model);
hold on
pdemesh(FEMesh.Nodes, FEMesh.Elements(:,cutOutElements_sub_bottom),'EdgeColor','green');
% pdemesh(FEMesh.Nodes, FEMesh.Elements(:,cutOutElements_kir),'EdgeColor','green');
hold off


return