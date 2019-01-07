var recdir = 1;
var results_filename;

macro "Segment_Cytoplasm" {
	run("Set Measurements...", "mean modal limit redirect=None decimal=3");
	setBatchMode(true);
	// Select a directory and recurse through it, working on .lsm images
	//setBatchMode(true);		// Batch mode: don't show any image windows
	dir = getDirectory("Choose a Directory ");

	Deconvolution_Image = dir + "PSF.tif";
	if (File.exists(Deconvolution_Image) == 0)
	{
		waitForUser("Creating a new PSF","...");
	//40X Objective
	//run("Diffraction PSF 3D", "index=1.00 numerical=0.60 wavelength=515 longitudinal=0 image=151 slice=90 width,=696 height,=520 depth,=5 normalization=[Sum of pixel values = 1] title=PSF");
	
	//63X Objective
	run("Diffraction PSF 3D", "index=1.518 numerical=1.40 wavelength=400 longitudinal=0 image=22 slice=90 width=696 height=520 depth,=5 normalization=[Sum of pixel values = 1] title=PSF");
	saveAs ("tiff", Deconvolution_Image);

	waitForUser("Finished with the new image","");
	close();
	}
	

	// Recurse through selected directory
	openFiles(dir);

	// Done
	waitForUser("Finished analyzing images.");
}


function openFiles(dir) {
	
	list = getFileList(dir);
	for (i=0; i<list.length; i++) {
		path = dir+list[i];
		showProgress(i, list.length);
		showStatus(path);
		if (endsWith(path,"/"))	{	// If path is a directory, recurse into the directory
			recdir = 1;
			openFiles(path);
		}
		// If path is a processed image, open and work on the file
		file2 = "";
					//waitForUser("Got To Here" + i, path);
		if (endsWith(path,"A_Preprocessed_Open.tif"))
		{
			open(path);
 			AnisotropySegmentation(path);

		}
					
		else if (endsWith(path, "I_Preprocessed.tif"))
        {
        	open(path);
        	IntensitySegmentation(path);
        }

	}
}


/*
//
//
//Segment cells from anisotropy images
//
//
*/
function AnisotropySegmentation(path)
{
threshold_value = 100;
threshold_lower_modifier = 0.75;
threshold_upper_modifier = 1.4;

//Paste in parameters from aa_ParameterTest.ijm
sigma = 10;  //Amount of blur before selecting maxima
noise = 5000;  //Noise parameter for maxima selection

getDimensions(width, height, channels, slices, frames);
WindowName = getTitle(); 
newImage("Mask", "16-bit black", width, height, 1);
newImage("ROIs", "16-bit black", width, height, 1);
//waitForUser("", "C" + channels + "  S" + slices + "  f" + frames);


//Find Cells
selectWindow(WindowName);
run("Revert");
run("Select None");
run("Gaussian Blur...", "sigma=" + sigma);
run("Find Maxima...", "noise=" + noise + " output=[Point Selection]");
getSelectionCoordinates(xPoints,yPoints);
number_of_points = xPoints.length;
//waitForUser(xPoints[0], number_of_points);
run("Revert");
run("Select None");
//run("Gaussian Blur...", "sigma=2");
run("Median...", "radius=4");






roiManager("reset");
//for (i=0; i<(number_of_points-1); i++)
//for (i=0; i<3; i++)
for (i=0; i<(number_of_points-1); i++)
{
	

selectWindow(WindowName);
run("Select All");
run("Copy");
selectWindow("Mask");
run("Paste");

makePoint(xPoints[i], yPoints[i]);



//waitForUser ("Select the Cell");
run("Enlarge...", "enlarge=3 pixel");
//run("Measure");

List.setMeasurements;
mean_Value = List.getValue ("Mean");
//waitForUser ("The mean is", mean_Value); 
if (mean_Value > threshold_value)
{

//waitForUser("Mean is", mean_Value);
setThreshold(mean_Value*threshold_lower_modifier,mean_Value*threshold_upper_modifier, "Over/Under");
//waitForUser("THreshold","");
run("Create Selection");
run("Make Inverse");
run("Set...", "value=NaN");


makePoint(xPoints[i], yPoints[i]);
run("Interactive Morphological Reconstruction", "type=[By Dilation] connectivity=4");
//waitForUser("Before Threshold","");
setThreshold(1,pow(2,16)-1, "Over/Under");

run("Create Selection");
is_selection = selectionType(); 
//print("The selection type is: " + type);
if (is_selection != -1)
{
	roiManager("Add");
	run("Set...", "value=" + (i+1));
	imageCalculator("Add", "ROIs", "Mask-rec");
}
	
	
	
selectWindow("Mask-rec");
close();
}


}

//waitForUser("At the ROIs Step");
selectWindow("Mask");
close();

roi_path = replace (path, "_Open.tif", "--ROI.zip");
if(roiManager("count")!=0)
{
roiManager("save",roi_path);
}

selectWindow("ROIs");
new_path = replace (path, ".tif", "ROI.tif");

saveAs ("tiff", new_path);
close();
selectWindow(WindowName);
close();
//waitForUser("Done", new_path);

}


/*
//
//
//Segment cells from intensity images (1 channel)
//
//
*/



function IntensitySegmentation(path)
{
threshold_value = 500;
threshold_lower_modifier = 0.9;
threshold_upper_modifier = 1.2;

//Paste in parameters from aa_ParameterTest.ijm
sigma = 10;  //Amount of blur before selecting maxima
noise = 5000;  //Noise parameter for maxima selection


getDimensions(width, height, channels, slices, frames);
WindowName = getTitle(); 
newImage("Mask", "16-bit black", width, height, 1);
newImage("ROIs", "16-bit black", width, height, 1);
//waitForUser("", "C" + channels + "  S" + slices + "  f" + frames);


//Find Cells
selectWindow(WindowName);
run("Revert");
run("Select None");
run("Gaussian Blur...", "sigma=" + sigma);
run("Find Maxima...", "noise=" + noise + " output=[Point Selection]");
getSelectionCoordinates(xPoints,yPoints);
number_of_points = xPoints.length;
//waitForUser(xPoints[0], number_of_points);
run("Revert");
run("Select None");
//run("Gaussian Blur...", "sigma=2");
run("Median...", "radius=4");






roiManager("reset");
//for (i=0; i<(number_of_points-1); i++)
//for (i=0; i<3; i++)
for (i=0; i<(number_of_points-1); i++)
{
	

selectWindow(WindowName);
run("Select All");
run("Copy");
selectWindow("Mask");
run("Paste");

makePoint(xPoints[i], yPoints[i]);



//waitForUser ("Select the Cell");
run("Enlarge...", "enlarge=3 pixel");
//run("Measure");

List.setMeasurements;
mean_Value = List.getValue ("Mean");
//waitForUser ("The mean is", mean_Value); 
if (mean_Value > threshold_value)
{

//waitForUser("Mean is", mean_Value);
setThreshold(mean_Value*threshold_lower_modifier,mean_Value*threshold_upper_modifier, "Over/Under");
//waitForUser("THreshold","");
run("Create Selection");
run("Make Inverse");
run("Set...", "value=NaN");


makePoint(xPoints[i], yPoints[i]);
run("Interactive Morphological Reconstruction", "type=[By Dilation] connectivity=4");
//waitForUser("Before Threshold","");
setThreshold(1,pow(2,16)-1, "Over/Under");

run("Create Selection");
is_selection = selectionType(); 
//print("The selection type is: " + type);
if (is_selection != -1)
{
	roiManager("Add");
	run("Set...", "value=" + (i+1));
	imageCalculator("Add", "ROIs", "Mask-rec");
}
	
	
	
selectWindow("Mask-rec");
close();
}


}

//waitForUser("At the ROIs Step");
selectWindow("Mask");
close();

roi_path = replace (path, "Preprocessed.tif", "--ROI.zip");
if(roiManager("count")!=0)
{
roiManager("save",roi_path);
}

selectWindow("ROIs");
new_path = replace (path, ".tif", "ROI.tif");

saveAs ("tiff", new_path);
close();
selectWindow(WindowName);
close();
//waitForUser("Done", new_path);

}