module ElbowJoint2_stl() {
	sw = dynamixel_width(DYNAMIXELAX12);
	iw = sw - 2*8.5;
	d = 13;
	
	printedPart("printedparts/ElbowJoint2.scad", "Elbow Joint 2", "ElbowJoint2_stl()") {

        view(t=[-1, 2, 3]);

        if (UseSTL) {
            import(str(STLPath, "ElbowJoint2.stl"));
        } else {
            translate([0,0,-ShoulderHeight-1.5])
            difference() {
                union() {
                    translate([-sw/2, -d, 0])
                        cube([sw, d+eta, ShoulderHeight]);	


                    // inner bulge for washer plate
                    translate([-iw/2, -d, 0])
                        cube([iw, d+eta, ShoulderHeight+1.5]);

                    // tail cap
                    translate([0,0,0])
                        sector(r=sw/2+1.5, a=180, h=ShoulderHeight+1.5, center = false);

                    // cable guide
                    for (i=[-1,1])
                        translate([i* (5 + tw/2), -d - 9 + tw/2, 0])
                        roundedRect([tw, 9, 8], tw/2);

                    // cosmetic cover panel

                    translate([0, -d+eta, ShoulderHeight + 1.5 - dw])
                        rotate([0,90,180])
                        right_triangle(6, 6, iw);	

                }

                // hollow for axle 
                translate([0,0,nut_thickness(M6_nut)+3*layers])
                    cylinder(r=8/2, h=ShoulderHeight+10);

                // fixings
                for(i=[0,1])
                    translate([0, -sw/4, ShoulderHeight/2 - 8 + i*16])
                    rotate([0,90,0])
                    cylinder(r=4.3/2, h=100, center=true);


                // nut trap
                translate([0,0,-eta])
                    cylinder(r=nut_radius(M6_nut), h=nut_thickness(M6_nut), $fn=6);


                // cable-tie holes
                translate([0, -d - 3, 4])
                    rotate([0, 90, 0])
                    cylinder(r=4/2, h=100, center=true);


                // debug - chop in half
                *translate([0,-50,-10])
                    cube([100,100,100]);
            }
        }
    }
}