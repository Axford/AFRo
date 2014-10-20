ShoulderWidth = 36;  // space between alu channel sides
ShoulderHeight = 40-1.5;  // vertical space "inside" channel sides


module ShoulderAssembly() {
	
	h = NEMA_length(NEMA17);
	
	bod = linear_bearing_od(ShoulderRodBearing);
	bh = linear_bearing_height(ShoulderRodBearing);
	
	bigod = linear_bearing_od(ShoulderPostBearing);
	
	assembly("Shoulder");
	

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
	
		translate([0,0,-3]) 
			rotate([0,0,ElbowAngle])
			LowerArmAssembly();
	}
	
	end("Shoulder");
	
}


module ShoulderBracketLeft_stl() {

	bod = linear_bearing_od(ShoulderRodBearing);
	bh = linear_bearing_height(ShoulderRodBearing);
	
	bigod = linear_bearing_od(LM20UU);
	
	l = 15 + TorsoRodSpacing/2 + 50;
	
	t=8;

	// big bearing clamp
	difference() {
		union() {
		
			// front fixings
			for (i=[0,1])
				translate([
					-ShoulderWidth/2, 
					-TorsoRodSpacing/2 - bod/2 - 2*tw, 
					bh - 2*tw - i*(ShoulderHeight-4*tw)])
				roundedRectX([ShoulderWidth/2-1, 2*tw, 2*tw],tw/4);
				
			// small bearing casing
			translate([
					-ShoulderWidth/2, 
					-TorsoRodSpacing/2 - (bod+2*tw)/2, 
					0])
				roundedRectX([ShoulderWidth/2-1, bod+2*tw, bh],tw/4);
				
			// mid fixings
			for (i=[0,1])
				translate([
					-ShoulderWidth/2, 
					-bigod/2 - 2*tw, 
					bh - 2*tw - i*(ShoulderHeight-4*tw)])
				roundedRectX([ShoulderWidth/2-1, 2*tw, 2*tw],tw/4);
			
			// big bearing casing
			translate([
					-ShoulderWidth/2, 
					- (bigod+2*tw)/2, 
					bh-ShoulderHeight])
				roundedRectX([ShoulderWidth/2-1, bigod+2*tw, ShoulderHeight],tw/4);
			
			// back fixings
			for (i=[0,1])
				translate([
					-ShoulderWidth/2, 
					bigod/2, 
					bh - 2*tw - i*(ShoulderHeight-4*tw)])
				roundedRectX([ShoulderWidth/2-1, 2*tw, 2*tw],tw/4);
			
			
			// outer frame
			translate([-ShoulderWidth/2, -TorsoRodSpacing/2 - bod/2 - tw, bh-ShoulderHeight+3*tw])
				roundedRectX([tw, bigod/2 + TorsoRodSpacing/2 + bod/2, ShoulderHeight- 4*tw], tw, center=false, shell=tw);
			
			*translate([-ShoulderWidth/2, -TorsoRodSpacing/2 - 15, bh - ShoulderHeight])
				cube([ShoulderWidth/2-1, l, ShoulderHeight],3);
		}
		
		
		// hollow for little bearing
		translate([0,-TorsoRodSpacing/2,0])
			cylinder(r=bod/2, h=200, center=true);
		
		// hollow for big bearing
		cylinder(r=bigod/2, h=200, center=true);
		
		//weight loss
		translate([0, 0, bh-ShoulderHeight/2])
			rotate([0,90,0])
			cylinder(r=bigod/2-1, h=100, center=true);
			
		translate([0, -TorsoRodSpacing/2, bh/2])
			rotate([0,90,0])
			cylinder(r=bod/2-1, h=100, center=true);
		
		
		// back fixings
		for (i=[0,1])
			translate([0, bigod/2 + tw, bh - tw - i*(ShoulderHeight-4*tw)])
			rotate([0,90,0])
			cylinder(r=4.3/2, h=100, center=true);
		
		// mid fixings
		for (i=[0,1])
			translate([0, -bigod/2 - tw, bh - tw - i*(ShoulderHeight-4*tw)])
			rotate([0,90,0])
			cylinder(r=4.3/2, h=100, center=true);
		
		// front fixings
		for (i=[0,1])
			translate([0, -TorsoRodSpacing/2 - bod/2 - tw, bh - tw - i*(ShoulderHeight-4*tw)])
			rotate([0,90,0])
			cylinder(r=4.3/2, h=100, center=true);
			
		// motor plate fixing
		translate([-ShoulderWidth/2 + tw, bigod/2 + tw+1, bh - ShoulderHeight/2 + 2])
			rotate([90,0,0])
			cylinder(r=2.6/2, h=12);
		
	}	


}


module ShoulderBracketRight_stl() {

	bod = linear_bearing_od(ShoulderRodBearing);
	bh = linear_bearing_height(ShoulderRodBearing);
	
	bigod = linear_bearing_od(LM20UU);
	
	l = 15 + TorsoRodSpacing/2 + 50;
	
	t=8;

	// big bearing clamp
	difference() {
		union() {
		
			// front fixings
			for (i=[0,1])
				translate([
					1, 
					-TorsoRodSpacing/2 - bod/2 - 2*tw, 
					bh - 2*tw - i*(ShoulderHeight-4*tw)])
				roundedRectX([ShoulderWidth/2-1, 2*tw, 2*tw],tw/4);
				
			// small bearing casing
			translate([
					1, 
					-TorsoRodSpacing/2 - (bod+2*tw)/2, 
					0])
				roundedRectX([ShoulderWidth/2-1, bod+2*tw, bh],tw/4);
				
			// belt clamp base
			translate([
					ShoulderWidth/2- 8.5, 
					-40- 5- 2*tw, 
					bh - 4*tw])
				roundedRectX([8.5, 10 + 4*tw, 4*tw],tw);
				
			// belt clamp web
			translate([
					ShoulderWidth/2- tw, 
					-40- tw/2, 
					0])
				roundedRectX([tw, tw, bh],tw/2);
				
				
			// mid fixings
			for (i=[0,1])
				translate([
					1, 
					-bigod/2 - 2*tw, 
					bh - 2*tw - i*(ShoulderHeight-4*tw)])
				roundedRectX([ShoulderWidth/2-1, 2*tw, 2*tw],tw/4);
			
			// big bearing casing
			translate([
					1, 
					- (bigod+2*tw)/2, 
					bh-ShoulderHeight])
				roundedRectX([ShoulderWidth/2-1, bigod+2*tw, ShoulderHeight],tw/4);
			
			// back fixings
			for (i=[0,1])
				translate([
					1, 
					bigod/2, 
					bh - 2*tw - i*(ShoulderHeight-4*tw)])
				roundedRectX([ShoulderWidth/2-1, 2*tw, 2*tw],tw/4);
			
			
			// outer frame
			translate([ShoulderWidth/2 - tw, -TorsoRodSpacing/2 - bod/2 - tw, bh-ShoulderHeight+3*tw])
				roundedRectX([tw, bigod/2 + TorsoRodSpacing/2 + bod/2, ShoulderHeight- 4*tw], tw, center=false, shell=tw);
		}
		
		
		// hollow for little bearing
		translate([0,-TorsoRodSpacing/2,0])
			cylinder(r=bod/2, h=200, center=true);
		
		// hollow for big bearing
		cylinder(r=bigod/2, h=200, center=true);
		
		//weight loss
		translate([0, 0, bh-ShoulderHeight/2])
			rotate([0,90,0])
			cylinder(r=bigod/2-1, h=100, center=true);
			
		translate([0, -TorsoRodSpacing/2, bh/2])
			rotate([0,90,0])
			cylinder(r=bod/2-1, h=100, center=true);
		
		
		// back fixings
		for (i=[0,1])
			translate([0, bigod/2 + tw, bh - tw - i*(ShoulderHeight-4*tw)])
			rotate([0,90,0])
			cylinder(r=4.3/2, h=100, center=true);
		
		// mid fixings
		for (i=[0,1])
			translate([0, -bigod/2 - tw, bh - tw - i*(ShoulderHeight-4*tw)])
			rotate([0,90,0])
			cylinder(r=4.3/2, h=100, center=true);
		
		// front fixings
		for (i=[0,1])
			translate([0, -TorsoRodSpacing/2 - bod/2 - tw, bh - tw - i*(ShoulderHeight-4*tw)])
			rotate([0,90,0])
			cylinder(r=4.3/2, h=100, center=true);
			
		// motor plate fixing
		translate([ShoulderWidth/2 - tw, bigod/2 + tw+1, bh - ShoulderHeight/2 + 2])
			rotate([90,0,0])
			cylinder(r=2.6/2, h=12);
		
		// belt clamp fixings
		for(i=[-1,1])
			translate([
					ShoulderWidth/2- 8.5, 
					-40 + i*(5+tw), 
					bh - 2*tw])
				rotate([0,90,0])
				cylinder(r=2.6/2, h=100, center=true);
		
	}	

}


module ShoulderBeltClamp_stl() {
	bod = linear_bearing_od(ShoulderRodBearing);
	bh = linear_bearing_height(ShoulderRodBearing);
	
	bigod = linear_bearing_od(LM20UU);
	
	l = 15 + TorsoRodSpacing/2 + 50;
	
	t=8;

	difference() {
		union() {
		
			// belt clamp base
			translate([
					ShoulderWidth/2- tw - 2.5, 
					-5- 2*tw, 
					bh - 4*tw])
				roundedRectX([tw + 2.5, 10 + 4*tw, 4*tw],tw);
		}
		
		//hollow for belts
		translate([ShoulderWidth/2 - tw - 2.5 - 1, -5, -50])
			cube([2.2+1, 10, 100]);
		
		// belt clamp fixings
		for(i=[-1,1])
			translate([
					ShoulderWidth/2- 8.5, 
					i*(5+tw), 
					bh - 2*tw])
				rotate([0,90,0])
				cylinder(r=3.5/2, h=100, center=true);
		
	}	
}

module ElbowJointAssembly() {
	bw = ball_bearing_width(BB608);
	bod = ball_bearing_od(BB608);
	
	d = bod + 2*tw;

	assembly("ElbowJoint");
	
	// pulley lock nut
	translate([0,0,ShoulderHeight+21])
		nut(M6_nut, nyloc=true);
	
	// pulley washer
	translate([0,0,ShoulderHeight+19])
		washer(M8_washer);
	
	// pulley
	translate([0,0,ShoulderHeight+2])
		ElbowDrivenPulley_stl();
		
	// belt
	translate([0,0,ShoulderHeight+14])
		rotate([0,0,90])
		belt(T2p5x6, 0, 0, 12, UpperArmLength + TorsoRodSpacing/2 + 46, 0, 12, gap = 0);
	
	// top nut
	translate([0,0,ShoulderHeight+2])
		nut(M6_nut);
	
	// upper washer
	translate([0,0,ShoulderHeight])
		washer(M8_washer);
	
	// upper bearing
	translate([0,0, ShoulderHeight-bw/2])
		ball_bearing(BB608);
	
	// tube
	translate([0,0,-40])
		color(alu_color)
		tube(8/2, 8/2-1, ShoulderHeight+40, center=false);
	
	// threaded rod
	translate([0,0,-ShoulderHeight-6])
		cylinder(r=6/2, h=115);
	
	// lower bearing
	translate([0,0,bw/2-2])
		ball_bearing(BB608);
		
	// lower washer
	translate([0,0,-3])
		washer(M8_washer);
		
	// bottom nut
	translate([0,0,-ShoulderHeight-5])
		nut(M6_nut);
		
		
	// stl
	ElbowJoint_stl();
	
	
	end("ElbowJoint");
	
}


module ElbowJoint_stl() {
	bw = ball_bearing_width(BB608);
	bod = ball_bearing_od(BB608);
	
	d = bod + 2*tw;
	
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


module ElbowMotorPlate_stl() {
	// origin at post, base of shoulder
	
	bh = linear_bearing_height(ShoulderRodBearing);
	bigod = linear_bearing_od(LM20UU);
	nw = NEMA_width(NEMA11);
	
	sw = ShoulderWidth;
	
	edgeOfBracket = bigod/2 + tw;
	
	d = ElbowMotorOffset;

	d1 = d - edgeOfBracket -  tw;
	
	
	render()
	difference() {
		union() {
			
			// motor plate
			translate([-sw/2, edgeOfBracket + tw, bh -dw ])
				roundedRect([sw, d1, dw + 1.5], tw/2);
				
			// back rest
			translate([-sw/2, edgeOfBracket + tw, dw ])
				roundedRect([sw, tw, bh - dw], tw/2);
			
			// mating plate
			translate([-sw/2, edgeOfBracket + eta, 14 - dw ])
				rotate([0, 90, 0])
				trapezoidPrism(14 + tw/2, 14-tw, tw + tw/2, -tw - tw/2, sw);
				
			// fillets
			for (i=[0,1])
				mirror([i,0,0])
				translate([sw/2 - dw/2, edgeOfBracket + tw + tw/2, bh - dw])
				rotate([0, 90, 0])
				right_triangle(10, 10, dw, center = true);
				
			// back rest fillet
			
		}
		
		// motor fixings / boss
		translate([0, ElbowMotorOffset, bh+1.5]) {
			// boss
			cylinder(r=NEMA_big_hole(NEMA11)+0.3, h=50, center=true);
	
			// motor fixings
			for(a = [0: 90 : 90 * (4 - 1)])
				rotate([0, 0, a])
				translate([NEMA_holes(NEMA11)[0], NEMA_holes(NEMA11)[1], 0])
				cylinder(r=screw_clearance_radius(M3_cap_screw), h=50, center=true);
		}
		
		// shoulder bracket fixings
		for (i=[0,1])
			mirror([i,0,0])
			translate([ShoulderWidth/2 - tw, edgeOfBracket, bh - ShoulderHeight/2 + 2]) {
				// bore
				cube([4, 100, 3.3], center=true);
				
			}
			
		// trim for screw heads
		translate([-sw/2-5, edgeOfBracket + tw, 12 - dw - eta ])
			rotate([0, 90, 0])
			trapezoidPrism(12 + tw/2, 12-tw, tw + tw/2, -tw - tw/2, sw+10);
			
		// weight loss
		translate([0,0, 0])
			scale([0.5,1,1])
			rotate([90,0, 0])
			cylinder(r=20, h=100, center=true);
		
	}

}


module ElbowMotorPlate_stl_old() {
	// origin at post, base of shoulder
	
	bh = linear_bearing_height(ShoulderRodBearing);
	bigod = linear_bearing_od(LM20UU);
	nw = NEMA_width(NEMA17S);
	d = 45.5;
	
	render()
	difference() {
		union() {
			hull() {
				// motor fixings
				translate([-nw/2, 45.5 - nw/2, bh + 1.5])
					roundedRect([nw, 12, tw], tw);
					
				// arm fixings
				translate([ShoulderWidth/2 + 2.5, bigod/2 + tw - 6, bh+1.5])
					roundedRect([tw, 12, tw],tw/2);
				translate([-ShoulderWidth/2 - 2.5 - tw, bigod/2 + tw - 6, bh+1.5])
					roundedRect([tw, 12, tw],tw/2);
			}
			
			// arm fixings
			translate([ShoulderWidth/2 + 2.5, bigod/2 + tw - 6, bh+1.5 - 3*tw])
				roundedRect([tw, 12, 4*tw],tw/2);
			translate([-ShoulderWidth/2 - 2.5 - tw, bigod/2 + tw - 6, bh+1.5 - 3*tw])
				roundedRect([tw, 12, 4*tw],tw/2);
		}
		
		// motor fixings / boss
		translate([0, 45.5, bh+1.5]) {
			// boss
			cylinder(r=NEMA_big_hole(NEMA17), h=50, center=true);
	
			// motor fixings
			for(a = [0: 90 : 90 * (4 - 1)])
				rotate([0, 0, a])
				translate([NEMA_holes(NEMA17)[0], NEMA_holes(NEMA17)[1], 0])
				cylinder(r=screw_clearance_radius(M3_cap_screw), h=50, center=true);
		}
		
		// back fixings
		for (i=[0,1])
			translate([0, bigod/2 + tw, bh - tw - i*(ShoulderHeight-4*tw) - 0.5])
			rotate([0,90,0])
			cylinder(r=5/2, h=100, center=true);
			
		// weight loss
		cylinder(r=20, h=100);
	
	}

}



module ElbowDrivenPulley_stl() {
	render()
	difference() {
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
			pulley_b_ht = 8,	// pulley base height, standard = 8. Set to same as idler_ht if you want an idler but no pulley.
			pulley_b_dia = 22,	// pulley base diameter, standard = 20
			no_of_nuts = 1,		// number of captive nuts required, standard = 1
			nut_angle = 90,		// angle between nuts, standard = 90
			nut_shaft_distance = 2.2,	// distance between inner face of nut and shaft, can be negative.
			//	********************************
			//	** Scaling tooth for good fit **
			//	********************************
			//	To improve fit of belt to pulley, set the following constant. Decrease or 
			// increase by 0.1mm at a time. We are modelling the *BELT* tooth here, not the 
			// tooth on the pulley. Increasing the number will *decrease* the pulley tooth 
			// size. Increasing the tooth width will also scale proportionately the tooth 
			// depth, to maintain the shape of the tooth, and increase how far into the 
			// pulley the tooth is indented. Can be negative 
			additional_tooth_width = 0.2, // scaling for good fit
			//	If you need more tooth depth than this provides, adjust the following constant. 
			// However, this will cause the shape of the tooth to change.
			additional_tooth_depth = 0 //mm
		);

		// lock nut
		translate([0,0,-1])
			cylinder(r=nut_radius(M6_nut), h=nut_thickness(M6_nut)+1, $fn=6);
	}
}


module ElbowDrivePulley_stl() {
	render()
	difference() {
		pulley(
			teeth = 34,			// Number of teeth, standard Mendel T5 belt = 8, gives Outside Diameter of 11.88mm
			belt_type = "T2.5",	// supported types: MXL 40DP XL H T2.5 T5 T10 AT5 HTD_3mm HTD_5mm HTD_8mm GT2_2mm GT2_3mm GT2_5mm
			motor_shaft = 5.2,	// NEMA17 motor shaft exact diameter = 5
			m3_dia = 3.3,		// 3mm hole diameter
			m3_nut_hex = 1,		// 1 for hex, 0 for square nut
			m3_nut_flats = 5.7,	// normal M3 hex nut exact width = 5.5
			m3_nut_depth = 2.7,	// normal M3 hex nut exact depth = 2.4, nyloc = 4
			retainer = 1,		// Belt retainer above teeth, 0 = No, 1 = Yes
			retainer_ht = 1.5,	// height of retainer flange over pulley, standard = 1.5
			idler = 1,			// Belt retainer below teeth, 0 = No, 1 = Yes
			idler_ht = 1.5,		// height of idler flange over pulley, standard = 1.5
			pulley_t_ht = 8,	// length of toothed part of pulley, standard = 12
			pulley_b_ht = 9,	// pulley base height, standard = 8. Set to same as idler_ht if you want an idler but no pulley.
			pulley_b_dia = 20,	// pulley base diameter, standard = 20
			no_of_nuts = 1,		// number of captive nuts required, standard = 1
			nut_angle = 90,		// angle between nuts, standard = 90
			nut_shaft_distance = 2.2,	// distance between inner face of nut and shaft, can be negative.
			//	********************************
			//	** Scaling tooth for good fit **
			//	********************************
			//	To improve fit of belt to pulley, set the following constant. Decrease or 
			// increase by 0.1mm at a time. We are modelling the *BELT* tooth here, not the 
			// tooth on the pulley. Increasing the number will *decrease* the pulley tooth 
			// size. Increasing the tooth width will also scale proportionately the tooth 
			// depth, to maintain the shape of the tooth, and increase how far into the 
			// pulley the tooth is indented. Can be negative 
			additional_tooth_width = 0.2, // scaling for good fit
			//	If you need more tooth depth than this provides, adjust the following constant. 
			// However, this will cause the shape of the tooth to change.
			additional_tooth_depth = 0 //mm
		);
	}
}


module CounterweightLineBracket_stl() {
	w = ShoulderWidth;
	d = 2*tw;
	
	render()
	difference() {
		union() {
			hull() {
				translate([-w/2, -d/2, -tw])
					cube([w, d, tw]);
			
				translate([0,0,-2*tw])
					cylinder(r=4/2, h=2*tw, $fn=12);		
			}
		}
		
		// hole for line
		cylinder(r=3/2, h=1200, center=true);
	
	}
}
