module ElbowDrivenGear_stl(ExplodeSpacing=10) {
    printedPart("printedparts/ElbowDrivenGear.scad", "Elbow Driven Gear", "ElbowDrivenGear_stl()") {

        view(t=[-1, 2, 3]);

        if (UseSTL) {
            import(str(STLPath, "ElbowDrivenGear.stl"));
        } else {

            difference() {
                union() {
                    // gear
                    gear(
                        number_of_teeth=ElbowDrivenGearTeeth,
                        circular_pitch=ElbowGearCircularPitch, diametral_pitch=false,
                        pressure_angle=32,
                        clearance = 0.5,
                        gear_thickness=6,
                        rim_thickness=6,
                        rim_width=5,
                        hub_thickness=6,
                        hub_diameter=10,
                        bore_diameter=8,
                        circles=0,
                        backlash=0,
                        twist=0,
                        involute_facets=0,
                        flat=false);

                    // hub
                    cylinder(r=9.5, h=12);
                }


                // bore
                cylinder(r=8/2, h=100, center=true);


                // nut trap
                translate([0,-4-1.5,6+3]) {
                    rotate([90,0,0])
                        rotate([0,0,360/12])
                        cylinder(r=nut_radius(M3_nut)+0.1/2, h=nut_thickness(M3_nut)+0.2, center=true, $fn=6);

                    translate([0,0,5+3/2])
                        cube([nut_flat_radius(M3_nut)*2+0.1, nut_thickness(M3_nut)+0.2, 10], center=true);
                }

                // hole for grub screw
                translate([0,0,6 + 3])
                    rotate([90,0,0])
                    cylinder(r=3/2, h=100);

            }
        }
    }

    h = 12;
    // allow for natural threading
    thread(h, ExplodeSpacing=ExplodeSpacing)
        children();
}
