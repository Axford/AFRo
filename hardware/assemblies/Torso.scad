
module TorsoAssembly() {

	h = NEMA_length(NEMA17);
	nw = NEMA_width(NEMA17);

	assembly("assemblies/Torso.scad", "Torso", "TorsoAssembly()") {

        view(t=[-69, -24, 306], r=[80,0,113], d=3215);

        translate([0,0, h + 12])
            TorsoBigGear_stl();

        translate([0,0, h + 12 + TorsoBigGearThickness])
            TorsoBase_stl();


        // big ol bearing - bottom
        translate([0,0,h]) {
            translate([0,0,ball_bearing_width(TorsoBearing)/2 + tw])
                ball_bearing(TorsoBearing);


            TorsoBearingCollar_stl();
        }


        // big ol bearing - top, etc
        translate([0,0, PostLength-15]) {
            translate([0,0,ball_bearing_width(TorsoBearing)/2])
                ball_bearing(TorsoBearing);


            TorsoBearingTopCollar_stl();

            translate([0,0, 0])
                TorsoCap_stl();

            translate([0, -h/2, TorsoStepperZOffset])
                rotate([90,0,0])
            // alternate position
            //translate([0, -2*h/2 - 10, TorsoStepperZOffset])
            //	rotate([-90,0,0])
            {
                    rotate([0,0,180])
                        NEMA(NEMA17);

                    translate([0,0,5])
                        metal_pulley(T2p5x18_metal_pulley);

                }

            // belt
            translate([0, -h/2 - 17, TorsoStepperZOffset])
                rotate([0,90,90])
                belt(T2p5x6, 0, 0, 8, PostLength-68, 0, 8, gap = 0);

            // end stop
            *translate([0,0,-20])
                TorsoEndStopAssembly();
        }


        // vertical smooth rods and counterweight idlers
        for (i=[0,1])
            mirror([0,i,0])
            translate([0, TorsoRodSpacing/2, h + 30]) {
                color(alu_color)
                    cylinder(r=TorsoRodDia/2, h=TorsoRodLength);

                translate([0,0, TorsoRodLength])
                    CounterweightIdlerAssembly();
            }


        // shoulder
        translate([0,0,h+60 + ShoulderPosition])
            ShoulderAssembly();

        // counterweight line
        color("red") {

            // top
            translate([0,0, h + 30 + TorsoRodLength + dw + 2perim + 1])
                rotate([90,0,0])
                cylinder(r=1, h=TorsoRodSpacing + 2*CounterweightIdler_offsetY, center=true);

            // to arm
            translate([0, -TorsoRodSpacing/2 - CounterweightIdler_offsetY - 8, h + 30 + ShoulderPosition + 40])
                cylinder(r=1, h=TorsoRodLength-5 - ShoulderPosition - 40);

            // to counterweight
            translate([0, TorsoRodSpacing/2 + CounterweightIdler_offsetY + 8, h + 30 + TorsoRodLength - ShoulderPosition - 100])
                cylinder(r=1, h=ShoulderPosition + 100);
        }

        // counterweight
        translate([0, TorsoRodSpacing/2, h+30 + TorsoRodLength - 100 - ShoulderPosition])
            CounterweightAssembly();


        // idler
        // bearing axle
        translate([0, -h/2 - 30, h+44])
            rotate([90,0,0])
                threadTogether([
                    washer_thickness(M4_washer),
                    dw + 2.8 + washer_thickness(M5_penny_washer),
                    washer_thickness(M4_washer),
                    ball_bearing_width(BB624)/2,
                    ball_bearing_width(BB624),
                    ball_bearing_width(BB624)/2 + washer_thickness(M4_washer),
                    washer_thickness(M5_penny_washer),
                    2.8 + dw + washer_thickness(M4_washer),
                    0
                ]) {
                    screw(M4_hex_screw,30);
                    washer(M4_washer);
                    washer(M5_penny_washer);
                    washer(M4_washer);
                    ball_bearing(BB624);
                    ball_bearing(BB624);
                    washer(M4_washer);
                    washer(M5_penny_washer);
                    washer(M4_washer);
                    rotate([180,0,0]) nut(M4_nut,nyloc=true);
                }



        // cable guide, at same height as TorsoBase
        translate([0,0, h + 12 + TorsoBigGearThickness])
            CableGuideAssembly();

	}

}


module TorsoDriveAssembly() {

    assembly("assemblies/Torso.scad", "Torso Drive", "TorsoDriveAssembly()") {

        translate([0,0,NEMA_length(NEMA17)]) {
            rotate([0,0,90])
            NEMA(NEMA17);

            // drive gear
            translate([0,0,3])
                //rotate([0,0,360/15/2])
                TorsoDriveGear_stl();
        }

	}
}


module CounterweightIdlerAssembly() {
	bw = ball_bearing_width(BB624);
    slotw = bw + 2*washer_thickness(M4_washer) + 1;  // room for small washers and some clamping pressure
    w = slotw + 2*dw;

    assembly("assemblies/Torso.scad", "Counterweight Idler", "CounterweightIdlerAssembly()") {

        CounterweightIdler_stl();

        // bearing, guide and fixings
        translate([0, CounterweightIdler_offsetY, CounterweightIdler_offsetZ])
            rotate([0,90,0]) {
                ball_bearing(BB624);

                CounterweightIdlerGuide_stl();

                // washers
                for (i=[0,1])
                    mirror([0,0,i])
                    translate([0,0,bw/2+ washer_thickness(M4_washer)/2 - 0.5])
                    washer(M4_washer);

                // bolt
                translate([0,0,w/2])
                    screw_and_washer(M4_cap_screw, 20);

                // washer and nut
                translate([0,0,-w/2])
                    mirror([0,0,1])
                    nut_and_washer(M4_nut, nyloc=true);
            }


	}
}


module CounterweightAssembly() {

	// origin is on smooth rod, at top of counterweight assembly

	// weight dimensions
	ww = CounterweightWidth;
	wd = CounterweightDepth;
	wh = CounterweightHeight;

	oy = 10;  // offset of weights in y

    assembly("assemblies/Torso.scad", "Counterweight", "CounterweightAssembly()") {

        CounterweightBracket_stl();

        // weight blocks
        color(alu_color)
            translate([-ww/2, oy, -wh-dw])
            cube([ww, wd, wh]);

	}
}



module TorsoEndStopAssembly() {

	mcon = [[-1.5*dw, -EndStopOffsetY - microswitch2_fixingCentres, tw/2],[-1,0,0], 90];

	assembly("assemblies/Torso.scad", "Torso EndStop", "TorsoEndStopAssembly()") {

        TorsoEndStopBracket_stl();

        attach(mcon, microswitch2_connectors[0])
            microswitch2();

	}
}
