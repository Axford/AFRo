//
// Robobuilder SAM-3 Servo
//
// GNU GPL v2
// damian@axford.me.uk
//


SAM3_width = 20;
SAM3_height = 27.6;
SAM3_depth = 36;
SAM3_hubOffset = 9.35;
SAM3_hubToBase = SAM3_depth - SAM3_hubOffset;

module RobobuilderSAM3() {
	// local coordinate system places origin centred on upper surface of body, hub at x=y=0
	// body of servo extends along y-

    // body
    w = 20;
    d = 36;
    h = 27.6;
    cr = 7;
    
    hubOffset = 9.35;
    
    vitamin(str("RobobuilderSAM-3"));
   
   	// top horn
    color(grey20) 
    	difference() {
    		union() {
    			cylinder(r=7/2, h=4);
    		
    			translate([0,0,3.5])
    				cylinder(r=21/2, h=3.5);
    		}
    		
    		// M2 fixing holes
    		for(i=[0:3])
    			rotate([0,0,i*90 + 45])
    			translate([15/2, 0, 0])
    			cylinder(r=2/2, h=100, center=true);
    			
    		// M2 nut traps
    		for(i=[0:3])
    			rotate([0,0,i*90 + 45])
    			translate([15/2, 0, 3.5-eta])
    			cylinder(r=screw_head_radius(M2p5_cap_screw), h=1.6, $fn=6);
    			
    		// big fixing holes
    		for(i=[0:3])
    			rotate([0,0,i*90])
    			translate([14/2, 0, 0])
    			cylinder(r=4/2, h=100, center=true);
    		
   		}
   		
   	// mid horn
    color(grey80) 
    	difference() {
    		translate([0,-0.5,-h/2])
    			roundedRect([4.7, 7.8, 8],1,center=true);
    			
    		translate([0,0,-h/2])
    			rotate([0,90,0])
    			cylinder(r=3.8/2, h=100, center=true);
    	}
    
    // body
     color(grey20)
     	render()
     	union() {
			difference() {
				union() {
					hull() {
						translate([-w/2+cr, hubOffset - cr, -h])
							cylinder(r=cr, h=h);
						
						translate([w/2-cr, hubOffset - cr, -h])
							cylinder(r=cr, h=h);
						
						translate([-w/2+2, -d + hubOffset+2, -h])
							cylinder(r=2, h=h);
						
						translate([w/2-2, -d + hubOffset +2, -h])
							cylinder(r=2, h=h);
					
					}
				
				}
			
				// notch for mid horn
				translate([-w/2 - 1, -(16-hubOffset), -(h-7)/2 -7])
					cube([w+2, 16+1 , 7]);
				
				// mid through holes
				for (i=[0,1])
					translate([-w/2 + 1.95 + i*(w-2*1.95), hubOffset - d + 22.27, -h/2])
					cylinder(r=2/2, h=100, center=true);
					
				// mid nut traps
				for (i=[0,1])
					translate([-w/2 + 1.95 + i*(w-2*1.95), hubOffset - d + 22.27, -1.6])
					rotate([0,0,30])
					cylinder(r=screw_head_radius(M2p5_cap_screw), h=100, $fn=6);
				
				for (i=[0,1])
					translate([-w/2 + 1.95 + i*(w-2*1.95), hubOffset - d + 22.27, -h+(h-7)/2-1.6])
					rotate([0,0,30])
					cylinder(r=screw_head_radius(M2p5_cap_screw), h=1.7, $fn=6);
				
				
				// notch for connector
				translate([-w/2-eta, hubOffset -d + 4, -h+4])
					cube([5, 10, 12.5]);
		
				// top/bot back shelves
				translate([-w/2-1, hubOffset-d-1, -2.8])
					cube([w+2,4.3+1,3]);	
				translate([-w/2-1, hubOffset-d-1, -h-0.2])
					cube([w+2,4.3+1,3]);
				
				// back through holes
				for (i=[0,1])
					translate([-w/2 + 1.95 + i*(w-2*1.95), hubOffset - d + 2.25, -h/2])
					cylinder(r=2/2, h=100, center=true);
					
				// back upper nut traps
				for (i=[0,1])
					translate([-w/2 + 1.95 + i*(w-2*1.95), hubOffset - d + 2.25, -2.8-1.6])
					rotate([0,0,30])
					cylinder(r=screw_head_radius(M2p5_cap_screw)+0.2, h=1.7, $fn=6);
		
			}
			
			// nubbins
			translate([-4.4/2, hubOffset - d + 2, -h])
				cube([4.4, 3, h]);
     	}
    
    // connector
    color(grey80)
    	translate([-w/2-eta, hubOffset -d + 4, -h+4])
		cube([5, 10, 1]);
    
}