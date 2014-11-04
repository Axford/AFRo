include <config/config.scad>

debugConnectors=false;

//DynamixelAX12();

//ThreadlessBallscrew();

*color(grey50)
	translate([46,47,0])
	rotate([0,0,-90])
	import("utils/MEGA2560_and_RAMPS14.stl");
	
*BaseBracket_stl();

*ShoulderBracket_UpperPlate_stl();
	
*ShoulderBracket_LowerPlate_stl();

*ShoulderBracket_Ballscrew_stl();

*ZInnerCap_stl();

*rotate([0,90,0])
	UpperArmSpar_stl();
	

*BaseBracket_stl();

*ZInnerCap_stl();

*rotate([0,180,0])
	LowerArmUpperPlate_stl();
	
*rotate([0,90,0])
	LowerArmSpar_stl();
	
	
ShoulderAngle = 0;
ElbowAngle = 0;
WristAngle = 0;

*LowerArmAssembly();

*rotate([0,180,0])
	WristBracket_stl();
	
//RobobuilderSAM3();

*rotate([0,180,0]) 
SpoonHolder_stl();

*coupling_stl();

//microswitch2();

*EndStopBracket_stl();

*translate([-49,67, -14])
	rotate([0,90,0])
	cupHolderAssembly();
	
*TorsoBearingCollar_stl();

*translate([40,0, 15+dw])
	rotate([180,0,0])
	TorsoBearingTopCollar_stl();

*TorsoBigGear_stl();


*TorsoDriveGear_stl();

*TorsoBase_stl();

*TorsoCap_stl();

*TorsoBearingTopCollarDev_stl();

*ShoulderBracketRight_stl();

*ShoulderBeltClamp_stl();

*ElbowJoint_stl();

*ElbowMotorPlate_stl();

*ElbowJoint2_stl();

*LowerArmServoBracket_stl();

*ElbowDrivenPulley_stl();

*CounterweightIdler_stl();

*CounterweightLineBracket_stl();

*CounterweightBracket_stl();

*CounterweightIdlerGuide_stl();

*WristBracket_stl();

ElbowMotorPlate_stl();