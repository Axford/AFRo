include <../config/config.scad>


ShoulderBracketLeft_stl();
ShoulderBracketRight_stl();

ElbowMotorPlate_stl();

bh = linear_bearing_height(ShoulderRodBearing);

// motor frame
translate([0, ElbowMotorOffset, bh - dw])
	frame();


translate([-80, 0, 0]) ShoulderAssembly();