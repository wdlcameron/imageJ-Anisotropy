macro "Preprocessing" {


	//Initialization Parameters (can make a dialog box instead)
/*
	numberOfColours = 2;
	namesArray = newArray("Turquoise2","Venus");
	anisotropyArray = newArray(1,1);  //1 if anisotropy, 0 if fluorescence
	channelsPerColour = newArray(3,3); //Channels per colour, for splitting

  Dialog.create("Image Parameters");
  Dialog.addNumber("Number of Colours:", numberOfColours);
  Dialog.addString("Colour Labels:", colourLabelsString);
  Dialog.addString("Anisotropy Chanels:", anisotropyChannelsString);
  Dialog.addNumber("Channels Per Colour:", channelsPerColourString);
  Dialog.show();


	namesArray = newArray(colourLabelsString);
	anisotropyArray = newArray(1,1);  //1 if anisotropy, 0 if fluorescence
	channelsPerColour = newArray(3,3); //Channels per colour, for splitting


	
	waitForUser(colourLabelsString, namesArray[0]);
*/	




/*
 * 
 * 
 * 
 * 
 * Initialize Settings
 *
 *
 *
 *
 */
	
	//numberOfColours = 3;
	//namesArray = newArray("Venus", "mCherry", "processed");
	//anisotropyArray = newArray(0,0,1);  //1 if anisotropy, 0 if fluorescence
	//channelsPerColour = newArray(1,1,3); //Channels per colour, for splitting

	//Initialization Parameters (can make a dialog box instead)
	/*numberOfColours = 1;
	namesArray = newArray("Processed", "Brightfield");
	anisotropyArray = newArray(1,0);  //1 if anisotropy, 0 if fluorescence
	channelsPerColour = newArray(3,1); //Channels per colour, for splitting
	*/

	/*numberOfColours = 3;
	namesArray = newArray("0100", "0500", "1000");
	anisotropyArray = newArray(1,1,1);  //1 if anisotropy, 0 if fluorescence
	channelsPerColour = newArray(3,3,3); //Channels per colour, for splitting
	*/

//Ginni's Settings 
/*
	numberOfColours = 1;
	namesArray = newArray("Processed", "0500", "1000");
	anisotropyArray = newArray(1,1);  //1 if anisotropy, 0 if fluorescence
	channelsPerColour = newArray(3,3); //Channels per colour, for splitting
*/

/*
	//Huntley's Settings
	numberOfColours = 3;
	namesArray = newArray("T2", "Citrine", "mCherry");
	anisotropyArray = newArray(1,0,0);  //1 if anisotropy, 0 if fluorescence
	channelsPerColour = newArray(3,1,1); //Channels per colour, for splitting
*/

/*
	numberOfColours = 3;
	namesArray = newArray("T2", "Venus", "Brightfield");
	anisotropyArray = newArray(1,1,0);  //1 if anisotropy, 0 if fluorescence
	channelsPerColour = newArray(3,3,1); //Channels per colour, for splitting

*/
	//numberOfColours = 2;
	//namesArray = newArray("Venus", "Venus", "Brightfield");
	//anisotropyArray = newArray(1,1,0);  //1 if anisotropy, 0 if fluorescence
	//channelsPerColour = newArray(3,3,1); //Channels per colour, for splitting
	
	//run("Show LSMToolbox","ext")

	numberOfColours = 1;
	namesArray = newArray("Venus", "Empty");
	anisotropyArray = newArray(1,0);  //1 if anisotropy, 0 if fluorescence
	channelsPerColour = newArray(3,1); //Channels per colour, for splitting
	
	//run("Show LSMToolbox","ext")
	

	setBatchMode(true);

	dir = getDirectory("Choose a Directory ");
    list = getFileList(dir);

          
    for (i=0; i<list.length; i++) {
        path = dir+list[i];
		sub_path = list[i];
		
        showProgress(i, list.length);
        if (endsWith(path,"/"))		// If path is a directory, recurse into the directory
            {
        		makeDirectories(dir, numberOfColours, namesArray, "");
            	RecurseDirectory(dir, sub_path);
            }

  
	//waitForUser("Done!", "Done upper loop!");
 	while (nImages>0) { 
          selectImage(nImages); 
          close(); 
      } 
}

waitForUser("Done", "Done Processing Images");
}




function RecurseDirectory (dir, sub_path)
{
	dir2 = dir+sub_path;
	listR = getFileList(dir2);

    
    for (i=0; i<listR.length; i++) {
        path2 = dir2+listR[i];
        sub_path2 = sub_path + listR[i];
        showProgress(i, listR.length);
        
        if (endsWith(path2,"/"))		// If path is a directory, recurse into the directory
            {
            	makeDirectories(dir, numberOfColours, namesArray, sub_path);
            	RecurseDirectory(dir, sub_path2);
            }


        //else if (endsWith(path2,"Pos0.ome.tif") || endsWith(path2,"Pos_000_000.ome.tif")) 
        else if (endsWith(path2,".ome.tif"))
		{
			open(path2);
        	if (nImages>=1) {
				PreprocessImages(dir, sub_path); }  
		}        

    }
    
    
	//waitForUser("Done!", "Done!");
 	while (nImages>0) { 
          selectImage(nImages); 
          close(); 
      } 
}











//note: Import the required arrays if necessary
function PreprocessImages(dir, sub_path){

FileName=getTitle();
getDimensions(width, height, channels, slices, frames);

//waitForUser(slices, frames);
//Stitch Images if Required
//if (endsWith(FileName, "Pos_000_000.ome.tif"))
//run("Grid/Collection stitching", "type=[Positions from file] order=[Defined by image metadata] browse=[" + dir + FileName + "] multi_series_file=[" + dir + FileName +"] fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 increase_overlap=0 computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");
	            
FileName=replace (FileName, ".ome.tif", "");


//waitForUser("HEY");
upperDir = sub_path;
upperDir = substring(upperDir, 0, lengthOf(upperDir)-1); //remove the first slash
while (!endsWith(upperDir, "\\") & !endsWith(upperDir, "/"))
	{
	//upperDir = Array.slice(upperDir, 0, upperDir.length-1);
	//waitForUser("UpperDir: ", upperDir);
	//waitForUser("length: ",lengthOf(upperDir));
	upperDir = substring(upperDir, 0, lengthOf(upperDir)-1);
	//waitForUser("Filename i uppers", upperDir);
	}


currentSlice = 0;
slicestring = "";

for (i=0; i<numberOfColours; i++)
{
	//waitForUser("Channels Per colour", channelsPerColour[1]);

	//File.makeDirectory(dir + "/" + namesArray[i] + "/" + sub_path);
	firstSlice = currentSlice + 1;  //starts at the beginning
	for (j=0; j<channelsPerColour[i]; j++)
	{
		lastSlice = currentSlice + 1;

		currentSlice = currentSlice+1;  //increment the counter
	}

	if (channels == 1)
	{

	//run("Make Substack...", "channels=" + firstSlice + "-" + lastSlice);
	//run ("Make Substack...", "channels=" + firstSlice + "-" + lastSlice + " frames=1-" + frames);
	//saveString =  upperDir + FileName + "_" + namesArray[i];
	//saveString = dir + namesArray[i] + "_Processed" + File.separator + upperDir + FileName;
	}
	else
	{
	run ("Make Substack...", "channels=" + firstSlice + "-" + lastSlice + " frames=1-" + frames);
	//saveString =  upperDir + namesArray[i] + "/" + FileName + "_" + namesArray[i];
	//saveString =  dir + namesArray[i] + "_Processed" + File.separator + upperDir + File.separator + FileName + "_" + namesArray[i];
	}

	saveString =  dir + namesArray[i] + "_Processed" + File.separator + upperDir + File.separator + FileName + "_" + namesArray[i];
	if(anisotropyArray[i])
	saveString = saveString + "_A";

	if(anisotropyArray[i] == 0)
	{
		saveString = saveString + "_I";
	}
	
	saveAs ("tiff", saveString + "_Preprocessed.tif");
	//close();

}

//Close all open images
 	while (nImages>0) { 
          selectImage(nImages); 
          close(); 
      } 

}

   
//You need to make the directories before you can save to them...   
function makeDirectories(dir, numberOfColours, namesArray, sub_path)
{
	for (i=0; i<numberOfColours; i++)
	{
		newDirectory = dir + namesArray[i] + "_Processed" + File.separator + sub_path;
		File.makeDirectory (newDirectory);

	}

	
}
 


//Other Functions:

//Find the previous directory to save all of the images
/*upperDir = dir;
upperDir = substring(upperDir, 0, lengthOf(upperDir)-1);
while (!endsWith(upperDir, "\\") & !endsWith(upperDir, "/"))
	{
	//upperDir = Array.slice(upperDir, 0, upperDir.length-1);
	upperDir = substring(upperDir, 0, lengthOf(upperDir)-1);
	//waitForUser("Filename i uppers", upperDir);
	}
*/

