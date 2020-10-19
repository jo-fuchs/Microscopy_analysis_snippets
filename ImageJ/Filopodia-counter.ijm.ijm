// Counts Filopodia around a cell
//    as intensity maxima on a line 1 µm outside of cell mask
//
// on Max-Projections, make sure to exclude long thin processes
// Calibration points:
//   - Threshold
//   - Filopodia-detection threshold
//
//
// v0.1 19.10.2020 Joachim Fuchs
//

path = getDirectory("image");
imgName = getTitle();
Channel = getValue("Ch");
run("Line Width...", "line="+5); 
run("Select None");
roiManager("deselect");

run("Duplicate...", "duplicate");
roiManager("Select", 0);
rName = Roi.getName;
run("Median...", "radius=2 slice");
setAutoThreshold("Huang dark");
//run("Analyze Particles...", "size=200-Infinity clear add slice");
run("Analyze Particles...", "size=200-Infinity clear include add slice");
close();
roiManager("Select", 0);

// remove some long thin processes
run("Enlarge...", "enlarge=-1");

run("Enlarge...", "enlarge=2.5");

run("Area to Line");
roiManager("add");
roiManager("Select", 1);
Length = getValue("Length");
//Stack.setChannel(4);
/// have an adaptable threshold depending on intensities of the lines
roiManager("measure");
intens = getResult("Mean", 0);



run("Plot Profile");

run("Find Peaks", "min._peak_amplitude=" + intens + " min._peak_distance=0 min._value=NaN max._value=0 exclude list");

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

saveAs("Results", path + imgName+ rName + "_Filopodia.csv");


//Clear
// clean up
run("Close All");
roiManager("Deselect");
roiManager("Save", path + imgName + rName + ".zip");
roiManager("Delete");

list = getList("window.titles");
 for (i=0; i<list.length; i++){
 winame = list[i];
  selectWindow(winame);
 run("Close");
 }