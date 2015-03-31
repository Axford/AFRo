module TorsoBigGear_stl() {
	bod = ball_bearing_od(TorsoBearing);
	bh =  ball_bearing_width(TorsoBearing);

	t = 8;

    printedPart("printedparts/TorsoBigGear.scad", "Torso Big Gear", "TorsoBigGear_stl()") {

        view(t=[-1, 2, 3]);

        if (UseSTL) {
            import(str(STLPath, "TorsoBigGear.stl"));
        } else {
            difference() {
                union() {
                    gear(
                        number_of_teeth=TorsoBigGearTeeth,
                        circular_pitch=Torso_gears_circular_pitch, diametral_pitch=false,
                        pressure_angle=32,
                        clearance = 0.2,
                        gear_thickness=TorsoBigGearThickness,
                        rim_thickness=TorsoBigGearThickness,
                        rim_width=5,
                        hub_thickness=20,
                        hub_diameter=20,
                        bore_diameter=5,
                        circles=0,
                        backlash=0,
                        twist=0,
                        involute_facets=0,
                        flat=false);


                    // bearing collar
                    tube(bod/2 + dw, bod/2, bh);


                }

                // hollow for post
                cylinder(r=25/2 + 7, h=100, center=true);

                // bearing recess
                translate([0,0,-bh/2-1])
                    cylinder(r=bod/2+0.1, h=bh + 1);

                // fixings for base
                for (i=[0,1])
                    mirror([i,0,0])
                    translate([bod/2 + 2, 0, 0])
                    cylinder(r=2.5/2, h=100);

            }
        }
    }
}