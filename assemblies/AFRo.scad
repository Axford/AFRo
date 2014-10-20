

module AFRoAssembly() {

	assembly("AFRo");
	
	w = 140;  // width of base, excluding cover sheet
	iw = NEMA_width(NEMA17)+24;  // inner width, excluding cover sheet
	h = NEMA_length(NEMA17);
	ih = 20;
	
	echo(iw);
	
	// base plate - plywood
	translate([-140/2,  -TorsoPostAxisOffset -NEMA_width(NEMA17)/2 - 12 -1, 0])
		color(grey20)
		cube([140, 206, 12]);
		
	translate([0,0,12]) {
	
		// RAMPS assembly
		*translate([-18, 20, 0])
			{	
				// at origin
				color(grey50)
					translate([26,57,0])
					rotate([0,0,0])
					import("utils/MEGA2560_and_RAMPS14.stl");
			}
		
		*translate([FanOffsetX, 110 - fan_thickness(fan30x10)/2, fan_width(fan30x10)/2 + 10])
			rotate([90,0,180])
			fan_assembly(fan40x11, 12, include_fan=true);
	
	
		BaseBracket_stl();
		
		// wood plates
	
		// inner front
		translate([-NEMA_width(NEMA17)/2, -TorsoPostAxisOffset + NEMA_width(NEMA17)/2,0])
			color(wood_color)
			cube([NEMA_width(NEMA17),12,47]);
		
		// inner back
		translate([-NEMA_width(NEMA17)/2, + (TorsoPostAxisOffset-NEMA_width(NEMA17)/2) - 12,0])
			color(wood_color)
			cube([NEMA_width(NEMA17),12,47]);
		
		// side
		for (i=[0,1])
			mirror([i,0,0])
			translate([-NEMA_width(NEMA17)/2-12, -TorsoPostAxisOffset -NEMA_width(NEMA17)/2 -1,0])
			color(wood_color)
			difference() {
				cube([12, 183, 47]);
				
				translate([-1, 102,-5])
					roundedRectX([14, 63, 38 +5],5);
					
				translate([-1, 5,-5])
					roundedRectX([14, 35, 38 +5],5);
			}
			
		// front
		translate([0, -TorsoPostAxisOffset -NEMA_width(NEMA17)/2 - 12 -1,0])
			color(wood_color)
			translate([-w/2,0,0])
			cube([w, 12, 47]);
			
			
		// back
		translate([0, 110,0])
			color(wood_color)
			difference() {
				translate([-w/2,0,0])
					cube([w, 12, 47]);
					
				translate([0,0,25])
					rotate([90,0,0])
					cylinder(r=38/2, h=100,center=true);
			}
			
	
		// turntable post
		translate([0,0,0])
			color(grey80)
			cylinder(r=TorsoPostDia/2, h=PostLength);
	
	
		// Torso (turntable)
		translate([0,0,0]) 
			rotate([0,0,ShoulderAngle])
			TorsoAssembly();
		
		// torso drive
		translate([0, -TorsoPostAxisOffset, 0])
			TorsoDriveAssembly();
			
		
		// cable guide from base to torso base
		*color(grey20)
			curvedPipe(
				[ 
					[0, 130, 50],
					[-50 * sin(ShoulderAngle/3), 130, 80 + 50*cos(ShoulderAngle/2)],
					[-110 * sin(ShoulderAngle/2), 110 * cos(ShoulderAngle/2), 80 + 50*cos(ShoulderAngle/2)],
					[-100 * sin(ShoulderAngle), 100 * cos(ShoulderAngle), 80],
					[-90 * sin(ShoulderAngle), 90 * cos(ShoulderAngle), 80]
				],
				4,
				[10, 10 + abs(50*sin(ShoulderAngle)),10,10],
				10,
				0);
		
	}
	
	end("AFRo");
	
}


module BaseBracket_stl() {
	// origin at surface of base plate (i.e. z=3)
	// centred on bearing post

	h = NEMA_length(NEMA17);

	sw = NEMA_width(NEMA17) + 0.2;  // stepper width + with a little tolerance
	d = 2 * (TorsoPostAxisOffset - NEMA_width(NEMA17)/2 - 12);
	

	//render()
	difference() {
		union() {
				
			// post support
			//cylinder(r=d/2, h=h);
			
			// outer box
			translate([-sw/2, -d/2, 0])
				roundedRect([sw, d, h],5);
				
		}
		
		// hollow for post
		translate([0,0,-1])
			cylinder(r=TorsoPostDia/2, h=PostLength);
			
		// slot for post clamp
		translate([-sw/2-1,-dw/2,-1])
			cube([sw+2,dw,h+2]);
			
		// post clamp fixings - through bolts!  Allow for M5, will prob use smaller
		for (i=[0,1], j=[0,1])
			mirror([j,0,0])
			translate([-TorsoPostDia/2 - 5, 0, 10 + i*(h-20)])
			rotate([90,0,0])
			cylinder(r=5.3/2, h=100, center=true);
			
			
		
		
	}
}



module BaseBackFrame_stl() {
	// origin at surface of base plate (i.e. z=3)
	// centred on bearing post

	w = 140;  // width of base, excluding cover sheet
	iw = 60;  // inner width, excluding cover sheet
	h = NEMA_length(NEMA17);

	sw = NEMA_width(NEMA17);  // stepper width
	w1 = tw;  // width of support webs
	
	render()
	difference() {
		union() {
			translate([0,  -dw, 0]) 
				difference() {
					union() {
						translate([-iw/2, 0, h])
							rotate([-90,0,0])
							trapezoidPrism(w, iw, h-10, -(w-iw)/2, dw, center=false);
			
						translate([-w/2, 0, 0])
							cube([w, dw, 10 + eta]);
							
						// fixing tabs
						for (i=[0,1])
							mirror([i,0,0])
							translate([w/2-10, -12, 0]) {
								cube([10, 12, tw]);
							
								translate([5, 12, tw])
									rotate([0,-90,180])
									right_triangle(10 - tw, 12, 10);
							}
					}
					
					// fan
					translate([FanOffsetX, -1, 15])
						rotate([-90,0,0])
						fan_holes(fan30x10);
					
					// usb
					translate([21, -1, 5])
						cube([14, dw+2, 12]);
					
					// power
					translate([-17, -1, 18])
						cube([25, dw+2, 10]);
						
				}
				
		}
					
		// base bolt holes
		for (i=[0,1])
			mirror([i,0,0])
			translate([w/2 - 5, -10, 0]) {
				translate([0,0,-1])
					cylinder(r=4.3/2, h=100);
			
				translate([0,0,tw])
					cylinder(r=screw_head_radius(M4_cap_screw) + 0.3, h=10);
			}
		
	}
}


module ZCapAssembly() {
	frame();
	
	translate([0, - TorsoPostAxisOffset, ball_bearing_width(BB608)/2+1])
		ball_bearing(BB608);
	
	ZInnerCap_stl();
	
	ZOuterCap_stl();
}


module ZInnerCap_stl() {
	h = ball_bearing_width(BB608)+1;
	r = TorsoPostDia/2 + 2*tw;
	
	render()
	difference() {
		union() {
			hull() {
				cylinder(r=r, h=h);
				
				translate([0, - TorsoPostAxisOffset, 0])
					cylinder(r=r, h=h);
			}
			
		}
		
		// post
		translate([0,0,-1])
			cylinder(r=TorsoPostDia/2, h=100);
			
		// axis, inc bearing clearance
		translate([0, -TorsoPostAxisOffset, -1])
			cylinder(r=TorsoAxisDia/2 + 3, h=100);
		
		// axis bearing
		translate([0, -TorsoPostAxisOffset, 1])
			cylinder(r=ball_bearing_diameter(BB608)/2, h=ball_bearing_width(BB608)+1);
			
		// clamping slot
		translate([-tw/2, -TorsoPostAxisOffset, -1])
			cube([tw,TorsoPostAxisOffset,50]);
		
		// clamp bolt hole, etc
		translate([0, -(TorsoPostAxisOffset)/2, tw]) {
			rotate([0,90,0])
				cylinder(r=4.3/2, h=100, center=true);
			
			// nut trap
			translate([r - nut_thickness(M4_nut, nyloc=true),0,0])
				rotate([0,90,0])
				cylinder(r=nut_flat_radius(M4_nut) + 0.3, h=100, $fn=6);
			
			// bolt head
			translate([-r + screw_head_height(M4_cap_screw),0,0])
				rotate([0,-90,0])
				cylinder(r=screw_head_radius(M4_cap_screw) + 0.3, h=100);
			
		}
		
	}
}

module ZOuterCap_stl() {
	h = ball_bearing_width(BB608)+1 + tw;
	r = TorsoPostDia/2 + 2*tw + dw;
	
	render()
	difference() {
		union() {
			hull() {
				cylinder(r=r, h=h);
				
				translate([0, - TorsoPostAxisOffset, 0])
					cylinder(r=r, h=h);
			}
			
		}
		
		translate([0,0,-eta])
			hull() {
				cylinder(r=r - dw, h=h);
				
				translate([0, - TorsoPostAxisOffset, 0])
					cylinder(r=r - dw, h=h - dw);
			}
		
	}
}




module BaseBracket_stl_old() {
	// origin at surface of base plate (i.e. z=3)
	// centred on bearing post

	w = 140;  // width of base, excluding cover sheet
	iw = 60;  // inner width, excluding cover sheet
	h = NEMA_length(NEMA17);

	sw = NEMA_width(NEMA17) + 0.2;  // stepper width + with a little tolerance
	w1 = tw;  // width of support webs

	//render()
	difference() {
		union() {
			// x webs
			for (i=[0,1])
				translate([0,  -w1 - i*(TorsoPostAxisOffset - sw/2 - w1), 0]) 
				difference() {
					union() {
						translate([-iw/2, 0, h])
							rotate([-90,0,0])
							trapezoidPrism(w, iw, h-10, -(w-iw)/2, w1, center=false);
			
						translate([-w/2, 0, 0])
							cube([w, w1, 10 + eta]);
							
						// connecting pieces
						if (i==1)
							for (i=[0,1])
							mirror([i,0,0])
							translate([w/2-10, 0, 0])
							cube([10+eta, TorsoPostAxisOffset - sw/2, tw]);
					}
					
					// hollow the web
					for (i=[0,1])
						mirror([i,0,0]) {
							translate([sw/2 + w1, w1+1, 10])
								rotate([90,0,0])
								right_triangle(h-10-w1, h-10-2*w1, w1+2, center = false);
						
							translate([sw/2 + w1, -1, dw])
								cube([h-10-w1, w1+2, 10-dw+eta]);
						}
						
					// hollow the centre
					if (i>0) 
						translate([-sw/2, -1, dw])
						cube([sw, w1+2, h-tw-dw]);
						
				}
			
			// y webs
			for (i=[0,1])
				mirror([i,0,0])
				difference() {
					union() {
						translate([sw/2, -TorsoPostAxisOffset + sw/2, tw])
							rotate([0,-90, 180])
							right_triangle(h-tw, sw + tw, w1, center = false);
						
							
						translate([sw/2, -TorsoPostAxisOffset + sw/2 - eta, 0])
							cube([w1, 
								  tw,
								  h]);
							
						translate([sw/2, -TorsoPostAxisOffset + sw/2 - eta, 0])
							cube([w1, 
								  TorsoPostAxisOffset - sw/2 + 2*eta,
								  dw]);
						
						translate([sw/2, -TorsoPostAxisOffset + sw/2 - eta, h-tw])		  
							minSupportBeamY([w1, 
								  TorsoPostAxisOffset - sw/2,
								  tw],
								  bridge=6, air=h-2*tw);
					}
				}
				
			// central stiffener
			translate([-tw/2, -TorsoPostAxisOffset + sw/2 - eta, 0]) {
				cube([tw, tw, h]);
				
				cube([tw, TorsoPostAxisOffset - sw/2 - TorsoPostDia/2, dw]);
				
				translate([0,tw-eta,h-tw])
					minSupportBeamY([tw, TorsoPostAxisOffset - sw/2 - TorsoPostDia/2 - 2*tw, tw], bridge=6, air=h-2*tw);
			}
			
			// stepper front retainer
			translate([-sw/2 - w1-eta, -TorsoPostAxisOffset - sw/2 - tw, 0])
				cube([sw + 2*w1 + 2*eta, sw + 2*tw + eta, tw+eta]);
				
			// stepper back retainer
			for (i=[0,1])
				mirror([i,0,0])
				translate([tw/2-eta, -TorsoPostAxisOffset + sw/2, h-tw])
				minSupportBeam([sw/2-tw/2+eta, tw, tw], bridge=6, air=h-2*tw, center=false);
				
			// post support
			cylinder(r=TorsoPostDia/2 + 2*tw, h=h);
			
			// clamping flange
			translate([-iw/2, -TorsoPostDia/2 - eta, 0])
				cube([iw/2, TorsoPostDia, h]);
				
		}
		
		// hollow y webs
		for (i=[0,1])
			mirror([i,0,0])
			translate([sw/2 - 1, -TorsoPostAxisOffset + sw/2, dw])
			rotate([0,-90, 180])
			right_triangle(h-2*w1-dw, h-2*w1-dw, w1+2, center = false);
		
		// hollow for post
		translate([0,0,-1])
			cylinder(r=TorsoPostDia/2, h=PostLength);
			
		// slot for post clamp
		translate([-w,-dw/2,-1])
			cube([w,dw,h+2]);
			
		// post clamp fixings
		for (i=[0,1])
			translate([-TorsoPostDia/2 - 3*tw, 0, 10 + i*(h-20)]) {
				rotate([90,0,0])
					cylinder(r=4.3/2, h=30, center=true);
					
				// nut trap
				translate([0,-TorsoPostDia/2 + nut_thickness(M4_nut),0])
					rotate([90,0,0])
					cylinder(r=nut_flat_radius(M4_nut), h=8, $fn=6);
			}
			
		
		
		// hollow for stepper
		translate([-sw/2, -TorsoPostAxisOffset - sw/2, -1])
			cube([sw, sw, h+2]);
			
		// base bolt holes
		for (i=[0,1])
			mirror([i,0,0])
			translate([w/2 - 5, -(TorsoPostAxisOffset - sw/2)/2, -1])
			cylinder(r=4.3/2, h=100);
		
	}
}
