module ElbowJoint_stl() {
	bw = ball_bearing_width(BB608);
	bod = ball_bearing_od(BB608);
	
	d = bod + 2*tw;
	
    printedPart("printedparts/ElbowJoint.scad", "Elbow Joint", "ElbowJoint_stl()") {

        view(t=[-1, 2, 3]);

        if (UseSTL) {
            import(str(STLPath, "ElbowJoint.stl"));
        } else {
            difference() {
                union() {
                    translate([-ShoulderWidth/2, 0, -2])
                        cube([ShoulderWidth, d/2, ShoulderHeight+2]);	


                    // nose cap
                    translate([0,0,-2])
                        rotate([0,0,180])
                        sector(r=ShoulderWidth/2+1.5, a=180, h=ShoulderHeight+2+1.5, center = false);
                }

                // bearings
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

                // debug - chop in half
                *translate([0,-50,-10])
                    cube([100,100,100]);
            }
        }
    }
}