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
roiManager( "Rename", "Plasma membrane" )
roiManager("Deselect");


// Intracellular selection
run("Select None");
roiManager("Select", 0);
run("Enlarge...", "enlarge=-3");
run("Make Band...", "band=1");
roiManager("add");
roiManager("Deselect");


// perinuclear selection
run("Select None");
run("Duplicate...", "duplicate");
roiManager("Select", 0);
Stack.setPosition(2, slice, frame)  // Dapi channel
run("Median...", "radius=2 slice");
setAutoThreshold("Moments dark");
run("Analyze Particles...", "size=70-Infinity add include slice");
// This fails for multiple nuclei

roiManager("Select", 3);
run("Enlarge...", "enlarge=-1");
run("Make Band...", "band=1");
roiManager("add");
close();


// remove cell Mask
roiManager("Select", 0);
roiManager("delete");
// remove nucleus mask
roiManager("Select", 2);
roiManager("delete");

// Measure all
roiManager("Select", 0);
roiManager( "Rename", "Membrane" )
Stack.setPosition(1, slice, frame)
run("Measure");
Stack.setPosition(3, slice, frame)
run("Measure");

roiManager("Select", 1);
roiManager( "Rename", "Intracellular" )
Stack.setPosition(1, slice, frame)
run("Measure");
Stack.setPosition(3, slice, frame)
run("Measure");

roiManager("Select", 2);
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
