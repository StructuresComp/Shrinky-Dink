# abaqus cae noGUI=readODB -- ODB_NAME
# Currently calculates max height and final strain energy

from odbAccess import *
from abaqusConstants import *

from odbMaterial import *
from odbSection import *

import sys

# This is how to print to terminal
# print >> sys.__stdout__, 'Opening ODB'

odbname = sys.argv[-1]

outputDataFile = 'final-short-' + odbname[:-4] + '-output.txt' # Define output file name
outputDataFile2 = 'final-long-' + odbname[:-4] + '-output.txt' # Define output file name

f = open(outputDataFile, "w")
f2 = open(outputDataFile2, "w")


odb = openOdb(odbname)

# Initiate arrays for x, y, z coordinates
xPoss=[]
yPoss=[]
zPoss=[]

lastFrame = odb.steps['Step-Final'].frames[-1] # Read last frame of the simulation
nodalpos = lastFrame.fieldOutputs['COORD'] # Get nodal coordinates
nodalPosvalues = nodalpos.values

for j in range(len(nodalPosvalues)):
	curNodePos = nodalPosvalues[j].data        
	xPoss.append(curNodePos[0])
	yPoss.append(curNodePos[1])                     
	zPoss.append(curNodePos[2])   

ELSE_field  = lastFrame.fieldOutputs['ELSE'].values # Get elemental strain energy
numEl = len(ELSE_field)
total_E = 0
for j in range(numEl):
    total_E = total_E + ELSE_field[j].data

height  = max(zPoss) - min(zPoss)

# Write to file
f.writelines(["%s\n" % height])
f.writelines(["%s\n" % total_E])	

f.close()

lastFrame = odb.steps['Step-Final'].frames[-1]
nodalPosField = lastFrame.fieldOutputs['COORD']
print >> sys.__stdout__, odb.rootAssembly.instances.keys()
print >> sys.__stdout__, odb.rootAssembly.instances['PART-1-1'].nodeSets.keys()
center = odb.rootAssembly.instances['PART-1-1'].\
    nodeSets['NODEALL']
nodalpos = nodalPosField.getSubset(region=center)  
nodalPosvalues = nodalpos.values
for j in range(len(nodalPosvalues)):
	curNodePos = nodalPosvalues[j].data        
	xPoss.append(curNodePos[0])
	yPoss.append(curNodePos[1])                     
	zPoss.append(curNodePos[2])     
      

f2.writelines(["%s\n" % item  for item in xPoss])
f2.writelines(["%s\n" % item  for item in yPoss])	
f2.writelines(["%s\n" % item  for item in zPoss])	

# f.close()
f2.close()

odb.close()