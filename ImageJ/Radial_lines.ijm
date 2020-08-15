
// start off with user drawn line

getLine(centX, centY, x2, y2, lineWidth);

   if (centX==-1)
      exit("This macro requires a straight line selection");

//Radial profile

dx = x2-centX; 
dy = y2-centY;
   len = sqrt(dx*dx+dy*dy);

steps = 50;

for (i = 0; i < steps; i++) {
	step = 2 * PI / steps; 
	a = centX + len * cos(i*step);
	b = centY + len * sin(i*step);

	makeLine(centX, centY, a, b, lineWidth);
	roiManager("add");
}


// export line profiles
// use Save_profiles.ijm

//dir = getDirectory("image"); 
//name = getTitle;
//roiManager("save", dir + File.separator + title + "_refined.zip");

// refine lines according to cell mask?
/// adding lines with ROI works but creates "freehand" type selection
/// converting of freehand to rectangle still is "freehand" type > other way?