%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%    This code is for soft kirigami simulation  %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;
clc;

trilayer = 0; % 1 for trilayer, else for bilayer
abaqus_addr = '/home/sci02/abaqus/Commands/abaqus'; % Location to abaqus on the computer

%% Kirigami Shape
shape_id = 2; % 1 for Cross Shape, 2 for Lotus, you can add your shape and mesh file here.

switch shape_id
    case 1
        % Inputs parameters for Cross Shape
        L = 150/1000;  % Length of the Cross Shape (m)
        H=1.5/100; % Height of the Cross Shape (m)
        Xk=H/2; % X coordinate required for mesh definition
        Yk=sqrt((L/2)^2-Xk^2); % Y coordinate
%         Xk = 30/1000;
%         Yk = 10/1000;
        main_dimension = L/2;
        maxMeshSize = main_dimension/40; % max size of mesh
        minMeshSize = maxMeshSize/2; % min size of mesh
        
%         [FEMesh, cutOutElements] = cutoutMesh_rectangle(L, Xk, Yk,maxMeshSize,minMeshSize);
        [FEMesh, cutOutElements] = cutoutMesh_cross(L, Xk, Yk,maxMeshSize,minMeshSize);
    case 2
        % Inputs parameters for Lotus Shape
        R = 60/100;  % OuterRadius (m)
        radiusRatio = 0.5; % Ratio of the inner Radius to the Outer Radius
        Nstrips = 8; % Number of lotus petal-lls
        innerRadius = radiusRatio*R;        
        alpha = 0.5; % Percentage Material removed
        dTheta = 2*pi*alpha/Nstrips; % Angle required for mesh definition - central angle for cutout
        
        main_dimension = R;
        maxMeshSize = main_dimension/40; % max size of mesh
        minMeshSize = maxMeshSize/2; % min size of mesh
        
        [FEMesh, cutOutElements] = cutoutMesh_lotus(innerRadius,R,...
            Nstrips, dTheta, maxMeshSize, minMeshSize);
        
    case 3
        % Inputs parameters for Cross Shape
        L = 150/1000;  % Length of the Cross Shape (m)
        H= 1.5/100; % Height of the Cross Shape (m)
%         Xk=H/2; % X coordinate required for mesh definition
%         Yk=sqrt((L/2)^2-Xk^2); % Y coordinate
        Xk =L;
        Yk = H;
        main_dimension = Xk/2;
        maxMeshSize = main_dimension/20; % max size of mesh
        minMeshSize = maxMeshSize/2; % min size of mesh
        
        [FEMesh, cutOutElements] = cutoutMesh_rectangle(L, Xk, Yk,maxMeshSize,minMeshSize);
%         [FEMesh, cutOutElements] = cutoutMesh_cross(L, Xk, Yk,maxMeshSize,minMeshSize);
        
        
    otherwise 
        disp("Please define shape")
        exit()        
end

diagnostic = 0; % 1 to delete all abaqus files post simulation, 2 to delete all except odb, otherwise not delete any files
%%
% lambda = 1.01; % Substrate prestretch

temp_in = 24.4;
temp_final = 40;
thickness_1 = (0.1) / 1000; % Thickness of the substrate | reduce thickness b/c of post-stretching, divided by 2-2*lambda
thickness_2 = 1.8 / 1000; % Thickness of the kirigami

%% material properties
% Mooney-Rivlin Parameters
% Substrate
% C1s = 2.206e4; 
% C2s = 1656;
% D1s = 0.00001;
Es = 6.55e8;
vs = 0.49;
alphas = -0.005;
%Kirigami
% C1k = 1.788e4;
% C2k = 8.445e4;
% D1k = 0.00001;
% 1.8055
% Ek = Es*1.1269;
Ek=7.55e8;
vk = 0.49;
alphak1 = -0.0001;
alphak2 = -0.0012;
alphak3 = -0.0025;
alphak4 = -0.0037;
alphak5 = -0.005;

% mat_param = [C1s, C2s, D1s, C1k, C2k, D1k];
% mat_param = [ Es, vs, alphas, Ek, vk, alphak1, alphak2,alphak3,alphak4,alphak5];
mat_param = [ Es, vs, alphas, Ek, vk, alphak1, alphak3,alphak5];
%% Stress Calculation
% I1 = 2*lambda^2 + 1/lambda^4; % stress invariant
% dI1 = 4*lambda - 4/lambda^5; % derivative of stress invariant
% stress = 2*C1s*(lambda^2-1/lambda^4)-2*C2s*(1/lambda^2-lambda^4); % stress calculation from pre-stretch

%% Build and start the simulation

objfun_kirigami_shell(main_dimension, temp_in, temp_final, ...
    thickness_1, thickness_2, mat_param,...
    FEMesh, cutOutElements,...
    abaqus_addr, diagnostic, trilayer);



1