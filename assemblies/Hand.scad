module HandAssembly() {
	
	assembly("Hand");
		
	
	// spoon holder
	translate([0,0,-10])
		rotate([0,0,180]) {
			
			translate([0,0,-10])
				cylinder(r=30/2, h=20);
		
			translate([0,-20,0])
				Spoon();
			
		}
		
		
	
	
	end("Hand");
	
}


module Spoon() {
	// coordinate system places origin at tip of handle
	// spoon lies along y+
	color(grey80)
		union() {
			translate([-7/2, 0, 0])
				cube([7,160,2]);
	
			translate([0, 152, 0])	
				scale([4/6,1,1])
				cylinder(r=60/2, h=2);
	}
}