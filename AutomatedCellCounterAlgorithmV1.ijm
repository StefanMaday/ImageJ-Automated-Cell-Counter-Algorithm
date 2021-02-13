requires("1.53g"); //Checks the ImageJ version to be compatible with the algorithm.

/*
 * Information Block:
 * Please feel free to contact Ivan Kondratyev (Ikondrat@bu.edu) with any suggestions, problems and ideas regarding the algorithm. This is still very much work in progress and any input is greately appreciated.
 * Some methods used by the algorithm require citation if the algorithm is used to analyse data that goes into a manuscript. Please see the guide that was distributed with the algorithm for more information!
 * Please see comments in code and user guide for instructions regarding the usage of the algorithm.
 */



//User-defined variables block. 
//Setting these manually allows to bypass all dialogs and furher automate the processing.
//Please note! The variables are presented sequentially, corresponding to their respective dialog position in the order of execution.

var triggerDialogs = 1; //If set to 0, disables all non-essential dialogs and forces the counter to use the variables below.

var pathSeparator = "/"; // System-invariant (as of imageJ v 1.53h) paramter that sets what is used to separate folders in directory path.
var fileExtension = ".oif"; // Specifies the extension of image files to be opened by the algorithm. Can be set to any of the image extensions supported by ImageJ.

var modeChoice = "Automatic"; //Sets the processing workflow. Options are Automatic (counts), Confirmation (automatic AND manual counts) and Calibration (allows to calibrate automatic methods).

//Please note! TuningParameter variables function as profiles for all low level processing algorithms. You have an option of either using pre-calibrated parameters or calibrating you rown with the "Calibration" processing mode. Consult the guide for mroe information.
var region1Name = "Dentate"; //Sets the name for the first ROI to be processed. Please avoid the "/" and "." signs in names, as this would interfere with counter's functions.
var region1DapiTuningParameter = 1; //The Dapi tuning preset of the region, where "1" corresponds to the dHPC Dentate and "2" to every other dHPC region. This value is crucial for the counter to select an appropriate Thresholding algorithm (meaningless for Deconvolution).
var region1CfosTuningParameter = 1; //The cfos tuning preset of the region. Right now only has generic preset "1".
var region1GFPTuningParameter = 1; //The GFP tuning preset of the region. Right now only has generic preset "1".
var region1OverlapTuningParameter = 1; //The Overlap tuning preset of the region. Right now only has generic preset "1".
var region1DapiChoice = 1; //If set to 1, enables the dapi counter for the region.
var region1CfosChoice = 1; //If set to 1, enables the cfos counter for the region.
var region1GfpChoice = 1; //If set to 1, enables the eYFP/GFP counter for the region.
var region1OverlapChoice = 1; //If set to 1, enables overlap dapi counter for the region.
var region1BrushSize = 50; //Sets the default size of the brush used to select the region ROI.
//Please note! Setting all four stain settings to "0" excludes the region from being counted for ALL images in the batch to be processed. Also ensures it is not included in the output summary.


var region2Name = "CA23"; //Same as above, but for Region 2
var region2DapiTuningParameter = 2;
var region2CfosTuningParameter = 1;
var region2GFPTuningParameter = 1;
var region2OverlapTuningParameter = 1;
var region2DapiChoice = 1;
var region2CfosChoice = 1;
var region2GfpChoice = 1;
var region2OverlapChoice = 1;
var region2BrushSize = 50;

var region3Name = "CA1"; // Region 3
var region3DapiTuningParameter = 2;
var region3CfosTuningParameter = 1;
var region3GFPTuningParameter = 1;
var region3OverlapTuningParameter = 1;
var region3DapiChoice = 1;
var region3CfosChoice = 1;
var region3GfpChoice = 1;
var region3OverlapChoice = 1;
var region3BrushSize = 50;

var region4Name = "Other"; //Region 4
var region4DapiTuningParameter = 2;
var region4CfosTuningParameter = 1;
var region4GFPTuningParameter = 1;
var region4OverlapTuningParameter = 1;
var region4DapiChoice = 1;
var region4CfosChoice = 1;
var region4GfpChoice = 1;
var region4OverlapChoice = 1;
var region4BrushSize = 100;
//Please note! If you intend to process more than 4 ROI per image, you need to write the same variable blocks for each region above 4. There is currently no way to do this automatically.

var dapiChannel = "C1-"; //Sets the channel for the dapi stain. Please note! In order to work, the channel number "C#" have to be followed by "-".
var cfosChannel = "C3-"; //Sets the channel for the cfos stain. Please note! In order to work, the channel number "C#" have to be followed by "-".
var gfpChannel = "C2-"; //Sets the channel for the gfp stain. Please note! In order to work, the channel number "C#" have to be followed by "-".

var confirmationDapiChoice = 0; //If set to 1, enables the manual confirmation of Dapi counts. Typically this is unfeasible or unwanted, therefore the default option is 0.
var confirmationCfosChoice = 1; //If set to 1, enables the manual confirmation of Cfos counts. Typically this is unfeasible or unwanted, therefore the default option is 0.
var confirmationGfpChoice = 1; //If set to 1, enables the manual confirmation of GFP counts. Typically this is unfeasible or unwanted, therefore the default option is 0.
var confirmationOverlapChoice = 1; //If set to 1, enables the manual confirmation of Overlap counts. Typically this is unfeasible or unwanted, therefore the default option is 0.

var calibrationDapiChoice = 0; //If set to 1, enables the manual calibration of Dapi counter. It is highly advised to run this on a selection fo images from each batch, to ensure most accurate counts.
var calibrationCfosChoice = 0; //If set to 1, enables the manual calibration of Cfos counter. It is highly advised to run this on a selection fo images from each batch, to ensure most accurate counts.
var calibrationGfpChoice = 0; //If set to 1, enables the manual calibration of GFP counter. It is highly advised to run this on a selection fo images from each batch, to ensure most accurate counts.
var calibrationOverlapChoice = 0; //If set to 1, enables the manual calibration of Overlap counter. It is highly advised to run this on a selection fo images from each batch, to ensure most accurate counts.

var confirmationPreProcessChoice = 0; //If set to 1, directs the confirmation function to use a user-defined pre-processing method on each original channel iamge. Please note! You need to manually enter the method in the appropriate function, located at the very bottom of this algorithm.
var confirmationOverlayChoice = 0; //If set to 1, enables the overlay of automated counts over the user-supplied manual counted window. This may be helpful when analysing convergence of the human and automated counting.
var confirmationOverlapSourceChoice = 0; //If set to 1, opens the original overlap (cfox x eYFP) image. Otherwise opens cfos and eYFP images separately, prompting the user to manually construct the overlap composite.
var confirmationSaveManualCountChoice = 1; //If set to 1, allows the usre to save their manual counter image.

var calibrationProfileChoice = 1; //If set to 1, substitues the newly calibrated tuning profile of the region for all subsequent images.
//Please note! User-defined Pre Processing functions for cfos and gfp confirmation WILL NOT be automatically applied to the images supplied for the manual overlap construction.

//End of Block



//Internal variable block.
//These variables handle the movement of data betweem various subroutines of the counter.

var inputDirectory = 0; //Sets the folder containing the images to be analyzed. Since directory dialog is enforced, has been moved to automatic variables
var outputDirectory = 0; //Sets the folder containing the counter output (tif images, ROI selections, etc).

var regionName = 0;
var region1SaveName = 0; // This variable is used to restore the user-defined region name after some internal transformations required to properly update the output table.
var region2SaveName = 0;
var region3SaveName = 0;
var region4SaveName = 0;

var regionStainName = 0;
var regionCount = 0;
var dapiCount = 0;
var cfosCount = 0;
var gfpCount = 0;
var overlapCount = 0;
var fileArray = 0;
var regionArray = 0;
var dapiArray = 0;
var cfosArray = 0;
var gfpArray = 0;
var overlapArray =0; 
var fileArrayAdd = "Null"; //Uses "Null" as the initial value to flag the first line of the output table to be deleted. If you want to use the first line of the counter as a separator, use some other value.
var regionArrayAdd = "Null";
var dapiArrayAdd = "Null";
var cfosArrayAdd = "Null";
var gfpArrayAdd = "Null";
var overlapArrayAdd = "Null";
var psfpath = 0;
var imagepath = 0;
var outputpath = 0;
var imageOutputPath = 0;
var filename = 0;
var regionFilename = 0;
var channelROIPath = 0;
var manualCountName = 0;
var manualPresence = 0;

var cfosROIPath = 0;
var gfpROIPath = 0;
var overlapROIPath = 0;

var dapiAutoPath =0;
var cfosAutoPath = 0;
var gfpAutoPath = 0;
var overlapAutoPath = 0;

var dapiEnhancedPath = 0;
var cfosEnhancedPath = 0;
var gfpEnhancedPath = 0;
var overlapEnhancedPath = 0;

var dapiOriginalPath = 0;
var cfosOriginalPath = 0;
var gfpOriginalPath = 0;
var overlapOriginalPath = 0;

var dapiManualPath = 0;
var cfosManualPath = 0;
var gfpManualPath = 0;
var overlapManualPath = 0;

var regenerateInstance = 0;
var saveName = 0;
var initialCount = 0;
var imageCount = 0;
var controlPanelChoice = 0;

//Stain indentification block
var dapiTuningParameter = 0;
var cfosTuningParameter = 0;
var gfpTuningParameter = 0;
var overlapTuningParameter = 0;
//End of Block

//A set of variables that transfer the text arguments between executable blocks and storage databases. This is required for the proper functioning of the code blocks generated during calibration, as the method of generation leaves out "" marks crucial for text arguments.
var elongation = "ELONGATION";
var compactness = "COMPACTNESS";
var volume = "VOLUME"; // Used both for Thresholding and Criteria.
var mser = "MSER";
var edges = "EDGES";

var step = "STEP";
var kmeans = "KMEANS";

var all = "All";
var best = "Best";

var filtering = "filtering";
var null = ""; // This variable is used to convey an empty string argument (for instance, if filtering is disabled, the parameter variable should be set to null).

var outlines = "Outlines";
var nothing = "Nothing";

var infinity = "Infinity";
var summarize = "summarize";
var add = "add";
//End of Block

//3D Thresholding arguments block
var criteriaMethodArray = newArray(elongation, compactness, volume, mser, edges);
var thresholdMethodArray = newArray(step, kmeans, volume);
var segmentResultsArray = newArray(all, best);
var filteringChoice = 0;

var minVolPix = 20; //Minimum object volume (Area for 2D images), measured in pixels. Setting to 0 is equal to having no minimum.
var maxVolPix = 100; //Maximum object volume (Area for 2D images), measured in pixels. DOES NOT SUPPORT "Infinity" or other absence of upper limit quantifications.
var minThreshold = 0; //Minimum threshold (brightness) of pixels to be processed. Use this to filter faint/background cells.
var minContrast = 0; //Minimum contrast of pixels to be processed. Contrast is a measure of how the pixel stands out from its global surrounding. Generally best to keep "0".
var criteriaMethod = "ELONGATION"; //Thresholding criteria, instructs the algorithm to prioritize a certain parameter. "ELONGATION" results in most round objects.
var thresholdMethod = "KMEANS"; //Determines how iterative thresholds are calculated. It is generally advised to keep it as "KMEANS" or "STEP".
var segmentResults = "All"; //Determines whether to segment all cells or only those that fit the algorithm's curve best. It is advised to keep this to 'All".
var valueMethod = 10; // Determines the number of iterations (Bins) the algorithm runs through. has a theoretical maximum of 255 for 8-bit images. It is advised to keep this around 10 unless there is a good reason to do otherwise.
var filteringParameter = ""; //Determines whether the source image is filtered before thresholding. Uses median filtering, this setting usually helps to remove noise in high-resolution images, but interferes with thresholding the low-resolution or high-density regions (such as dHPC Dentate Dapi).

var minVolPrint = 0;
var maxVolPrint = 0;
var minThresholdPrint = 0;
var minContrastPrint = 0;
var criteriaMethodPrint = 0;
var thresholdMethodPrint = 0;
var segmentResultsPrint = 0;
var valueMethodPrint = 0;
var filteringParameterPrint = 0;
				
//Cell Counter arguments block
var showArray = newArray(outlines, nothing);
var summaryChoice = 0;
var addChoice = 0;

var minSize = 0; //Minimum object size, measured in pixels. Setting to 0 is equal to having no minimum.
var maxSize = "Infinity"; //Maximum object size, measured in pixels. Can be a number of "Infinity" for no limit.
var minCircularity = 0.00; //Minimum object circularity. Has to be a number between o (Not circular at all) and 1 (perfect circle).
var maxCircularity = 1.00; //Maximum object circularity. Has to be a number between o (Not circular at all) and 1 (perfect circle).
var showMode = "Outlines"; //Setting to "Outlines" displays a windows with counted ROIs drawn, setting to "Nothing" displays nothing. See the method guide for other options.
var summaryMode = "summarize"; //Setting to "summarize" displays a Summary table with the number of counted cells printed, setting to ""(blank) does not do the count.
var addROIMode = "add"; //Setting to "add" adds all counted ROis to the ROI manager, setting to "" (blank) disables this option.

var minSizePrint = 0;
var maxSizePrint = 0;
var minCircularityPrint = 0;
var maxCircularityPrint = 0;

var regionOutputCfosPath = 0;
var regionOutputGFPPath = 0;
var regionOutputOverlapPath = 0;
var regionOutputDapiPath = 0;
var regionBrushSize = 0;

//Please note! If you intend to process more than 4 ROI per image, you need to add a variable for each additional region to each of the mini-blocks below.
var region1DapiAutoPath = 0;
var region2DapiAutoPath = 0;
var region3DapiAutoPath = 0;
var region4DapiAutoPath = 0;

var region1CfosAutoPath = 0;
var region2CfosAutoPath = 0;
var region3CfosAutoPath = 0;
var region4CfosAutoPath = 0;

var region1GFPAutoPath = 0;
var region2GFPAutoPath = 0;
var region3GFPAutoPath = 0;
var region4GFPAutoPath = 0;

var region1OverlapAutoPath = 0;
var region2OverlapAutoPath = 0;
var region3OverlapAutoPath = 0;
var region4OverlapAutoPath = 0;

var region1DapiEnhancedPath = 0;
var region2DapiEnhancedPath = 0;
var region3DapiEnhancedPath = 0;
var region4DapiEnhancedPath = 0;

var region1CfosEnhancedPath = 0;
var region2CfosEnhancedPath = 0;
var region3CfosEnhancedPath = 0;
var region4CfosEnhancedPath = 0;

var region1GFPEnhancedPath = 0;
var region2GFPEnhancedPath = 0;
var region3GFPEnhancedPath = 0;
var region4GFPEnhancedPath = 0;

var region1OverlapEnhancedPath = 0;
var region2OverlapEnhancedPath = 0;
var region3OverlapEnhancedPath = 0;
var region4OverlapEnhancedPath = 0;

var region1CfosROIPath = 0;
var region2CfosROIPath = 0;
var region3CfosROIPath = 0;
var region4CfosROIPath = 0;

var region1GFPROIPath = 0;
var region2GFPROIPath = 0;
var region3GFPROIPath = 0;
var region4GFPROIPath = 0;

var region1OverlapROIPath = 0;
var region2OverlapROIPath = 0;
var region3OverlapROIPath = 0;
var region4OverlapROIPath = 0;

var region1OriginalCfosPath = 0;
var region2OriginalCfosPath = 0;
var region3OriginalCfosPath = 0;
var region4OriginalCfosPath = 0;

var region1OriginalGFPPath = 0;
var region2OriginalGFPPath = 0;
var region3OriginalGFPPath = 0;
var region4OriginalGFPPath = 0;

var region1OriginalOverlapPath = 0;
var region2OriginalOverlapPath = 0;
var region3OriginalOverlapPath = 0;
var region4OriginalOverlapPath = 0;

var region1OriginalDapiPath = 0;
var region2OriginalDapiPath = 0;
var region3OriginalDapiPath = 0;
var region4OriginalDapiPath = 0;

var region1ManualDapiPath = 0;
var region2ManualDapiPath = 0;
var region3ManualDapiPath = 0;
var region4ManualDapiPath = 0;

var region1ManualCfosPath = 0;
var region2ManualCfosPath = 0;
var region3ManualCfosPath = 0;
var region4ManualCfosPath = 0;

var region1ManualGfpPath = 0;
var region2ManualGfpPath = 0;
var region3ManualGfpPath = 0;
var region4ManualGfpPath = 0;

var region1ManualOverlapPath = 0;
var region2ManualOverlapPath = 0;
var region3ManualOverlapPath = 0;
var region4ManualOverlapPath = 0;

//Region-specific methodTuning parameters

//Dapi Block
//Threshoilding:
var region1MinVolPixDapi = 0;
var region2MinVolPixDapi = 0;
var region3MinVolPixDapi = 0;
var region4MinVolPixDapi = 0;

var region1MaxVolPixDapi = 0;
var region2MaxVolPixDapi = 0;
var region3MaxVolPixDapi = 0;
var region4MaxVolPixDapi = 0;

var region1MinThresholdDapi = 0;
var region2MinThresholdDapi = 0;
var region3MinThresholdDapi = 0;
var region4MinThresholdDapi = 0;

var region1MinContrastDapi  = 0;
var region2MinContrastDapi  = 0;
var region3MinContrastDapi  = 0;
var region4MinContrastDapi  = 0;

var region1CriteriaMethodDapi = 0;
var region2CriteriaMethodDapi = 0;
var region3CriteriaMethodDapi = 0;
var region4CriteriaMethodDapi = 0;

var region1ThresholdMethodDapi = 0;
var region2ThresholdMethodDapi = 0;
var region3ThresholdMethodDapi = 0;
var region4ThresholdMethodDapi = 0;

var region1SegmentResultsDapi = 0;
var region2SegmentResultsDapi = 0;
var region3SegmentResultsDapi = 0;
var region4SegmentResultsDapi = 0;

var region1ValueMethodDapi = 0;
var region2ValueMethodDapi = 0;
var region3ValueMethodDapi = 0;
var region4ValueMethodDapi = 0;

var region1FilteringParameterDapi = 0;
var region2FilteringParameterDapi = 0;
var region3FilteringParameterDapi = 0;
var region4FilteringParameterDapi = 0;

//Counter:
var region1MinSizeDapi = 0;
var region2MinSizeDapi = 0;
var region3MinSizeDapi = 0;
var region4MinSizeDapi = 0;

var region1MaxSizeDapi = 0;
var region2MaxSizeDapi = 0;
var region3MaxSizeDapi = 0;
var region4MaxSizeDapi = 0;

var region1MinCircularityDapi = 0;
var region2MinCircularityDapi = 0;
var region3MinCircularityDapi = 0;
var region4MinCircularityDapi = 0;

var region1MaxCircularityDapi = 0;
var region2MaxCircularityDapi = 0;
var region3MaxCircularityDapi = 0;
var region4MaxCircularityDapi = 0;
//End of Block

//Cfos Block
var region1MinVolPixCfos = 0;
var region2MinVolPixCfos = 0;
var region3MinVolPixCfos = 0;
var region4MinVolPixCfos = 0;

var region1MaxVolPixCfos = 0;
var region2MaxVolPixCfos = 0;
var region3MaxVolPixCfos = 0;
var region4MaxVolPixCfos = 0;

var region1MinThresholdCfos = 0;
var region2MinThresholdCfos = 0;
var region3MinThresholdCfos = 0;
var region4MinThresholdCfos = 0;

var region1MinContrastCfos  = 0;
var region2MinContrastCfos  = 0;
var region3MinContrastCfos  = 0;
var region4MinContrastCfos  = 0;

var region1CriteriaMethodCfos = 0;
var region2CriteriaMethodCfos = 0;
var region3CriteriaMethodCfos = 0;
var region4CriteriaMethodCfos = 0;

var region1ThresholdMethodCfos = 0;
var region2ThresholdMethodCfos = 0;
var region3ThresholdMethodCfos = 0;
var region4ThresholdMethodCfos = 0;

var region1SegmentResultsCfos = 0;
var region2SegmentResultsCfos = 0;
var region3SegmentResultsCfos = 0;
var region4SegmentResultsCfos = 0;

var region1ValueMethodCfos = 0;
var region2ValueMethodCfos = 0;
var region3ValueMethodCfos = 0;
var region4ValueMethodCfos = 0;

var region1FilteringParameterCfos = 0;
var region2FilteringParameterCfos = 0;
var region3FilteringParameterCfos = 0;
var region4FilteringParameterCfos = 0;

//Counter:
var region1MinSizeCfos = 0;
var region2MinSizeCfos = 0;
var region3MinSizeCfos = 0;
var region4MinSizeCfos = 0;

var region1MaxSizeCfos = 0;
var region2MaxSizeCfos = 0;
var region3MaxSizeCfos = 0;
var region4MaxSizeCfos = 0;

var region1MinCircularityCfos = 0;
var region2MinCircularityCfos = 0;
var region3MinCircularityCfos = 0;
var region4MinCircularityCfos = 0;

var region1MaxCircularityCfos = 0;
var region2MaxCircularityCfos = 0;
var region3MaxCircularityCfos = 0;
var region4MaxCircularityCfos = 0;
//End of Block

//GFP Block
var region1MinVolPixGFP = 0;
var region2MinVolPixGFP = 0;
var region3MinVolPixGFP = 0;
var region4MinVolPixGFP = 0;

var region1MaxVolPixGFP = 0;
var region2MaxVolPixGFP = 0;
var region3MaxVolPixGFP = 0;
var region4MaxVolPixGFP = 0;

var region1MinThresholdGFP = 0;
var region2MinThresholdGFP = 0;
var region3MinThresholdGFP = 0;
var region4MinThresholdGFP = 0;

var region1MinContrastGFP  = 0;
var region2MinContrastGFP  = 0;
var region3MinContrastGFP  = 0;
var region4MinContrastGFP  = 0;

var region1CriteriaMethodGFP = 0;
var region2CriteriaMethodGFP = 0;
var region3CriteriaMethodGFP = 0;
var region4CriteriaMethodGFP = 0;

var region1ThresholdMethodGFP = 0;
var region2ThresholdMethodGFP = 0;
var region3ThresholdMethodGFP = 0;
var region4ThresholdMethodGFP = 0;

var region1SegmentResultsGFP = 0;
var region2SegmentResultsGFP = 0;
var region3SegmentResultsGFP = 0;
var region4SegmentResultsGFP = 0;

var region1ValueMethodGFP = 0;
var region2ValueMethodGFP = 0;
var region3ValueMethodGFP = 0;
var region4ValueMethodGFP = 0;

var region1FilteringParameterGFP = 0;
var region2FilteringParameterGFP = 0;
var region3FilteringParameterGFP = 0;
var region4FilteringParameterGFP = 0;

//Counter:
var region1MinSizeGFP = 0;
var region2MinSizeGFP = 0;
var region3MinSizeGFP = 0;
var region4MinSizeGFP = 0;

var region1MaxSizeGFP = 0;
var region2MaxSizeGFP = 0;
var region3MaxSizeGFP = 0;
var region4MaxSizeGFP = 0;

var region1MinCircularityGFP = 0;
var region2MinCircularityGFP = 0;
var region3MinCircularityGFP = 0;
var region4MinCircularityGFP = 0;

var region1MaxCircularityGFP = 0;
var region2MaxCircularityGFP = 0;
var region3MaxCircularityGFP = 0;
var region4MaxCircularityGFP = 0;
//End of Block

//Overlap Block

//Counter:
var region1MinSizeOverlap = 0;
var region2MinSizeOverlap = 0;
var region3MinSizeOverlap = 0;
var region4MinSizeOverlap = 0;

var region1MaxSizeOverlap = 0;
var region2MaxSizeOverlap = 0;
var region3MaxSizeOverlap = 0;
var region4MaxSizeOverlap = 0;

var region1MinCircularityOverlap = 0;
var region2MinCircularityOverlap = 0;
var region3MinCircularityOverlap = 0;
var region4MinCircularityOverlap = 0;

var region1MaxCircularityOverlap = 0;
var region2MaxCircularityOverlap = 0;
var region3MaxCircularityOverlap = 0;
var region4MaxCircularityOverlap = 0;
//End of Block

//End of Block


//Displays a Dialog via which the user can specify the input and output directories. Please note, this is a NECESSARY dialog.
inputDirectory = getDirectory("Please specify the folder that contains the images to be analyzed");
outputDirectory = inputDirectory+"Output";
File.makeDirectory(outputDirectory);
//End of Block

//Displays a Dialog, via which the user can specify the file extension to be opened by the algorithm.
if (triggerDialogs == 1)
{
	fileExtensionarray = newArray(".oif",".tif",".png",".czi"); //Please note, you can add any other image extension to this array and it will be displayed in the dialog window.
	Dialog.create("File extension");
	Dialog.addChoice("Please select the extension of your image files:", fileExtensionarray, ".oif");
	Dialog.show();
	fileExtension = Dialog.getChoice();
}
//End of Block

//Displays a Dialog via which the user can set the automation parameter.
if (triggerDialogs == 1)
{
	buttonsMode = newArray("Automatic", "Confirmation & Calibration");
    Dialog.create("Mode selection");
    Dialog.addRadioButtonGroup("Please select the processing mode:", buttonsMode, 2, 1, "Automatic");
    Dialog.show();
    modeChoice = Dialog.getRadioButton();
}
//End of Block

//Displays a Dialog via which the user can set the number of regions to be analyzed per image
if (triggerDialogs == 1 )
{
    labelArray = newArray("dapi", "cfos", "GFP", "Overlap");
    defaultArray = newArray(true, true, true, true);
    idArray = newArray("1","2","3","4","5","6","7","8","9");
    Dialog.create("Region setup");
    Dialog.addCheckboxGroup(1, 4, labelArray, defaultArray);
    Dialog.addString("Region 1 name:", "Dentate");
    Dialog.addChoice("dapi tuning parameter:", idArray, 1);
    Dialog.addToSameRow();
    Dialog.addChoice("cfos tuning parameter:", idArray, 2);
    Dialog.addToSameRow();
    Dialog.addChoice("GFP tuning parameter:", idArray, 2);
    Dialog.addToSameRow();
    Dialog.addChoice("Overlap tuning parameter:", idArray, 1);
    
    Dialog.addCheckboxGroup(1, 4, labelArray, defaultArray);
    Dialog.addString("Region 2 name:", "CA23");
    Dialog.addChoice("dapi tuning parameter:", idArray, 2);
    Dialog.addToSameRow();
    Dialog.addChoice("cfos tuning parameter:", idArray, 2);
    Dialog.addToSameRow();
    Dialog.addChoice("GFP tuning parameter:", idArray, 2);
    Dialog.addToSameRow();
    Dialog.addChoice("Overlap tuning parameter:", idArray, 1);
    
    Dialog.addCheckboxGroup(1, 4, labelArray, defaultArray);
    Dialog.addString("Region 3 name:", "CA1");
    Dialog.addChoice("dapi tuning parameter:", idArray, 2);
    Dialog.addToSameRow();
    Dialog.addChoice("cfos tuning parameter:", idArray, 2);
    Dialog.addToSameRow();
    Dialog.addChoice("GFP tuning parameter:", idArray, 2);
    Dialog.addToSameRow();
    Dialog.addChoice("Overlap tuning parameter:", idArray, 1);
    
    Dialog.addCheckboxGroup(1, 4, labelArray, defaultArray);
    Dialog.addString("Region 4 name:", "Other");
    Dialog.addChoice("dapi tuning parameter:", idArray, 2);
    Dialog.addToSameRow();
    Dialog.addChoice("cfos tuning parameter:", idArray, 2);
    Dialog.addToSameRow();
    Dialog.addChoice("GFP tuning parameter:", idArray, 2);
    Dialog.addToSameRow();
    Dialog.addChoice("Overlap tuning parameter:", idArray, 1);
    Dialog.show();
    
    region1DapiChoice = Dialog.getCheckbox();
    region1CfosChoice = Dialog.getCheckbox();
    region1GfpChoice = Dialog.getCheckbox();
    region1OverlapChoice = Dialog.getCheckbox();
    region1Name = Dialog.getString();
    region1DapiTuningParameter = Dialog.getChoice();
    region1CfosTuningParameter = Dialog.getChoice();
    region1GFPTuningParameter = Dialog.getChoice();
    region1OverlapTuningParameter = Dialog.getChoice();
    
    region2DapiChoice = Dialog.getCheckbox();
    region2CfosChoice = Dialog.getCheckbox();
    region2GfpChoice = Dialog.getCheckbox();
    region2OverlapChoice = Dialog.getCheckbox();
    region2Name = Dialog.getString();
    region2DapiTuningParameter = Dialog.getChoice();
    region2CfosTuningParameter = Dialog.getChoice();
    region2GFPTuningParameter = Dialog.getChoice();
    region2OverlapTuningParameter = Dialog.getChoice();
    
    region3DapiChoice = Dialog.getCheckbox();
    region3CfosChoice = Dialog.getCheckbox();
    region3GfpChoice = Dialog.getCheckbox();
    region3OverlapChoice = Dialog.getCheckbox();
    region3Name = Dialog.getString();
    region3DapiTuningParameter = Dialog.getChoice();
    region3CfosTuningParameter = Dialog.getChoice();
    region3GFPTuningParameter = Dialog.getChoice();
    region3OverlapTuningParameter = Dialog.getChoice();
    
    region4DapiChoice = Dialog.getCheckbox();
    region4CfosChoice = Dialog.getCheckbox();
    region4GfpChoice = Dialog.getCheckbox();
    region4OverlapChoice = Dialog.getCheckbox();
    region4Name = Dialog.getString();
    region4DapiTuningParameter = Dialog.getChoice();
    region4CfosTuningParameter = Dialog.getChoice();
    region4GFPTuningParameter = Dialog.getChoice();
    region4OverlapTuningParameter = Dialog.getChoice();
}
//End of Block



//Main Executable of the counter. Corresponds to the 0th level of processing (Algorithmic):
run("Clear Results"); //A legacy function, used for compatinility with other workflows. Deletes all entries from the results master-table.
Table.create("Cell Counts"); //Creates a table to store the counts. The table is updated after each image in the batch is processed.

setBatchMode(true); //Enables batch mode, significantly increasing the processing speed of automatic counter.
	
filelist = getFileList(inputDirectory); //Scans the input directory for files.
for (i = 0; i < lengthOf(filelist); i++) //This function loops over all images in the input folder and opens up ".oif" images.
{
	FileNameM = filelist[i];
	pathofile = inputDirectory + FileNameM;
	if (endsWith(pathofile,fileExtension)==1) //Please note! Ff you need other image formats to be opened by this function, you need to add an additional "if" statement replacing ".oif" with ".extension" of your images.
	{
		processImage(filelist[i]); //This function is the master-function of the counter, it serves as root hub for all subroutines and data transformations.
	}
}
selectWindow("Cell Counts");
saveAs("results"); //Saves the final version of the counts data table as an excell file.
//End of Block





//Automated Counter functions. They control the machine-driven analysis workflow and require minimum user interaction:

//Master-Function of the counter. ALL other functions must be called from here:
function processImage(imageFile)
{
	//Opens up the iamge to be processed
	prevNumResults = nResults;
	open(imageFile);
	filename = getTitle();

	//Saves region names to the temporary variables in order to preserve them from being corrupted by the internal transformations of the algorithm)
	region1SaveName = region1Name;
	region2SaveName = region2Name;
	region3SaveName = region3Name;
	region4SaveName = region4Name;
	//End of Block

    //Sets up the image file directory in the Output folder.
    //Please note! If you intend to process more than 4 ROI per image, you need to manually add them (in a similar fashion) to each of the region mini-blocks below.
	imageOutputPath = outputDirectory+pathSeparator+filename;
	
	region1OutputPath = imageOutputPath+pathSeparator+region1Name;
	region2OutputPath = imageOutputPath+pathSeparator+region2Name;
	region3OutputPath = imageOutputPath+pathSeparator+region3Name;
	region4OutputPath = imageOutputPath+pathSeparator+region4Name;

	region1OutputDapiPath = region1OutputPath+pathSeparator+"Dapi";
	region1OutputGFPPath = region1OutputPath+pathSeparator+"GFP";
	region1OutputCfosPath = region1OutputPath+pathSeparator+"Cfos";
	region1OutputOverlapPath = region1OutputPath+pathSeparator+"Overlap";

    region2OutputDapiPath = region2OutputPath+pathSeparator+"Dapi";
	region2OutputGFPPath = region2OutputPath+pathSeparator+"GFP";
	region2OutputCfosPath = region2OutputPath+pathSeparator+"Cfos";
	region2OutputOverlapPath = region2OutputPath+pathSeparator+"Overlap";

    region3OutputDapiPath = region3OutputPath+pathSeparator+"Dapi";
	region3OutputGFPPath = region3OutputPath+pathSeparator+"GFP";
	region3OutputCfosPath = region3OutputPath+pathSeparator+"Cfos";
	region3OutputOverlapPath = region3OutputPath+pathSeparator+"Overlap";

    region4OutputDapiPath = region4OutputPath+pathSeparator+"Dapi";
	region4OutputGFPPath = region4OutputPath+pathSeparator+"GFP";
	region4OutputCfosPath = region4OutputPath+pathSeparator+"Cfos";
	region4OutputOverlapPath = region4OutputPath+pathSeparator+"Overlap";
	
	File.makeDirectory(imageOutputPath);
	
	File.makeDirectory(region1OutputPath);
	File.makeDirectory(region2OutputPath);
	File.makeDirectory(region3OutputPath);
	File.makeDirectory(region4OutputPath);

	File.makeDirectory(region1OutputDapiPath);	
	File.makeDirectory(region1OutputGFPPath);
	File.makeDirectory(region1OutputCfosPath);
	File.makeDirectory(region1OutputOverlapPath);

	File.makeDirectory(region2OutputDapiPath);	
	File.makeDirectory(region2OutputGFPPath);
	File.makeDirectory(region2OutputCfosPath);
	File.makeDirectory(region2OutputOverlapPath);

	File.makeDirectory(region3OutputDapiPath);	
	File.makeDirectory(region3OutputGFPPath);
	File.makeDirectory(region3OutputCfosPath);
	File.makeDirectory(region3OutputOverlapPath);

	File.makeDirectory(region4OutputDapiPath);	
	File.makeDirectory(region4OutputGFPPath);
	File.makeDirectory(region4OutputCfosPath);
	File.makeDirectory(region4OutputOverlapPath);
    //End of Block

    //Sets up the manual confirmation of the channels' color.
    run("Duplicate...", "title=ChannelSelector duplicate");
    selectWindow("ChannelSelector");
    rename(filename+"ChannelSelector");
    setOption("ScaleConversions", true);
    run("8-bit");
    run("Split Channels");
    if (triggerDialogs == 1) 
    {
    	selectWindow("C1-"+filename+"ChannelSelector");
    	setBatchMode("show");
    	selectWindow("C2-"+filename+"ChannelSelector");
	    setBatchMode("show");
	    selectWindow("C3-"+filename+"ChannelSelector");
	    setBatchMode("show");
	    Dialog.createNonBlocking("Channel selection");
        Dialog.addChoice("DAPI channel:", newArray("C1-","C2-","C3-"),"C1-");
        Dialog.addChoice("cfos channel:", newArray("C1-","C2-","C3-"),"C3-");
        Dialog.addChoice("GFP channel:", newArray("C1-","C2-","C3-"),"C2-");
        Dialog.show();
        dapiChannel = Dialog.getChoice();
        cfosChannel = Dialog.getChoice();
        gfpChannel = Dialog.getChoice();
    }
    //End of Block

    originalImageSave(imageFile); // Uses orignal channel images to construct composite tiffs for demonstrations / papers. Creates two images, original and enhanced, for cfos, gfp and overlap. All are saved in the image folder.

    //Please note! If you intend to process more than 4 ROI per image, you need to manually add all additional region blocks below.
    //Processes Region 1
    //This mini-block transfers region-specific paramteres to the variables used by the lower-level sub-routines. In other words, this is the input block
    regionName = region1Name;
    regionCount = 1;
    regionDapiChoice = region1DapiChoice;
    regionCfosChoice = region1CfosChoice;
    regionGfpChoice = region1GfpChoice;
    regionOverlapChoice = region1OverlapChoice;
    regionOutputDapiPath = region1OutputDapiPath;
    regionOutputCfosPath = region1OutputCfosPath;
    regionOutputGFPPath = region1OutputGFPPath;
    regionOutputOverlapPath = region1OutputOverlapPath;
    dapiTuningParameter = region1DapiTuningParameter;
    cfosTuningParameter = region1CfosTuningParameter;
    gfpTuningParameter = region1GFPTuningParameter;
    overlapTuningParameter = region1OverlapTuningParameter;
    regionBrushSize = region1BrushSize;
    //End of Block

    processRegion(imageFile); //This function controls the processing of each region.
    
    //This mini-block transfers the output parameteres and values from the lower-level subroutines to the region-specific variables. Together, the two blocks control the flow of information between different functional levels of the counter.
    region1Name = regionName;
    region1DapiCount = dapiCount;
    region1CfosCount = cfosCount;
    region1GfpCount = gfpCount;
    region1OverlapCount = overlapCount;
    region1FileName = regionFilename;
    region1DapiAutoPath = dapiAutoPath;
    region1CfosAutoPath = cfosAutoPath;
    region1GFPAutoPath = gfpAutoPath;
    region1OverlapAutoPath = overlapAutoPath;
    region1DapiEnhancedPath = dapiEnhancedPath;
    region1CfosEnhancedPath = cfosEnhancedPath;
    region1GFPEnhancedPath = gfpEnhancedPath;
    region1OverlapEnhancedPath = overlapEnhancedPath;
    region1CfosROIPath = cfosROIPath;
    region1GFPROIPath = gfpROIPath;
    region1OverlapROIPath = overlapROIPath;
    region1OriginalDapiPath = dapiOriginalPath;
    region1OriginalCfosPath = cfosOriginalPath;
    region1OriginalGFPPath = gfpOriginalPath;
    region1OriginalOverlapPath = overlapOriginalPath;
    // End of Block

    //Processes CA23 (Region 2)
    regionName = region2Name;
    regionCount = 2;
    regionDapiChoice = region2DapiChoice;
    regionCfosChoice = region2CfosChoice;
    regionGfpChoice = region2GfpChoice;
    regionOverlapChoice = region2OverlapChoice;
    regionOutputDapiPath = region2OutputDapiPath;
    regionOutputCfosPath = region2OutputCfosPath;
    regionOutputGFPPath = region2OutputGFPPath;
    regionOutputOverlapPath = region2OutputOverlapPath;
    dapiTuningParameter = region2DapiTuningParameter;
    cfosTuningParameter = region2CfosTuningParameter;
    gfpTuningParameter = region2GFPTuningParameter;
    overlapTuningParameter = region2OverlapTuningParameter;
    regionBrushSize = region2BrushSize;

    processRegion(imageFile);

    region2Name = regionName;
    region2DapiCount = dapiCount;
    region2CfosCount = cfosCount;
    region2GfpCount = gfpCount;
    region2OverlapCount = overlapCount;
    region2FileName = regionFilename;
    region2DapiAutoPath = dapiAutoPath;
    region2CfosAutoPath = cfosAutoPath;
    region2GFPAutoPath = gfpAutoPath;
    region2OverlapAutoPath = overlapAutoPath;
    region2DapiEnhancedPath = dapiEnhancedPath;
    region2CfosEnhancedPath = cfosEnhancedPath;
    region2GFPEnhancedPath = gfpEnhancedPath;
    region2OverlapEnhancedPath = overlapEnhancedPath;
    region2CfosROIPath = cfosROIPath;
    region2GFPROIPath = gfpROIPath;
    region2OverlapROIPath = overlapROIPath;
    region2OriginalDapiPath = dapiOriginalPath;
    region2OriginalCfosPath = cfosOriginalPath;
    region2OriginalGFPPath = gfpOriginalPath;
    region2OriginalOverlapPath = overlapOriginalPath;
    // End of Block

    //Processes CA1 (Region 3)
    regionName = region3Name;
    regionCount = 3;
    regionDapiChoice = region3DapiChoice;
    regionCfosChoice = region3CfosChoice;
    regionGfpChoice = region3GfpChoice;
    regionOverlapChoice = region3OverlapChoice;
    regionOutputDapiPath = region3OutputDapiPath;
    regionOutputCfosPath = region3OutputCfosPath;
    regionOutputGFPPath = region3OutputGFPPath;
    regionOutputOverlapPath = region3OutputOverlapPath;
    dapiTuningParameter = region3DapiTuningParameter;
    cfosTuningParameter = region3CfosTuningParameter;
    gfpTuningParameter = region3GFPTuningParameter;
    overlapTuningParameter = region3OverlapTuningParameter;
    regionBrushSize = region3BrushSize;

    processRegion(imageFile);

    region3Name = regionName;
    region3DapiCount = dapiCount;
    region3CfosCount = cfosCount;
    region3GfpCount = gfpCount;
    region3OverlapCount = overlapCount;
    region3FileName = regionFilename;
    region3DapiAutoPath = dapiAutoPath;
    region3CfosAutoPath = cfosAutoPath;
    region3GFPAutoPath = gfpAutoPath;
    region3OverlapAutoPath = overlapAutoPath;
    region3DapiEnhancedPath = dapiEnhancedPath;
    region3CfosEnhancedPath = cfosEnhancedPath;
    region3GFPEnhancedPath = gfpEnhancedPath;
    region3OverlapEnhancedPath = overlapEnhancedPath;
    region3CfosROIPath = cfosROIPath;
    region3GFPROIPath = gfpROIPath;
    region3OverlapROIPath = overlapROIPath;
    region3OriginalDapiPath = dapiOriginalPath;
    region3OriginalCfosPath = cfosOriginalPath;
    region3OriginalGFPPath = gfpOriginalPath;
    region3OriginalOverlapPath = overlapOriginalPath;
    // End of Block

    //ProcessesOther (Region 4)
    regionName = region4Name;
    regionCount = 4;
    regionDapiChoice = region4DapiChoice;
    regionCfosChoice = region4CfosChoice;
    regionGfpChoice = region4GfpChoice;
    regionOverlapChoice = region4OverlapChoice;
    regionOutputDapiPath = region4OutputDapiPath;
    regionOutputCfosPath = region4OutputCfosPath;
    regionOutputGFPPath = region4OutputGFPPath;
    regionOutputOverlapPath = region4OutputOverlapPath;
    dapiTuningParameter = region4DapiTuningParameter;
    cfosTuningParameter = region4CfosTuningParameter;
    gfpTuningParameter = region4GFPTuningParameter;
    overlapTuningParameter = region4OverlapTuningParameter;
    regionBrushSize = region4BrushSize;

    processRegion(imageFile);

    region4Name = regionName;
    region4DapiCount = dapiCount;
    region4CfosCount = cfosCount;
    region4GfpCount = gfpCount;
    region4OverlapCount = overlapCount;
    region4FileName = regionFilename;
    region4DapiAutoPath = dapiAutoPath;
    region4CfosAutoPath = cfosAutoPath;
    region4GFPAutoPath = gfpAutoPath;
    region4OverlapAutoPath = overlapAutoPath;
    region4DapiEnhancedPath = dapiEnhancedPath;
    region4CfosEnhancedPath = cfosEnhancedPath;
    region4GFPEnhancedPath = gfpEnhancedPath;
    region4OverlapEnhancedPath = overlapEnhancedPath;
    region4CfosROIPath = cfosROIPath;
    region4GFPROIPath = gfpROIPath;
    region4OverlapROIPath = overlapROIPath;
    region4OriginalDapiPath = dapiOriginalPath;
    region4OriginalCfosPath = cfosOriginalPath;
    region4OriginalGFPPath = gfpOriginalPath;
    region4OriginalOverlapPath = overlapOriginalPath;
    // End of Block

    //Iteratively appends all results to the custom output table. Primarily designed to solve the problem of Iterative Thresholding spawning a new "Results" table for each instance.
    fileArray = newArray(region1FileName, region2FileName, region3FileName, region4FileName);
    regionArray = newArray(region1Name, region2Name, region3Name, region4Name);
    dapiArray = newArray(region1DapiCount, region2DapiCount, region3DapiCount, region4DapiCount);
    cfosArray = newArray(region1CfosCount, region2CfosCount, region3CfosCount, region4CfosCount);
    gfpArray = newArray(region1GfpCount, region2GfpCount, region3GfpCount, region4GfpCount);
    overlapArray = newArray(region1OverlapCount, region2OverlapCount, region3OverlapCount, region4OverlapCount);
    fileArrayAdd = Array.concat(fileArrayAdd, fileArray);
    regionArrayAdd = Array.concat(regionArrayAdd, regionArray);
    dapiArrayAdd = Array.concat(dapiArrayAdd, dapiArray);
    cfosArrayAdd = Array.concat(cfosArrayAdd, cfosArray);
    gfpArrayAdd = Array.concat(gfpArrayAdd, gfpArray);
    overlapArrayAdd = Array.concat(overlapArrayAdd, overlapArray);
    // End of Block

    // Deletes all "Null" entries from the results table
    fileArrayShow = Array.deleteValue(fileArrayAdd, "Null");
    regionArrayShow = Array.deleteValue(regionArrayAdd, "Null");
    dapiArrayShow = Array.deleteValue(dapiArrayAdd, "Null");
    cfosArrayShow = Array.deleteValue(cfosArrayAdd, "Null");
    gfpArrayShow = Array.deleteValue(gfpArrayAdd, "Null");
    overlapArrayShow = Array.deleteValue(overlapArrayAdd, "Null");
    // End of Block

    // Updates the results table
    selectWindow("Cell Counts");
    Table.setColumn("File", fileArrayShow);
    Table.setColumn("Region", regionArrayShow);
    Table.setColumn("DAPI", dapiArrayShow);
    Table.setColumn("cfos", cfosArrayShow);
    Table.setColumn("GFP", gfpArrayShow); 
    Table.setColumn("Overlap", overlapArrayShow);
    Table.update;
    //End of Block

    close("*"); //Closes all image windows, hidden or displayed. This prepares the counter to handle the next image.

   //Confirmation & Calibration Block:
    if (modeChoice != "Automatic")
    {
    	confirmImage(imageFile); // Confirmation master-function. Fulfills a similar role to "processRegion" function. Only called if the user selects 'Confirmation" processing mode.
    }
   //End of Block

   close("*");

   //Region Name restoration block
   region1Name = region1SaveName;
   region2Name = region2SaveName;
   region3Name = region3SaveName;
   region4Name = region4SaveName;
   //End of Block

}

//Region master-function. It is called for each region and, depending on user-defined parameter variables, calls appropriate methods to process various stains (dapi, eYFp, cfos, overlap).
function processRegion(imageFile)
{
	if ((regionDapiChoice||regionCfosChoice||regionGfpChoice||regionOverlapChoice) == 0) //Automatically marks non-processed regions for deletion from the results table and skips their processing.Non-processed regions are defined by having all analysis options set to 0.
	{
		regionFilename = "Null";
		regionName = "Null";
		dapiCount = "Null";
		cfosCount = "Null";
		gfpCount = "Null";
		overlapCount = "Null";
	}
	else
	{
		//Please note! This is a NECESSARY dialog, there is no way to bypass it. Prompts the user to define the ROI or skip the region altogether if ROI cannot be defined.
		selectWindow(filename);
		setBatchMode("show");
		setTool("brush");
		call("ij.gui.Toolbar.setBrushSize", regionBrushSize); // Sets the brush size
		Roi.remove
		buttons = newArray("Process", "Skip");
		noError = 0;
		while (noError == 0)
		{
			Dialog.createNonBlocking("Please select"+" "+regionName+" "+"ROI");
			Dialog.addRadioButtonGroup("Process ROI?", buttons, 1, 3, "Process");
			Dialog.show();
			dialogButton = Dialog.getRadioButton();

			if (dialogButton == "Process")
			{
				//Displays an error if there is no ROI selection. Used to prevent the algorithm from aborting.
				roiSize = Roi.size;
				if (roiSize != 0)
				{
					noError = 1;
				}
				else
				{
					Dialog.create("Warning!");
					Dialog.addMessage("Error! Please use the brush tool to draw your ROI on the image or select the Skip option", 15, "#FF0000");
					Dialog.show();
					noError = 0;
				}
			}
			else
			{
				noError = 1;
			}
			//End of Block
		}
		//End of Block
		
		if (dialogButton == "Process")
		{
			//Prepares the region for processing by isolating it from the parent image.
			setBatchMode("hide");
			run("Duplicate...", "title=Region duplicate");
			selectWindow("Region");
			rename(filename+regionName);
			preProcess(imageFile);
			//End of Block
			
			//Processes dapi
			if (regionDapiChoice == 1) //Processes dapi channel of the region. If dapi option is disabled, writes it as N/A.
			{
				regionStainName = "Dapi";
				selectWindow(dapiChannel+filename+regionName);
				setBatchMode("hide");
				rename(filename+"_"+regionName+"_dapi");
				save(regionOutputDapiPath+pathSeparator+filename+"_"+regionName+"_Original_Dapi"+".tif");
				dapiOriginalPath = regionOutputDapiPath+pathSeparator+filename+"_"+regionName+"_Original_Dapi"+".tif";
				run("Duplicate...", "title=dapiRegionEnhancedFeed duplicate");
				selectWindow("dapiRegionEnhancedFeed");
				enhanceContrast(imageFile); // This is a method that auto_enhances constrast of images.
				save(regionOutputDapiPath+pathSeparator+filename+"_"+regionName+"_Enhanced_Dapi"+".tif");
				dapiEnhancedPath = regionOutputDapiPath+pathSeparator+filename+"_"+regionName+"_Enhanced_Dapi"+".tif";
				close();
				selectWindow(filename+"_"+regionName+"_dapi");
				countDapi(imageFile); //This is the THRESHOLDING method, used by default.
			}
			else 
			{
				dapiCount = "N/A";
			}
			//End of Block
			
			//Processes cfos.
			if (regionCfosChoice == 1) //Same as above, except it also saves a .tif image for Original and auto-Enhanced region. If processing mode is set to "Confirmation," also saves the auto-thresholded image, auto-counted image and counted ROIs. All images are saved in the automatically generated Output folder.
			{
				regionStainName = "Cfos";
				selectWindow(cfosChannel+filename+regionName);
				setBatchMode("hide");
				rename(filename+"_"+regionName+"_cfos");
				save(regionOutputCfosPath+pathSeparator+filename+"_"+regionName+"_Original_Cfos"+".tif");
				cfosOriginalPath = regionOutputCfosPath+pathSeparator+filename+"_"+regionName+"_Original_Cfos"+".tif";
				run("Duplicate...", "title=cfosRegionEnhancedFeed duplicate");
				selectWindow("cfosRegionEnhancedFeed");
				enhanceContrast(imageFile);
				save(regionOutputCfosPath+pathSeparator+filename+"_"+regionName+"_Enhanced_Cfos"+".tif");
				cfosEnhancedPath = regionOutputCfosPath+pathSeparator+filename+"_"+regionName+"_Enhanced_Cfos"+".tif";
				selectWindow(filename+"_"+regionName+"_cfos");
				countCfos(imageFile); // This is the main cfos method. Like all non-dapi methods, it utilises 3D Iterative Thresholding for segmentation and Cell Counter for counting.
			}
			else
			{
				cfosCount = "N/A";
			}
			//End of Block
			
			//Processes GFP/eYFP.
			if (regionGfpChoice == 1)
			{
				regionStainName = "GFP";
				selectWindow(gfpChannel+filename+regionName);
				setBatchMode("hide");
				rename(filename+"_"+regionName+"_GFP");
				save(regionOutputGFPPath+pathSeparator+filename+"_"+regionName+"_Original_GFP"+".tif");
				gfpOriginalPath = regionOutputGFPPath+pathSeparator+filename+"_"+regionName+"_Original_GFP"+".tif";
				run("Duplicate...", "title=gfpRegionEnhancedFeed duplicate");
				selectWindow("gfpRegionEnhancedFeed");
				enhanceContrast(imageFile);
				save(regionOutputGFPPath+pathSeparator+filename+"_"+regionName+"_Enhanced_GFP"+".tif");
				gfpEnhancedPath = regionOutputGFPPath+pathSeparator+filename+"_"+regionName+"_Enhanced_GFP"+".tif";
				selectWindow(filename+"_"+regionName+"_GFP");
				countGFP(imageFile); // This is the main GFP/eYFP method. Like all non-dapi methods, it utilises 3D Iterative Thresholding for segmentation and Cell Counter for counting.
			}
			else 
			{
				gfpCount = "N/A";
			}
			//End of Block
			
			//Processes Overlap.
			if ((regionGfpChoice&&regionCfosChoice&&regionOverlapChoice) == 1) //Counts cfosxGFP overlap. Please note! Requires cfos, GFP and Overlap counting to all be enabled.
			{
				regionStainName = "Overlap";
				run("Merge Channels...", "c1=cfosRegionEnhancedFeed c2=gfpRegionEnhancedFeed");
				save(regionOutputOverlapPath+pathSeparator+filename+"_"+regionName+"_Enhanced_Overlap"+".tif");
				overlapEnhancedPath = regionOutputOverlapPath+pathSeparator+filename+"_"+regionName+"_Enhanced_Overlap"+".tif";
				close();
				run("Merge Channels...", "c1=cfosOriginalRegionFeed c2=gfpOriginalRegionFeed");
				save(regionOutputOverlapPath+pathSeparator+filename+"_"+regionName+"_Original_Overlap"+".tif");
				overlapOriginalPath = regionOutputOverlapPath+pathSeparator+filename+"_"+regionName+"_Original_Overlap"+".tif";
				close();
				constructOverlap(imageFile); // Unlike other channels, Overlap uses two separate methods. Overlap 1 is the methods that uses a thresholded cfos and gfp image to construct a thresholded overlap (via the AND image calculator function).
				selectWindow("Result of CfosOverlap");
				rename(filename+"_"+regionName+"_Overlap");
				countOverlap(imageFile); // The second method of the Overlap channel processing. Utilizes the Cell Coubnter to count the overlap images, since Thresholding is performed during cfos and gfp processing.
			}
			else 
			{
				overlapCount = "N/A";
			}
			//End of Block
		}
		else //Marks manually skipped regions for deletion from the results table. Skipped regions are defined by selecting the "Skip" option in the ROI-drawing dialog.
		{
			regionFilename = "Null";
			regionName = "Null";
			dapiCount = "Null";
			cfosCount = "Null";
			gfpCount = "Null";
			overlapCount = "Null";
		}
	}
}


//Method functions that handle channel-specific tasks. Correspond to the 3d level of processing (Method):

function originalImageSave(imageFile)
{
    //Dapi Block
    selectWindow(dapiChannel+filename+"ChannelSelector");
    rename(filename+"_Dapi"+"_Original");
    saveName = getTitle();
    save(imageOutputPath+pathSeparator+saveName+".tif");
    enhanceContrast(imageFile);
    rename(filename+"_Dapi"+"_Enhanced");
    saveName = getTitle();
    save(imageOutputPath+pathSeparator+saveName+".tif");
    //End of Block

    //Cfos Block
    selectWindow(cfosChannel+filename+"ChannelSelector");
    rename(filename+"_Cfos"+"_Original");
    saveName = getTitle();
    save(imageOutputPath+pathSeparator+saveName+".tif");
    run("Duplicate...", "title=CfosOverlapFeed duplicate");
    selectWindow(filename+"_Cfos"+"_Original");
    enhanceContrast(imageFile);
    rename(filename+"_Cfos"+"_Enhanced");
    saveName = getTitle();
    save(imageOutputPath+pathSeparator+saveName+".tif");
    rename("CfosEnhancedOverlapFeed");
    //End of Block

    //GFP Block
    selectWindow(gfpChannel+filename+"ChannelSelector");
    rename(filename+"_GFP"+"_Original");
    saveName = getTitle();
    save(imageOutputPath+pathSeparator+saveName+".tif");
    run("Duplicate...", "title=GFPOverlapFeed duplicate");
    selectWindow(filename+"_GFP"+"_Original");
    enhanceContrast(imageFile);
    rename(filename+"_GFP"+"_Enhanced");
    saveName = getTitle();
    save(imageOutputPath+pathSeparator+saveName+".tif");
    rename("GFPEnhancedOverlapFeed");
    //End of Block

    //Overlap block
    run("Merge Channels...", "c1=CfosOverlapFeed c2=GFPOverlapFeed");
    rename(filename+"_Overlap"+"_Original");
    saveName = getTitle();
    save(imageOutputPath+pathSeparator+saveName+".tif");
    close();
    run("Merge Channels...", "c1=CfosEnhancedOverlapFeed c2=GFPEnhancedOverlapFeed");
    rename(filename+"_Overlap"+"_Enhanced");
    saveName = getTitle();
    save(imageOutputPath+pathSeparator+saveName+".tif");
    close();
    //End of Block
}

function preProcess(imageFile)
{
    setBackgroundColor(0, 0, 0);
    run("Clear Outside");
    setOption("ScaleConversions", true);
    run("8-bit");
    run("Split Channels");
}

//Main Dapi method. Utilizes 3D Iterative thresholding for Segmentation and Automatic Cell Counter for counting.
function countDapi(imageFile)
{
	//Initialization Block
	mainname = getTitle();
	rename("dapiOriginalRegionFeed");
	methodTuning(imageFile);
    //End of Block
	
	//Thresholds the image to segment the cells of interest from the background
	run("3D Iterative Thresholding", "min_vol_pix=" +minVolPix+" max_vol_pix="+maxVolPix+" min_threshold="+minThreshold+" min_contrast="+minContrast+" criteria_method="+criteriaMethod+" threshold_method="+thresholdMethod+" segment_results="+segmentResults+" value_method="+valueMethod+" "+filteringParameter);
	//End of Block

	//Binarises the Thresholded image, preparing it for counting:
	rename(mainname);
	run("8-bit");
    setAutoThreshold("Intermodes dark");
    setThreshold(10, 255);
    setOption("BlackBackground", true);
    run("Convert to Mask", "method=Intermodes background=Dark black");
    save(imageOutputPath+pathSeparator+regionName+pathSeparator+"Dapi"+pathSeparator+filename+"_"+regionName+"_Thresholded_Dapi"+".tif");
    // End of Block

    //Counts appropriate cells
    	showMode = outlines;
		summaryMode = summarize;
		addROIMode = null;
		run("Analyze Particles...", "size="+minSize+"-"+maxSize+" pixel circularity="+minCircularity+"-"+maxCircularity+" show="+showMode+" "+summaryMode+" "+addROIMode);

    //Retrieves and saves all necessary information from the counter
	dapiAutoPath = imageOutputPath+pathSeparator+regionName+pathSeparator+"Dapi"+pathSeparator+filename+"_"+regionName+"_AutoCounts_Dapi"+".tif";
	save(dapiAutoPath);

	//This block is designed to solve the internal naming issue arising due to a piculiar interaction of Thresholding and Counter internal logic.
    window1 = isOpen("Summary");
    if (window1 == 1)
    {
	selectWindow("Summary");
    }
	else 
	{
	selectWindow("Summary of "+mainname);
	}
    dapiCount = Table.get("Count", 0);
    run("Close");
    //End of Block
}

function countCfos(imageFile)
{
	//Initialization Block
	mainname = getTitle();
	methodTuning(imageFile);
	rename("cfosOriginalRegionFeed");
	//End of Block

	//Thresholder Block
	run("3D Iterative Thresholding", "min_vol_pix=" +minVolPix+" max_vol_pix="+maxVolPix+" min_threshold="+minThreshold+" min_contrast="+minContrast+" criteria_method="+criteriaMethod+" threshold_method="+thresholdMethod+" segment_results="+segmentResults+" value_method="+valueMethod+" "+filteringParameter);
    //End of Block

	//Transition Block
	rename(mainname);
	run ("Duplicate...", "title=CfosOverlap duplicate");
	selectWindow(mainname);
	run("8-bit");
    setAutoThreshold("Intermodes dark");
    setThreshold(10, 255);
    setOption("BlackBackground", true);
    run("Convert to Mask", "method=Intermodes background=Dark black");
    save(imageOutputPath+pathSeparator+regionName+pathSeparator+"Cfos"+pathSeparator+filename+"_"+regionName+"_Thresholded_Cfos"+".tif");
    //End of Block

    //Counter Block
    showMode = outlines;
	summaryMode = summarize;
	addROIMode = add;
	run("Analyze Particles...", "size="+minSize+"-"+maxSize+" pixel circularity="+minCircularity+"-"+maxCircularity+" show="+showMode+" "+summaryMode+" "+addROIMode); //Counter

	//Retrieval Block
	cfosAutoPath = imageOutputPath+pathSeparator+regionName+pathSeparator+"Cfos"+pathSeparator+filename+"_"+regionName+"_AutoCounts_Cfos"+".tif";
	save(cfosAutoPath);
	cfosROIPath = imageOutputPath+pathSeparator+regionName+pathSeparator+"Cfos"+pathSeparator+filename+"_"+regionName+"ROI_Cfos"+".zip";

	//This block checks whether there are any ROIs to save
	if (roiManager("Count") != 0) 
	{
	roiManager("save selected", cfosROIPath);
	roiManager("delete");
	}	
	window1 = isOpen("Summary");
    if (window1 == 1)
    {
	selectWindow("Summary");
    }
	else 
	{
	selectWindow("Summary of "+mainname);
	}
	cfosCount = Table.get("Count", 0);
	run("Close");
	//End of Block
}

//Main GFP method. Utilizes 3D Iterative thresholding for Segmentation and Automatic Cell Counter for counting
function countGFP(imageFile)
{
	//Initialization Block
	mainname = getTitle();
	methodTuning(imageFile);
	rename("gfpOriginalRegionFeed");
    //End of Block
	
	//Thresholder Block
	run("3D Iterative Thresholding", "min_vol_pix=" +minVolPix+" max_vol_pix="+maxVolPix+" min_threshold="+minThreshold+" min_contrast="+minContrast+" criteria_method="+criteriaMethod+" threshold_method="+thresholdMethod+" segment_results="+segmentResults+" value_method="+valueMethod+" "+filteringParameter);
    //End of Block
    
	//Transition block
	rename(mainname);
	run("Duplicate...", "title=GfpOverlap duplicate");
	selectWindow(mainname);
	run("8-bit");
    setAutoThreshold("Intermodes dark");
    setThreshold(10, 255);
    setOption("BlackBackground", true);
    run("Convert to Mask", "method=Intermodes background=Dark black");
    save(imageOutputPath+pathSeparator+regionName+pathSeparator+"GFP"+pathSeparator+filename+"_"+regionName+"_Thresholded_GFP"+".tif");
    //End of Block

    //Counter Block
	showMode = outlines;
	summaryMode = summarize;
	addROIMode = add;
	run("Analyze Particles...", "size="+minSize+"-"+maxSize+" pixel circularity="+minCircularity+"-"+maxCircularity+" show="+showMode+" "+summaryMode+" "+addROIMode); //Counter
	
	//Retrieval block
	gfpAutoPath = imageOutputPath+pathSeparator+regionName+pathSeparator+"GFP"+pathSeparator+filename+"_"+regionName+"_AutoCounts_GFP"+".tif";
	save(gfpAutoPath);
	gfpROIPath = imageOutputPath+pathSeparator+regionName+pathSeparator+"GFP"+pathSeparator+filename+"_"+regionName+"ROI_GFP"+".zip";

	if (roiManager("Count") != 0) 
	{
	roiManager("save selected", gfpROIPath);
	roiManager("delete");
	}
	
	window1 = isOpen("Summary");
    if (window1 == 1)
    {
	selectWindow("Summary");
    }
	else 
	{
	selectWindow("Summary of "+mainname);
	}
	gfpCount = Table.get("Count", 0);
	run("Close");
	//End of Block
}

function constructOverlap(imageFile)
{
	imageCalculator("AND create stack", "CfosOverlap", "GfpOverlap");
    selectWindow("CfosOverlap");
    rename("OverlapDiscard1");
    selectWindow("GfpOverlap");
    rename("OverlapDiscard2");
}

//The second of the two overlap methods. Runs the Particle Counter with pre-defined parameters. Please note! It is best to tune overlap counter to the MORE CONSERVATIVE stain (higher min size/circularity).
function countOverlap(imageFile)
{
	//Initialization block
	mainname = getTitle();
	methodTuning(imageFile);
	run("Duplicate...", "title=CounterDiscard duplicate");
	//End of Block

	//Transition block
	selectWindow(mainname);
	run("8-bit");
    setAutoThreshold("Intermodes dark");
    setThreshold(10, 255);
    setOption("BlackBackground", true);
    run("Convert to Mask", "method=Intermodes background=Dark black");
    save(imageOutputPath+pathSeparator+regionName+pathSeparator+"Overlap"+pathSeparator+filename+"_"+regionName+"_Thresholded_Overlap"+".tif");
    //End of Block

    //Counter block
	showMode = outlines;
	summaryMode = summarize;
	addROIMode = add;
	run("Analyze Particles...", "size="+minSize+"-"+maxSize+" pixel circularity="+minCircularity+"-"+maxCircularity+" show="+showMode+" "+summaryMode+" "+addROIMode); //Counter
	
	//Retrieval block
	overlapAutoPath = imageOutputPath+pathSeparator+regionName+pathSeparator+"Overlap"+pathSeparator+filename+"_"+regionName+"_AutoCounts_Overlap"+".tif";
	save(overlapAutoPath);
	overlapROIPath = imageOutputPath+pathSeparator+regionName+pathSeparator+"Overlap"+pathSeparator+filename+"_"+regionName+"ROI_Overlap"+".zip";
	
	if (roiManager("Count") != 0) 
	{
	roiManager("save selected", overlapROIPath);
	roiManager("delete");
	}

	window1 = isOpen("Summary");
    if (window1 == 1)
    {
	selectWindow("Summary");
    }
	else 
	{
	selectWindow("Summary of "+mainname);
	}
	overlapCount = Table.get("Count", 0);
	run("Close");
	//End of Block
}  

//A minor method that automatically enhances contrast of iamges. Used to construct auto-enhanced images for papers/demonstrations (automatic generation).
function enhanceContrast(imageFile)
{
	run("Enhance Contrast", "saturated=0.35");
    run("Apply LUT");
}





//Confirmation functions. They allow the user to manually confirm the machine counts:

//Confirmation master-function. Calls all relevant confirmation sub-functions.
function confirmImage(imageFile)
{
	setBatchMode(false); //Exits batch mode and disposes of all hidden images.

	//Displays a Dialog, via which the user can set some confirmation parameters
	if (triggerDialogs == 1)
	{
		Dialog.create("Confirmation Settings");
		Dialog.addCheckbox("Confirm Dapi?", 0);
		Dialog.addToSameRow();
		Dialog.addCheckbox("Calibrate Dapi counter?", 1);
		Dialog.addCheckbox("Confirm Cfos?", 1);
		Dialog.addToSameRow();
		Dialog.addCheckbox("Calibrate Cfos counter?", 1);
		Dialog.addCheckbox("Confirm GFP?", 1);
		Dialog.addToSameRow();
		Dialog.addCheckbox("Calibrate GFP counter?", 1);
		Dialog.addCheckbox("Confirm Overlap?", 1);
		Dialog.addToSameRow();
		Dialog.addCheckbox("Calibrate Overlap counter?", 1);
		Dialog.addCheckbox("Use a custom pre-processing algortihm for the manual counter?", 0);
		Dialog.addCheckbox("Overlay outomated counts over the manual counter?", 0);
		Dialog.addCheckbox("Use default overlap image?", 1);
		Dialog.addCheckbox("Would you like to save your manual counter image?", 1);
		Dialog.show();
		confirmationDapiChoice = Dialog.getCheckbox();
		calibrationDapiChoice = Dialog.getCheckbox();
		confirmationCfosChoice = Dialog.getCheckbox();
		calibrationCfosChoice = Dialog.getCheckbox();
		confirmationGfpChoice = Dialog.getCheckbox();
		calibrationGfpChoice = Dialog.getCheckbox();
		confirmationOverlapChoice = Dialog.getCheckbox();
		calibrationOverlapChoice = Dialog.getCheckbox();
		confirmationPreProcessChoice = Dialog.getCheckbox();
		confirmationOverlayChoice = Dialog.getCheckbox();
		confirmationOverlapSourceChoice = Dialog.getCheckbox();
		confirmationSaveManualCountChoice = Dialog.getCheckbox();
		//End of Block
	}

    //Please note! If you intend to process more than 4 ROI per image, you need to manually add all additional region blocks below.
    
	//Confirmes & Calibrates Region 1
	regionName = region1Name;
	regionCount = 1;
	regionDapiChoice = region1DapiChoice;
	regionCfosChoice = region1CfosChoice;
	regionGfpChoice = region1GfpChoice;
	regionOverlapChoice = region1OverlapChoice;
	dapiAutoPath = region1DapiAutoPath;
	cfosAutoPath = region1CfosAutoPath;
	gfpAutoPath = region1GFPAutoPath;
	overlapAutoPath = region1OverlapAutoPath;
	dapiOriginalPath = region1OriginalDapiPath;
	cfosOriginalPath = region1OriginalCfosPath;
	gfpOriginalPath = region1OriginalGFPPath;
	overlapOriginalPath = region1OriginalOverlapPath;
	dapiEnhancedPath = region1DapiEnhancedPath;
	cfosEnhancedPath = region1CfosEnhancedPath;
	gfpEnhancedPath = region1GFPEnhancedPath;
	overlapEnhancedPath = region1OverlapEnhancedPath;
	cfosROIPath = region1CfosROIPath;
	gfpROIPath = region1GFPROIPath;
	overlapROIPath = region1OverlapROIPath;
	regionName = region1Name;
	dapiTuningParameter = region1DapiTuningParameter;
    cfosTuningParameter = region1CfosTuningParameter;
    gfpTuningParameter = region1GFPTuningParameter;
    overlapTuningParameter = region1OverlapTuningParameter;
	
	confirmRegion(imageFile); //This function controls the confirmation of each region.
	//End of Block

	// Confirmes & Calibrates Region 2
	regionName = region2Name;
	regionCount = 2;
	regionDapiChoice = region2DapiChoice;
	regionCfosChoice = region2CfosChoice;
	regionGfpChoice = region2GfpChoice;
	regionOverlapChoice = region2OverlapChoice;
	dapiAutoPath = region2DapiAutoPath;
	cfosAutoPath = region2CfosAutoPath;
	gfpAutoPath = region2GFPAutoPath;
	overlapAutoPath = region2OverlapAutoPath;
	dapiOriginalPath = region2OriginalDapiPath;
	cfosOriginalPath = region2OriginalCfosPath;
	gfpOriginalPath = region2OriginalGFPPath;
	overlapOriginalPath = region2OriginalOverlapPath;
	dapiEnhancedPath = region2DapiEnhancedPath;
	cfosEnhancedPath = region2CfosEnhancedPath;
	gfpEnhancedPath = region2GFPEnhancedPath;
	overlapEnhancedPath = region2OverlapEnhancedPath;
	cfosROIPath = region2CfosROIPath;
	gfpROIPath = region2GFPROIPath;
	overlapROIPath = region2OverlapROIPath;
	regionName = region2Name;
	dapiTuningParameter = region2DapiTuningParameter;
    cfosTuningParameter = region2CfosTuningParameter;
    gfpTuningParameter = region2GFPTuningParameter;
    overlapTuningParameter = region2OverlapTuningParameter;
	
	confirmRegion(imageFile);
	//End of Block

	// Confirmes & Calibrates Region 3
	regionName = region3Name;
	regionCount = 3;
	regionDapiChoice = region3DapiChoice;
	regionCfosChoice = region3CfosChoice;
	regionGfpChoice = region3GfpChoice;
	regionOverlapChoice = region3OverlapChoice;
	dapiAutoPath = region3DapiAutoPath;
	cfosAutoPath = region3CfosAutoPath;
	gfpAutoPath = region3GFPAutoPath;
	overlapAutoPath = region3OverlapAutoPath;
	dapiOriginalPath = region3OriginalDapiPath;
	cfosOriginalPath = region3OriginalCfosPath;
	gfpOriginalPath = region3OriginalGFPPath;
	overlapOriginalPath = region3OriginalOverlapPath;
	dapiEnhancedPath = region3DapiEnhancedPath;
	cfosEnhancedPath = region3CfosEnhancedPath;
	gfpEnhancedPath = region3GFPEnhancedPath;
	overlapEnhancedPath = region3OverlapEnhancedPath;
	cfosROIPath = region3CfosROIPath;
	gfpROIPath = region3GFPROIPath;
	overlapROIPath = region3OverlapROIPath;
	regionName = region3Name;
	dapiTuningParameter = region3DapiTuningParameter;
    cfosTuningParameter = region3CfosTuningParameter;
    gfpTuningParameter = region3GFPTuningParameter;
    overlapTuningParameter = region3OverlapTuningParameter;
	
	confirmRegion(imageFile);
	//End of Block

	// Confirmes & Calibrates Region 4
	regionName = region4Name;
	regionCount = 4;
	regionDapiChoice = region4DapiChoice;
	regionCfosChoice = region4CfosChoice;
	regionGfpChoice = region4GfpChoice;
	regionOverlapChoice = region4OverlapChoice;
	dapiAutoPath = region4DapiAutoPath;
	cfosAutoPath = region4CfosAutoPath;
	gfpAutoPath = region4GFPAutoPath;
	overlapAutoPath = region4OverlapAutoPath;
	dapiOriginalPath = region4OriginalDapiPath;
	cfosOriginalPath = region4OriginalCfosPath;
	gfpOriginalPath = region4OriginalGFPPath;
	overlapOriginalPath = region4OriginalOverlapPath;
	dapiEnhancedPath = region4DapiEnhancedPath;
	cfosEnhancedPath = region4CfosEnhancedPath;
	gfpEnhancedPath = region4GFPEnhancedPath;
	overlapEnhancedPath = region4OverlapEnhancedPath;
	cfosROIPath = region4CfosROIPath;
	gfpROIPath = region4GFPROIPath;
	overlapROIPath = region4OverlapROIPath;
	regionName = region4Name;
	dapiTuningParameter = region4DapiTuningParameter;
    cfosTuningParameter = region4CfosTuningParameter;
    gfpTuningParameter = region4GFPTuningParameter;
    overlapTuningParameter = region4OverlapTuningParameter;
	
	confirmRegion(imageFile);
	//End of Block

	setBatchMode(true); //Re-enables batch-mode for the automatic counting of the next image
}

//Region confirmation master-function. Functions identically to processRegion, but is only called if the processing mode is set to "Confirmation".
function confirmRegion(imageFile)
{
	//Initialization
	if ((regionDapiChoice||regionCfosChoice||regionGfpChoice||regionOverlapChoice) == 1) //Only executes the block if there is at least one stain that was confirmed or calibrated
	{
		run("Cell Counter"); //Opens Cell Counter plugin that is used for manual cell counting. Feel free to delete if you are using some other manual pipeline.
	}
	
	// Dapi confirmation&calibration block:
	if (regionDapiChoice == 1)
	{
		regionStainName = "Dapi"; //Sets Stain name for Calibration and Naming purposes.
		
		if (confirmationDapiChoice == 1) //Checks if the user wants to confirm Dapi and enables confirmation mode if this is the case.
		{
			//Initialization Block
			regenerateInstance = 1;
			//End of Block
		}
		else 
		{
			regenerateInstance = 0;
		}

		//Confirmation block:
		while (regenerateInstance == 1)
		{
			regenerateInstance = 0; //Disables the confirmation loop.

			//Initialization block. Opens up the original channel image and the machine counted image. Applies custom pre-processing if it was specified
			close("*");
		    open(dapiAutoPath);
		    rename("Automated Counter Output");
		    open(dapiOriginalPath);
		    rename("Original Channel Image");
		    if (confirmationPreProcessChoice == 1) 
			{
				confirmationDapiPreProcess(imageFile); //User-defined pre-processing function. Please scroll to the bottom of this algorithm to edit this function.
			}
			open(dapiEnhancedPath);
		    rename("Enhanced Channel Image");
			//End of Block

			//if (confirmationOverlayChoice == 1)
			//{
				//overlayImage(imageFile); //Displays a dialog to allow the user to overlay the automated counts (ROIs) over manual counts. Allows to quanitfy convergence between automated and manual counts.
			//}
			// Currently there is no Dapi overlay process, since given its density in most regions it would be close to pointless.

			//Opens a Dialog, whcih allows the user to either reset the instance and start the confirmation process again or move on to the next region.
			confirmationArray = newArray("Move on","Repeat");
			Dialog.createNonBlocking("Confirmation Control Panel");
			Dialog.addMessage("Currently processsing:"+" "+regionName+" "+regionStainName);
			Dialog.addRadioButtonGroup("What do you want to do next?", confirmationArray, 1, 2, "Move on");
			Dialog.show();
			controlPanelChoice = Dialog.getRadioButton();
			//End of Block

			//This block allows the user to rerun the procedure:
			if (controlPanelChoice == "Repeat") 
			{
				regenerateInstance = 1;
			}
			//End of Block

			//This block allows to exit the stain confirmation block and, if algorithm runs in the calibration mode, initiates the confirmation process:
			else if (controlPanelChoice == "Move on")
			{
				regenerateInstance = 0;
				if (roiManager("Count") != 0) 
				{
					roiManager("delete");
				}
				manualPresence = 0;

				//Allows the user to choose the manual counter iamge to be saved:
				if (confirmationSaveManualCountChoice == 1)
				{
					Dialog.create("Image savior");
					Dialog.addImageChoice("Please select your manual counter image");
					Dialog.show();
					manualName = Dialog.getChoice();
					manualPresence = 1; // Indicates that there is a manual counter file. This is needed for some downstream functions to work properly.
					selectWindow(manualName);
					if (roiManager("Count") != 0) 
					{
						roiManager("delete");
					}
					dapiManualPath = imageOutputPath+pathSeparator+regionName+pathSeparator+"Dapi"+pathSeparator+filename+"_"+regionName+"_ManualCounts_Dapi"+".tif";
					save(dapiManualPath);	
				}
			}
			//End of Block
		}
			if (calibrationDapiChoice == 1)
			{
				close("*");
				if ((confirmationSaveManualCountChoice&&confirmationDapiChoice) == 1)
				{
					open(dapiManualPath);
					manualCountName = "DAPI Manual Counts";
					rename(manualCountName);
					fileExists = File.exists(channelROIPath);
					if (fileExists == 1)
					{
						roiManager("open",channelROIPath);
						roiManager("show all");
					}
				}
				open(dapiOriginalPath);
				rename("TuningSource");
				calibrateMethod(imageFile);
			}
	}
	
	//Cfos confirmation&calibration block:
	if (regionCfosChoice == 1)
	{
		regionStainName = "Cfos"; //Sets Stain name for Calibration and Naming purposes.
		
		if (confirmationCfosChoice == 1)
		{
			//Initialization Block
			regenerateInstance = 1;
			channelROIPath = cfosROIPath;
			//End of Block
		}
		else 
		{
			regenerateInstance = 0;
		}

		//Confirmation block:
		while (regenerateInstance == 1)
		{
			regenerateInstance = 0; //Disables the confirmation loop.

			//Initialization block
			close("*");
		    open(cfosAutoPath);
		    rename("Automated Counter Output");
		    open(cfosOriginalPath);
		    rename("Original Channel Image");
		    if (confirmationPreProcessChoice == 1) 
			{
				confirmationCfosPreProcess(imageFile);
			}
			open(cfosEnhancedPath);
		    rename("Enhanced Channel Image");
			//End of Block

			if (confirmationOverlayChoice == 1)
			{
				overlayImage(imageFile);
			}

			//Opens a Dialog, whcih allows the user to either reset the instance and start the confirmation process again or move on to the next region.
			confirmationArray = newArray("Move on","Repeat");
			Dialog.createNonBlocking("Confirmation Control Panel");
			Dialog.addMessage("Currently processsing:"+" "+regionName+" "+regionStainName);
			Dialog.addRadioButtonGroup("What do you want to do next?", confirmationArray, 1, 2, "Move on");
			Dialog.show();
			controlPanelChoice = Dialog.getRadioButton();
			//End of Block

			//This block allows the user to rerun the procedure:
			if (controlPanelChoice == "Repeat") 
			{
				regenerateInstance = 1;
			}
			//End of Block

			//This block allows to exit the stain confirmation block and, if algorithm runs in the calibration mode, initiates the confirmation process:
			else if (controlPanelChoice == "Move on")
			{
				regenerateInstance = 0;
				if (roiManager("Count") != 0) 
				{
					roiManager("delete");
				}
				manualPresence = 0;

				//Allows the user to choose the manual counter iamge to be saved:
				if (confirmationSaveManualCountChoice == 1)
				{
					Dialog.create("Image savior");
					Dialog.addImageChoice("Please select your manual counter image");
					Dialog.show();
					manualName = Dialog.getChoice();
					manualPresence = 1;
					selectWindow(manualName);
					if (roiManager("Count") != 0) 
					{
						roiManager("delete");
					}
					cfosManualPath = imageOutputPath+pathSeparator+regionName+pathSeparator+"Cfos"+pathSeparator+filename+"_"+regionName+"_ManualCounts_Cfos"+".tif";
					save(cfosManualPath);	
				}
			}
			//End of Block
		}
			if (calibrationCfosChoice == 1)
			{
				close("*");
				if ((confirmationSaveManualCountChoice&&confirmationCfosChoice) == 1)
				{
					open(cfosManualPath);
					manualCountName = "Cfos Manual Counts";
					rename(manualCountName);
					fileExists = File.exists(channelROIPath);
					if (fileExists == 1)
					{
						roiManager("open",channelROIPath);
						roiManager("show all");
					}
				}
				open(cfosOriginalPath);
				rename("TuningSource");
				calibrateMethod(imageFile);
			}
	}

	// GFP confirmation&calibration block:
	if (regionGfpChoice == 1)
	{
		regionStainName = "GFP"; //Sets Stain name for Calibration and Naming purposes.
		if (confirmationGfpChoice == 1) 
		{
			//Initialization Block
			regenerateInstance = 1;
			channelROIPath = gfpROIPath;
			//End of Block
		}
		else 
		{
			regenerateInstance = 0;
		}

		//Confirmation block:
		while (regenerateInstance == 1)
		{
			regenerateInstance = 0;

			//Initialization block.
			close("*");
		    open(gfpAutoPath);
		    rename("Automated Counter Output");
		    open(gfpOriginalPath);
		    rename("Original Channel Image");
		    if (confirmationPreProcessChoice == 1) 
			{
				confirmationGFPPreProcess(imageFile);
			}
			open(gfpEnhancedPath);
		    rename("Enhanced Channel Image");
			//End of Block

			if (confirmationOverlayChoice == 1)
			{
				overlayImage(imageFile);
			}

			//Opens a Dialog, whcih allows the user to either reset the instance and start the confirmation process again or move on to the next region.
			confirmationArray = newArray("Move on","Repeat");
			Dialog.createNonBlocking("Confirmation Control Panel");
			Dialog.addMessage("Currently processsing:"+" "+regionName+" "+regionStainName);
			Dialog.addRadioButtonGroup("What do you want to do next?", confirmationArray, 1, 2, "Move on");
			Dialog.show();
			controlPanelChoice = Dialog.getRadioButton();
			//End of Block

			//This block allows the user to rerun the procedure:
			if (controlPanelChoice == "Repeat") 
			{
				regenerateInstance = 1;
			}
			//End of Block

			//This block allows to exit the stain confirmation block and, if algorithm runs in the calibration mode, initiates the confirmation process:
			else if (controlPanelChoice == "Move on")
			{
				regenerateInstance = 0;
				if (roiManager("Count") != 0) 
				{
					roiManager("delete");
				}
				manualPresence = 0;

				//Allows the user to choose the manual counter iamge to be saved:
				if (confirmationSaveManualCountChoice == 1)
				{
					Dialog.create("Image savior");
					Dialog.addImageChoice("Please select your manual counter image");
					Dialog.show();
					manualName = Dialog.getChoice();
					manualPresence = 1;
					selectWindow(manualName);
					if (roiManager("Count") != 0) 
					{
						roiManager("delete");
					}
					gfpManualPath = imageOutputPath+pathSeparator+regionName+pathSeparator+"GFP"+pathSeparator+filename+"_"+regionName+"_ManualCounts_GFP"+".tif";
					save(gfpManualPath);	
				}
			}
			//End of Block
		}
			if (calibrationGfpChoice == 1)
			{
				close("*");
				if ((confirmationSaveManualCountChoice&&confirmationGfpChoice) == 1)
				{
					open(gfpManualPath);
					manualCountName = "GFP Manual Counts";
					rename(manualCountName);
					fileExists = File.exists(channelROIPath);
					fileExists = File.exists(channelROIPath);
					if (fileExists == 1)
					{
						roiManager("open",channelROIPath);
						roiManager("show all");
					}
				}
				open(gfpOriginalPath);
				rename("TuningSource");
				calibrateMethod(imageFile);
			}
	}

	// Overlap confirmation&calibration block:
	if (regionOverlapChoice == 1)
	{
		regionStainName = "Overlap"; //Sets Stain name for Calibration and Naming purposes.
		if (confirmationOverlapChoice == 1) 
		{
			//Initialization Block
			regenerateInstance = 1;
			channelROIPath = overlapROIPath;
			//End of Block
		}
		else 
		{
			regenerateInstance = 0;
		}

		//Confirmation block:
		while (regenerateInstance == 1)
		{
			regenerateInstance = 0;

			//Initialization block.
			close("*");
		    open(overlapAutoPath);
		    rename("Automated Counter Output");
		    if (confirmationOverlapSourceChoice == 1) 
			{
				open(overlapOriginalPath);
				rename("Original Channel Image");
				if (confirmationPreProcessChoice == 1) 
				{
					confirmationOverlapPreProcess(imageFile);
				}
				open(overlapEnhancedPath);
		        rename("Enhanced Channel Image");
				
			}
			else 
			{
				open(cfosOriginalPath);
				if (confirmationPreProcessChoice == 1) 
				{
					confirmationCfosPreProcess(imageFile);
				}
				open(gfpOriginalPath);
				if (confirmationPreProcessChoice == 1) 
				{
					confirmationGFPPreProcess(imageFile);
				}
			}
			//End of Block

			if (confirmationOverlayChoice == 1)
			{
				overlayImage(imageFile);
			}

			//Opens a Dialog, whcih allows the user to either reset the instance and start the confirmation process again or move on to the next region.
			confirmationArray = newArray("Move on","Repeat");
			Dialog.createNonBlocking("Confirmation Control Panel");
			Dialog.addMessage("Currently processsing:"+" "+regionName+" "+regionStainName);
			Dialog.addRadioButtonGroup("What do you want to do next?", confirmationArray, 1, 2, "Move on");
			Dialog.show();
			controlPanelChoice = Dialog.getRadioButton();
			//End of Block

			//This block allows the user to rerun the procedure:
			if (controlPanelChoice == "Repeat") 
			{
				regenerateInstance = 1;
			}
			//End of Block

			//This block allows to exit the stain confirmation block and, if algorithm runs in the calibration mode, initiates the confirmation process:
			else if (controlPanelChoice == "Move on")
			{
				regenerateInstance = 0;
				if (roiManager("Count") != 0) 
				{
					roiManager("delete");
				}
				manualPresence = 0;

				//Allows the user to choose the manual counter iamge to be saved:
				if (confirmationSaveManualCountChoice == 1)
				{
					Dialog.create("Image savior");
					Dialog.addImageChoice("Please select your manual counter image");
					Dialog.show();
					manualName = Dialog.getChoice();
					manualPresence = 1;
					selectWindow(manualName);
					if (roiManager("Count") != 0) 
					{
						roiManager("delete");
					}
					overlapManualPath = imageOutputPath+pathSeparator+regionName+pathSeparator+"Overlap"+pathSeparator+filename+"_"+regionName+"_ManualCounts_Overlap"+".tif";
					save(overlapManualPath);	
				}
			}
			//End of Block
		}
			if (calibrationOverlapChoice == 1)
			{
				close("*");
				if ((confirmationSaveManualCountChoice&&confirmationOverlapChoice) == 1)
				{
					open(overlapManualPath);
					manualCountName = "Overlap Manual Counts";
					rename(manualCountName);
					fileExists = File.exists(channelROIPath);
					if (fileExists == 1)
					{
						roiManager("open",channelROIPath);
						roiManager("show all");
					}
				}
				prepareOverlapCalibration(imageFile);
				rename("TuningSource");
				calibrateMethod(imageFile);
			}
	}

	close("*"); //Closes all windowa that can be closed via code.
	
	//Displays a dialog, prompting the user to close all windows that cannot be close automatically.
	if ((regionDapiChoice||regionCfosChoice||regionGfpChoice||regionOverlapChoice) == 1) //Only executes the block if there is at least one stain that was confirmed or calibrated
	{
		waitForUser("Please close all remaining windows, except for the Cell Counter master-table and the log window");
	}
	//End of Block
}

//A minor method used to overlay the automatic counts (in the form of ROI) over user-defined file. Can be used to quantify the convergence between machine and human counts during Confirmation.
function overlayImage(imageFile)
{
	Dialog.createNonBlocking("Overlay");
	Dialog.addMessage("Please click OK when you are ready to continue");
	Dialog.show();
	Dialog.addImageChoice("Please select the image to apply the overlay to")
	Dialog.show();
	overlayName = Dialog.getChoice();
	selectWindow(overlayName);
	fileExists = File.exists(channelROIPath);
	if (fileExists == 1)
	{
		roiManager("open", channelROIPath);
		roiManager("show all");
	}
}

//The pre-processing block is used to accelerate manual confirmaqtions. Each function from this block is applied to the freshly open original (unprocessed) image of their respective channel (split is done automatically, so only insert things like color enhancement here).
function confirmationDapiPreProcess(imageFile)
{
	//User-defined custom dapi pre-process sequence goes here.
}

function confirmationCfosPreProcess(imageFile)
{
	//User-defined custom gfp pre-process sequence goes here.
}

function confirmationGFPPreProcess(imageFile)
{
	//User-defined custom gfp pre-process sequence goes here.
}

function confirmationOverlapPreProcess(imageFile)
{
	//User-defined custom overlap pre-process sequence goes here.
}





//calibration functions. They allow the user to iteratively tunbe machine counting parameters.


//Channel (Stain)-specific calibration method. Works in tandem with Confirmation function, generates a calibration environment and automatically generates pastable code blocks.
function calibrateMethod(imageFile)
{
	regenerateInstance = 1;
	methodTuning(imageFile);
	while (regenerateInstance == 1) 
	{
		roiReset(imageFile); // A minor function that resets the ROI overlay of the manual counter window.
		
		//Generates a count with the same parameters used by the system during automatic processing. Illustrates each step since BatchMode is set to be "false".
		selectWindow("TuningSource");

		if (regionStainName != "Overlap")
		{
			run("8-bit"); //This is needed to convert the overlap image into a format that 3D Iterative Thresholding can process.
			run("3D Iterative Thresholding", "min_vol_pix=" +minVolPix+" max_vol_pix="+maxVolPix+" min_threshold="+minThreshold+" min_contrast="+minContrast+" criteria_method="+criteriaMethod+" threshold_method="+thresholdMethod+" segment_results="+segmentResults+" value_method="+valueMethod+" "+filteringParameter);
		}
		
		run("8-bit");
		setAutoThreshold("Intermodes dark");
		setThreshold(10, 255);
		setOption("BlackBackground", true);
		run("Convert to Mask", "method=Intermodes background=Dark black");
		
		showMode = outlines;
		summaryMode = summarize;
		addROIMode = add;
		run("Analyze Particles...", "size="+minSize+"-"+maxSize+" pixel circularity="+minCircularity+"-"+maxCircularity+" show="+showMode+" "+summaryMode+" "+addROIMode);
		
		roiUpdate(imageFile); //A minor function that overlays the new set of ROi recieved from running the machine counter over manual counter windows. Allows to track the convergence between the machine and human counts over calibration iterations.
		//End of Block
		
		//Displays a Dialog, which allows the user to choose what methods they want to calibrate.
		//methodArray = newArray("Segmentation", "Counting");
		//defaultmethodArray = methodArray;
		confirmationArray = newArray("Move on","Rerun");
		Dialog.createNonBlocking("Calibration Control Panel");
		Dialog.addMessage("Currently processsing:"+" "+regionName+" "+regionStainName);
		Dialog.addRadioButtonGroup("What do you want to do next?", confirmationArray, 1, 2, "Move on");
		Dialog.show();
		controlPanelChoice = Dialog.getRadioButton();
		//End of Block

		if (controlPanelChoice == "Rerun")
		{
			
			//Displays a Dialog, which allows the user to tune and input various parameters, controlling the calibrated methods. Enables the calibration via iterative tuning.
			Dialog.create("Method Parameters");

			if (regionStainName != "Overlap")
			{
				//Thresholding dialog
				Dialog.addMessage("Please tune the Iterative Thresholding settings below. This method is used to segment the cells of interest from everything else:");	
				Dialog.addNumber("Min vol pix:", minVolPix);
				Dialog.addNumber("Max vol pix:", maxVolPix);
				Dialog.addNumber("Min threshold:", minThreshold);
				Dialog.addNumber("Min contrast:", minContrast);
				Dialog.addChoice("Criteria method:", criteriaMethodArray, criteriaMethod);
				Dialog.addChoice("Threshold method:",thresholdMethodArray,thresholdMethod);
				Dialog.addChoice("Segment results:", segmentResultsArray, segmentResults);
				Dialog.addNumber("Value method:", valueMethod);
				Dialog.addCheckbox("Filtering:", 0);
				Dialog.addMessage("");
				Dialog.addMessage("");		
			}
			
			//Counter dialog
			Dialog.addMessage("Please tune the Analyze Particles settings below. This method is used to count the cells of interest:");
			Dialog.addNumber("Min size:", minSize);
			Dialog.addNumber("Max size:", maxSize);
			Dialog.addNumber("Min circularity:", minCircularity);
			Dialog.addNumber("Max circularity:", maxCircularity);
			Dialog.addMessage("");
			Dialog.addMessage("");
			
			Dialog.show();

			//Cleans up the windows from last instance
			if (regionStainName != "Overlap")
			{
				if (filteringParameter == filtering)
				{
					selectWindow("filtered_1");
					close();
				}
				selectWindow("draw");
				close();
				
				selectWindow("Drawing of draw");
				close();
			}
			//End of Block

			//Retrieves Thresholding parameters
			if (regionStainName != "Overlap")
			{
				minVolPix = Dialog.getNumber();
				maxVolPix = Dialog.getNumber();
				minThreshold = Dialog.getNumber();
				minContrast = Dialog.getNumber();
				criteriaMethod = Dialog.getChoice();
				thresholdMethod = Dialog.getChoice();
				segmentResults = Dialog.getChoice();
				valueMethod = Dialog.getNumber();
				filteringChoice = Dialog.getCheckbox();
				if (filteringChoice == 1)
				{
					filteringParameter = filtering;
				}
			}
			
			//Retrieves Counter parameters
			minSize = Dialog.getNumber();
			maxSize = Dialog.getNumber();
			minCircularity = Dialog.getNumber();
			maxCircularity = Dialog.getNumber();
			//End of Block

			preserveCalibratedProfile(imageFile); //Temporarily supresses automatic method tuning to enable iterative calibration by the user.
			
			regenerateInstance = 1;
			
			rerunPresence = 1;
		}
		
		//Displays a log window with the formated code block. Enables the user to copy the block and paste it into methodTuning function as a new profile (or update an old one)
		if (controlPanelChoice == "Move on")
		{
			regenerateInstance = 0; //Exits the calibration loop

			if (rerunPresence == 1) //Checks whether there has been any user calibration of the profile and, if so, asks whether the user would like to use the generated profile in the current isntance
			{
				Dialog.create("Preserve Calibrated Settings?");
				Dialog.addCheckbox("Would you like to use the calibrated profile for the rest of the images?", 1);
				Dialog.show();
				preserveCalibratedProfileChoice = Dialog.getCheckbox();
			}
			
			if (preserveCalibratedProfileChoice == 1)
			{
				preserveCalibratedProfile(imageFile); // Forces the Algorithm to use the newly calibrated profile for all further instances of this stain-region combination.
			}

			
			//Deletes summary window:
			window1 = isOpen("Summary");
			if (window1 == 1)
			{
				selectWindow("Summary");
			}
			else 
			{
				selectWindow("Summary of draw");
			}
			run("Close");
			//End of Block

			//Cleans up the windows from last instance
			if (regionStainName != "Overlap")
			{
				if (filteringParameter == filtering)
				{
					selectWindow("filtered_1");
					close();
				}
				selectWindow("draw");
				close();
				selectWindow("Drawing of draw");
				close();
			}

			if (regionStainName == "Overlap")
			{
				selectWindow("Drawing of TuningSource");
				close();
			}
			//End of Block

			if (regionStainName != "Overlap")
			{
				//Print Thresholding Parameters
				minVolPrint = "minVolPix = "+minVolPix+";";
				maxVolPrint = "maxVolPix = "+maxVolPix+";";
				minThresholdPrint = "minThreshold = "+minThreshold+";";
				minContrastPrint = "minContrast = "+minContrast+";";
				criteriaMethodPrint = "criteriaMethod = "+criteriaMethod+";";
				thresholdMethodPrint = "thresholdMethod = "+thresholdMethod+";";
				segmentResultsPrint = "segmentResults = "+segmentResults+";";
				valueMethodPrint = "valueMethod = "+valueMethod+";";
				filteringParameterPrint = "filteringParameter = "+filteringParameter+";";

				textConverter(imageFile); //Converts string values into variables to make the autogenerated code exetuable
					
				print("Please copy and paste the following code block inside the methodTuning function");
				print("Append it to the end of "+regionStainName+" Tuning Block");
				print("-------");
				print("//Thresholding settings");
				print(minVolPrint);
				print(maxVolPrint);
				print(minThresholdPrint);
				print(minContrastPrint);
				print(criteriaMethodPrint);
				print(thresholdMethodPrint);
				print(segmentResultsPrint);
				print(valueMethodPrint);
				print(filteringParameterPrint);
			}

			//Print Segmentation Parameters
			minSizePrint = "minSize = "+minSize+";";
			maxSizePrint = "maxSize = "+maxSize+";";
			minCircularityPrint = "minCircularity = "+minCircularity+";";
			maxCircularityPrint = "maxCircularity = "+maxCircularity+";";

			textConverter(imageFile);
				
			print("");
			print("//Counter settings");
			print(minSizePrint);
			print(maxSizePrint);
			print(minCircularityPrint);
			print(maxCircularityPrint);

			waitForUser("Please copy the code blocks from the log window into tuneMethod function!");
			
			if (roiManager("Count") != 0) 
		    {
				roiManager("delete");
		    }

		    rerunPresence = 0;
		}
		//End of Block
	}
}

//This is a major method, which handles various tuning profiles, acting as region-specific and (stain) channel-specific set of parameters that are passed to Segmentation and Counter methods. Stores all valid sets of paramters as well as their unique token numbers.
function methodTuning(imageFile)
{
	//Stain1 Block
	if (regionStainName == "Dapi")
	{
		//Switches the tuner to the set of internal parameters generated by user during calibration. Allows to tune the algorithms methods while it i8s running.
		if (dapiTuningParameter == 0)
		{
			if (regionCount == 1)
			{
				//Thresholder parameters block
				minVolPix = region1MinVolPixDapi;
				maxVolPix = region1MaxVolPixDapi;
				minThreshold = region1MinThresholdDapi;
				minContrast = region1MinContrastDapi;
				criteriaMethod = region1CriteriaMethodDapi;
				thresholdMethod = region1ThresholdMethodDapi;
				segmentResults = region1SegmentResultsDapi;
				valueMethod = region1ValueMethodDapi;
				filteringParameter = region1FilteringParameterDapi;
				//End of Block       
				
				//Counter parameters block
				minSize = region1MinSizeDapi;
				maxSize = region1MaxSizeDapi;
				minCircularity = region1MinCircularityDapi;
				maxCircularity = region1MaxCircularityDapi;
			}

			if (regionCount == 2)
			{
				//Thresholder parameters block
				minVolPix = region2MinVolPixDapi;
				maxVolPix = region2MaxVolPixDapi;
				minThreshold = region2MinThresholdDapi;
				minContrast = region2MinContrastDapi;
				criteriaMethod = region2CriteriaMethodDapi;
				thresholdMethod = region2ThresholdMethodDapi;
				segmentResults = region2SegmentResultsDapi;
				valueMethod = region2ValueMethodDapi;
				filteringParameter = region2FilteringParameterDapi;
				//End of Block       
				
				//Counter parameters block
				minSize = region2MinSizeDapi;
				maxSize = region2MaxSizeDapi;
				minCircularity = region2MinCircularityDapi;
				maxCircularity = region2MaxCircularityDapi;
			}

			if (regionCount == 3)
			{
				//Thresholder parameters block
				minVolPix = region3MinVolPixDapi;
				maxVolPix = region3MaxVolPixDapi;
				minThreshold = region3MinThresholdDapi;
				minContrast = region3MinContrastDapi;
				criteriaMethod = region3CriteriaMethodDapi;
				thresholdMethod = region3ThresholdMethodDapi;
				segmentResults = region3SegmentResultsDapi;
				valueMethod = region3ValueMethodDapi;
				filteringParameter = region3FilteringParameterDapi;
				//End of Block       
				
				//Counter parameters block
				minSize = region3MinSizeDapi;
				maxSize = region3MaxSizeDapi;
				minCircularity = region3MinCircularityDapi;
				maxCircularity = region3MaxCircularityDapi;
			}

			if (regionCount == 4)
			{
				//Thresholder parameters block
				minVolPix = region4MinVolPixDapi;
				maxVolPix = region4MaxVolPixDapi;
				minThreshold = region4MinThresholdDapi;
				minContrast = region4MinContrastDapi;
				criteriaMethod = region4CriteriaMethodDapi;
				thresholdMethod = region4ThresholdMethodDapi;
				segmentResults = region4SegmentResultsDapi;
				valueMethod = region4ValueMethodDapi;
				filteringParameter = region4FilteringParameterDapi;
				//End of Block       
				
				//Counter parameters block
				minSize = region4MinSizeDapi;
				maxSize = region4MaxSizeDapi;
				minCircularity = region4MinCircularityDapi;
				maxCircularity = region4MaxCircularityDapi;
			}
		}
		//dHPC Dentate dapi. Calibrated for Kelton's CLSM images.
		if (dapiTuningParameter == 1)
		{
			//Thresholder parameters block
			minVolPix = 0;
			maxVolPix = 100;
			minThreshold = 0;
			minContrast = 0;
			criteriaMethod = "ELONGATION";
			thresholdMethod = "KMEANS";
			segmentResults = "All";
			valueMethod = 40;
			filteringParameter = "";
			//End of Block       
			
			//Counter parameters block
			minSize = 0;
			maxSize = "Infinity";
			minCircularity = 0.00;
			maxCircularity = 1.00;
			//End of Block
		}
		
		//dHPC CA1, 2, 3. In theory, works for everything with dapi density lower than Dentate.
		if (dapiTuningParameter == 2)
		{
			//Thresholder parameters block
			minVolPix = 0;
			maxVolPix = 100;
			minThreshold = 0;
			minContrast = 0;
			criteriaMethod = "ELONGATION";
			thresholdMethod = "KMEANS";
			segmentResults = "All";
			valueMethod = 40;
			filteringParameter = "filtering";
			//End of Block
			
			//Counter parameters block
			minSize = 0;
			maxSize = "Infinity";
			minCircularity = 0.00;
			maxCircularity = 1.00;
			//End of Block
		}

		//Description of the profile goes here
		if (dapiTuningParameter == 3)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (dapiTuningParameter == 4)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (dapiTuningParameter == 5)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (dapiTuningParameter == 6)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (dapiTuningParameter == 7)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (dapiTuningParameter == 8)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (dapiTuningParameter == 9)
		{
			//Code-block created by Calibration pipeline goes here
		}
		
	}
	//End of Block

    //Cfos Block
	if (regionStainName == "Cfos")
	{
		//Switches the tuner to the set of internal parameters generated by user during calibration. Allows to tune the algorithms methods while it i8s running.
		if (cfosTuningParameter == 0)
		{
			if (regionCount == 1)
			{
				//Thresholder parameters block
				minVolPix = region1MinVolPixCfos;
				maxVolPix = region1MaxVolPixCfos;
				minThreshold = region1MinThresholdCfos;
				minContrast = region1MinContrastCfos;
				criteriaMethod = region1CriteriaMethodCfos;
				thresholdMethod = region1ThresholdMethodCfos;
				segmentResults = region1SegmentResultsCfos;
				valueMethod = region1ValueMethodCfos;
				filteringParameter = region1FilteringParameterCfos;
				//End of Block       
				
				//Counter parameters block
				minSize = region1MinSizeCfos;
				maxSize = region1MaxSizeCfos;
				minCircularity = region1MinCircularityCfos;
				maxCircularity = region1MaxCircularityCfos;
			}

			if (regionCount == 2)
			{
				//Thresholder parameters block
				minVolPix = region2MinVolPixCfos;
				maxVolPix = region2MaxVolPixCfos;
				minThreshold = region2MinThresholdCfos;
				minContrast = region2MinContrastCfos;
				criteriaMethod = region2CriteriaMethodCfos;
				thresholdMethod = region2ThresholdMethodCfos;
				segmentResults = region2SegmentResultsCfos;
				valueMethod = region2ValueMethodCfos;
				filteringParameter = region2FilteringParameterCfos;
				//End of Block       
				
				//Counter parameters block
				minSize = region2MinSizeCfos;
				maxSize = region2MaxSizeCfos;
				minCircularity = region2MinCircularityCfos;
				maxCircularity = region2MaxCircularityCfos;
			}

			if (regionCount == 3)
			{
				//Thresholder parameters block
				minVolPix = region3MinVolPixCfos;
				maxVolPix = region3MaxVolPixCfos;
				minThreshold = region3MinThresholdCfos;
				minContrast = region3MinContrastCfos;
				criteriaMethod = region3CriteriaMethodCfos;
				thresholdMethod = region3ThresholdMethodCfos;
				segmentResults = region3SegmentResultsCfos;
				valueMethod = region3ValueMethodCfos;
				filteringParameter = region3FilteringParameterCfos;
				//End of Block       
				
				//Counter parameters block
				minSize = region3MinSizeCfos;
				maxSize = region3MaxSizeCfos;
				minCircularity = region3MinCircularityCfos;
				maxCircularity = region3MaxCircularityCfos;
			}

			if (regionCount == 4)
			{
				//Thresholder parameters block
				minVolPix = region4MinVolPixCfos;
				maxVolPix = region4MaxVolPixCfos;
				minThreshold = region4MinThresholdCfos;
				minContrast = region4MinContrastCfos;
				criteriaMethod = region4CriteriaMethodCfos;
				thresholdMethod = region4ThresholdMethodCfos;
				segmentResults = region4SegmentResultsCfos;
				valueMethod = region4ValueMethodCfos;
				filteringParameter = region4FilteringParameterCfos;
				//End of Block       
				
				//Counter parameters block
				minSize = region4MinSizeCfos;
				maxSize = region4MaxSizeCfos;
				minCircularity = region4MinCircularityCfos;
				maxCircularity = region4MaxCircularityCfos;
			}
		}
		
		//Generic cfos parameters. Require minor calibration for every batch of images.
		if (cfosTuningParameter == 1)
		{
			//Thresholder parameters block
			minVolPix = 20;
			maxVolPix = 100;
			minThreshold = 20;
			minContrast = 0;
			criteriaMethod = "ELONGATION";
			thresholdMethod = "STEP";
			segmentResults = "All";
			valueMethod = 10;
			filteringParameter = "filtering";
			//End of Block
			
			//Counter parameters block
			minSize = 0;
			maxSize = 300;
			minCircularity = 0.60;
			maxCircularity = 1.00;
			//End of Block
		}

		//A cfos profile tuned for .oif images used by Kelton Wilmerding. May be worth testing on non-oif images, as it is designed to bias for high-contrast cells that are more likely to be regiustered by a human counter.
		if (cfosTuningParameter == 2)
		{
			//Thresholding settings
			minVolPix = 20;
			maxVolPix = 100;
			minThreshold = 20;
			minContrast = 5;
			criteriaMethod = "ELONGATION";
			thresholdMethod = "KMEANS";
			segmentResults = "All";
			valueMethod = 10;
			filteringParameter = "filtering";
			
			//Counter settings
			minSize = 0;
			maxSize = 300;
			minCircularity = 0.6;
			maxCircularity = 1;

		}

		//Description of the profile goes here
		if (cfosTuningParameter == 3)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (cfosTuningParameter == 4)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (cfosTuningParameter == 5)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (cfosTuningParameter == 6)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (cfosTuningParameter == 7)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (cfosTuningParameter == 8)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (cfosTuningParameter == 9)
		{
			//Code-block created by Calibration pipeline goes here
		}
	}
	//End of Block

    //GFP Block
	if(regionStainName == "GFP")
	{
		//Switches the tuner to the set of internal parameters generated by user during calibration. Allows to tune the algorithms methods while it i8s running.
		if (gfpTuningParameter == 0)
		{
			if (regionCount == 1)
			{
				//Thresholder parameters block
				minVolPix = region1MinVolPixGFP;
				maxVolPix = region1MaxVolPixGFP;
				minThreshold = region1MinThresholdGFP;
				minContrast = region1MinContrastGFP;
				criteriaMethod = region1CriteriaMethodGFP;
				thresholdMethod = region1ThresholdMethodGFP;
				segmentResults = region1SegmentResultsGFP;
				valueMethod = region1ValueMethodGFP;
				filteringParameter = region1FilteringParameterGFP;
				//End of Block       
				
				//Counter parameters block
				minSize = region1MinSizeGFP;
				maxSize = region1MaxSizeGFP;
				minCircularity = region1MinCircularityGFP;
				maxCircularity = region1MaxCircularityGFP;
			}

			if (regionCount == 2)
			{
				//Thresholder parameters block
				minVolPix = region2MinVolPixGFP;
				maxVolPix = region2MaxVolPixGFP;
				minThreshold = region2MinThresholdGFP;
				minContrast = region2MinContrastGFP;
				criteriaMethod = region2CriteriaMethodGFP;
				thresholdMethod = region2ThresholdMethodGFP;
				segmentResults = region2SegmentResultsGFP;
				valueMethod = region2ValueMethodGFP;
				filteringParameter = region2FilteringParameterGFP;
				//End of Block       
				
				//Counter parameters block
				minSize = region2MinSizeGFP;
				maxSize = region2MaxSizeGFP;
				minCircularity = region2MinCircularityGFP;
				maxCircularity = region2MaxCircularityGFP;
			}

			if (regionCount == 3)
			{
				//Thresholder parameters block
				minVolPix = region3MinVolPixGFP;
				maxVolPix = region3MaxVolPixGFP;
				minThreshold = region3MinThresholdGFP;
				minContrast = region3MinContrastGFP;
				criteriaMethod = region3CriteriaMethodGFP;
				thresholdMethod = region3ThresholdMethodGFP;
				segmentResults = region3SegmentResultsGFP;
				valueMethod = region3ValueMethodGFP;
				filteringParameter = region3FilteringParameterGFP;
				//End of Block       
				
				//Counter parameters block
				minSize = region3MinSizeGFP;
				maxSize = region3MaxSizeGFP;
				minCircularity = region3MinCircularityGFP;
				maxCircularity = region3MaxCircularityGFP;
			}

			if (regionCount == 4)
			{
				//Thresholder parameters block
				minVolPix = region4MinVolPixGFP;
				maxVolPix = region4MaxVolPixGFP;
				minThreshold = region4MinThresholdGFP;
				minContrast = region4MinContrastGFP;
				criteriaMethod = region4CriteriaMethodGFP;
				thresholdMethod = region4ThresholdMethodGFP;
				segmentResults = region4SegmentResultsGFP;
				valueMethod = region4ValueMethodGFP;
				filteringParameter = region4FilteringParameterGFP;
				//End of Block       
				
				//Counter parameters block
				minSize = region4MinSizeGFP;
				maxSize = region4MaxSizeGFP;
				minCircularity = region4MinCircularityGFP;
				maxCircularity = region4MaxCircularityGFP;
			}
		}
		
		//Generic GFP parameters. Require minor calibration for every batch of images.
		if (gfpTuningParameter == 1)
		{
			//Thresholder parameters block
			minVolPix = 20;
			maxVolPix = 100;
			minThreshold = 20;
			minContrast = 0;
			criteriaMethod = "ELONGATION";
			thresholdMethod = "STEP";
			segmentResults = "All";
			valueMethod = 10;
			filteringParameter = "filtering";
			//End of Block
			
			//Counter parameters block
			minSize = 0;
			maxSize = 300;
			minCircularity = 0.65;
			maxCircularity = 1.00;
			//End of Block
		}

		if (gfpTuningParameter == 2)
		{
			//Thresholding settings
			minVolPix = 20;
			maxVolPix = 100;
			minThreshold = 20;
			minContrast = 6;
			criteriaMethod = elongation;
			thresholdMethod = kmeans;
			segmentResults = all;
			valueMethod = 10;
			filteringParameter = filtering;
			
			//Counter settings
			minSize = 0;
			maxSize = 300;
			minCircularity = 0.65;
			maxCircularity = 1;

		}

		//Description of the profile goes here
		if (gfpTuningParameter == 3)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (gfpTuningParameter == 4)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (gfpTuningParameter == 5)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (gfpTuningParameter == 6)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (gfpTuningParameter == 7)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (gfpTuningParameter == 8)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (gfpTuningParameter == 9)
		{
			//Code-block created by Calibration pipeline goes here
		}
	}
	//End of Block

    //Overlap Block
	if(regionStainName == "Overlap")
	{
		//Switches the tuner to the set of internal parameters generated by user during calibration. Allows to tune the algorithms methods while it i8s running.
		if (overlapTuningParameter == 0)
		{
			if (regionCount == 1)
			{
				//Counter parameters block
				minSize = region1MinSizeOverlap;
				maxSize = region1MaxSizeOverlap;
				minCircularity = region1MinCircularityOverlap;
				maxCircularity = region1MaxCircularityOverlap;
			}

			if (regionCount == 2)
			{
				//Counter parameters block
				minSize = region2MinSizeOverlap;
				maxSize = region2MaxSizeOverlap;
				minCircularity = region2MinCircularityOverlap;
				maxCircularity = region2MaxCircularityOverlap;
			}

			if (regionCount == 3)
			{
				//Counter parameters block
				minSize = region3MinSizeOverlap;
				maxSize = region3MaxSizeOverlap;
				minCircularity = region3MinCircularityOverlap;
				maxCircularity = region3MaxCircularityOverlap;
			}

			if (regionCount == 4)
			{
				//Counter parameters block
				minSize = region4MinSizeOverlap;
				maxSize = region4MaxSizeOverlap;
				minCircularity = region4MinCircularityOverlap;
				maxCircularity = region4MaxCircularityOverlap;
			}
		}
		
		//Generic Overlap parameters. Should match either gfp or cfos profile, whichever is more conservative.
		if (overlapTuningParameter == 1)
		{
			//Counter parameters block
			minSize = 20;
			maxSize = 300;
			minCircularity = 0.65;
			maxCircularity = 1.00;
			//End of Block
		}

		//Description of the profile goes here
		if (overlapTuningParameter == 2)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (overlapTuningParameter == 3)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (overlapTuningParameter == 4)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (overlapTuningParameter == 5)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (overlapTuningParameter == 6)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (overlapTuningParameter == 7)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (overlapTuningParameter == 8)
		{
			//Code-block created by Calibration pipeline goes here
		}

		//Description of the profile goes here
		if (overlapTuningParameter == 9)
		{
			//Code-block created by Calibration pipeline goes here
		}
	}
	//End of Block
}

// This is a minor method that is used to dynamically overwrite tuning profile assignment with 0 (corresponds to no profile). If called during/after manual calibration, this essentially sets the active profile to the one created by the user during calibration. This may be helpful when batch-processing images, so that the user only needs to calibrate the first few images and then carry on in automatic mode.
function preserveCalibratedProfile(imageFile)
{
	if (controlPanelChoice == "Move On")
	{
		//Dapi Block
		if (regionStainName == "Dapi")
		{
			dapiTuningParameter = 0; // sets the tuning parameter to internal variables
	
			//Sets the internal variables to match user-calibrated parameters.
			if (regionCount == 1)
			{
				region1DapiTuningParameter = dapiTuningParameter;
				
				//Thresholding Settings
				region1MinVolPixDapi = minVolPix;
				region1MaxVolPixDapi = maxVolPix;
				region1MinThresholdDapi = minThreshold;
				region1MinContrastDapi = minContrast;
				region1CriteriaMethodDapi = criteriaMethod;
				region1ThresholdMethodDapi = thresholdMethod;
				region1SegmentResultsDapi = segmentResults;
				region1ValueMethodDapi = valueMethod;
				region1FilteringParameterDapi = filteringParameter;
					
				//Counter settings
				region1MinSizeDapi = minSize;
				region1MaxSizeDapi = maxSize;
				region1MinCircularityDapi = minCircularity;
				region1MaxCircularityDapi = maxCircularity;
				//End of Block
			}
			if (regionCount == 2)
			{
				region2DapiTuningParameter = dapiTuningParameter;
				
				//Thresholding Settings
				region2MinVolPixDapi = minVolPix;
				region2MaxVolPixDapi = maxVolPix;
				region2MinThresholdDapi = minThreshold;
				region2MinContrastDapi = minContrast;
				region2CriteriaMethodDapi = criteriaMethod;
				region2ThresholdMethodDapi = thresholdMethod;
				region2SegmentResultsDapi = segmentResults;
				region2ValueMethodDapi = valueMethod;
				region2FilteringParameterDapi = filteringParameter;
					
				//Counter settings
				region2MinSizeDapi = minSize;
				region2MaxSizeDapi = maxSize;
				region2MinCircularityDapi = minCircularity;
				region2MaxCircularityDapi = maxCircularity;
				//End of Block
			}
			if (regionCount == 3)
			{
				region3DapiTuningParameter = dapiTuningParameter;
				
				//Thresholding Settings
				region3MinVolPixDapi = minVolPix;
				region3MaxVolPixDapi = maxVolPix;
				region3MinThresholdDapi = minThreshold;
				region3MinContrastDapi = minContrast;
				region3CriteriaMethodDapi = criteriaMethod;
				region3ThresholdMethodDapi = thresholdMethod;
				region3SegmentResultsDapi = segmentResults;
				region3ValueMethodDapi = valueMethod;
				region3FilteringParameterDapi = filteringParameter;
					
				//Counter settings
				region3MinSizeDapi = minSize;
				region3MaxSizeDapi = maxSize;
				region3MinCircularityDapi = minCircularity;
				region3MaxCircularityDapi = maxCircularity;
				//End of Block
			}
			if (regionCount == 4)
			{
				region4DapiTuningParameter = dapiTuningParameter;
				
				//Thresholding Settings
				region4MinVolPixDapi = minVolPix;
				region4MaxVolPixDapi = maxVolPix;
				region4MinThresholdDapi = minThreshold;
				region4MinContrastDapi = minContrast;
				region4CriteriaMethodDapi = criteriaMethod;
				region4ThresholdMethodDapi = thresholdMethod;
				region4SegmentResultsDapi = segmentResults;
				region4ValueMethodDapi = valueMethod;
				region4FilteringParameterDapi = filteringParameter;
					
				//Counter settings
				region4MinSizeDapi = minSize;
				region4MaxSizeDapi = maxSize;
				region4MinCircularityDapi = minCircularity;
				region4MaxCircularityDapi = maxCircularity;
				//End of Block
			}
		}
		//End of Block
	
		//Cfos Block
		if (regionStainName == "Cfos")
		{
			cfosTuningParameter = 0;
	
			if (regionCount == 1)
			{
				region1CfosTuningParameter = cfosTuningParameter;
				
				//Thresholding Settings
				region1MinVolPixCfos = minVolPix;
				region1MaxVolPixCfos = maxVolPix;
				region1MinThresholdCfos = minThreshold;
				region1MinContrastCfos = minContrast;
				region1CriteriaMethodCfos = criteriaMethod;
				region1ThresholdMethodCfos = thresholdMethod;
				region1SegmentResultsCfos = segmentResults;
				region1ValueMethodCfos = valueMethod;
				region1FilteringParameterCfos = filteringParameter;
					
				//Counter settings
				region1MinSizeCfos = minSize;
				region1MaxSizeCfos = maxSize;
				region1MinCircularityCfos = minCircularity;
				region1MaxCircularityCfos = maxCircularity;
				//End of Block
			}
			if (regionCount == 2)
			{
				region2CfosTuningParameter = cfosTuningParameter;
				
				//Thresholding Settings
				region2MinVolPixCfos = minVolPix;
				region2MaxVolPixCfos = maxVolPix;
				region2MinThresholdCfos = minThreshold;
				region2MinContrastCfos = minContrast;
				region2CriteriaMethodCfos = criteriaMethod;
				region2ThresholdMethodCfos = thresholdMethod;
				region2SegmentResultsCfos = segmentResults;
				region2ValueMethodCfos = valueMethod;
				region2FilteringParameterCfos = filteringParameter;
					
				//Counter settings
				region2MinSizeCfos = minSize;
				region2MaxSizeCfos = maxSize;
				region2MinCircularityCfos = minCircularity;
				region2MaxCircularityCfos = maxCircularity;
				//End of Block
			}
			if (regionCount == 3)
			{
				region3CfosTuningParameter = cfosTuningParameter;
				
				//Thresholding Settings
				region3MinVolPixCfos = minVolPix;
				region3MaxVolPixCfos = maxVolPix;
				region3MinThresholdCfos = minThreshold;
				region3MinContrastCfos = minContrast;
				region3CriteriaMethodCfos = criteriaMethod;
				region3ThresholdMethodCfos = thresholdMethod;
				region3SegmentResultsCfos = segmentResults;
				region3ValueMethodCfos = valueMethod;
				region3FilteringParameterCfos = filteringParameter;
					
				//Counter settings
				region3MinSizeCfos = minSize;
				region3MaxSizeCfos = maxSize;
				region3MinCircularityCfos = minCircularity;
				region3MaxCircularityCfos = maxCircularity;
				//End of Block
			}
			if (regionCount == 4)
			{
				region4CfosTuningParameter = cfosTuningParameter;
				
				//Thresholding Settings
				region4MinVolPixCfos = minVolPix;
				region4MaxVolPixCfos = maxVolPix;
				region4MinThresholdCfos = minThreshold;
				region4MinContrastCfos = minContrast;
				region4CriteriaMethodCfos = criteriaMethod;
				region4ThresholdMethodCfos = thresholdMethod;
				region4SegmentResultsCfos = segmentResults;
				region4ValueMethodCfos = valueMethod;
				region4FilteringParameterCfos = filteringParameter;
					
				//Counter settings
				region4MinSizeCfos = minSize;
				region4MaxSizeCfos = maxSize;
				region4MinCircularityCfos = minCircularity;
				region4MaxCircularityCfos = maxCircularity;
				//End of Block
			}
		}
		//End of Block
	
		//GFP Block
		if (regionStainName == "GFP")
		{
			gfpTuningParameter = 0;
	
			if (regionCount == 1)
			{
				region1GFPTuningParameter = gfpTuningParameter;
				
				//Thresholding Settings
				region1MinVolPixGFP = minVolPix;
				region1MaxVolPixGFP = maxVolPix;
				region1MinThresholdGFP = minThreshold;
				region1MinContrastGFP = minContrast;
				region1CriteriaMethodGFP = criteriaMethod;
				region1ThresholdMethodGFP = thresholdMethod;
				region1SegmentResultsGFP = segmentResults;
				region1ValueMethodGFP = valueMethod;
				region1FilteringParameterGFP = filteringParameter;
					
				//Counter settings
				region1MinSizeGFP = minSize;
				region1MaxSizeGFP = maxSize;
				region1MinCircularityGFP = minCircularity;
				region1MaxCircularityGFP = maxCircularity;
				//End of Block
			}
			if (regionCount == 2)
			{
				region2GFPTuningParameter = gfpTuningParameter;
				
				//Thresholding Settings
				region2MinVolPixGFP = minVolPix;
				region2MaxVolPixGFP = maxVolPix;
				region2MinThresholdGFP = minThreshold;
				region2MinContrastGFP = minContrast;
				region2CriteriaMethodGFP = criteriaMethod;
				region2ThresholdMethodGFP = thresholdMethod;
				region2SegmentResultsGFP = segmentResults;
				region2ValueMethodGFP = valueMethod;
				region2FilteringParameterGFP = filteringParameter;
					
				//Counter settings
				region2MinSizeGFP = minSize;
				region2MaxSizeGFP = maxSize;
				region2MinCircularityGFP = minCircularity;
				region2MaxCircularityGFP = maxCircularity;
				//End of Block
			}
			if (regionCount == 3)
			{
				region3GFPTuningParameter = gfpTuningParameter;
				
				//Thresholding Settings
				region3MinVolPixGFP = minVolPix;
				region3MaxVolPixGFP = maxVolPix;
				region3MinThresholdGFP = minThreshold;
				region3MinContrastGFP = minContrast;
				region3CriteriaMethodGFP = criteriaMethod;
				region3ThresholdMethodGFP = thresholdMethod;
				region3SegmentResultsGFP = segmentResults;
				region3ValueMethodGFP = valueMethod;
				region3FilteringParameterGFP = filteringParameter;
					
				//Counter settings
				region3MinSizeGFP = minSize;
				region3MaxSizeGFP = maxSize;
				region3MinCircularityGFP = minCircularity;
				region3MaxCircularityGFP = maxCircularity;
				//End of Block
			}
			if (regionCount == 4)
			{
				region4GFPTuningParameter = gfpTuningParameter;
				
				//Thresholding Settings
				region4MinVolPixGFP = minVolPix;
				region4MaxVolPixGFP = maxVolPix;
				region4MinThresholdGFP = minThreshold;
				region4MinContrastGFP = minContrast;
				region4CriteriaMethodGFP = criteriaMethod;
				region4ThresholdMethodGFP = thresholdMethod;
				region4SegmentResultsGFP = segmentResults;
				region4ValueMethodGFP = valueMethod;
				region4FilteringParameterGFP = filteringParameter;
					
				//Counter settings
				region4MinSizeGFP = minSize;
				region4MaxSizeGFP = maxSize;
				region4MinCircularityGFP = minCircularity;
				region4MaxCircularityGFP = maxCircularity;
				//End of Block
			}
		}
		//End of Block
	
		//Overlap Block
		if (regionStainName == "Overlap")
		{
			overlapTuningParameter = 0;
	
			if (regionCount == 1)
			{
				region1OverlapTuningParameter = overlapTuningParameter;
				
				region1MinSizeOverlap = minSize;
				region1MaxSizeOverlap = maxSize;
				region1MinCircularityOverlap = minCircularity;
				region1MaxCircularityOverlap = maxCircularity;
			}
			if (regionCount == 2)
			{
				region2OverlapTuningParameter = overlapTuningParameter;
				
				region2MinSizeOverlap = minSize;
				region2MaxSizeOverlap = maxSize;
				region2MinCircularityOverlap = minCircularity;
				region2MaxCircularityOverlap = maxCircularity;
			}
			if (regionCount == 3)
			{
				region3OverlapTuningParameter = overlapTuningParameter;
				
				region3MinSizeOverlap = minSize;
				region3MaxSizeOverlap = maxSize;
				region3MinCircularityOverlap = minCircularity;
				region3MaxCircularityOverlap = maxCircularity;
			}
			if (regionCount == 4)
			{
				region4OverlapTuningParameter = overlapTuningParameter;
				
				region4MinSizeOverlap = minSize;
				region4MaxSizeOverlap = maxSize;
				region4MinCircularityOverlap = minCircularity;
				region4MaxCircularityOverlap = maxCircularity;
			}
		}
		//End of Block
	}
	else 
	{
		if (regionStainName == "Dapi")
		{
			dapiTuningParameter = "Null";
		}
		if (regionStainName == "Cfos")
		{
			cfosTuningParameter = "Null";
		}
		if (regionStainName == "GFP")
		{
			gfpTuningParameter = "Null";
		}
		if (regionStainName == "Overlap")
		{
			overlapTuningParameter = "Null";
		}
	}
}

// This is a minor function which converts the string values of the parameter variables generated by calibrateMethod function into the variable names. This is a necessary formating step to make auto-generated code executable without user interaction.
function textConverter(imageFile)
{
	//criteriaMethod Block
	if (criteriaMethod == elongation)
	{
		criteriaMethodPrint = "criteriaMethod = elongation;";
	}
	if (criteriaMethod == compactness)
	{
		criteriaMethodPrint = "criteriaMethod = compactness;";
	}
	if (criteriaMethod == volume)
	{
		criteriaMethodPrint = "criteriaMethod = volume;";
	}
	if (criteriaMethod == mser)
	{
		criteriaMethodPrint = "criteriaMethod = mser;";
	}
	if (criteriaMethod == edges)
	{
		criteriaMethodPrint = "criteriaMethod = edges;";
	}
	// End of Block

	//thresholdMethod Block
	if (thresholdMethod == step)
	{
		thresholdMethodPrint = "thresholdMethod = step;";
	}
	if (thresholdMethod == kmeans)
	{
		thresholdMethodPrint = "thresholdMethod = kmeans;";
	}
	if (thresholdMethod == volume)
	{
		thresholdMethodPrint = "thresholdMethod = volume;";
	}
	//End of Block

	//segmentResults Block
	if (segmentResults == all)
	{
		segmentResultsPrint = "segmentResults = all;";
	}
	if (segmentResults == best)
	{
		segmentResultsPrint = "segmentResults = best;";
	}
	//End of Block

	//filteringParameter Block
	if (filteringParameter == filtering)
	{
		filteringParameterPrint = "filteringParameter = filtering;";
	}
	if (filteringParameter != filtering)
	{
		filteringParameterPrint = "filteringParameter = null;";
	}
	//End of Block

	//maxSize Block
	if (maxSize == infinity)
	{
		maxSizePrint = "maxSize = infinity;";	
	}
	//End of Block
}

// This is a first component of the two minor functions that update the ROI overlay on the manaul counter image to reflect the convergence between machine methods being tuned and human output
function roiReset(imageFile)
{
	if (manualPresence == 1)
	{
		selectWindow(manualCountName);
		if (roiManager("Count") != 0) 
		{
			roiManager("delete");
		}
	}
	
}

//A second component of the minor function described above
function roiUpdate(imageFile)
{
	if (manualPresence == 1)
	{
		selectWindow(manualCountName);
		if (roiManager("Count") != 0) 
		{
			roiManager("show all");
		}
	}
}

//This is a minor function, which generates the Overlap image for calibration. In order to do so, it uses either predefined or calibrated tuning profiles for gfp and cfos, following a similar procedure utilized by the automatic counter, but without the generation of tiff images.
function prepareOverlapCalibration(imageFile)
{
	//Cfos Block
	regionStainName = "Cfos";
	open(cfosOriginalPath);
	methodTuning(imageFile);
	rename("Discard 1");
	
	run("3D Iterative Thresholding", "min_vol_pix=" +minVolPix+" max_vol_pix="+maxVolPix+" min_threshold="+minThreshold+" min_contrast="+minContrast+" criteria_method="+criteriaMethod+" threshold_method="+thresholdMethod+" segment_results="+segmentResults+" value_method="+valueMethod+" "+filteringParameter);
	
	rename("CfosFeed");
	//End of Block
	
	//GFP Block
	regionStainName = "GFP";
	open(gfpOriginalPath);
	methodTuning(imageFile);
	rename("Discard 2");

	run("3D Iterative Thresholding", "min_vol_pix=" +minVolPix+" max_vol_pix="+maxVolPix+" min_threshold="+minThreshold+" min_contrast="+minContrast+" criteria_method="+criteriaMethod+" threshold_method="+thresholdMethod+" segment_results="+segmentResults+" value_method="+valueMethod+" "+filteringParameter);
    
	rename("GfpFeed");
	//End of Block

	//Overlap constructor block
	imageCalculator("AND create stack", "CfosFeed", "GfpFeed");
    //End of Block

    regionStainName = "Overlap";
    selectWindow("Result of CfosFeed"); //This is a crucial step for this function to be successfully implemented on the lower levels.
}
