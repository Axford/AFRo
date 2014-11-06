module ElbowDrivenGear_stl(ExplodeSpacing=10) {
    printedPart("printedparts/ElbowDrivenGear.scad", "Elbow Driven Gear", "ElbowDrivenGear_stl()") {

        view(t=[-1, 2, 3]);

        if (UseSTL) {
            import(str(STLPath, "ElbowDrivenGear.stl"));
        } else {

            difference() {
                // gear
                gear(
                    number_of_teeth=ElbowDrivenGearTeeth,
                    circular_pitch=ElbowGearCircularPitch, diametral_pitch=false,
                    pressure_angle=32,
                    clearance = 0.2,
                    gear_thickness=6,
                    rim_thickness=6,
                    rim_width=5,
                    hub_thickness=6,
                    hub_diameter=10,
                    bore_diameter=4,
                    circles=0,
                    backlash=0,
                    twist=0,
                    involute_facets=0,
                    flat=false);

                // nut trap
                translate([0,0,-1])
                    cylinder(r=nut_radius(M6_nut), h=nut_thickness(M6_nut)+1, $fn=6);
            }
        }
    }

    h = 6;
    // allow for natural threading
    thread(h, ExplodeSpacing=ExplodeSpacing)
        children();
}
