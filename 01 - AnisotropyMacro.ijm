 var manualBackgroundCheck = 2; //0 for automatic, 1 for manual 2 for no background
 
 
 
 macro "Anisotropy_Calculation" {
	//run("Show LSMToolbox","ext")
dir = getDirectory("Choose a Directory ");
    list = getFileList(dir);
setBatchMode(true);
           
    for (i=0; i<list.length; i++) {
        path = dir+list[i];

        showProgress(i, list.length);
        if (endsWith(path,"/"))		// If path is a directory, recurse into the directory
            RecurseDirectory(path);
        if (endsWith(path,"A_Preprocessed.tif")) 
		{
		open (path);
        if (nImages>=1) {
            AnisotropyMeasurement(dir); }          
        }
    }
	waitForUser("Done!", "Done!");
 	while (nImages>0) { 
          selectImage(nImages); 
          close(); 
      } 
}

function RecurseDirectory (dir2)
{
	
	listR = getFileList(dir2);
       
    for (i=0; i<listR.length; i++) {
        path2 = dir2+listR[i];
        //waitForUser("Done!", path2);
        showProgress(i, listR.length);
        if (endsWith(path2,"/"))		// If path is a directory, recurse into the directory
            RecurseDirectory(path2);
        if (endsWith(path2,"A_Preprocessed.tif")) 
	{	open (path2);
        if (nImages>=1) {
            AnisotropyMeasurement(dir2); }          
        }
    }
	//waitForUser("Done!", "Done!");
 	while (nImages>0) { 
          selectImage(nImages); 
          close(); 
      } 
}



	




function AnisotropyMeasurement (dir){

substackCheck = 0;
FileName=getTitle();
FileName=replace (FileName, ".tif", "");
rename(FileName);
getDimensions(width, height, channels, slices, frames);
if (frames>1)
{
	substackCheck = 1;
}

for  (currentSlice = 1; currentSlice<(slices+1); currentSlice++)
{
	for (currentFrame = 1; currentFrame<(frames+1); currentFrame++)
	{
	run("Make Substack...", "channels=1-3 frames=" + currentFrame + "-" + currentFrame + " slices=" + currentSlice + "-" + currentSlice);
	//waitForUser(currentFrame, currentSlice);
	rename("F" + IJ.pad(currentFrame, 3) + "S" + IJ.pad(currentSlice,3) + "_" + FileName);
	calculateAnisotropy(dir);
	}
}

//Close all open images
 	while (nImages>0) { 
          selectImage(nImages); 
          close(); 
      } 

}



function calculateAnisotropy (dir)
{





if (manualBackgroundCheck == 1)
	{
		subBack();
	}
else if (manualBackgroundCheck == 2)
	{
		nullVariable = 0;  //do Nothing
	}
else
	{
		run("Subtract Background...", "rolling=500");
	}


FileName=getTitle();
//isStack = indexOf(title, "40X") >= 0;

//Manual subtractions of the background
//subBack();


//setBatchMode(true);
//run("Subtract Background...", "rolling=50 disable");

setSlice(1);
//run("Stack to Images");
run("Split Channels");

//("s2i",FileName);
//use filename

//selectWindow(FileName + ".tif");
/*// For the third channel
selectWindow("C3-" + FileName + ".tif");
saveAs ("tiff", dir + FileName + "_Open.tif");
selectWindow("C1-" + FileName + ".tif");
//saveAs ("tiff", dir + FileName + "_Open.tif");
close();
*/

/*if (indexOf(dir,"mito")
{
	selectWindow("C2-" + FileName + ".tif");
	saveAs ("tiff", dir + FileName + "_Para.tif");
	close();

 	selectWindow("C3-" + FileName + ".tif");
	saveAs ("tiff", dir + FileName + "_Perp.tif");
	close();

}*/





//selectWindow("C2-" + FileName + ".tif");
selectWindow("C2-" + FileName);
saveAs ("tiff", dir + FileName + "_Open.tif");


//selectWindow("C1-" + FileName + ".tif");
selectWindow("C1-" + FileName);
close();




//selectWindow("T PMT-T2");
//close();



run("Images to Stack");

//waitForUser("","");

setSlice(1);
run("Select All");
run("Copy");
setSlice(2);
run("Add Slice");
run("Paste");
setSlice(1);
run("Delete Slice");

//waitForUser("Before Alignment","");
//run("Linear Stack Alignment with SIFT", "initial_gaussian_blur=1.60 steps_per_scale_octave=3 minimum_image_size=64 maximum_image_size=1024 feature_descriptor_size=4 feature_descriptor_orientation_bins=8 closest/next_closest_ratio=0.92 maximal_alignment_error=25 inlier_ratio=0.05 expected_transformation=Affine interpolate");
//waitForUser("After ALighment","");


rename(FileName + "_processed");
run("32-bit");
//run("HomoFRET Ver6 ", "lens=1.40 index=1.518 g-factor=0.4375");  //Zeiss Objective (63X)
run("HomoFRET Ver6 ", "lens=1.43 index=1.518 g-factor=1.000"); //Oil Objective
//run("HomoFRET Ver6 ", "lens=0.6 index=1.00 g-factor=1.000");  //Air Objective











saveAs ("tiff", dir + FileName + "_processed.tif");
close(); 

}


function subBack()
{

setBatchMode(false);
setSlice(1);
makeRectangle(18, 39, 112, 89);
waitForUser("Select Background", "Select a sample of the background then click \"OK\".");

//setBatchMode(true);
setSlice(3);
List.setMeasurements;
PerpBG = List.getValue ("Mean");

setSlice(2);
List.setMeasurements;
ParaBG = List.getValue ("Mean");

run("Select None");

setSlice(3);
run("Subtract...", "value=" + PerpBG + " slice");

setSlice(2);
run("Subtract...", "value=" + ParaBG + " slice"); 
setBatchMode(true);

}
   


function deconvolveImage()
{
	//40X Objective
	run("Diffraction PSF 3D", "index=1.00 numerical=0.60 wavelength=515 longitudinal=0 image=151 slice=90 width,=696 height,=520 depth,=5 normalization=[Sum of pixel values = 1] title=PSF");

	//63X Objective
	//run("Diffraction PSF 3D", "index=1.518 numerical=1.40 wavelength=400 longitudinal=0 image=22 slice=90 width,=1024 height,=1024 depth,=5 normalization=[Sum of pixel values = 1] title=PSF");
}
 

