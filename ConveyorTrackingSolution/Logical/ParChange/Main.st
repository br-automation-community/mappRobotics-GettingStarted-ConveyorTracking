
PROGRAM _INIT
	
	
	// ------------------------------------------------------------------------------------------------
	// Optional: Operate on parameters of TrackingFrameSelection feature for robot 1 during PLC runtime
	
	// ------------------------------------------------------------------------------------------------
	// Prepare dummy parameters and data type with 'unbounded arrays'
	
	// AxesGroupFeature - TrackingFrameSelection - Parmeters
	// Selectors
	TrkFrmSelConfig.Selectors.Selector.DataAddress := ADR(TrkFrmSelConfig_Selectors);
	TrkFrmSelConfig.Selectors.Selector.NumberOfArrayElements := 10;
	TrkFrmSelConfig.Selectors.Selector.NumberOfElements := 2;
	// Selector 1
	TrkFrmSelConfig_Selectors[0].Type := mcAGFTFSSS_SNG_FRM;
	TrkFrmSelConfig_Selectors[0].SingleFrames.Name := 'myTrkFrmSelector2';
	// Selector 1 - Strategy
	TrkFrmSelConfig_Selectors[0].SingleFrames.Strategy.Type := mcAGFTFSSFS_FIFO;
	// Selector 1 - Filters
	TrkFrmSelConfig_Selectors[0].SingleFrames.Filters.Filter.DataAddress := ADR(TrkFrmSelConfig_Sel1Filters);
	TrkFrmSelConfig_Selectors[0].SingleFrames.Filters.Filter.NumberOfArrayElements := 2;
	TrkFrmSelConfig_Selectors[0].SingleFrames.Filters.Filter.NumberOfElements := 2;
	// Selector 1 - First filter - Specific tracking path
	TrkFrmSelConfig_Sel1Filters[0].TrackingPaths.TrackingPathReference.DataAddress := ADR(TrkFrmSelConfig_Sel1TrkPaths);
	TrkFrmSelConfig_Sel1Filters[0].TrackingPaths.TrackingPathReference.NumberOfArrayElements := 2;
	TrkFrmSelConfig_Sel1Filters[0].TrackingPaths.TrackingPathReference.NumberOfElements := 2;
	// Selector 1 - Second filter - Selection area
	TrkFrmSelConfig_Sel1Filters[1].SelectionArea.Area.DataAddress := ADR(TrkFrmSelConfig_Sel1Areas);
	TrkFrmSelConfig_Sel1Filters[1].SelectionArea.Area.NumberOfArrayElements := 2;
	TrkFrmSelConfig_Sel1Filters[1].SelectionArea.Area.NumberOfElements := 1;
	// Selector 1 - TrackingPaths
	TrkFrmSelConfig_Sel1TrkPaths[0].ConfigType := mcCFG_TRK_PATH;
	TrkFrmSelConfig_Sel1TrkPaths[0].Name := 'gTrkPath_Conveyor_1';
	// Selector 1 - Selection area
	TrkFrmSelConfig_Sel1Areas[0].Type := mcAGFTFSSFSFSAA_CYLINDER;
	TrkFrmSelConfig_Sel1Areas[0].Cylinder.Dimensions.Radius := 500;
	TrkFrmSelConfig_Sel1Areas[0].Cylinder.Dimensions.Height := 300;
	TrkFrmSelConfig_Sel1Areas[0].Cylinder.Origin.Type := mcAGFTFSSFSFSAACylO_MCS;
	TrkFrmSelConfig_Sel1Areas[0].Cylinder.Orientation.Angle1:= 0;
	TrkFrmSelConfig_Sel1Areas[0].Cylinder.Orientation.Angle2:= 0;
	TrkFrmSelConfig_Sel1Areas[0].Cylinder.Orientation.Angle3:= 0;
	TrkFrmSelConfig_Sel1Areas[0].Cylinder.Translation.X := -300;
	TrkFrmSelConfig_Sel1Areas[0].Cylinder.Translation.Y := 0;
	TrkFrmSelConfig_Sel1Areas[0].Cylinder.Translation.Z := -100;
	// Selector 2
	TrkFrmSelConfig_Selectors[1].Type := mcAGFTFSSS_SNG_FRM;
	TrkFrmSelConfig_Selectors[1].SingleFrames.Name := 'myTrkFrmSelector1';
	// Selector 2 - Strategy
	TrkFrmSelConfig_Selectors[1].SingleFrames.Strategy.Type := mcAGFTFSSFS_FIFO;
	// Selector 2 - Filters
	TrkFrmSelConfig_Selectors[1].SingleFrames.Filters.Filter.DataAddress := ADR(TrkFrmSelConfig_Sel2Filters);
	TrkFrmSelConfig_Selectors[1].SingleFrames.Filters.Filter.NumberOfArrayElements := 2;
	TrkFrmSelConfig_Selectors[1].SingleFrames.Filters.Filter.NumberOfElements := 2;
	// Selector 2 - First filter - Specific tracking path
	TrkFrmSelConfig_Sel2Filters[0].TrackingPaths.TrackingPathReference.DataAddress := ADR(TrkFrmSelConfig_Sel2TrkPaths);
	TrkFrmSelConfig_Sel2Filters[0].TrackingPaths.TrackingPathReference.NumberOfArrayElements := 2;
	TrkFrmSelConfig_Sel2Filters[0].TrackingPaths.TrackingPathReference.NumberOfElements := 2;
	// Selector 2 - Second filter - Selection area
	TrkFrmSelConfig_Sel2Filters[1].SelectionArea.Area.DataAddress := ADR(TrkFrmSelConfig_Sel2Areas);
	TrkFrmSelConfig_Sel2Filters[1].SelectionArea.Area.NumberOfArrayElements := 2;
	TrkFrmSelConfig_Sel2Filters[1].SelectionArea.Area.NumberOfElements := 1;
	// Selector 2 - TrackingPaths
	TrkFrmSelConfig_Sel2TrkPaths[0].ConfigType := mcCFG_TRK_PATH;
	TrkFrmSelConfig_Sel2TrkPaths[0].Name := 'gTrkPath_Conveyor_1';
	// Selector 2 - Selection area
	TrkFrmSelConfig_Sel2Areas[0].Type := mcAGFTFSSFSFSAA_CYLINDER;
	TrkFrmSelConfig_Sel2Areas[0].Cylinder.Dimensions.Radius := 500;
	TrkFrmSelConfig_Sel2Areas[0].Cylinder.Dimensions.Height := 300;
	TrkFrmSelConfig_Sel2Areas[0].Cylinder.Origin.Type := mcAGFTFSSFSFSAACylO_MCS;
	TrkFrmSelConfig_Sel2Areas[0].Cylinder.Orientation.Angle1:= 0;
	TrkFrmSelConfig_Sel2Areas[0].Cylinder.Orientation.Angle2:= 0;
	TrkFrmSelConfig_Sel2Areas[0].Cylinder.Orientation.Angle3:= 0;
	TrkFrmSelConfig_Sel2Areas[0].Cylinder.Translation.X := -300;
	TrkFrmSelConfig_Sel2Areas[0].Cylinder.Translation.Y := 0;
	TrkFrmSelConfig_Sel2Areas[0].Cylinder.Translation.Z := -100;

	// ------------------------------------------------------------------------------------------------

	// Prepare function block for optional manual execution in Watch window
	// ...to manipulate TrackingFrameSelection parameters for robot 1
	ProcessParam_TrkFrmSelectionFeat.Component := ADR(gAxesGroup_D4r1100R_1);
	ProcessParam_TrkFrmSelectionFeat.AdvancedParameters.Name := 'Feature_TrkFrmSel_D4r1100R_X';
	ProcessParam_TrkFrmSelectionFeat.DataAddress := ADR(TrkFrmSelConfig);
	ProcessParam_TrkFrmSelectionFeat.DataType := mcCFG_AXGRP_FEAT_TRKFRM_SEL;
	ProcessParam_TrkFrmSelectionFeat.Mode := mcPPM_READ;
	
	// ------------------------------------------------------------------------------------------------

END_PROGRAM


PROGRAM _CYCLIC

	ProcessParam_TrkFrmSelectionFeat();
	 
END_PROGRAM


