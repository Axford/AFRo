

module UpperArmAssembly() {
	
	assembly("UpperArm");
		
	// shoulder servo
	translate()
		DynamixelAX12();
		
	// elbow servo
	translate([0,-UpperArmLength,0]) {
		rotate([0,0,180])
			DynamixelAX12();
			
		// lower arm
		rotate([0, 0, ElbowAngle]) 
			LowerArmAssembly();
	}
				
				
	UpperArmSpar_stl();
	
	// other spar
	mirror([1,0,0])
		UpperArmSpar_stl();
	
	// spars
	*for (i=[0,1])
		mirror([i,0,0])
		translate([UpperArmWidth/2 - 3, -UpperArmLength-5, -32])
		cube([3, UpperArmLength + 10, 22]);
		
	// end caps
	*for (i=[0,1])
		translate([0,5 -i*(UpperArmLength+10), -37])
		rotate([0,0,i*180])
		scale([1, 11/16, 1])
		linear_extrude(32)
		donutSector2D(or=UpperArmWidth/2, ir=UpperArmWidth/2 - 3, a=180, center=false);
		
	// top/bottom plates
	*for (i=[0,1])
		translate([0,0, -5 - i*35])
		difference() {
			hull() {
				translate([0,0, 0])
					cylinder(r=UpperArmWidth/2, h=3);
				
				translate([0,-UpperArmLength,0])
					cylinder(r=UpperArmWidth/2, h=3);
			}
			
		}
	
	
	end("UpperArm");
	
}


module UpperArmSpar_stl() {
	// x+ side
	// origin is aligned with top of shoulder servo horn at joint origin
	
	$fn=24;
	
	render()
	difference() {
		union() {
			translate([UpperArmWidth/2 - 3, -UpperArmLength-3, -40])
				roundedRectX([3, UpperArmLength + 6, 38], 3);
				
			// servo fixing tabs
			for (y=[0,1], z=[0,1])
				translate([UpperArmWidth/2 - 6, -34 - y*(UpperArmLength-37), -5 - z*(35)])
				cube([5, 33, 3]);
				
			// i-beam top/bottom
			for (z=[0,1])
				translate([UpperArmWidth/2 - 6, -UpperArmLength, -5 - z*(35)])
				cube([5, UpperArmLength, 3]);
		
		}
	
	
		// hollow for servo fixings
		for (y=[0,1], z=[0,1])
			translate([UpperArmWidth/2 - 4, -34 - y*(UpperArmLength-37), -10 - z*(27)]) {
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
		for (y=[0,1])
			translate([0,-y*UpperArmLength,-10])
			cylinder(r=22/2 + 0.5, h=10);
			
		// weight loss
		for (i=[-2:2])
			translate([0, -UpperArmLength/2  + i*25, -21])
			rotate([0,90,0])
			scale([1.4,1,1])
			cylinder(r=22/2, h=100, center=true);
			
		// more weight loss
		for (i=[-1,1], y=[0,1])
			translate([0, -UpperArmLength/2  + i*(UpperArmLength/2-28) + i*y*19, -21])
			rotate([0,90,0])
			cylinder(r=16/2, h=100, center=true);
			
		// notch for servo bottom locating lugs
		*for (i=[0,1])
			translate([UpperArmWidth/2 - 9, -33 - i*(UpperArmLength-57), -41])
			cube([5, 9, 4]);			
	}
}