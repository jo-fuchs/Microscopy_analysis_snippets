// open all images for analysis
path = getDirectory("Choose a Directory");
run("Set Measurements...", "area mean min display redirect=None decimal=2");

while (nImages>0) {

  //// Intensity measurements with adaptive thresholding////
  
	// set channel of interest & change filename for output in last line
  Stack.setChannel(2);
  getStatistics(a,mean,a,a,a);

	// set lower threshold as multiple of mean, adapt upper threshold if required  
  setThreshold(1.05*mean,254);
  
  run("Threshold...");
  run("Create Selection");
  run("Measure");
  run("Select None");
  close();
}

saveAs("Results", path+"Results.txt");
run("Clear Results");