<!-- Add title -->
# ABAQUS Simulation of Soft Kirigami Structures


<!-- Add description -->
## Description
This repository contains the files used to simulate the soft kirigami structures in the paper "Directed Shape Morphing using Kirigami-enhanced Thermoplastics" by
Mrunmayi Mungekar, Sanjith Menon, M. Ravi Shankar, and M. Khalid Jawed.

<!-- Add table of contents -->
## Table of Contents
- [Title](#title)
- [Description](#description)
- [Table of Contents](#table-of-contents)
- [Pre-requisites](#pre-requisites)
- [Files](#files)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)


## Pre-requisites
The code is written for ABAQUS 2018 and MATLAB R2024a. The MATLAB code is used to generate the input files for ABAQUS and the Python code is used to post-process the results. Ensure you have a running version of these softwares installed on your system.

## Files
All the simulation files are under the folder FEM Simulation
1. > Main Code: <br>
_Main.m_ - This file contains the inputs to the code such as material and geometric properties, pre-stretch, kirigami design, etc. You can also decide what structure you want to simulate and based on that select the bilayer or trilayer (for combination structures) mode.
2. > Template file for ABAQUS input: <br>
_template.inp_ - This is the template input file for ABAQUS for planar to 3D simulations. The code will generate a new input file for each kirigami design based on this template. <br>
_template_butterfly.inp_ - This is a customized template file for complex shape of a butterfly. You can create your own file based on change in requirements <br>
_template_act.inp _- This template file includes the steps required to actuate a bistable structure. If your 3D structure is bistable, you can use this to enable actuation between stable states. 
3. > Basic mesh generation: <br>
_Mesh Generation Functions Folder_: These files are used to generate the mesh design for ABAQUS for different shapes. It creates the Shrinky Dink and Kirigami base mesh for all structures which is later enhanced in the meshGen_shell files. We have provided mesh generation files for examples in the manuscrip. You can add the base mesh your own customized shape here.
4. > Run ABAQUS with input <br>
_objfun_kirigami_shell.m_ - The Main file runs this function for bilayered structures. The main goal of this function is to start/stop ABAQUS, run the various functions required for the simulation, and post-process the results. <br>
_objfun_kirigami_shell_tri.m_ - The Main file runs this function instead for trilayered combination structures. 
5. > Mesh Enhancement <br>
_meshGen_shell.m_ - This function generates the 3D mesh for the kirigami structure from the design described in the cuoutMesh files. This data then populates the various files that ABAQUS requires as input. <br>
_meshGen_shell_tri.m_ - This function is used instead for trilayered combination structures. 
6. > Populate input file <br>
_write_input_file.m_ - This function modifies the input file as required by the codes input.
7. > Read Results <br>
_readODB.py_ - This file is used to post-process the results from ABAQUS. It reads the .odb file. Currently, it provides overall node coordinates for the structure, but can be modified according to user requirements.

## Usage
1. Download the code or pull it from this github repo. 
2. Start ABAQUS license and note the address for your ABAQUS files
3. Design a mesh for your kirigami structure and add it to the Mesh Generation Function Folder. The code currently supports kirigami designs from the manuscript. You can modify the code to support other designs as well.
<!--
<figure class="half" style="display:flex">
    <figure>
    <img style="scale:50%" src="images/cross_mesh.png">
        <figcaption>Cross-shaped Kirigami, Square-shaped substrate</figcaption>
    </figure>
    <figure>
    <img style="scale:50%" src="images/lotus_mesh.png">
        <figcaption>Lotus-shaped Kirigami, Circle-shaped substrate</figcaption>
    </figure>

</figure> 
-->
4. You can add a customized template .inp file for complex shapes if required
5. Once this is done, you have to change only the Main file of the code to run the simulation. The following changes need to be made based on your requirements:
* > Enter your ABAQUS address in abaqus_addr
* > template_file notes to the default template file. Do not change this. This is in case you forget to define one later.
* > trilayer = 0 by default. You can either change it here for three-layered structures or change it in the switch case section
* > In the switch section, add your new shape as a case. Case 1-8 correspond to structures in the manuscript. Do the following for each: <br>
      > Define shape name<br>
      > Set trilayer to 1. The rest of the code files will adjust accordingly <br>
      > Define geometry required for mesh generation <br>
      > Define maximum and minimum mesh sizes based on time and accuracy <br>
      > Define STL file, if necessary for your mesh generation <br>
      > Generate mesh using your mesh generation file <br>
      > Define template file. You can skip this if default file is to be used <br>
* > Temperature conditions, material thicknesses can be defined here <br>
* > Material: The code is build on linear approximations (required E, &nu and &alpha). But you can modify the code to use other material types as well. Change the mat_param array and template file accordingly

(If you need to modify further details or any ABAQUS simulation parameters, you can look at [Files](#files) section to understand the files and modify them accordingly.)

5. Start your ABAQUS license and run the Main file. It will generate the input files for ABAQUS and run the simulation. It will also post-process the results and save them in a .txt file. You can also check the .odb file to see the results of the simulation. <br>
(Check the progress of your code in the .sta file. Any errors will be displayed in either the .log, .dat or .msg file.)

## Disclaimer
This code does not account for contact modelling. Hence, it is not designed for too high deformations.
<!-- Add contributing -->
## Contributing
Feedback is welcome! For major changes, please open an issue first to discuss what you would like to change.

## Acknowledgments
We acknowledge financial support from the National Science Foundation (grants: CMMI-2332555 and CMMI-2053971).

<!-- License -->
## License


