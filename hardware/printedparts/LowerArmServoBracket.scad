
LowerArmServoBracket_Con_Servo = [[-LowerArmWidth/2, 0, -ShoulderHeight-3.5], [0,0,1], 0,0,0];

LowerArmServoBracket_Con_Fixings = [
    [[0, 50 - 2*tw, -1.5 - ShoulderHeight/2 + 10], [-1,0,0], 0,0,0],
    [[0, 50 - 2*tw, -1.5 - ShoulderHeight/2 - 10], [-1,0,0], 0,0,0]
];

module LowerArmServoBracket_stl() {
	// x+ side
	// origin is aligned with top of shoulder servo horn at joint origin
	
	$fn=24;
	
	sparLen = LowerArmLength * 0.68;
	d = 50;
	fixingSpacing = 2*(sparLen - LowerArmLength/2) - 20;
    
    if (DebugCoordinateFrames) frame();
    if (DebugConnectors) {
        connector(LowerArmServoBracket_Con_Servo);
        for (i=[0:1])
            connector(LowerArmServoBracket_Con_Fixings[i]);
    }
	
    printedPart("printedparts/LowerArmServoBracket.scad", "Lower Arm Servo Bracket", "LowerArmServoBracket_stl()") {

        view(t=[0, 25, -19]);

        if (UseSTL) {
            import(str(STLPath, "LowerArmServoBracket.stl"));
        } else {
            //render()
            difference() {
                union() {
                    translate([- 3, -3, -40])
                        roundedRectX([3, d, 38], 3);

                    // i-beam top/bottom
                    for (z=[0,1])
                        translate([- 6, 0, -5 - z*(35)])
                        cube([5, d - 6, 3]);

                }

                // arm fixings
                for(i=[0:1])
                    attach(LowerArmServoBracket_Con_Fixings[i], DefConUp)
                    cylinder(r=4.3/2, h=100, center=true);

                // hollow for servo fixings
                for (y=[1], z=[0,1])
                    translate([- 4, -34 + 37, -10 - z*(27)]) {
                        translate([0,-1,0])
                            cube([5, 33, 5]);

                        // screw holes
                        for (i=[0:3])
                            translate([4 - 2.5, 3.5 + i*8, 1 -z*7])
                            cylinder(r=2.3/2, h=10, $fn=8);

                        // countersink
                        for (i=[0:3])
                            translate([4 - 2.5, 3.5 + i*8, 7 -z*19])
                            cylinder(r=4/2, h=10, $fn=12);
                    }

                // hollow for servo horns
                translate([-LowerArmWidth/2,0,-41])
                    cylinder(r=22/2 + 0.5, h=100);


                // more weight loss
                for (i=[-1], y=[0,1])
                    translate([0,  i*(-28) + i*y*19, -21])
                    rotate([0,90,0])
                    cylinder(r=16/2, h=100, center=true);			
            }
        }
    }
}