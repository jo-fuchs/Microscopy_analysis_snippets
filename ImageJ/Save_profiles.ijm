///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Colocalization analysis via line profile
//
// Run for every image separately after:
//	 - opening Image-Stack with 3 channels
//	 - Lines stored in ROI-manager
//
// Goals:
//   - check &/or create LineProfiles-folder
//   - Create line profile of a stored line in the ROI manager in all 3 channels
//   - Scale Y-axis to µm instead of pixeles
//	 - Save final table for each ROI with the name: "ImageName_RoiName"
//	 - Save ROIs
//
//   Version 0.1 (11.06.2020)
// 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// select working directory & read image name & ID
path = getDirectory("Choose a Directory");
imgID = getImageID;
imgName = getTitle();;

// create Results directory
subdir=path+"LineProfiles/";
File.makeDirectory(subdir); 

// loop through Roi-Manager for each protrusion
nR = roiManager("Count"); 

for (k=0; k<nR; k++) { 
	run("Clear Results");
	roiManager("Select",k);
	rName = Roi.getName;
	Stack.setChannel(1);
	profile_1 = getProfile();		// get profile for Tau
	Stack.setChannel(2);
	profile_2 = getProfile();		// get profile for Tub-Y
	Stack.setChannel(3);               // get profile for Tub-Ac
	profile_3 = getProfile();

	// scale X-axis from pixel to scale
	x = Array.getSequence(profile_1.length);
	scaleArray(imgID, x );

	//create results table with  X and Y of Profiles
	//// if you want to give different names make sure to also modify them accordingly in the R-code (part 2) of the analysis!)
	for (i=0; i<profile_Tau.length; i++) {
		setResult("X", i, x[i]);
		setResult("Channel_1", i, profile_1[i]) ;
		setResult("Channel_2", i, profile_2[i]) ;
		setResult("Channel_3", i, profile_3[i]) ;
	}
	
	// save results table as "ImageName_RoiName.txt"
	updateResults(); 
	saveAs("Measurements", subdir+imgName+"_"+rName+".txt"); 
	}
	

//// scale Array function from user anon96376101 at https://forum.image.sc/t/getprofile-function-not-following-the-scale/9260
function scaleArray( image, array ) {
	front = getImageID;
	selectImage( image );
	for ( i= 0; i < array.length; i++ ) toScaled( array[i] );
	selectImage( front );
}

