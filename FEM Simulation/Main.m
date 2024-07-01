%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%    This code is for Shrinky Dink simulation  %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% close all;
% clear all;
% clc;

abaqus_addr = '/home/sci02/abaqus/Commands/abaqus'; % Location to abaqus on the computer
template_file = "template.inp"; % Template input file. Can be replaced within a shape case if required.

addpath("Mesh Generation Functions/");
addpath("STL Files/");
%% Kirigami Shape
trilayer = 0; %default, set 1 for trilayer simulations
% shape_id =  1; % 1 for Cross Shape, 2 for Lotus, you can add your shape and mesh file here.

outerRadius = 0; % Needed to define nodes for bowl later;
switch shape_id


    case 1
        shape = "bowl"; % Shape name
        % Inputs parameters for Lotus Shape
        outerRadius = 55/1000;  % Outer Radius (m)
        radiusRatio = 0.4; % Ratio of the inner Radius to the Outer Radius
        Nstrips = 8; % Number of lotus petal
        innerRadius = radiusRatio*outerRadius;
        dTheta = 2*pi/16;

        maxMeshSize = outerRadius/20; % max size of mesh
        minMeshSize = maxMeshSize/2; % min size of mesh


        if radiusRatio==1
            [FEMesh, cutOutElements_kir] = cutoutMesh_lotus100(outerRadius,maxMeshSize,minMeshSize);
        else
            [FEMesh, cutOutElements_kir] = cutoutMesh_lotus(innerRadius,outerRadius,...
                Nstrips, dTheta, maxMeshSize, minMeshSize);
        end

        template_file = "template_act.inp";


    case 2
        shape = "pyramid"; % Shape name
        stlfile = "PyramidFaceAll.STL"; % STL file with the kirigiami and substrate
        [FEMesh, cutOutElements_kir] = cutoutMesh_pyramid(stlfile);

    case 3
        shape = "peanut"; % Shape name
        stlfile = "PeanutFaceAll.STL"; % STL file with the kirigiami and substrate
        [FEMesh, cutOutElements_kir] = cutoutMesh_peanut(stlfile);


    case 4
        shape = "butterfly"; % Shape name
        stlfile = "ButterflyFaceAll.STL"; % STL file with the kirigiami and substrate
        [FEMesh, cutOutElements_kir] = cutoutMesh_butterfly(stlfile);
        template_file = "template_butterfly.inp";

    case 5
        shape = "shell"; % Shape name
        stlfile = "ShellFaceAll.STL"; % STL file with the kirigiami and substrate
        [FEMesh, cutOutElements_kir] = cutoutMesh_shell(stlfile);

    case 6
        shape = "mouse"; % Shape name
        stlfile = "MouseFaceAll.STL"; % STL file with the kirigiami and substrate
        [FEMesh, cutOutElements_kir] = cutoutMesh_mouse(stlfile);

    case 7
        shape = "spoon"; % Shape name
        trilayer = 1;
        % Inputs parameters for Spoon Shape
        outerRadius = 35/1000;  % Outer Radius (m)
        radiusRatio = 3/7; % Ratio of the Inner Radius to the Outer Radius
        Nstrips = 8; % Number of lotus petals
        innerRadius = radiusRatio*outerRadius;
        dTheta = 2*pi/16; % Angle required for mesh definition - central angle for cutout
        length_handle = 106/1000;

        maxMeshSize = outerRadius/10; % max size of mesh
        minMeshSize = maxMeshSize/2; % min size of mesh


        [FEMesh, cutOutElements_kir, cutOutElements_sub_bottom, cutOutElements_sub_top]...
            = cutoutMesh_spoon(innerRadius,outerRadius,length_handle, Nstrips, dTheta,...
            maxMeshSize, minMeshSize);


    case 8
        shape = "rimmed_plate"; % Shape name
        trilayer = 1;
        outerRadius = 70/1000; % Outer Radius (m)
        innerRadius = 25/1000; % Inner Radius (m)
        midRadius = 50/1000; % Middle Radius (m)
        Nstrips = 8; % Number of lotus petals
        dTheta = 2*pi/16; % Angle required for mesh definition - central angle for cutout

        maxMeshSize = outerRadius/20; % max size of mesh
        minMeshSize = maxMeshSize/2; % min size of mesh

        [FEMesh, cutOutElements_kir, cutOutElements_sub_bottom, cutOutElements_sub_top]...
            = cutoutMesh_matka(innerRadius, midRadius,outerRadius,Nstrips, dTheta, ...
            maxMeshSize, minMeshSize);


    otherwise
        disp("Please define shape")
        exit()
end

diagnostic = 0; % 1 to delete all abaqus files post simulation, 2 to delete all except odb, otherwise not delete any files


temp_in = 22; % Initial Temperature
temp_final = 132; % Final Temperature
thickness_sub = (0.1) / 1000; % Thickness of the Shrinky Dink Layer
thickness_kir = 1.8 / 1000; % Thickness of the Kirigami Layer

%% material properties

% Shrinky Dink Layer
Es = 4.0421e8;
vs = 0.48;
alphas = -0.01; % Original alphas = -0.005

% Kirigami Layer
Ek=7.6165e8;
vk = 0.48;
alphak = 0; % Original alphak = -0.0001, reduce it to zero for simplification of simulation

mat_param = [ Es, vs, Ek, vk];

stress = -alphas*(temp_final-temp_in)*Es; % Stress on substrate/Shrinky Dink layer due to temperature increase
%% Build and start the simulation

if trilayer == 1
    objfun_kirigami_shell_tri(shape, stress, template_file,...
        thickness_sub, thickness_kir,mat_param,...
        FEMesh, cutOutElements_kir, cutOutElements_sub_bottom, cutOutElements_sub_top,...
        abaqus_addr, diagnostic);
else
    objfun_kirigami_shell(shape,outerRadius, stress, template_file,...
        thickness_sub, thickness_kir,mat_param,...
        FEMesh, cutOutElements_kir,...
        abaqus_addr, diagnostic);
end
