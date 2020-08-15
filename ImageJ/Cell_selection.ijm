run("Duplicate...", "duplicate");

// initial selection
Stack.setChannel(2);
run("Gaussian Blur...", "sigma=1");
setAutoThreshold("Otsu dark");
getThreshold(lower,upper);
setThreshold(lower,4075);
run("Create Mask");

// refine mask
setOption("BlackBackground", false);
run("Erode");
run("Erode"); // remove remaining speckles outside of cell
//run("Dilate"); // reset cell border?
run("Create Selection");
	roiManager("add");
selectWindow("mask")
close();




// Alternative with lower Threshold depending on mean intensity
//getStatistics(a, mean, a, a, a, a);
 
// lower border depends on mean intensity of image (remove background) 
// upper border leaves out top 0.5% intensity (removes bright speckles)
//setThreshold(1.7 * mean, 4075);
//run("Threshold...");

// run("Create Selection"); // using a mask (as above) can further refine the selection as follows
