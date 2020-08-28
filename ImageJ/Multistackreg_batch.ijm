// Drift correct movie with several channels identically
//
// - Creates mask of one channel
// - drift corrects the mask & saves coordinates as a tmp-file using Multistackreg
// - drift corrects actual channels using coordinates from mask & saves as tif
//
// - todo: Batch version

dir = getDirectory("Choose a Directory");

imgname = getTitle();
middle = substring(imgname, 0, lengthOf(imgname) - 4);
mask = middle + "-1.tif";

// create mask from first channel
run("Duplicate...", "duplicate channels=1" + "title="+mask);
		setAutoThreshold("Li dark no-reset");
		//run("Threshold...");
		setOption("BlackBackground", true);
		run("Convert to Mask");


// create name for tempfile of coordinates
getDateAndTime(year, month, dayOfWeek, dayOfMonth,
	hour, minute, second, msec);
tmpfile  = getDirectory("temp");
tmpfile += "MSR-" + year + "-" + month + "-" + dayOfMonth +
	"_" + hour + "-" + minute + "-" + second + ".txt";

// drift-correct mask & save coordinates to tempfile
run("MultiStackReg", "stack_1=" + mask
	+ " action_1=Align"
	+ " file_1=[" + tmpfile + "]"
	+ " stack_2=None"
	+ " action_2=Ignore"
	+ " file_2=[]"
	+ " transformation=Translation save");
	


// split channels 
selectWindow(imgname);
run("Split Channels");

c1 = "C1-" + imgname;
c2 = "C2-" + imgname;

// apply coordinates to Channel 1
run("MultiStackReg", "stack_1=" + c1 +
	" action_1=[Load Transformation File]" +
	" file_1=[" + tmpfile + "]" +
	" stack_2=None" +
	" action_2=Ignore" +
	" file_2=[]" +
	" transformation=Translation");

// apply coordinates to Channel 2
run("MultiStackReg", "stack_1=" + c2 +
	" action_1=[Load Transformation File]" +
	" file_1=[" + tmpfile + "]" +
	" stack_2=None" +
	" action_2=Ignore" +
	" file_2=[]" +
	" transformation=Translation");

run("Merge Channels...", "c1=" + c1 + " c2=" + c2 + " create");
saveAs("Tiff", dir + "\\DriftCorrected_" + imgname);
