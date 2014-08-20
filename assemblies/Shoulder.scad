

module ShoulderAssembly() {
	
	assembly("Shoulder");
	
	*translate([0,0,
		bearing_height(ShoulderPostLinearBearing)/2 + ServoBracketOpening + tw -  bearing_height(ShoulderPostLinearBearing) + dw])
		rotate([0,90,0])
		linear_bearing(ShoulderPostLinearBearing);
		
	ShoulderBracket_UpperPlate_stl();
	
	ShoulderBracket_LowerPlate_stl();
	
	translate([0, -ShoulderPostAxisOffset, ServoBracketOpening + tw])
		ShoulderBracket_Ballscrew_stl();
	
	*translate([0,-ShoulderPostJointOffset, ServoBracketOpening + tw])
		rotate([0,0, ShoulderAngle])
		UpperArmAssembly();
	
	end("Shoulder");
	
}


module ShoulderBracket_Ballscrew_stl() {
	// local origin places ballscrew below z=0, with upper mating surface at z=0,
	// centred in x/y on the axis rod
	frame();
	
	//render()
	difference() {
		union() {
			hull() {
				// bearing mounts
				rotate([0,0,90])
					for(bearingNum=[1:3])
						rotate(-bearingOffset+bearingNum*360/3,[0,0,1])
						translate([0,bearingTolerance,-MountHeight]) {
							*cylinder(r=8, h=MountHeight, center=true);
						
							rotate([0,Angle*.71,0])
								cylinder (h=BearingHeight, r=BearingHoleOD, center = true, $fn=cylFn);
						}
						
				// clamp
				translate([-ShoulderBracketWidth/4, 20, -MountHeight -tw])
					roundedRectY([ShoulderBracketWidth/2, 10, 2*tw], 2);
					
				// top fixing
				translate([0, -27, - MountHeight])
					cylinder(r=tw, h=2*tw, center=true);
			}
		
		}
		
		// bearings
		translate([0, 0, -MountHeight])
			rotate([0,0,90])
			for(bearingNum=[1:3]) {
				rotate(-bearingOffset+bearingNum*360/3,[0,0,1])
				translate([0,bearingTolerance,0])
				topBearing(bearingNum==1 ? 44 :(bearingNum==2 ? 164 : 284));
	
				//rotate(bearingOffset+bearingNum*360/3,[0,0,1])
				rotate(-bearingOffset+bearingNum*360/3,[0,0,1])
				translate([0,bearingTolerance,0])
				bottomBearing(bearingNum==1 ? 83 :(bearingNum==2 ? 203 : 323));
			}
			
		// axis
		cylinder(r=ShoulderAxisDia/2 + 1, h=100, center=true);
		
		
		// clamp slot
		translate([-dw/2, 0, -50])
			cube([dw, 100, 100]);
		
	}
	
}


module ShoulderBracket_UpperPlate_stl() {
	// local origin is centred on the post, the base of the bracket sits on z=0
	
	//render()
	union() {
		// print support
		for (i=[0:23])
			rotate([0,0, i*(360/24)])
			translate([-perim/2, ShoulderPostDia/2, ServoBracketOpening + tw])
			cube([perim, bearing_radius(ShoulderPostLinearBearing) - ShoulderPostDia/2- perim, dw + eta]);
			
		translate([0,0, ServoBracketOpening + tw])
			tube(or=ShoulderPostDia/2 + perim, ir=ShoulderPostDia/2, h=dw-layers, center=false);
		
		
	
	
		difference() {
			union() {
				translate([0,0, ServoBracketOpening + tw + tw -eta])
					hull() {
						cylinder(r1=ShoulderBracketWidth/2, r2=ShoulderBracketWidth/2-2*tw, h=tw);
					
						translate([0, -ShoulderPostAxisOffset, 0])
							cylinder(r1=ShoulderBracketWidth/2, r2=ShoulderBracketWidth/2-2*tw, h=2*tw);
				
						translate([0, -ShoulderPostJointOffset, 0])
							cylinder(r1=UpperArmWidth/2, r2=UpperArmWidth/2-tw, h=tw);
					}
			
				// upper plate
				translate([0,0, ServoBracketOpening + tw])
					hull() {
						cylinder(r=ShoulderBracketWidth/2, h=tw);
					
						translate([0, -ShoulderPostAxisOffset, 0])
							cylinder(r=ShoulderBracketWidth/2, h=tw);
				
						translate([0, -ShoulderPostJointOffset, 0])
							cylinder(r=UpperArmWidth/2, h=tw);
					}
				
				// reinforcing ribs
				*for (i=[0,1])
					mirror([i,0,0]) {
						// inner ribs
						hull() {
							translate([3, -ShoulderPostJointOffset - 5, ServoBracketOpening + 2*tw - eta])
								rotate([0,0,-94])
								rotate([90,0,0])
								translate([0,0,-dw/2])
								right_triangle(10, 2*tw, dw);
							
							translate([ShoulderPostDia/2 + 4, ShoulderPostDia/2, ServoBracketOpening + 2*tw - eta])
								rotate([0,0,86])
								rotate([90,0,0])
								translate([0,0,-dw/2])
								right_triangle(10, 2*tw, dw);
						}
					
						// outer ribs
						hull() {
							translate([11, -ShoulderPostJointOffset, ServoBracketOpening + 2*tw - eta])
								rotate([0,0,-92])
								rotate([90,0,0])
								translate([0,0,-dw/2])
								right_triangle(10, 2*tw, dw);
							
							translate([ShoulderPostDia/2 + 6, ShoulderPostDia/2 -2, ServoBracketOpening + 2*tw - eta])
								rotate([0,0,88])
								rotate([90,0,0])
								translate([0,0,-dw/2])
								right_triangle(10, 2*tw, dw);
						}
					}
				
			}
		
			// Hollow it out
			// -------------
		
		
			// linear bearing
			translate([0,0, ServoBracketOpening - bearing_height(ShoulderPostLinearBearing) + tw + dw])
				cylinder(r=bearing_radius(ShoulderPostLinearBearing), h=bearing_height(ShoulderPostLinearBearing));
		
			// post
			translate([0, 0, -1])
				cylinder(r=ShoulderPostDia/2 + 1, h=100);
			
			// axis rod
			translate([0, -ShoulderPostAxisOffset, -1])
				cylinder(r=ShoulderAxisDia/2 + 1, h=100);
			
			// servo hub/bushing
			translate([0, -ShoulderPostJointOffset, 0])
				cylinder(r=8/3.2, h=300, center=true);

			// servo horn fixings
			for (i=[0:3])
				translate([0, -ShoulderPostJointOffset, 0])
				rotate([0,0,i*90])
				translate([0,16/2, 0]) {
					translate([0,0,ServoBracketOpening])
						cylinder(r=2.3/2, h=100, center=true);
				
					translate([0,0,ServoBracketOpening + tw + tw])
						cylinder(r1=5/2, h=100, center=false);
				}
			
			// vertical post fixings
			for (i=[0,1])
				mirror([i,0,0])	
				translate([0, -ShoulderPostAxisOffset, ServoBracketOpening - 3*tw])
				rotate([0,0,-35])
				translate([ShoulderBracketWidth/2 - tw,0,0])
				cylinder(r=1.3, h=ServoBracketOpening - tw);
			
			translate([0, -ShoulderPostJointOffset + 27, ServoBracketOpening - 3*tw])
				cylinder(r=1.3, h=ServoBracketOpening-tw);
		}	
	}
}

module ShoulderBracket_LowerPlate_stl() {
	// local origin is centred on the post, the base of the bracket sits on z=0
	
	color("orange")
	//render()
	difference() {
		union() {
			// lower plate
			translate([0,0, 0])
				hull() {
					cylinder(r=ShoulderBracketWidth/2, h=tw);
				
					translate([0, -ShoulderPostAxisOffset, 0])
						cylinder(r=ShoulderBracketWidth/2, h=tw);
				
					translate([0, -ShoulderPostJointOffset, 0])
						cylinder(r=UpperArmWidth/2, h=tw);
				}
			
			// vertical posts around z axis
			for (i=[0,1])
				mirror([i,0,0])	
				translate([0, -ShoulderPostAxisOffset, 0])
				rotate([0,0,-35])
				translate([ShoulderBracketWidth/2 - tw,0,0])
				cylinder(r=tw, h=ServoBracketOpening - tw);
				
			translate([0, -ShoulderPostJointOffset + 27, 0])
				cylinder(r=tw, h=ServoBracketOpening - tw);
				
			// thicken around lin bearing
			cylinder(r1=ShoulderBracketWidth/2 - tw, r2=bearing_radius(ShoulderPostLinearBearing) + dw, h=2*tw);
				
				
			// cosmetic cover round bearings
			*translate([0, -ShoulderPostAxisOffset, 0])
				linear_extrude(ServoBracketOpening + tw)
				rotate([0,0,180])
				donutSector2D(or=ShoulderBracketWidth/2, ir=ShoulderBracketWidth/2 - dw, a=180, center=false);
		}
		
		// Hollow it out
		// -------------
		
		// linear bearing
		translate([0,0, ServoBracketOpening - bearing_height(ShoulderPostLinearBearing) + tw + dw])
				cylinder(r=bearing_radius(ShoulderPostLinearBearing), h=bearing_height(ShoulderPostLinearBearing));
				
		// post
		translate([0, 0, -1])
			cylinder(r=ShoulderPostDia/2 + 1, h=100);
	
		// motor coupling
		translate([0, -ShoulderPostAxisOffset, -1])
			cylinder(r=25/2 + 1, h=30);
			
		// servo hub/bushing
		translate([0, -ShoulderPostJointOffset, 0])
			cylinder(r=8/3.2, h=300, center=true);
			
		// vertical post fixings
		for (i=[0,1])
			mirror([i,0,0])	
			translate([0, -ShoulderPostAxisOffset, ServoBracketOpening - 3*tw])
			rotate([0,0,-35])
			translate([ShoulderBracketWidth/2 - tw,0,0])
			cylinder(r=1.3, h=ServoBracketOpening - tw);
			
		translate([0, -ShoulderPostJointOffset + 27, ServoBracketOpening - 3*tw])
			cylinder(r=1.3, h=ServoBracketOpening-tw);

	}
	
}





// older versions

module ShoulderBracket_UpperPlate1_stl() {
	// local origin is centred on the post, the base of the bracket sits on z=0
	
	render()
	union() {
		// print support
		translate([0, -ShoulderPostAxisOffset, ShoulderBracketHeight - 1.5*tw])
			rotate([0,0,90])
			for(bearingNum=[1:3]) {
				rotate(-bearingOffset+bearingNum*360/3,[0,0,1])
				translate([0,bearingTolerance,0])
				for(i=[0:9])
					rotate([0,0,i*36])
					translate([2,0,0])
					cube([7, perim, 1.5*tw]);
			}
	
		difference() {
			union() {
				// upper plate
				translate([0,0, ServoBracketOpening + tw])
					hull() {
						cylinder(r=ShoulderBracketWidth/2, h=tw);
					
						translate([0, -ShoulderPostAxisOffset, 0])
							cylinder(r=ShoulderBracketWidth/2, h=tw);
				
						translate([0, -ShoulderPostJointOffset, 0])
							cylinder(r=UpperArmWidth/2, h=tw);
					}
				
			
				hull() {
					// upper plate extension around linear bearing
					translate([0,0, ServoBracketOpening - tw])
						cylinder(r=ShoulderBracketWidth/2 - tw, h=3*tw);
				
					// thicken up around z-bearing mounts
					translate([0, -ShoulderPostAxisOffset, ServoBracketOpening-tw])
						cylinder(r=ShoulderBracketWidth/2, h=3*tw);	
					
					translate([0, -ShoulderPostJointOffset + 27, ServoBracketOpening - tw])
						cylinder(r=tw, h=3*tw);
				}
				
				// cosmetic cover round bearings
				*translate([0, -ShoulderPostAxisOffset, 0])
					linear_extrude(ServoBracketOpening + tw)
					rotate([0,0,180])
					donutSector2D(or=ShoulderBracketWidth/2, ir=ShoulderBracketWidth/2 - dw, a=180, center=false);
			}
		
			// Hollow it out
			// -------------
		
			// clamping slot
			translate([-tw/2, -ShoulderPostAxisOffset, ServoBracketOpening-25])
				cube([tw,ShoulderPostAxisOffset,50]);
		
			// clamp bolt hole, etc
			translate([0, -(ShoulderPostAxisOffset)/2, ServoBracketOpening + tw/2]) {
				rotate([0,90,0])
					cylinder(r=5.3/2, h=100, center=true);
			
				// nut trap
				translate([ShoulderBracketWidth/2 - nut_thickness(M5_nut, nyloc=true),0,0])
					rotate([0,90,0])
					cylinder(r=nut_flat_radius(M5_nut) + 0.3, h=100, $fn=6);
			
				// bolt head
			
				translate([-ShoulderBracketWidth/2 + screw_head_height(M5_cap_screw),0,0])
					rotate([0,-90,0])
					cylinder(r=screw_head_radius(M5_cap_screw) + 0.3, h=100);
			
			}
		
			// linear bearing
			translate([0,0, 1])
				cylinder(r=bearing_radius(ShoulderPostLinearBearing) + 0.3, h=bearing_height(ShoulderPostLinearBearing)+0.3);
		
			// post
			translate([0, 0, -1])
				cylinder(r=ShoulderPostDia/2 + 1, h=100);
			
			// bearings
			translate([0, -ShoulderPostAxisOffset, ShoulderBracketHeight - 1.5*tw])
				rotate([0,0,90])
				for(bearingNum=[1:3]) {
					rotate(-bearingOffset+bearingNum*360/3,[0,0,1])
					translate([0,bearingTolerance,0])
					topBearing(bearingNum==1 ? 44 :(bearingNum==2 ? 164 : 284));
		
					//rotate(bearingOffset+bearingNum*360/3,[0,0,1])
					rotate(-bearingOffset+bearingNum*360/3,[0,0,1])
					translate([0,bearingTolerance,0])
					bottomBearing(bearingNum==1 ? 83 :(bearingNum==2 ? 203 : 323));
				}
			
			// servo hub/bushing
			translate([0, -ShoulderPostJointOffset, 0])
				cylinder(r=8/3.2, h=300, center=true);

			// servo horn fixings
			translate([0, -ShoulderPostJointOffset, 0])
				for (i=[0:3])
				rotate([0,0,i*90])
				translate([0,16/2,0])
				cylinder(r=2.3/2, h=100, center=true);
			
			// vertical post fixings
			for (i=[0,1])
				mirror([i,0,0])	
				translate([0, -ShoulderPostAxisOffset, ServoBracketOpening - 3*tw])
				rotate([0,0,-35])
				translate([ShoulderBracketWidth/2 - tw,0,0])
				cylinder(r=1.3, h=ServoBracketOpening - tw);
			
			translate([0, -ShoulderPostJointOffset + 27, ServoBracketOpening - 3*tw])
				cylinder(r=1.3, h=ServoBracketOpening-tw);
		}
	}	
}

module ShoulderBracket_LowerPlate1_stl() {
	// local origin is centred on the post, the base of the bracket sits on z=0
	
	color("orange")
	render()
	difference() {
		union() {
			// lower plate
			translate([0,0, 0])
				hull() {
					cylinder(r=ShoulderBracketWidth/2, h=tw);
				
					translate([0, -ShoulderPostAxisOffset, 0])
						cylinder(r=ShoulderBracketWidth/2, h=tw);
				
					translate([0, -ShoulderPostJointOffset, 0])
						cylinder(r=UpperArmWidth/2, h=tw);
				}
			
			// vertical posts around z axis
			for (i=[0,1])
				mirror([i,0,0])	
				translate([0, -ShoulderPostAxisOffset, 0])
				rotate([0,0,-35])
				translate([ShoulderBracketWidth/2 - tw,0,0])
				cylinder(r=tw, h=ServoBracketOpening - tw);
				
			translate([0, -ShoulderPostJointOffset + 27, 0])
				cylinder(r=tw, h=ServoBracketOpening - tw);
				
			// thicken around lin bearing
			cylinder(r=ShoulderBracketWidth/2 - tw, h=2*tw);
				
				
			// cosmetic cover round bearings
			*translate([0, -ShoulderPostAxisOffset, 0])
				linear_extrude(ServoBracketOpening + tw)
				rotate([0,0,180])
				donutSector2D(or=ShoulderBracketWidth/2, ir=ShoulderBracketWidth/2 - dw, a=180, center=false);
		}
		
		// Hollow it out
		// -------------
		
		// linear bearing
		translate([0,0, 1])
			cylinder(r=bearing_radius(ShoulderPostLinearBearing) + 0.3, h=bearing_height(ShoulderPostLinearBearing)+0.3);
		
		// post
		translate([0, 0, -1])
			cylinder(r=ShoulderPostDia/2 + 1, h=100);
	
		// motor coupling
		translate([0, -ShoulderPostAxisOffset, -1])
			cylinder(r=25/2 + 1, h=30);
			
		// servo hub/bushing
		translate([0, -ShoulderPostJointOffset, 0])
			cylinder(r=8/3.2, h=300, center=true);
			
		// vertical post fixings
		for (i=[0,1])
			mirror([i,0,0])	
			translate([0, -ShoulderPostAxisOffset, ServoBracketOpening - 3*tw])
			rotate([0,0,-35])
			translate([ShoulderBracketWidth/2 - tw,0,0])
			cylinder(r=1.3, h=ServoBracketOpening - tw);
			
		translate([0, -ShoulderPostJointOffset + 27, ServoBracketOpening - 3*tw])
			cylinder(r=1.3, h=ServoBracketOpening-tw);

	}
	
}