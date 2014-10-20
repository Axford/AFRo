

module LowerArmAssembly() {
	
	assembly("LowerArm");
	
	sw = dynamixel_width(DYNAMIXELAX12);
			
	// sides
	for (i=[0,1])
		mirror([i,0,0])
		translate([sw/2 + 1.5, -LowerArmLength, 0])
		rotate([-90,0,0])
		mirror([1,0,0])
		aluAngle(10,40,LowerArmLength,1.5);
	
	ElbowJoint2_stl();
	
	LowerArmServoBracket_stl();
	
	mirror([1,0,0])
		LowerArmServoBracket_stl();
	
	
	translate([0, -LowerArmLength, -42]) {
		rotate([0,180,180])
			DynamixelAX12();
		
		rotate([0,0, WristAngle])
			HandAssembly();
	}
	
	end("LowerArm");
	
}


module ElbowJoint2_stl() {
	sw = dynamixel_width(DYNAMIXELAX12);
	iw = sw - 2*8.5;
	d = 13;
	
	translate([0,0,-ShoulderHeight-1.5])
	difference() {
		union() {
			translate([-sw/2, -d, 0])
				cube([sw, d+eta, ShoulderHeight]);	
				
				
			// inner bulge for washer plate
			translate([-iw/2, -d, 0])
				cube([iw, d+eta, ShoulderHeight+1.5]);
			
			// tail cap
			translate([0,0,0])
				sector(r=sw/2+1.5, a=180, h=ShoulderHeight+1.5, center = false);
				
			// cable guide
			for (i=[-1,1])
				translate([i* (5 + tw/2), -d - 9 + tw/2, 0])
				roundedRect([tw, 9, 8], tw/2);
				
			// cosmetic cover panel
			
			translate([0, -d+eta, ShoulderHeight + 1.5 - dw])
				rotate([0,90,180])
				right_triangle(6, 6, iw);	
			
		}

		// hollow for axle 
		translate([0,0,nut_thickness(M6_nut)+3*layers])
			cylinder(r=8/2, h=ShoulderHeight+10);
			
		// fixings
		for(i=[0,1])
			translate([0, -sw/4, ShoulderHeight/2 - 8 + i*16])
			rotate([0,90,0])
			cylinder(r=4.3/2, h=100, center=true);


		// nut trap
		translate([0,0,-eta])
			cylinder(r=nut_radius(M6_nut), h=nut_thickness(M6_nut), $fn=6);
		

		// cable-tie holes
		translate([0, -d - 3, 4])
			rotate([0, 90, 0])
			cylinder(r=4/2, h=100, center=true);
			

		// debug - chop in half
		*translate([0,-50,-10])
			cube([100,100,100]);
	}
}




module LowerArmServoBracket_stl() {
	// x+ side
	// origin is aligned with top of shoulder servo horn at joint origin
	
	$fn=24;
	
	sparLen = LowerArmLength * 0.68;
	d = 50;
	fixingSpacing = 2*(sparLen - LowerArmLength/2) - 20;
	
	//render()
	difference() {
		union() {
			translate([LowerArmWidth/2 - 3, -LowerArmLength-3, -40])
				roundedRectX([3, d, 38], 3);
				
			// i-beam top/bottom
			for (z=[0,1])
				translate([LowerArmWidth/2 - 6, -LowerArmLength, -5 - z*(35)])
				cube([5, d - 6, 3]);
		
		}
	
		// arm fixings
		for(i=[-1,1])
			translate([0, -LowerArmLength + d - 2*tw, -1.5-ShoulderHeight/2 + i*10])
			rotate([0,90,0])
			cylinder(r=4.3/2, h=100, center=true);
	
		// hollow for servo fixings
		for (y=[1], z=[0,1])
			translate([LowerArmWidth/2 - 4, -34 - y*(LowerArmLength-37), -10 - z*(27)]) {
				translate([0,-1,0])
					cube([5, 33, 5]);
			
				// screw holes
				for (i=[0:3])
					translate([4 - 2.5, 3.5 + i*8, 1 -z*7])
					cylinder(r=2.3/2, h=10, $fn=8);
					
				// countersink
				for (i=[0:3])
					translate([4 - 2.5, 3.5 + i*8, 7 -z*19])
					cylinder(r=4/2, h=10, $fn=12);
			}
			
		// hollow for servo horns
		translate([0,-LowerArmLength,-41])
			cylinder(r=22/2 + 0.5, h=100);
			
			
		// more weight loss
		for (i=[-1], y=[0,1])
			translate([0, -LowerArmLength/2  + i*(LowerArmLength/2-28) + i*y*19, -21])
			rotate([0,90,0])
			cylinder(r=16/2, h=100, center=true);			
	}
}