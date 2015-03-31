module WristBracket_stl() {
	// x+ side
	// origin is aligned with top of shoulder servo horn at joint origin
	
	sw = dynamixel_width(DYNAMIXELAX12)-6; 
	w = dynamixel_height(DYNAMIXELAX12);
	h = tw;
	d = dynamixel_width(DYNAMIXELAX12);
	
    printedPart("printedparts/WristBracket.scad", "Wrist Bracket", "WristBracket_stl()") {

        view(t=[-1, 2, 3]);

        if (UseSTL) {
            import(str(STLPath, "WristBracket.stl"));
        } else {
            render()
            difference() {
                union() {
                    hull() {
                        translate([0,0,-h])
                            cylinder(r=12, h=h);

                        translate([-w/2, -d/2, -h])
                            roundedRect([w, d, h], 2);

                    }

                    // i-beam top/bottom
                    for (i=[0,1])
                        translate([-w/2 + i*(w-3), -d/2+3, -h-5+eta + 0.2])
                        cube([3, d-6, 7]);

                }


                // hollow for horn fixings
                for (i=[0:3])
                        translate([0, 0, 0])
                        rotate([0,0,i*90])
                        translate([0,16/2, 0]) {
                            // through hole
                            translate([0,0,0])
                                cylinder(r=2.3/2, h=100, center=true);

                            // CS
                            translate([0,0, -h-eta])
                                cylinder(r=5/2, h=tw/2);
                        }


                // hollow for servo side fixings
                for (y=[0,1], x=[0,1])	
                    mirror([x,0,0])
                    mirror([0,y,0])
                    translate([0, 0, -h-2.5]) {
                        translate([w/2-3-5, 25.5/2-8, 0])
                            cube([5, 8, 20]);

                        translate([w/2-3-5, -25.5/2, 2.5-eta])
                            cube([5, 22.5, 1]);

                        // screw holes
                        translate([ w/2-5, 8, 4 - 2.5])
                            rotate([0,90,0])
                            cylinder(r=2.3/2, h=10, $fn=8);

                        // countersink
                        translate([w/2-1, 8, 4 - 2.5])
                            rotate([0,90,0])
                            cylinder(r=4/2, h=10, $fn=12);
                    }

                // central hole for horn fixing
                cylinder(r=6/2, h=100, center=true);

            }
        }
    }
}