## Getting Started - mapp Robotics Conveyor Tracking Solution

This Automation Studio project accompanies the Getting Started 'Conveyor Tracking Solution' section from Automation Help.
The [Getting Started section](https://help.br-automation.com/#/de/6/motion/mapp_motion/mapp_robotics/gettingstarted/getting_started.html) explains the steps for configuring a pick-and-place application using the mapp Robotics Conveyor Tracking solution. The configuration consists of two delta robots and two conveyor belts, and can be easily expanded. Products (TrackingFrames) are automatically generated on one conveyor belt. On the other conveyor belt, drop-off positions for the created products (TrackingFrames) are automatically generated. Each robot selects both a product and a drop-off position, synchronizes with the product moving on the conveyor belt, closes the gripper, synchronizes with the drop-off position on the second conveyor belt, and opens the gripper to place the product. This pick-and-place process is repeated. If no new products or drop-off positions arrive, the respective robot moves to a park position and waits there for new products or drop-off positions. 
In this application, delta robots of the type Codian D4-ST21-1100-R11 are used and inserted via the Specific Robots Assistant. If a different type of delta robot is used (see Mechanical System), the hardware and settings in the configuration may need to be adjusted.

https://github.com/user-attachments/assets/02b87783-98be-48bd-ae22-59cb54273b7a

## How to run the application

0. Activate ArSim
1. "Offline commission"
2. Open watch for 'MovePrg' task
3. Add 'Cmd' and 'State' process variables 
4. Open the automatically generated scene from the Logical View: 'ObjectHierarchy.scn'
5. Connect SceneViewer via OPC-UA (Username: User, Password: 1234)
6. Use the 'Cmd' structure:
	1. To 'PowerAndHome' the robots and conveyor belts 
		(Optional: Before you set the PowerAndHome command to TRUE, you can try out the 'ParChange' program and manipulate the TrackingFrameSelection parameters using the ProcessParam FB in the Watch window) 
	2. To move the conveyor belts and to start the motionST program ('pnpPrg.st') for the robots
