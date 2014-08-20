

module LowerArmAssembly() {
	
	assembly("LowerArm");
			
	
	// spars
	*for (i=[0,1])
		mirror([i,0,0])
		translate([LowerArmWidth/2 - 3, -LowerArmLength-5, -32])
		cube([3, LowerArmLength + 10, 22]);
		
	// end caps
	*for (i=[0,1])
		translate([0,5 -i*(LowerArmLength+10), -37])
		rotate([0,0,i*180])
		linear_extrude(32)
		donutSector2D(or=LowerArmWidth/2, ir=LowerArmWidth/2 - 3, a=180, center=false);
		
	// top/bottom plates
	for (i=[0,1])
		translate([0,0, 0 - i*45])
		difference() {
			hull() {
				translate([0,0, 0])
					cylinder(r=LowerArmWidth/2, h=3);
				
				translate([0,-LowerArmLength, -5 + i*13])
					cylinder(r=LowerArmWidth/2, h=3);
			}
			
		}
	
	
	translate([0, -LowerArmLength, -40]) {
		rotate([0,180,180])
			DynamixelAX12();
		
		rotate([0,0, WristAngle])
			HandAssembly();
	}
		
		
	
	
	end("LowerArm");
	
}