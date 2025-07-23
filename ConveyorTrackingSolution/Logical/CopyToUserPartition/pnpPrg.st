TYPE
  MachineState : (Start, SelectPickPosition, PickObject, SelectPlacePosition, PlaceObject, ParkWithNoObject, ParkWithGrippedObject);
END_TYPE
 
VAR CONSTANT
    ParkPos      : McPointType := (Pos:=(X:=0, Y:=0, Z:= -900));
    SynchPosUp   : McPointType := (Pos:=(X:=   0, Y:= 0,  Z:= 100));
    SynchPosDown : McPointType := (Pos:=(X:=   0, Y:= 0,  Z:= 0));
END_VAR
 
VAR
    TrkFrmID_PickPosition: McTrkFrmIdentType;
    TrkFrmID_PlacePosition: McTrkFrmIdentType;
    State : MachineState;   
END_VAR
  
PROGRAM _MAIN
      
    State := MachineState#Start;
     
    REPEAT
        CASE State OF
         
        MachineState#Start:
            MoveLR(ParkPos);                                   
            WaitUntilSync(TrackingFrameIsAvailable('PickPositionSelector'));
            State := MachineState#SelectPickPosition;
         
        MachineState#SelectPickPosition:
            WaitALAP();
            IF TrackingFrameSelect(TrkFrmID_PickPosition, 'PickPositionSelector') THEN
                State :=  MachineState#PickObject;
            ELSE
                State := MachineState#ParkWithNoObject;
            END_IF
             
        MachineState#PickObject:
            TrackObjectR(TrkFrmID_PickPosition, SynchPosUp, 50, 50);
            MoveLR(SynchPosDown);
			CloseGripper := TRUE;	//close gripper
			WaitTime(0.01);			//wait until gripper is closed [s]
            MoveLR(SynchPosUp);
            State := MachineState#SelectPlacePosition;
         
        MachineState#SelectPlacePosition:
            WaitALAP();
            IF TrackingFrameSelect(TrkFrmID_PlacePosition, 'PlacePositionSelector') THEN
                State :=  MachineState#PlaceObject;
            ELSE
                State := MachineState#ParkWithGrippedObject;
            END_IF
         
        MachineState#PlaceObject:
            TrackObjectR(TrkFrmID_PlacePosition, SynchPosUp, 50, 50);
            MoveLR(SynchPosDown);
			CloseGripper := FALSE;	//open gripper
			WaitTime(0.01);			//wait until gripper is opened [s]
            MoveLR(SynchPosUp);
            State := MachineState#SelectPickPosition;   
 
        MachineState#ParkWithNoObject:
            TrackStopR(MachineFrame, ParkPos, 50, 50);                            
			WaitUntilSync(TrackingFrameSelect(TrkFrmID_PickPosition, 'PickPositionSelector'));
            State := MachineState#PickObject;        
         
        MachineState#ParkWithGrippedObject:
            TrackStopR(MachineFrame, ParkPos, 50, 50);                             
			WaitUntilSync(TrackingFrameSelect(TrkFrmID_PlacePosition, 'PlacePositionSelector'));
			State := MachineState#PlaceObject;    
			
        END_CASE       
    UNTIL FALSE END_REPEAT;
      
END_PROGRAM
