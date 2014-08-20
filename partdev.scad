include <config/config.scad>

debugConnectors=false;

//DynamixelAX12();

//ThreadlessBallscrew();

*color(grey50)
	translate([46,47,0])
	rotate([0,0,-90])
	import("utils/MEGA2560_and_RAMPS14.stl");
	
*BaseBracket_stl();

*rotate([180,0,0])
	ShoulderBracket_UpperPlate_stl();
	
*ShoulderBracket_LowerPlate_stl();

ShoulderBracket_Ballscrew_stl();

*ZInnerCap_stl();