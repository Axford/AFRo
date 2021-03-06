module ShoulderAssembly() {

	h = NEMA_length(NEMA17);

	bod = linear_bearing_od(ShoulderRodBearing);
	bh = linear_bearing_height(ShoulderRodBearing);

	bigod = linear_bearing_od(ShoulderPostBearing);

	assembly("assemblies/Shoulder.scad", "Shoulder", "ShoulderAssembly()") {

        // linear bearing
        translate([0, -TorsoRodSpacing/2, bh/2])
            rotate([0,90,0])
            linear_bearing(ShoulderRodBearing);


        // big lin bearing
        translate([0,0, -linear_bearing_height(LM20UU)/2 + bh])
            rotate([0,90,0])
            linear_bearing(LM20UU);


        // left (x-)
        ShoulderBracketLeft_stl();

        // right (x+)
        ShoulderBracketRight_stl();

        // belt clamp
        translate([20,-40,0])
            mirror([1,0,0])
            ShoulderBeltClamp_stl();


        // sides
        for (i=[0,1])
            mirror([i,0,0])
            translate([ShoulderWidth/2 + 1.5, -UpperArmLength - TorsoRodSpacing/2, bh + 1.5])
            rotate([-90,0,0])
            mirror([1,0,0])
            aluAngle(10,40,250,1.5);


        // elbow stepper
        translate([0, ElbowMotorOffset, bh - dw])
            rotate([0,0,0])
            NEMA(NEMA11);
        *translate([0, 45.5, bh + 1.5])
            rotate([0,0,0])
            NEMA(NEMA17S);

        // drive pulley
        translate([0, 45.5, bh + 27])
            rotate([180,0,0])
            ElbowDrivePulley_stl();

        ElbowMotorPlate_stl();


        // counterweight line bracket
        translate([0,-TorsoRodSpacing/2 - CounterweightIdler_offsetY - 8, bh])
            CounterweightLineBracket_stl();


        // elbow joint and lower arm
        translate([0,-UpperArmLength - TorsoRodSpacing/2, bh-ShoulderHeight]) {

            ElbowJointAssembly();
        }

	}

}


module ElbowJointAssembly() {
	bw = ball_bearing_width(BB608);
	bod = ball_bearing_od(BB608);

	d = bod + 2*tw;

	bw2 = ball_bearing_width(BB624);

	assembly("assemblies/Shoulder.scad", "Elbow Joint", "ElbowJointAssembly()") {

		// stl
		ElbowJoint_stl();

		step(1, "Loosely assemble the driven gear set and push fit into the elbow joint") {

			view(t=[5,19,14], r=[42,53,43],d=1200);

			// driven gear upper assembly
			attach(con([0,0,ShoulderHeight - bw/2], _down), DefConDown, $ExplodeChildren=$Explode)
				ball_bearing(BB608)
				washer(M6_washer)
				washer(M6_washer)
				ElbowDrivenGear_stl()
				washer(M6_washer)
				nut(M6_nut, nyloc=true);

			// threaded rod
			attach(con([0,0,-ShoulderHeight-6], _up), DefConUp, ExplodeSpacing=80, offset=80)
				ThreadedRod(od=6, l=110);
		}

		step (2,"Assemble the pulley set") {
			view(t=[5,19,14], r=[42,53,43],d=1200);

			// driven pulley upper assembly
			attach(con([0,ElbowGearSpacing,ShoulderHeight - bw2/2], _down), DefConDown, $ExplodeChildren=$Explode)
				ball_bearing(BB624)
				washer(M4_washer)
				washer(M6_washer)
				rotate([0,0, 180/ElbowDriveGearTeeth])
				ElbowDrivenPulley_stl()
				washer(M4_washer)
				screw(M4_cap_screw, 50);

			// driven pulley lower assembly
			attach(con([0,ElbowGearSpacing,ShoulderHeight/2 - bw2/2], _up), DefConDown, $ExplodeChildren=$Explode, ExplodeSpacing=20)
				ball_bearing(BB624)
				washer(M4_washer)
				nut(M4_nut, nyloc=true);
		}

		step(3, "Slide the aluminium tube over the threaded rod and push fit the lower bearing") {
			view(t=[-23,20,-53], r=[42,53,43],d=1280);

			// tube
			attach(con([0,0,-40], _up), DefConUp, ExplodeSpacing=90)
				aluTube(8, 6, ShoulderHeight+54);

			// lower bearing
			attach(con([0,0,bw/2-2], _up), DefConUp, ExplodeSpacing=140)
				ball_bearing(BB608);
		}

		step(4,"Connect the lower arm") {
			view(t=[-23,20,-53], r=[42,53,43],d=1280);

			// lower washer
			attach(con([0,0,-3], _up), DefConUp, ExplodeSpacing=50)
				washer(M8_washer);

			attach(con([0,0,-3], _up), DefConUp, ExplodeSpacing=60)
				rotate([0,0,ElbowAngle])
				LowerArmAssembly();

			// bottom nut
			attach(con([0,0,-ShoulderHeight-5], _up), DefConUp, ExplodeSpacing=70)
				nut(M6_nut);


		}

		step(5,"Slip the belt round the pulley - this be connected later") {
			view(t=[-23,20,-53], r=[42,53,43],d=1280);

			// belt
			translate([0,ElbowGearSpacing,ShoulderHeight+15])
				rotate([0,0,90])
				belt(T2p5x6, 0, 0, 12, UpperArmLength + TorsoRodSpacing/2 + 40 - ElbowGearSpacing, 0, 12, gap = 0);
		}


	}

}
