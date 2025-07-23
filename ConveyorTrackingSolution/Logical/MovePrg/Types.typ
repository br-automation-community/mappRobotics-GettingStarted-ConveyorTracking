
TYPE
	CommandType : 	STRUCT 
		PowerAndHome : BOOL;
		MoveConveyor1 : BOOL;
		MoveConveyor2 : BOOL;
		MoveProgramRobot1 : BOOL;
		MoveProgramRobot2 : BOOL;
		Settings : CmdSettingsType;
	END_STRUCT;
	CmdSettingsType : 	STRUCT 
		FrameSpaceConveyor1 : LREAL;
		FrameSpaceConveyor2 : LREAL;
		VelocityConveyor1 : REAL;
		VelocityConveyor2 : REAL;
	END_STRUCT;
	StateType : 
		(
		STARTUP,
		WAIT_FOR_POWER_AND_HOME,
		POWER,
		HOME,
		READ_CURRENT_PARAMETERS,
		RUN
		);
END_TYPE
