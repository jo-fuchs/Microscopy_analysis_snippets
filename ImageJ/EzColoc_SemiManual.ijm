// EzColoc macro for individual expressing cells
//
// for images with 3 Channels & refinement of masks on Channel 2
//
// can be followed up by First_look_at_results.R in this Repo
// 
// Oct 2020 Joachim Fuchs
//


// requires manual selection to refine cells. Selection has to exclude edges
waitForUser("Select cells of interest and store them in the ROI-manager\n \n Only then click OK to start the analysis\n \n \n Selections touching the border of the image are ignored");

title = getTitle();
dir = getDirectory("image");

// reduce all manual ROIs to one combined ROI for refinement
roiManager("Deselect");
roiManager("combine");
roiManager("add");
roiManager("Deselect");
n = roiManager("count");
 
array=newArray(n-1);
for(i=0; i < n-1; i++) {
        array[i] = i;
}
roiManager("Select", array); 
roiManager("delete");


// create selection in second channel (change Stack.setChannel() to preferred cell marker)
Stack.setChannel(2)
run("Median...", "radius=2 slice");
setAutoThreshold("MinError dark");
run("Create Selection");
roiManager("Add");

// refine selection with manual ROI
roiManager("Select", newArray(0,1));
roiManager("AND");

// further refine by filling holes & removing small particles
run("Create Mask");
run("Close-");
run("Dilate");
run("Fill Holes");
run("Create Selection");
run("Analyze Particles...", "size=100-Infinity clear add"); // keep only what is large enough to be a cell
close();

// save indiviual cells as individual ROIs
roiManager("Deselect");
roiManager("Save", dir + title +"_ROIs.zip");



// Colocalization analysis using EzColoc Macro
//
// requires scale set to global and split channels
getVoxelSize(width, height, depth, unit);
scale = 1/width;
run("Set Scale...", "distance="+ scale + " known=1 unit=micron global");

run("Split Channels");

C1 = "C1-"+title;
C2 = "C2-"+title;
C3 = "C3-"+title;

// add or remove comparisons
// EzColoc for Channel 1 vs. Channel 3
run("EzColocalization ", "reporter_1_(ch.1)=" + C1 + 
						" reporter_2_(ch.2)=" + C3 + 
						" cell_identification_input=[ROI Manager] " + 		   // cell selection from ROI-manager
						"alignthold4=default "+ 							   // no additional alignment of channels
						"tos metricthold1=ft allft-c1-1=10 allft-c2-1=20 "+    // TOS from top 10% Channel 1 and top 20% Channel 3
						"pcc metricthold2=all allft-c1-2=10 allft-c2-2=10 "+   // PCC from top 10% of both channels
						"srcc metricthold3=all allft-c1-3=10 allft-c2-3=10 "+  // SRCC from top 10% of both channels
						"average_signal");									   // measures for mean intensity
						
saveAs("Results", dir + title + "_1-3.csv");


// EzColoc for Channel 1 vs. Channel 2
run("EzColocalization ", "reporter_1_(ch.1)=" + C1 + 
						" reporter_2_(ch.2)=" + C2 + 
						" cell_identification_input=[ROI Manager] " + 
						"alignthold4=default "+ 
						"tos metricthold1=ft allft-c1-1=10 allft-c2-1=20 "+
						"pcc metricthold2=all allft-c1-2=10 allft-c2-2=10 "+
						"srcc metricthold3=all allft-c1-3=10 allft-c2-3=10 "+
						"average_signal");

saveAs("Results", dir + title + "_1-2.csv");

// EzColoc for Channel 2 vs. Channel 3
run("EzColocalization ", "reporter_1_(ch.1)=" + C2 + 
						" reporter_2_(ch.2)=" + C3 + 
						" cell_identification_input=[ROI Manager] " + 
						"alignthold4=default "+ 
						"tos metricthold1=ft allft-c1-1=10 allft-c2-1=20 "+
						"pcc metricthold2=all allft-c1-2=10 allft-c2-2=10 "+
						"srcc metricthold3=all allft-c1-3=10 allft-c2-3=10 "+
						"average_signal");

saveAs("Results", dir + title + "_2-3.csv");

// clean up
run("Close All");
roiManager("Deselect");
roiManager("Delete");

list = getList("window.titles");
 for (i=0; i<list.length; i++){
 winame = list[i];
  selectWindow(winame);
 run("Close");
 }
