

module LowerArmAssembly() {
	
	assembly("LowerArm");
			
	
	LowerArmUpperPlate_stl();	
	
	translate([0,0,-40])
		LowerArmLowerPlate_stl();
	
	LowerArmSpar_stl();
	
	mirror([1,0,0])
		LowerArmSpar_stl();
	
	
	translate([0, -LowerArmLength, -42]) {
		rotate([0,180,180])
			DynamixelAX12();
		
		rotate([0,0, WristAngle])
			HandAssembly();
	}
	
	end("LowerArm");
	
}


module LowerArmLowerPlate_stl() {

	// origin is centred on bottom of servo horn
	
	
	$fn=24;
	
	sparLen = LowerArmLength * 0.68;
	fixingSpacing = 2*(sparLen - LowerArmLength/2) - 20;
	
	bt = 1.8; // bushing thickness
	
	tabW = 3.2 + 2*dw +1;
	
	
	color(plastic_color)
	difference() {
		union() {
			hull() {
				translate([0,0, -tw - bt])
					cylinder(r=16/2 + tw, h=tw);
				
				translate([-LowerArmWidth/2, -sparLen + 5, -tw - bt])
					roundedRect([LowerArmWidth, sparLen/2, tw],4);
			}
			
			// thicker bits to mate to spars
			for (i=[0,1],j=[0,1]) 
				translate([LowerArmWidth/2-5 - j*(LowerArmWidth-10), 
					       -LowerArmLength/2 - fixingSpacing/2 + i*fixingSpacing, 
					       -bt+eta])
				cylinder(r=3.2/2 + dw, h=bt);
			
		}
		
		// servo bushing
		cylinder(r=8/2, h=100, center=true);
		
			
		// hollow for plate fixings
		for (i=[0,1],j=[0,1])
			translate([LowerArmWidth/2-5 - j*(LowerArmWidth-10), -LowerArmLength/2 - fixingSpacing/2 + i*fixingSpacing, 0])
			{
				translate([0,0, -bt - tw + dw])
					cylinder(r=3.2/2, h=100);
				
				// CS
				translate([0,0,-bt-tw-eta])
					cylinder(r=screw_head_radius(M3_cap_screw)+0.3, h=dw-layers);
			}
		
		// weight loss
		for (i=[-1:2])
			translate([0, -LowerArmLength/2  + 13 + i*25, -21])
			scale([1,1,1])
			cylinder(r=22/2, h=100, center=true);
		
	}
}


module LowerArmUpperPlate_stl() {

	$fn=24;
	
	sparLen = LowerArmLength * 0.68;
	fixingSpacing = 2*(sparLen - LowerArmLength/2) - 20;
	
	tabW = 3.2 + 2*dw +1;
	
	difference() {
		union() {
			hull() {
				translate([0,0, 0])
					cylinder(r=16/2 + tw, h=tw);
				
				translate([-LowerArmWidth/2, -sparLen + 5, 0])
					roundedRect([LowerArmWidth, sparLen/2, tw],4);
			}
			
			// thicker bits to mate to spars
			for (i=[0,1],j=[0,1]) 
				translate([LowerArmWidth/2-5 - j*(LowerArmWidth-10), -LowerArmLength/2 - fixingSpacing/2 + i*fixingSpacing, -2])
				cylinder(r=3.2/2 + dw, h=3);
			
		}
		
		// servo horn fixings
		for (i=[0:3])
			translate([0, 0, 0])
			rotate([0,0,i*90])
			translate([0,16/2, 0]) {
				translate([0,0,-eta])
					cylinder(r=2.3/2, h=dw, center=true);
		
				translate([0,0, dw + layers])
					cylinder(r1=5/2, h=100, center=false);
			}
			
		// hollow for plate fixings
		for (i=[0,1],j=[0,1])
			translate([LowerArmWidth/2-5 - j*(LowerArmWidth-10), -LowerArmLength/2 - fixingSpacing/2 + i*fixingSpacing, 0])
			{
				translate([0,0,-2-eta])
					cylinder(r=3.2/2, h=dw - layers);
				
				// CS
				translate([0,0,dw])
					cylinder(r=screw_head_radius(M3_cap_screw)+0.3, h=100);
			}
		
		// weight loss
		for (i=[-1:2])
			translate([0, -LowerArmLength/2  + 13 + i*25, -21])
			scale([1,1,1])
			cylinder(r=22/2, h=100, center=true);
		
	}
}




module LowerArmSpar_stl() {
	// x+ side
	// origin is aligned with top of shoulder servo horn at joint origin
	
	// fixings to upper/lower plates are spaced evenly about centre
	
	$fn=24;
	
	sparLen = LowerArmLength * 0.68;
	fixingSpacing = 2*(sparLen - LowerArmLength/2) - 20;
	
	render()
	difference() {
		union() {
			*translate([LowerArmWidth/2 - 3, -LowerArmLength-3, -40])
				roundedRectX([3, LowerArmLength + 6, 38], 3);
				
			translate([LowerArmWidth/2 - 3, -LowerArmLength-3, -40])
				roundedRectX([3, sparLen + 6, 38], 3);
				
			// servo fixing tabs
			*for (y=[1], z=[0,1])
				translate([LowerArmWidth/2 - 6, -34 - y*(LowerArmLength-37), -5 - z*(35)])
				cube([5, 33, 3]);
				
			// i-beam top/bottom
			for (z=[0,1])
				translate([LowerArmWidth/2 - 6, -LowerArmLength, -5 - z*(35)])
				cube([5, sparLen, 3]);
				
			// tabs for plate fixings
			for (i=[0,1],z=[0,1]) 
				translate([LowerArmWidth/2-5, -LowerArmLength/2 - fixingSpacing/2 + i*fixingSpacing, -3.5 - z*(35)])
				cylinder(r=3.2/2 + dw, h=3, center=true);
		
		}
	
	
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
			
		// hollow for plate fixings
		for (i=[0,1])
			translate([LowerArmWidth/2-5, -LowerArmLength/2 - fixingSpacing/2 + i*fixingSpacing, -20])
			cylinder(r=3.2/2, h=100, center=true);
			
		// countersink for plate fixings
		for (i=[0,1],z=[0,1]) 
			translate([LowerArmWidth/2-5, -LowerArmLength/2 - fixingSpacing/2 + i*fixingSpacing, -6.5 - z*(29)])
			cylinder(r=3.2/2 + dw, h=3, center=true);
			
		// weight loss
		for (i=[-2:2])
			translate([0, -LowerArmLength/2  + i*25, -21])
			rotate([0,90,0])
			scale([1.4,1,1])
			cylinder(r=22/2, h=100, center=true);
			
		// more weight loss
		for (i=[-1], y=[0,1])
			translate([0, -LowerArmLength/2  + i*(LowerArmLength/2-28) + i*y*19, -21])
			rotate([0,90,0])
			cylinder(r=16/2, h=100, center=true);			
	}
}