module ElbowDrivenPulley_stl(ExplodeSpacing=10) {
    printedPart("printedparts/ElbowDrivenPulley.scad", "Elbow Driven Pulley", "ElbowDrivenPulley_stl()") {

        view(t=[-1, 2, 3]);

        if (UseSTL) {
            import(str(STLPath, "ElbowDrivenPulley.stl"));
        } else {

            union() {
                pulley(
                    teeth = 34,			// Number of teeth, standard Mendel T5 belt = 8, gives Outside Diameter of 11.88mm
                    belt_type = "T2.5",	// supported types: MXL 40DP XL H T2.5 T5 T10 AT5 HTD_3mm HTD_5mm HTD_8mm GT2_2mm GT2_3mm GT2_5mm
                    motor_shaft = 6.2,	// NEMA17 motor shaft exact diameter = 5
                    m3_dia = 0,		// 3mm hole diameter
                    m3_nut_hex = 1,		// 1 for hex, 0 for square nut
                    m3_nut_flats = 0,	// normal M3 hex nut exact width = 5.5
                    m3_nut_depth = 0,	// normal M3 hex nut exact depth = 2.4, nyloc = 4
                    retainer = 1,		// Belt retainer above teeth, 0 = No, 1 = Yes
                    retainer_ht = 1.5,	// height of retainer flange over pulley, standard = 1.5
                    idler = 1,			// Belt retainer below teeth, 0 = No, 1 = Yes
                    idler_ht = 1.5,		// height of idler flange over pulley, standard = 1.5
                    pulley_t_ht = 8,	// length of toothed part of pulley, standard = 12
                    pulley_b_ht = 9,	// pulley base height, standard = 8. Set to same as idler_ht if you want an idler but no pulley.
                    pulley_b_dia = 12,	// pulley base diameter, standard = 20
                    no_of_nuts = 1,		// number of captive nuts required, standard = 1
                    nut_angle = 90,		// angle between nuts, standard = 90
                    nut_shaft_distance = 2.2,	// distance between inner face of nut and shaft, can be negative.
                    additional_tooth_width = 0.2, // scaling for good fit
                    additional_tooth_depth = 0 //mm
                );

                // gear
                gear(
                    number_of_teeth=ElbowDriveGearTeeth,
                    circular_pitch=ElbowGearCircularPitch, diametral_pitch=false,
                    pressure_angle=32,
                    clearance = 0.2,
                    gear_thickness=8,
                    rim_thickness=8,
                    rim_width=5,
                    hub_thickness=8,
                    hub_diameter=10,
                    bore_diameter=4,
                    circles=0,
                    backlash=0,
                    twist=0,
                    involute_facets=0,
                    flat=false);
            }
        }
    }

    h = 8 + 9 + 1.5;
    // allow for natural threading
    thread(h, ExplodeSpacing=ExplodeSpacing)
        children();
}
