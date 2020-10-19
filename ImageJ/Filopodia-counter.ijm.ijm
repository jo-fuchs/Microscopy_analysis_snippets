// Counts Filopodia around a cell
//    as intensity maxima on a line 1 µm outside of cell mask
//
// on Max-Projections, make sure to exclude long thin processes
// Calibration points:
//   - Threshold
//   - Filopodia-detection threshold
//
//
// v0.2 19.10.2020 Joachim Fuchs
//

// set up results
run("Input/Output...", "jpeg=100 gif=-1 file=.csv save_column");
run("Set Measurements...", "area mean standard median display redirect=None decimal=2");

path = getDirectory("image");
dirimg = path + "Filopodia/";
File.makeDirectory(dirimg); 
imgName = getTitle();
Channel = getValue("Ch");
run("Line Width...", "line="+5); 
run("Select None");
roiManager("deselect");


// refine cell ROI
run("Duplicate...", "duplicate");
roiManager("Select", 0);
rName = Roi.getName;
run("Median...", "radius=2 slice");
setAutoThreshold("Huang");
run("Analyze Particles...", "size=200-Infinity clear include add slice");
close();
roiManager("Select", 0);


// remove some long thin processes, enlarge by 1 µm
run("Enlarge...", "enlarge=-1");
run("Enlarge...", "enlarge=2");
	// remove unconnected parts & fill holes
	run("Create Mask");
	run("Analyze Particles...", "size=200-Infinity include add");
	run("Close");
	roiManager("Select", 1);

run("Area to Line");
roiManager("add");
roiManager("Select", 2);
Length = getValue("Length");

/// have an adaptable threshold depending on intensities of the lines
roiManager("measure");
selectWindow(imgName);
intens = getResult("Median", 0);


run("Plot Profile");
run("Find Peaks", "min._peak_amplitude=" + intens + 
	" min._peak_distance=1.5 min._value=NaN max._value=0 exclude list");

//Get number of maxima
selectWindow("Plot Values");
a = Table.getColumn("X1");
Filos = lengthOf(a);
run("Close");

dens = Filos / Length;

// Create Results
run("Clear Results");
setResult("Image", 0, imgName);
setResult("Channel", 0, Channel);
setResult("Length", 0, Length);
setResult("FiloNumber", 0, Filos); 
setResult("FiloDensity", 0, dens); 

saveAs("Results", dirimg + imgName+ rName + "_Filopodia.csv");


//Clear
// clean up
run("Close All");
roiManager("Deselect");
roiManager("Save", dirimg + imgName + rName + ".zip");
roiManager("Delete");

list = getList("window.titles");
 for (i=0; i<list.length; i++){
 winame = list[i];
  selectWindow(winame);
 run("Close");
 }