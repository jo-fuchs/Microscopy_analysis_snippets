// Plasma membrane recruitment analysis
// 
//	  	Measures intensity at cell surface, intracellular & perinuclear
//		creates 1µm thick band to measure intensity (mean & median) in all regions
//    
// requires:
//		membrane marker (fGFP or F-actin) optionally with Dapi (for perinuclear intensity)
//		manual selection of cell of interest in ROI-manager
//
// Output:
//    ROIs saved as Image_ROIname_ROIs.zip
//    Intensities saved as Image_ROIname_PMrecruitment.csv
//
// v0.2 26.10.2020 Joachim Fuchs
//



// define channels
GFPchannel = 1;
PRG2channel = 4;
Dapichannel = 3; // if no Dapi imaged, set to 0



// set up results
run("Input/Output...", "jpeg=100 gif=-1 file=.csv save_column");
run("Set Measurements...", "area mean standard median display redirect=None decimal=2");
path = getDirectory("Choose a Directory");
dirimg = path + "Measurements/";
File.makeDirectory(dirimg); 
imgName = getTitle();
Stack.getPosition(channel, slice, frame)
run("Select None");
roiManager("deselect");


// refinement of selection
run("Duplicate...", "duplicate");
roiManager("Select", 0);
ROIname = getInfo("roi.name"); 
Stack.setPosition(GFPchannel, slice, frame)  
run("Median...", "radius=2 slice");
setAutoThreshold("Huang dark");
run("Analyze Particles...", "size=200-Infinity clear include add slice");
close();

// Plasma membrane Selection
roiManager("Select", 0);
Stack.setPosition(GFPchannel, slice, frame)
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

if(Dapichannel != 0) {
	// perinuclear selection
	run("Select None");
	run("Duplicate...", "duplicate");
	roiManager("Select", 0);
	Stack.setPosition(Dapichannel, slice, frame)  
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
}

// create band around nuclei
roiManager("Select", 3);
run("Enlarge...", "enlarge=-1");
run("Make Band...", "band=1");
roiManager("add");
// remove nucleus area
roiManager("Select", 3);
roiManager("delete");
close(); // duplicated image


// keep cell area as a cell-defining ID
//roiManager("Select", 0);
//roiManager("delete");


// Measure all
roiManager("Select", 1);
roiManager( "Rename", "Membrane" )
Stack.setPosition(GFPchannel, slice, frame)
run("Measure");
Stack.setPosition(PRG2channel, slice, frame)
run("Measure");

roiManager("Select", 2);
roiManager( "Rename", "Intracellular" )
Stack.setPosition(GFPchannel, slice, frame)
run("Measure");
Stack.setPosition(PRG2channel, slice, frame)
run("Measure");

if(Dapichannel != 0) {
roiManager("Select", 3);
roiManager( "Rename", "Perinuclear" )
Stack.setPosition(GFPchannel, slice, frame)
run("Measure");
Stack.setPosition(PRG2channel, slice, frame)
run("Measure");
}

// save results
roiManager("Deselect");
roiManager("Save", dirimg + imgName + "_" + ROIname +"_ROIs.zip");

saveAs("Results", dirimg + imgName + "_" + ROIname + "_PMrecruitment.csv");

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
