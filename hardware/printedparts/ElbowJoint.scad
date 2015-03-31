module ElbowJoint_stl() {
	bw = ball_bearing_width(BB608);
	bod = ball_bearing_od(BB608);

	bw2 = ball_bearing_width(BB624);
	bod2 = ball_bearing_od(BB624);

	d = bod + 2*tw;

    printedPart("printedparts/ElbowJoint.scad", "Elbow Joint", "ElbowJoint_stl()") {

        view(t=[-1, 2, 3], d=600);

        if (UseSTL) {
            import(str(STLPath, "ElbowJoint.stl"));
        } else {
            difference() {
                union() {
					// body
                    hull() {
						translate([-ShoulderWidth/2, 0, -2])
							cube([ShoulderWidth, d/2, ShoulderHeight+2]);

						// casing for driven pulley bearings
						translate([0, ElbowGearSpacing ,ShoulderHeight/2])
							cylinder(r=bod2/2+tw, h=ShoulderHeight/2, $fn=32);
					}

                    // nose cap
                    translate([0,0,-2])
                        rotate([0,0,180])
                        sector(r=ShoulderWidth/2+1.5, a=180, h=ShoulderHeight+2+1.5, center = false);

                }

                // driven gear bearings
                translate([0,0,ShoulderHeight-bw])
                    cylinder(r=bod/2+0.1, h=bw+10);
                translate([0,0,-3])
                    cylinder(r=bod/2+0.1, h=bw+1);

                // bevel lower bearing void for printability
                translate([0,0, bw-2])
                    cylinder(r1=bod/2+0.1, r2=bod/2-dw, h=dw);

                // inner void
                translate([0,0,-1])
                    cylinder(r=bod/2-dw, h=ShoulderHeight+2);

                // fixings
                for(i=[0,1])
                    translate([0, bod/2, ShoulderHeight/2 - 8 + i*16])
                    rotate([0,90,0])
                    cylinder(r=4.3/2, h=100, center=true);


				// driven pulley bearings
				translate([0,ElbowGearSpacing,ShoulderHeight-bw2])
					cylinder(r=bod2/2+0.2, h=bw+10);
				translate([0,ElbowGearSpacing,-1])
					cylinder(r1=bod2/2+2,r2=bod2/2+0.2, h=ShoulderHeight/2+1);

				// inner void
				translate([0,ElbowGearSpacing,-1])
					cylinder(r=bod2/2-dw/2, h=ShoulderHeight+2);

				// bevel lower bearing void for printability
				translate([0, ElbowGearSpacing, ShoulderHeight/2 -eta ])
					cylinder(r1=bod2/2+0.2, r2=bod2/2-dw, h=dw);

                // debug - chop in half
                *translate([0,-50,-10])
                    cube([100,100,100]);
            }
        }
    }
}
