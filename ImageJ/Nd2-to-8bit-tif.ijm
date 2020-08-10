path = getDirectory("Choose a Directory");

while (nImages>0) {
	run("8-bit");
	title = getTitle();
	dotIndex = indexOf(title, ".nd2");
	title2 = substring(title,0, dotIndex);
	saveAs("Tiff", path+title2+".tif");
	close();
}