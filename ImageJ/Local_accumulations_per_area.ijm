
while(nImages > 0) {

Stack.setChannel(2);
run("Gaussian Blur...", "sigma=0.15 scaled slice");
setAutoThreshold("Otsu dark");
run("Create Selection");
getStatistics(area, mean, min, max, std, histogram);
run("Measure");
run("Find Maxima...", "prominence=" + mean + " output=Count");
close();

}
