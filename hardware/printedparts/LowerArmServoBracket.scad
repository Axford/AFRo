module LowerArmServoBracket_stl() {
	// x+ side
	// origin is aligned with top of shoulder servo horn at joint origin
	
	$fn=24;
	
	sparLen = LowerArmLength * 0.68;
	d = 50;
	fixingSpacing = 2*(sparLen - LowerArmLength/2) - 20;
	
    printedPart("printedparts/LowerArmServoBracket.scad", "Lower Arm Servo Bracket", "LowerArmServoBracket_stl()") {

        view(t=[-94, -69, -60], r=[74, 0, 45], d=632);

        if (UseSTL) {
            import(str(STLPath, "LowerArmServoBracket.stl"));
        } else {
            //render()
            difference() {
                union() {
                    translate([LowerArmWidth/2 - 3, -LowerArmLength-3, -40])
                        roundedRectX([3, d, 38], 3);

                    // i-beam top/bottom
                    for (z=[0,1])
                        translate([LowerArmWidth/2 - 6, -LowerArmLength, -5 - z*(35)])
                        cube([5, d - 6, 3]);

                }

                // arm fixings
                for(i=[-1,1])
                    translate([0, -LowerArmLength + d - 2*tw, -1.5-ShoulderHeight/2 + i*10])
                    rotate([0,90,0])
                    cylinder(r=4.3/2, h=100, center=true);

                // hollow for servo fixings
                for (y=[1], z=[0,1])
                    translate([LowerArmWidth/2 - 4, -34 - y*(LowerArmLength-37), -10 - z*(27)]) {
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
                translate([0,-LowerArmLength,-41])
                    cylinder(r=22/2 + 0.5, h=100);


                // more weight loss
                for (i=[-1], y=[0,1])
                    translate([0, -LowerArmLength/2  + i*(LowerArmLength/2-28) + i*y*19, -21])
                    rotate([0,90,0])
                    cylinder(r=16/2, h=100, center=true);			
            }
        }
    }
}