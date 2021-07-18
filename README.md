# Microscopy analysis snippets
Some code snippets I often use in ImageJ macros

## ImageJ
- [x] **Max_project images**: Batch version for z-projecting Confocal images
- [x] **Nd2-to-8bit-tif.ijm**: Batch version for changing Image Type (e.g. pre NeuronJ)
- [x] **Intensity_measurements.ijm**: Batch version for measuring intensity of whole with semi-automatic thresholded selection
- [x] **Measure_saved_ROIs.ijm**: Loading and measuring all ROI-sets in a given folder & subfolder structure
- [x] **ROI-manager loops**: measuring, refining (&& ||), deleting
- [x] **Selection refinements in masks**: Automatic or manual threshold, +/- mask refinement
- [x] **Save line profiles**: several channels as a column including one for X-axis in µm
- [x] **Radial line profiles**: create "star" of lines (360° around specified line)
- [x] **Accumulations per area**: Count intensity peaks per area (PH-domain accumulations in axon)
- [ ] Stackreg / Multistackreg batch
- [ ] normalize histogram batch
- [x] **EzColoc_SemiManual.ijm**: Macro version of EzColoc plugin (https://github.com/DrHanLim/EzColocalization) on manually selected cells (with some basic ROI-refinement) 
- [x] **Filopodia counter**: Counts Filopodia around a cell as intensity maxima on a line 1 µm outside of cell mask
- [x] **Membrane recruitment analysis**: Determines intensities on cell surface, intracellularly & around nucleus


## R
- [x] **Randomize_folder.R**: copies and renames files in a folder & creates a lookup table for unblinding
- [x] **First_look_at_results.R**: loads all results files in a folder, does some basic data cleaning and visualization