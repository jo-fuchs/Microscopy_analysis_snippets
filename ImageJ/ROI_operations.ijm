// Useful ROI manager operations

// Select only pixels present in both two last ROIs
n = roiManager("count");
a = newArray(n - 2, n - 1);
roiManager("select", a);

	roiManager("and");
	roiManager("add");

//remove individual ROIs
roiManager("select", a);
roiManager("delete");


// Refine previous (manual) ROIs by combined channel
n = roiManager("count");
  for (i = 0; i < n - 1; i++) {
  	a = newArray(i, n - 1);
  	
	roiManager("select", a);
	roiManager("and");
	roiManager("add");
	};
	


// measure intensities (only in refined ROIs > starting at n)
m = roiManager("count");
  for (j = n; j < m; j++) {
	roiManager("select", j);
	Stack.setChannel(1);
	run("Measure");
	Stack.setChannel(2);
	run("Measure");
	Stack.setChannel(3);
	run("Measure");

	};
