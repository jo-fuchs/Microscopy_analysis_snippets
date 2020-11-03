// Create ROIs from individual CSV results files per movie
//
// requires .csv with columns for:
// 	  - center coordinates (here: X_mid, Y_mid), 
//    - timepoint (here: Formation)
//	  - ROI-color (here: Color)
//
//  also needs tif-files with matching names & dimensions
// 
// returns new folder with ROI sets & exported RoiManager lists per movie
//
// 31.10.20 Joachim Fuchs
//
  
path = getDirectory("Choose a Directory");
// path for ROI-subdirectory
dirROI = path + "final_ROIs/";
dirCSV = path + "manual_csv"; // directory of csvs to read in
File.makeDirectory(dirROI);

filelist = getFileList(path);

for (j = 0; j < lengthOf(filelist); j++) { 
	file = filelist[j]; 

	if (endsWith(file, ".tif")) { 
		// only if it is a .tif follow up

		// Open image
		open(path + file); 
	
 		// Import corresponding csv into a results table.
  		run("Results... ", "open=" + dirCSV + File.separator + file + ".csv");
   
		 for (i = 0; i < nResults; i++) {
		      slice = getResult("Formation", i);
		      x = getResult("X_mid", i);
		      y = getResult("Y_mid", i);
		      typs = getResultString("Color", i);
			  
		      // create selection
		      run("Specify...", "width=30 height=30 x=&x y=&y slice=&slice centered");
		
		      // Add to the ROI manager.
		      roiManager("Add");
		      index = roiManager("count");
		      roiManager("select", index-1);
		 	  roiManager("Set Color", typs);
		 	  Roi.setPosition(0, slice, 0);  
		   }

		// save results
		run("Clear Results");
		
		roiManager("Deselect");
		roiManager("List");
		saveAs("Results", dirROI + file + ".csv");
		
		
		roiManager("Save", dirROI + file + ".zip");
		roiManager("delete");
		

		run("Clear Results");
		close();
	}
}