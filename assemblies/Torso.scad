Torso_gears_pitch_radius = TorsoPostAxisOffset;
TorsoBigGearTeeth = 41;
TorsoDriveGearTeeth = 11;
Torso_gears_circular_pitch = Torso_gears_pitch_radius*2 / TorsoBigGearTeeth * 180 * TorsoBigGearTeeth/(TorsoDriveGearTeeth+TorsoBigGearTeeth);

TorsoStepperZOffset = 40;

TorsoBigGearThickness = 14;

module TorsoAssembly() {
	
	h = NEMA_length(NEMA17);
	nw = NEMA_width(NEMA17);
	
	assembly("Torso");
		
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
	
	end("Torso");
	
}


module TorsoBearingCollar_stl() {
	h = ball_bearing_width(TorsoBearing) + tw;
	od = ball_bearing_od(TorsoBearing);
	id = ball_bearing_id(TorsoBearing);
	
	difference() {
		union() {
			// inner support
			cylinder(r=id/2, h=h);
			
			// shelf
			cylinder(r=id/2 + 4, h=tw);
			
		}
		
		// post
		translate()
			cylinder(r=TorsoPostDia/2+0.1, h=100, center=true);
	}
}



module TorsoBigGear_stl() {
	bod = ball_bearing_od(TorsoBearing);
	bh =  ball_bearing_width(TorsoBearing);

	t = 8;

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

module TorsoBase_stl() {
	bod = ball_bearing_od(TorsoBearing);
	bh =  ball_bearing_width(TorsoBearing);
	nl = NEMA_length(NEMA17);

	t = TorsoBaseThickness;
	
	idlerWidth = 14.8;

	difference() {
		union() {
				
			// post supports
			for (i=[0,1])
					mirror([0,i,0])
					translate([0, TorsoRodSpacing/2, 0])
					cylinder(r2=TorsoRodDia/2 + dw, r1=TorsoRodDia/2 + tw, h=30);
					
					
			// webbing
			hull() {
				for (i=[0,1])
					mirror([0,i,0])
					translate([0, TorsoRodSpacing/2, 0])
					cylinder(r=TorsoRodDia/2 + tw, h=t);
				
				translate([0,0, 0])
					cylinder(r=bod/2 + 2 + tw, h=t);
				
			}
			
			// idler supports
			translate([0, -nl/2 - 17, 0])
				for (i=[0,1])
				mirror([0,i,0])
				translate([-2-tw, -idlerWidth/2 - tw, 0])
				cube([4+2*tw, tw, 25]);
			
		}
		
		
		// hollow for post
		translate([0,0,-1])
			cylinder(r1= 25/2+7, r2=bod/2+2 - tw, h=t+2);
			
		// hollow for idler bolt
		translate([0, -nl/2 - 17, 19])
			rotate([90,0,0])
			cylinder(r=4.3/2, h=50, center=true);
		
			
		// hollow for smooth rods
		for (i=[0,1])
			mirror([0,i,0])
			translate([0, TorsoRodSpacing/2, -20])
			cylinder(r=TorsoRodDia/2+0.1, h=TorsoRodLength);
			
		// clamping slots
		for (i=[0,1])
			mirror([0,i,0])
			translate([-1, TorsoRodSpacing/2 - 25, -1])
			cube([2,25,25]);
			
		// clamping bolt holes
		for (i=[0,1])
			mirror([0,i,0])
			translate([-1, TorsoRodSpacing/2 - 12, t/2]) {
			
				rotate([0,90,0])
					cylinder(r=3.2/2, h=100, center=true);
					
				// nut trap
				translate([8,0,0])
					rotate([0,90,0])
					rotate([0,0,30])
					cylinder(r=nut_radius(M3_nut)+0.1, h=100, $fn=6);
					
				// cs
				translate([-8,0,0])
					rotate([0,-90,0])
					rotate([0,0,30])
					cylinder(r=washer_radius(M3_washer)+0.1, h=100);
			
			}
			
		// fixings to big gear
		for (i=[0,1])
			mirror([i,0,0])
			translate([bod/2 + 2, 0, -1])
			cylinder(r=3.5/2, h=100);
			
		// weight loss
		translate([0,43,0])
			cylinder(r=13, h=100, center=true);
		translate([0,-40.5,0])
			cylinder(r=7, h=100, center=true);
		
	}
}


module TorsoBearingTopCollar_stl() {
	t = dw;
	h = ball_bearing_width(TorsoBearing) + 2*t;
	od = ball_bearing_od(TorsoBearing);
	id = ball_bearing_id(TorsoBearing);
	
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

module TorsoBearingTopCollarDev_stl() {
	t = dw;
	h = ball_bearing_width(TorsoBearing) + 2*t;
	od = ball_bearing_od(TorsoBearing);
	id = ball_bearing_id(TorsoBearing);
	
	translate([0,0,-t])
	difference() {
		union() {
			// inner support
			cylinder(r=id/2, h=h);
			
			// cap
			*translate([0,0,h-t])
				cylinder(r=id/2, h=t);
				
			// shelf
			cylinder(r1=id/2 + dw, r2=id/2, h=dw);
			
			// clamp housing
			*translate([0,-t/2,0])
				cube([id/2+4, t, t]);
			
		}
		
		// post
		translate([0,0,-1])
			cylinder(r=TorsoPostDia/2 + 0.1, h=100);
			
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



module TorsoCap_stl() {
	bod = ball_bearing_od(TorsoBearing);
	bh =  ball_bearing_width(TorsoBearing);
	nw = NEMA_width(NEMA17);
	nl = NEMA_length(NEMA17);

	h = bh + dw;

	t = TorsoBaseThickness;

	difference() {
		union() {
				
			// bearing collar
			cylinder(r=bod/2 + tw, h=h);
				
			// post supports
			for (i=[0,1])
					mirror([0,i,0])
					translate([0, TorsoRodSpacing/2, 0])
					cylinder(r2=TorsoRodDia/2 + dw, r1=TorsoRodDia/2 + tw, h=18.5);
					
					
			// webbing
			hull() {
				for (i=[0,1])
					mirror([0,i,0])
					translate([0, TorsoRodSpacing/2, 0])
					cylinder(r=TorsoRodDia/2 + tw, h=t);
				
				translate([0,0,0])
					cylinder(r=bod/2 + tw, h=t);
				
			}
			
			// stepper mount
			translate([-nw/2, -nl/2-tw, 0])
				roundedRect([nw, tw, TorsoStepperZOffset], tw/2);
			
			// fillet
			translate([0, -nl/2-tw+0.5, t])
				rotate([0,-90,180])
				right_triangle(20, 20, dw, center = true);
				
			// alternate stepper mount
			*translate([0, -nl/2-nl+18-tw, 0])
				hull() {
					translate([-nw/2+7,0,0])
						roundedRect([nw-14, tw, 1], tw/2);
					translate([-nw/2,0,TorsoStepperZOffset-20])
						roundedRect([nw, tw, 20], tw/2);
				}
			
			// fillet
			*translate([0, -nl/2-nl+18-tw+0.5, t])
				rotate([0,-90,0])
				right_triangle(20, 20, dw, center = true);
		}
		
		// belt slots
		for (i=[0,1]) 
			mirror([i,0,0])
			translate([6, -nl/2 - 22, -1])
			cube([5, 10, 50]);
		
		// motor fixings / boss
		translate([0, -nl/2 - 20, TorsoStepperZOffset]) 
			rotate([90,0,0]) {
			// boss
			cylinder(r=NEMA_big_hole(NEMA17), h=50, center=true);
	
			// motor fixings
			for(a = [0: 90 : 90 * (4 - 1)])
				rotate([0, 0, a])
				translate([NEMA_holes(NEMA17)[0], NEMA_holes(NEMA17)[1], 0])
				cylinder(r=screw_clearance_radius(M3_cap_screw), h=50, center=true);
		}
		
		// hollow for post
		cylinder(r=25/2 + 7, h=100, center=true);
		
		// flare the hollow
		translate([0,0,bh-eta])
			cylinder(r1=bod/2, r2=bod/2 -dw, h=dw+2*eta);
		
		// bearing recess
		translate([0,0,-1])
			cylinder(r=bod/2, h=bh + 1);
			
		// hollow for smooth rods
		for (i=[0,1])
			mirror([0,i,0])
			translate([0, TorsoRodSpacing/2, -20])
			cylinder(r=TorsoRodDia/2+0.1, h=TorsoRodLength);
			
		// clamping slots
		for (i=[0,1])
			mirror([0,i,0])
			translate([-1, TorsoRodSpacing/2 - 25, -1])
			cube([2,25,17]);
			
		// clamping bolt holes
		for (i=[0,1])
			mirror([0,i,0])
			translate([-1, TorsoRodSpacing/2 - 12, t/2]) {
			
				rotate([0,90,0])
					cylinder(r=3.2/2, h=100, center=true);
					
				// nut trap
				translate([8,0,0])
					rotate([0,90,0])
					rotate([0,0,30])
					cylinder(r=nut_radius(M3_nut)+0.1, h=100, $fn=6);
					
				// cs
				translate([-8,0,0])
					rotate([0,-90,0])
					rotate([0,0,30])
					cylinder(r=washer_radius(M3_washer)+0.1, h=100);
			
			}
			
		// weight loss
		translate([0,43,0])
			cylinder(r=13, h=100, center=true);
		
	}
}


module TorsoDriveAssembly() {
	
	translate([0,0,NEMA_length(NEMA17)]) {
		rotate([0,0,90])
		NEMA(NEMA17);
		
		// drive gear
		translate([0,0,3])
			//rotate([0,0,360/15/2])
			TorsoDriveGear_stl();
	}
}


module TorsoDriveGear_stl() {
	
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


CounterweightIdler_offsetY = 15;
CounterweightIdler_offsetZ = -ball_bearing_od(BB624)/2 + dw;


module CounterweightIdlerAssembly() {
	assembly("CounterweightIdler");
	
	CounterweightIdler_stl();
	
	bw = ball_bearing_width(BB624);
	slotw = bw + 2*washer_thickness(M4_washer) + 1;  // room for small washers and some clamping pressure
	w = slotw + 2*dw;
	
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
		
	
	end("CounterweightIdler");
}

module CounterweightIdler_stl() {
	// extends in y+
	// sits on top of Torso smooth rod
	rod = TorsoRodDia;
	h=-CounterweightIdler_offsetZ + 4 + tw;
	od = rod + 2*dw;
	
	bw = ball_bearing_width(BB624);
	slotw = bw + 2*washer_thickness(M4_washer) + 1;  // room for small washers and some clamping pressure
	
	w = slotw + 2*dw;
	
	render()
	difference() {
		union() {
			// cap
			cylinder(r=rod/2+dw, h=dw);
		
			hull() {
				// sleeve
				translate([0,0,-h + dw - 5])
					cylinder(r=od/2, h=h + 5);
				
				// axle housing
				translate([-w/2, CounterweightIdler_offsetY - tw - 2, -h+dw])
					cube([w, 4+2*tw, h]);
			}
		}
		
		// hollow for smooth rod
		translate([0,0,-50])
			cylinder(r=rod/2+0.2, h=50);
		
		// hollow for bearing
		translate([-slotw/2, od/2, -50])
			cube([slotw, 50, 100]);
		
		// slot for clamp
		translate([0,4,0])
			cube([2,12,100], center=true);
		
		// hollow for bearing axle
		translate([0, CounterweightIdler_offsetY, CounterweightIdler_offsetZ])
			rotate([0,90,0])
			cylinder(r=4.3/2, h=100, center=true);
	}
}

module CounterweightIdlerGuide_stl() {
	bw = ball_bearing_width(BB624);
	bod = ball_bearing_od(BB624) + 0.4;
	
	render()
	difference() {
		union() {
			for (i=[0,1])
				mirror([0,0,i])
				translate([0,0,-eta])
				cylinder(r1=bod/2+2perim, r2=bod/2+dw, h=bw/2);
		}
		
		// hollow for bearing
		*cylinder(r=bod/2, h=100, center=true);
	
		// hollow for M4 bolt
		cylinder(r=4.3/2, h=100, center=true);
	}
}

module CounterweightAssembly() {
	assembly("Counterweight");
	// origin is on smooth rod, at top of counterweight assembly
	
	// weight dimensions
	ww = CounterweightWidth;
	wd = CounterweightDepth;
	wh = CounterweightHeight;
	
	oy = 10;  // offset of weights in y
	
	CounterweightBracket_stl();
	
	// weight blocks
	color(alu_color)
		translate([-ww/2, oy, -wh-dw])
		cube([ww, wd, wh]);
	
	end("Counterweight");
}


module CounterweightBracket_stl() {
	
	// weight dimensions
	ww = CounterweightWidth;
	wd = CounterweightDepth;
	wh = CounterweightHeight;
	
	oy = 10;  // offset of weights in y

	od = TorsoRodDia;

	render()
	difference() {
		union() {
			// top/bottom plates
			for (i=[0,1])
				translate([0,0,-dw - i*(wh + dw)]) {
					hull() {
						cylinder(r=od/2 + tw, h=dw);
					
						translate([-ww/2-dw, oy+wd/2, 0])
							cube([ww + 2*dw, wd/2+dw, dw]);	
				
					}
				
					// retaining ridge
					mirror([0,0,i])
						translate([ww/4, oy - tw, eta-i*dw])
						rotate([-90,0,90])
						trapezoidPrism(1, tw, (tw-1)/2, (tw-1)/2, ww/2);
				}
						
			// back plate
			for (i=[-1,1])
				translate([-tw/2 + i*(ww/2), oy+wd, -wh-2*dw])
				cube([tw, dw, wh+2*dw]);
			
			
			// side webbing
			for (i=[-1,1])
				translate([-dw/2 + i*(ww/2 + dw/2), oy+wd/2, -wh-2*dw])
				cube([dw, wd/2, wh+2*dw]);
		
			// line block
			hull() {
				translate([0,oy+wd/2,5])
					rotate([-90,0,0])
					cylinder(r=3/2+tw, h=dw, $fn=20);
					
				translate([0,oy+wd/2,5])
					rotate([-90,0,0])
					cylinder(r=3/2+1, h=wd/2+dw, $fn=20);
					
				translate([-6, oy+wd/2, -1])
					cube([12, wd/2+dw, 1]);
			}
			
			// line block reinforcing
			translate([-ww/2, oy+wd, -tw-dw+eta])
				cube([ww, dw, tw]);
				
			// OSHW logo
			translate([0, oy+wd+dw, -ww/2-tw-dw+eta])
				rotate([90,0,0])
				linear_extrude(height=dw)
				oshw_logo_2d(ww);
				
				
			// AFRo text
			translate([11, oy+wd, -dw-wh+5.5])
				rotate([-90,0,0])
				rotate([0, 0, 90])
				scale([1.3,1.5,1])
				fnt_str_p( ["A","F","R","o"], 
					[0,
					aa,
					aa+ff,
					aa+ff+rr], 
					4, 10, 2 );
		}
		
		// line hole
		translate([0,oy+wd/2,5])
					rotate([-90,0,0])
					cylinder(r=3/2, h=100, center=true);
		
		// hollow for smooth rod - sliding fit
		cylinder(r=TorsoRodDia/2+0.5, h=200, center=true);
		
	}

}


module TorsoEndStopAssembly() {
	
	mcon = [[-1.5*dw, -EndStopOffsetY - microswitch2_fixingCentres, tw/2],[-1,0,0], 90];
	
	TorsoEndStopBracket_stl();
	
	attach(mcon, microswitch2_connectors[0]) 
		microswitch2();
}

module TorsoEndStopBracket_stl() {

	h = 5;
	
	render()
	difference() {
		linear_extrude(h) 
			difference() {
				union() {
					circle(r=TorsoPostDia/2 + dw);			
			
					// clamp tabs
					translate([-tw, -TorsoPostDia/2 - 18, 0])
						square([2*tw, 18]);
				
				}
				
				// Torso post
				circle(r=TorsoPostDia/2);
			
				// clamp slot
				translate([-1, -TorsoPostDia/2 - 19, 0])
						square([2, 30]);
			
			}
		
		// servo fixings
		for(i=[0,1])
			translate([0,-EndStopOffsetY - i*(microswitch2_fixingCentres),h/2])
			rotate([0,90,0])
			cylinder(r=microswitch2_fixingRadius, h=100, center=true);
	}

}