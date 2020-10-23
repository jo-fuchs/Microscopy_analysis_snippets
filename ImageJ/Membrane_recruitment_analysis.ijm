// Plasma membrane recruitment analysis
// 
//  Measures intensity at cell surface, intracellular & perinuclear
//    
// requires manual selection of cell of interest on single z-Planes, 
// requires membrane marker (fGFP or F-actin) and Dapi
//    creates 1µm thick band to measure intensity (mean & median)
//    ROIs saved as Image_ROI.zip
//    Intensities saved as Image_ROI.csv
//
// Settings to be adjusted:
//    Membrane marker channel, Dapi channel 
//
// v0.1 22.10.2020 Joachim Fuchs
//


// set up results
run("Input/Output...", "jpeg=100 gif=-1 file=.csv save_column");
run("Set Measurements...", "area mean standard median display redirect=None decimal=2");
path = getDirectory("Choose a Directory");
imgName = getTitle();
Stack.getPosition(channel, slice, frame)
run("Select None");
roiManager("deselect");


// refinement of selection
run("Duplicate...", "duplicate");
roiManager("Select", 0);
ROIname = getInfo("roi.name"); 
Stack.setPosition(1, slice, frame)  // best case set: Actin channel
run("Median...", "radius=2 slice");
setAutoThreshold("Huang dark");
run("Analyze Particles...", "size=200-Infinity clear include add slice");
close();

// Plasma membrane Selection
roiManager("Select", 0);
Stack.getPosition(channel, slice, frame)
run("Enlarge...", "enlarge=-1.2");
run("Make Band...", "band=1");
roiManager("add");
roiManager("Deselect");


// Intracellular selection
run("Select None");
roiManager("Select", 0);
run("Enlarge...", "enlarge=-3");
	// Secure against unconnected ROIs remove unconnected parts & fill holes
	run("Create Mask");
	run("Analyze Particles...", "size=100-Infinity include add");
	run("Close");
	
roiManager("Select", 2);
run("Make Band...", "band=1");
roiManager("add");

roiManager("Select", 2);
roiManager("delete");

// perinuclear selection
run("Select None");
run("Duplicate...", "duplicate");
roiManager("Select", 0);
Stack.setPosition(2, slice, frame)  // Dapi channel
run("Median...", "radius=2 slice");
setAutoThreshold("Moments dark");
run("Analyze Particles...", "size=70-Infinity add include slice");

// This fails for multiple nuclei > merge multiple nuclei before
n = roiManager("Count");
a = Array.getSequence(n);
a = Array.slice(a,3,n);
if(a.length > 1) { // only if multiple nuclei
	roiManager("select", a);
	roiManager("Combine");
	run("Convex Hull");
	roiManager("add");
	
	//remove individual ROIs
	roiManager("select", a);
	roiManager("delete");
}

// create band around nuclei
roiManager("Select", 3);
run("Enlarge...", "enlarge=-1");
run("Make Band...", "band=1");
roiManager("add");
// remove nucleus area
roiManager("Select", 2);
roiManager("delete");
close(); // duplicated image


// keep cell area as a cell-defining ID
//roiManager("Select", 0);
//roiManager("delete");


// Measure all
roiManager("Select", 1);
roiManager( "Rename", "Membrane" )
Stack.setPosition(1, slice, frame)
run("Measure");
Stack.setPosition(3, slice, frame)
run("Measure");

roiManager("Select", 2);
roiManager( "Rename", "Intracellular" )
Stack.setPosition(1, slice, frame)
run("Measure");
Stack.setPosition(3, slice, frame)
run("Measure");

roiManager("Select", 3);
roiManager( "Rename", "Perinuclear" )
Stack.setPosition(1, slice, frame)
run("Measure");
Stack.setPosition(3, slice, frame)
run("Measure");


// save results
roiManager("Deselect");
roiManager("Save", path + imgName + "_" + ROIname +".zip");

saveAs("Results", path + imgName + "_" + ROIname + ".csv");

// close stuff
// clean up
run("Close All");
roiManager("Delete");

list = getList("window.titles");
 for (i=0; i<list.length; i++){
 winame = list[i];
  selectWindow(winame);
 run("Close");
 }
