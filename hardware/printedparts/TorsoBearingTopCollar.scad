
module TorsoBearingTopCollar_stl() {
	t = dw;
	h = ball_bearing_width(TorsoBearing) + 2*t;
	od = ball_bearing_od(TorsoBearing);
	id = ball_bearing_id(TorsoBearing);
	
    printedPart("printedparts/TorsoBearingTopCollar.scad", "Torso Bearing Top Collar", "TorsoBearingTopCollar_stl()") {

        view(t=[-5, 10, 16]);

        if (UseSTL) {
            import(str(STLPath, "TorsoBearingTopCollar.stl"));
        } else {
            translate([0,0,-t])
            difference() {
                union() {
                    // inner support
                    cylinder(r=id/2, h=h);

                    // cap
                    translate([0,0,h-t])
                        cylinder(r=id/2, h=t);

                    // shelf
                    cylinder(r1=id/2 + dw, r2=id/2, h=dw);

                    // clamp housing
                    *translate([0,-t/2,0])
                        cube([id/2+4, t, t]);

                }

                // post
                translate([0,0,-1])
                    cylinder(r=TorsoPostDia/2 + 0.1, h=h-t+1);

                // fixing bolt hole
                *translate([0,0,t/2])
                    rotate([0,90,0])
                    cylinder(r=3.2/2, h=100);

                // nut trap
                *translate([id/2, 0 ,t/2]) {
                    translate([0,0,0])
                        rotate([0,90,0])
                        rotate([0,0,360/12])
                        cylinder(r=nut_radius(M3_nut), h=nut_thickness(M3_nut)+0.1, center=true, $fn=6);
                    translate([0,0,-5])
                        cube([nut_thickness(M3_nut)+0.2, nut_flat_radius(M3_nut)*2+0.1, 10], center=true);
                }		

            }
        }
    }
}