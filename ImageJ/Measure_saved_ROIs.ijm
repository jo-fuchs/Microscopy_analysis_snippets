// Load all ROI-sets from a directory and measure the first

// Select directory of images
path = getDirectory("Choose a Directory");
// path for ROI-subdirectory
dirROI = path + "Measurements/";
filelist = getFileList(dirROI);
 
for (i = 0; i < lengthOf(filelist); i++) { 
	file = filelist[i]; 
	
	if (endsWith(file, ".zip")) { 
		// only if it is a .zip follow up

		// extract corresponding image name (depends on naming scheme)
		dot_Index = indexOf(file, "_000");
		ImgFile = substring(file,0, dot_Index); 

		// Open image
		open(path + ImgFile); 

		// open ROIs
		open(dirROI + file); 		
		roiManager("Open", dirROI + file);

		// Select ROI to measure & Channel
		roiManager("Select", 0);
		Stack.setChannel(4);
		run("Measure");

		roiManager("deselect");
		roiManager("Delete");
		close();
	}
 
}