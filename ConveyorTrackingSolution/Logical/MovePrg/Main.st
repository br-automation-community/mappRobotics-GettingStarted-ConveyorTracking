
PROGRAM _INIT
	
	//Initial process parameters
	Cmd.Settings.FrameSpaceConveyor1 := 150;
	Cmd.Settings.FrameSpaceConveyor2 := 150;
	Cmd.Settings.VelocityConveyor1 := 400;
	Cmd.Settings.VelocityConveyor2 := 400;

	// Robots
	MpRobotPar.ProgramName := 'pnpPrg.st';
	MpRobot_0.MpLink := ADR(gAxesGroup_D4r1100R_1);
	MpRobot_0.Enable := TRUE;
	MpRobot_0.Parameters := ADR(MpRobotPar);
	MpRobot_0.Override := 100;
	MpRobot_1.MpLink := ADR(gAxesGroup_D4r1100R_2);
	MpRobot_1.Enable := TRUE;
	MpRobot_1.Parameters := ADR(MpRobotPar);
	MpRobot_1.Override := 100;

	// Conveyor belts
	MpAxisParConv1.Velocity := Cmd.Settings.VelocityConveyor1;
	MpAxisParConv2.Velocity := Cmd.Settings.VelocityConveyor2;
	MpAxisConv1.MpLink := ADR(gAxis_Conveyor_1);
	MpAxisConv1.Parameters := ADR(MpAxisParConv1);
	MpAxisConv1.Enable := TRUE;
	MpAxisConv2.MpLink := ADR(gAxis_Conveyor_2);
	MpAxisConv2.Parameters := ADR(MpAxisParConv2);
	MpAxisConv2.Enable := TRUE;
	StatusTrackingPath1.Enable := TRUE;
	StatusTrackingPath2.Enable := TRUE;
	StatusTrackingPath1.TrackingPath := ADR(gTrkPath_Conveyor_1);
	StatusTrackingPath2.TrackingPath := ADR(gTrkPath_Conveyor_2);

	GripperRobot1OpenClose := FALSE; // Open
	GripperRobot2OpenClose := FALSE; // Open

	gAxisQ1_D4r1100R_1;
	gAxisQ2_D4r1100R_1;
	gAxisQ3_D4r1100R_1;
	gAxisQC_D4r1100R_1;
	
	gAxisQ1_D4r1100R_2;
	gAxisQ2_D4r1100R_2;
	gAxisQ3_D4r1100R_2;
	gAxisQC_D4r1100R_2;
	
END_PROGRAM




PROGRAM _CYCLIC

	// User Interface update
	MpRobot_0.MoveProgram := Cmd.MoveProgramRobot1;
	MpRobot_1.MoveProgram := Cmd.MoveProgramRobot2;
	MpAxisConv1.MoveVelocity := Cmd.MoveConveyor1;
	MpAxisConv2.MoveVelocity := Cmd.MoveConveyor2;


	// Main state machine
	CASE State OF

		STARTUP:
			
			IF MpRobot_0.Info.ReadyToPowerOn AND MpRobot_1.Info.ReadyToPowerOn AND MpAxisConv1.Info.ReadyToPowerOn AND MpAxisConv2.Info.ReadyToPowerOn THEN
				State := WAIT_FOR_POWER_AND_HOME;
			END_IF		


		WAIT_FOR_POWER_AND_HOME:
			
			// AxesGroups are still disabled in this state and optionally ProcessParam_TrkFrmSelectionFeat FB can be used to manually manipulate the configured parameters
			IF Cmd.PowerAndHome THEN
				State := POWER;
			END_IF


		POWER:
		
			MpRobot_0.Power := TRUE;
			MpRobot_1.Power := TRUE;
			MpAxisConv1.Power := TRUE;
			MpAxisConv2.Power := TRUE;
			IF MpRobot_0.PowerOn AND MpRobot_1.PowerOn  AND MpAxisConv1.PowerOn AND MpAxisConv2.PowerOn THEN
				State := HOME;
			END_IF


		HOME:
		
			MpRobot_0.Home := TRUE;
			MpRobot_1.Home := TRUE;
			MpAxisConv1.Home := TRUE;
			MpAxisConv2.Home := TRUE;
			IF MpRobot_0.IsHomed AND MpRobot_1.IsHomed AND MpAxisConv1.IsHomed AND MpAxisConv2.IsHomed THEN
				State := READ_CURRENT_PARAMETERS;	
			END_IF


		READ_CURRENT_PARAMETERS:
			
			// Read current automatic creation condition parameters configured for TrackingPath components

			IF StatusTrackingPath1.TrackingPathReady AND StatusTrackingPath2.TrackingPathReady THEN
				ProcessParam_AutCrtCond1TrkPath1.Execute := TRUE;
				ProcessParam_AutCrtCond1TrkPath1.Component := ADR(gTrkPath_Conveyor_1);
				ProcessParam_AutCrtCond1TrkPath1.AdvancedParameters.Name := 'Condition 1';
				ProcessParam_AutCrtCond1TrkPath1.DataAddress := ADR(AutoCreateConditionParTrkPath1);
				ProcessParam_AutCrtCond1TrkPath1.DataType := mcCFG_TRK_PATH_AUT_CRT_COND;
				ProcessParam_AutCrtCond1TrkPath1.Mode := mcPPM_READ;
	
				ProcessParam_AutCrtCond1TrkPath2.Execute := TRUE;
				ProcessParam_AutCrtCond1TrkPath2.Component := ADR(gTrkPath_Conveyor_2);
				ProcessParam_AutCrtCond1TrkPath2.AdvancedParameters.Name := 'Condition 1';
				ProcessParam_AutCrtCond1TrkPath2.DataAddress := ADR(AutoCreateConditionParTrkPath2);
				ProcessParam_AutCrtCond1TrkPath2.DataType := mcCFG_TRK_PATH_AUT_CRT_COND;
				ProcessParam_AutCrtCond1TrkPath2.Mode := mcPPM_READ;				
			END_IF
		
			IF ProcessParam_AutCrtCond1TrkPath1.Done AND ProcessParam_AutCrtCond1TrkPath2.Done THEN 
				
				ProcessParam_AutCrtCond1TrkPath1.Execute := FALSE;
				ProcessParam_AutCrtCond1TrkPath2.Execute := FALSE;
				
				Cmd.Settings.FrameSpaceConveyor1 := AutoCreateConditionParTrkPath1.Condition.DistanceBased.Distance;
				Cmd.Settings.FrameSpaceConveyor2 := AutoCreateConditionParTrkPath2.Condition.DistanceBased.Distance;
				
				State := RUN;

			END_IF


		RUN:

			// Update with commanded automatic TrackingFrame creation parameters
			IF AutoCreateConditionParTrkPath1.Condition.DistanceBased.Distance <> Cmd.Settings.FrameSpaceConveyor1 THEN
				AutoCreateConditionParTrkPath1.Condition.DistanceBased.Distance := Cmd.Settings.FrameSpaceConveyor1;
				ProcessParam_AutCrtCond1TrkPath1.Execute := TRUE;
				ProcessParam_AutCrtCond1TrkPath1.Component := ADR(gTrkPath_Conveyor_1);
				ProcessParam_AutCrtCond1TrkPath1.AdvancedParameters.Name := 'Condition 1';
				ProcessParam_AutCrtCond1TrkPath1.DataAddress := ADR(AutoCreateConditionParTrkPath1);
				ProcessParam_AutCrtCond1TrkPath1.DataType := mcCFG_TRK_PATH_AUT_CRT_COND;
				ProcessParam_AutCrtCond1TrkPath1.Mode := mcPPM_WRITE;
				ProcessParam_AutCrtCond1TrkPath1();
				ProcessParam_AutCrtCond1TrkPath1.Execute := FALSE;	
			END_IF
			IF AutoCreateConditionParTrkPath2.Condition.DistanceBased.Distance <> Cmd.Settings.FrameSpaceConveyor2 THEN
				AutoCreateConditionParTrkPath2.Condition.DistanceBased.Distance := Cmd.Settings.FrameSpaceConveyor2;
				ProcessParam_AutCrtCond1TrkPath2.Execute := TRUE;
				ProcessParam_AutCrtCond1TrkPath2.Component := ADR(gTrkPath_Conveyor_2);
				ProcessParam_AutCrtCond1TrkPath2.AdvancedParameters.Name := 'Condition 1';
				ProcessParam_AutCrtCond1TrkPath2.DataAddress := ADR(AutoCreateConditionParTrkPath2);
				ProcessParam_AutCrtCond1TrkPath2.DataType := mcCFG_TRK_PATH_AUT_CRT_COND;
				ProcessParam_AutCrtCond1TrkPath2.Mode := mcPPM_WRITE;
				ProcessParam_AutCrtCond1TrkPath2();
				ProcessParam_AutCrtCond1TrkPath2.Execute := FALSE;	
			END_IF
			
			// Update commanded conveyor belt velocities
			IF MpAxisParConv1.Velocity <> Cmd.Settings.VelocityConveyor1 THEN
				MpAxisParConv1.Velocity := Cmd.Settings.VelocityConveyor1;
				MpAxisConv1.Update := TRUE;
				MpAxisConv1();
				MpAxisConv1.Update := FALSE;
			END_IF
			IF MpAxisParConv2.Velocity <> Cmd.Settings.VelocityConveyor2 THEN
				MpAxisParConv2.Velocity := Cmd.Settings.VelocityConveyor2;
				MpAxisConv2.Update := TRUE;
				MpAxisConv2();
				MpAxisConv2.Update := FALSE;
			END_IF
		
			// Optional: Application dependent creation of TrackingFrames (example)
			MC_BR_TrackingFrameCreate_0.Execute := ManualCreationTrigger;	
			MC_BR_TrackingFrameCreate_0.TrackingPath := ADR(gTrkPath_Conveyor_1);
			// Position (relative to TrackingPath) at time of object detection
			MC_BR_TrackingFrameCreate_0.Parameters.Translation.X := 0; 
			MC_BR_TrackingFrameCreate_0.Parameters.Translation.Y := -50;
			MC_BR_TrackingFrameCreate_0.Parameters.Translation.Z := 0;
			// Conveyor position at time of object detection
			MC_BR_TrackingFrameCreate_0.Parameters.LatchedPath.Position := MpAxisConv1.Position;				
			// Wait for MC_BR_TrackingFrameCreate_0.Done
			IF (MC_BR_TrackingFrameCreate_0.Done) THEN
				ManualCreationTrigger := FALSE;		
			END_IF	

	END_CASE

	// Call function blocks
	MC_BR_TrackingFrameCreate_0();
	MpRobot_0();
	MpRobot_1();
	MpAxisConv1();
	MpAxisConv2();
	ProcessParam_AutCrtCond1TrkPath1();
	ProcessParam_AutCrtCond1TrkPath2();
	StatusTrackingPath1();
	StatusTrackingPath2();
	 
END_PROGRAM


