module TorsoDriveGear_stl() {
	printedPart("printedparts/TorsoDriveGear.scad", "Torso Drive Gear", "TorsoDriveGear_stl()") {

        view(t=[-1, 2, 3]);

        if (UseSTL) {
            import(str(STLPath, "TorsoDriveGear.stl"));
        } else {
            difference() {

                translate([0,0, 20])
                    mirror([0,0,1])
                    gear (
                        number_of_teeth=TorsoDriveGearTeeth,
                        circular_pitch=Torso_gears_circular_pitch, diametral_pitch=false,
                        pressure_angle=32,
                        clearance = 0.2,
                        gear_thickness=10,
                        rim_thickness=10,
                        rim_width=5,
                        hub_thickness=20,
                        hub_diameter=20,
                        bore_diameter=5,
                        circles=0,
                        backlash=0,
                        twist=0,
                        involute_facets=0,
                        flat=false);

                // motor shaft
                cylinder(r=5/2, h=100, center=true);

                // fixing bolt hole
                translate([0,0,5])
                    rotate([90,0,0])
                    cylinder(r=3.2/2, h=50);

                // nut trap
                translate([0,-5 ,5]) {
                    translate([0,0,0])
                        rotate([90,0,0])
                        rotate([0,0,360/12])
                        cylinder(r=nut_radius(M3_nut), h=nut_thickness(M3_nut)+0.1, center=true, $fn=6);
                    translate([0,0,-5])
                        cube([nut_flat_radius(M3_nut)*2+0.1, nut_thickness(M3_nut)+0.2, 10], center=true);
                }			
            }
        }
    }
}