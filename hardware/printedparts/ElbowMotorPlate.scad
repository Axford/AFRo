module ElbowMotorPlate_stl() {
	// origin at post, base of shoulder
	
	bh = linear_bearing_height(ShoulderRodBearing);
	bigod = linear_bearing_od(LM20UU);
	nw = NEMA_width(NEMA11);
	
	sw = ShoulderWidth;
	
	edgeOfBracket = bigod/2 + tw;
	
	d = ElbowMotorOffset;

	d1 = d - edgeOfBracket -  tw;
	
	printedPart("printedparts/ElbowMotorPlate.scad", "Elbow Motor Plate", "ElbowMotorPlate_stl()") {

        view(t=[-1, 2, 3]);

        if (UseSTL) {
            import(str(STLPath, "ElbowMotorPlate.stl"));
        } else {
            difference() {
                union() {

                    // motor plate
                    translate([-sw/2, edgeOfBracket + tw, bh -dw ])
                        roundedRect([sw, d1, dw + 1.5], tw/2);

                    // back rest
                    translate([-sw/2, edgeOfBracket + tw, dw ])
                        roundedRect([sw, tw, bh - dw], tw/2);

                    // mating plate
                    translate([-sw/2, edgeOfBracket + eta, 14 - dw ])
                        rotate([0, 90, 0])
                        trapezoidPrism(14 + tw/2, 14-tw, tw + tw/2, -tw - tw/2, sw);

                    // fillets
                    for (i=[0,1])
                        mirror([i,0,0])
                        translate([sw/2 - dw/2, edgeOfBracket + tw + tw/2, bh - dw])
                        rotate([0, 90, 0])
                        right_triangle(10, 10, dw, center = true);

                    // back rest fillet

                }

                // motor fixings / boss
                translate([0, ElbowMotorOffset, bh+1.5]) {
                    // boss
                    cylinder(r=NEMA_big_hole(NEMA11)+0.3, h=50, center=true);

                    // motor fixings
                    for(a = [0: 90 : 90 * (4 - 1)])
                        rotate([0, 0, a])
                        translate([NEMA_holes(NEMA11)[0], NEMA_holes(NEMA11)[1], 0])
                        cylinder(r=screw_clearance_radius(M3_cap_screw), h=50, center=true);
                }

                // shoulder bracket fixings
                for (i=[0,1])
                    mirror([i,0,0])
                    translate([ShoulderWidth/2 - tw, edgeOfBracket, bh - ShoulderHeight/2 + 2]) {
                        // bore
                        cube([4, 100, 3.3], center=true);

                    }

                // trim for screw heads
                translate([-sw/2-5, edgeOfBracket + tw, 12 - dw - eta ])
                    rotate([0, 90, 0])
                    trapezoidPrism(12 + tw/2, 12-tw, tw + tw/2, -tw - tw/2, sw+10);

                // weight loss
                translate([0,0, 0])
                    scale([0.5,1,1])
                    rotate([90,0, 0])
                    cylinder(r=20, h=100, center=true);

            }
        }
    }
}