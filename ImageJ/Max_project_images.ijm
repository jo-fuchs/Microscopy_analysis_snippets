// max projections of all open confocal stacks (names from Leica file format .lif)
// saved in subdirectory with title of confocal-session
path = getDirectory("Choose a Directory");
dir_title = getTitle();
dir_dotIndex = indexOf(dir_title, ".lif");
dir_title2 = substring(dir_title,0, dir_dotIndex)
dirimg=path+"//"+dir_title2+"//";
File.makeDirectory(dirimg); 

while (nImages>0) {
	run("Z Project...", "projection=[Max Intensity]");
	title = getTitle();
	dotIndex = indexOf(title, "- ");
	title2 = substring(title, dotIndex+2);
	saveAs("tiff",dirimg+title2);
	close();
	close();
}