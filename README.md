# imageJ-Anisotropy
<p align = "center">
  <a href="https://fiji.sc/">
<img src="https://fiji.sc/site/logo.png" alt "Fiji Logo" width="144" height="144"> 
  </a>
</p>


## Table of Contents
- [Overview](#overview)
- [Quick Start](#quick-start)
- [Status](#status)


## Overview
This is a series of plugins written in imageJ that can be used to either automatically or manually setect and output anisotropy values for targets (ex. cells or purified proteins) in fluorescence images.  These plugins were designed to handle either single or multi-colour fluorescence and therefore require some initial input to understand the structure of the input file.  

This page will be updated as the imageJ plugins become finalized.  It is recommended to use the python implementation of these plugins as it is faster, has much more functionality and is in current development.  This repository exists as a tool or guide for those who are more familiar with imageJ.


## Quick Start
Run the plugins in numerical order, skipping plugin 02a if you choose to manually select the cells.

### Plugin 00 - Preprocessing:
Separates your input files into their individual components and indentifies fluorescence images vs. anisotropy images as they are analyzed differently.

### Plugin 01 - Anisotropy Macro:
Calculates the anisotropy for all of the images that were identified as being anisotropy images.
It is important to change the optical parameters listed to suit your imaging setup as they influence how the k-factor correction is implemented.

### Plugin 02a - Segment Objects:
Automatically creates ROIs within the cells that will be used to create an anisotropy readout.  

### Plugin 03 - (ROI Selection) Weighted:
Outputs the anisotropy values to a .fritter file (equivalent to a .txt file).  Multiple values for the anisotropy are outputted (pixel-by-pixel anisotropy, weighted anisotropy, an average anisotropy as well as additional information (ex. intensity values and area)  



## Advanced Configuration
The most common configuration features are listed at the top of the document with explanations.

Documentation for more advanced changes will be updated as the plugins become finalized.


## Status
This project is gradually being replaced by a python implementation to improve speed and accuracy (see bio-lightnet and Anisotropy-Analysis)


Enjoy!
