module HandAssembly() {
	
	assembly("Hand");
		
		
	WristBracket_stl();
		
	
	translate([0,0, -SAM3_hubToBase - tw])
		rotate([90,0,90])
		rotate([0,0,180])
		translate([0,0,SAM3_height/2]) {
			RobobuilderSAM3();
		
			rotate([0,0,SpoonAngle])
			SpoonHolder_stl();	
		}
		
	
	
	end("Hand");
	
}


module WristBracket_stl() {
	difference() {
		union() {
			hull() {
				// plate to mate to dynamixel horn
				translate([0,0, -tw])
					cylinder(r=16/2 + tw, h=tw);
			
				translate([-(SAM3_height+0.4)/2, -(SAM3_width+3)/2, -tw])
					roundedRect([SAM3_height + 0.4, SAM3_width+3, tw],1.5); 
			
			}
			
			// SAM3 tabs
			for (i=[0,1])
				mirror([i,0,0])
				translate([SAM3_height/2-2.8, -(SAM3_width+3)/2, -tw-4.3])
				roundedRect([3, SAM3_width+3, 4.4],1.5);
			
		}
		
		// servo horn fixings
		for (i=[0:3])
			rotate([0,0,i*90])
			translate([0,16/2, 0]) {
				translate([0,0,-eta])
					cylinder(r=2.3/2, h=100, center=true);
		
				translate([0,0, -tw-eta])
					cylinder(r=5/2, h=(tw-dw), center=false);
			}
			
		// SAM3 through holes
		for(i=[0,1])
			translate([0, -SAM3_width/2 + 1.95 + i*(SAM3_width-2*1.95), -tw-2.25])
			rotate([0,90,0])
			cylinder(r=2.3/2, h=100, center=true);
			
		// nubbin
		translate([-SAM3_height/2-1, -4.8/2, -tw-4.3-eta])
			cube([SAM3_height+2, 4.8, 3]);
	
	}
}

module SpoonHolder_stl() {

	// spoon dims
	st = 3;  // thickness
	sw = 12;  // width

	// mag dims
	md = 6;
	mt = 3;
	
	hg = cupHolder_hookGap;
	hh = cupHolder_hookHeight;
	
	tabw = md + 2*dw;
	tabh = SAM3_height/2 + 7 + sw/2 + dw + dw;
	
	offsetY = 12;
	offsetX = 20;

	difference() {
		union() {
			hull() {
				// plate for servo horn
				translate([0,0,7])
					cylinder(r=21/2, h=dw);
				
				// back tab
				translate([-offsetX - tabw/2, offsetY, 7])
					roundedRect([tabw, tw, dw], tw/2);
					
				// back tab 2
				translate([-offsetX - tabw/2, offsetY + st + tw, 7])
					roundedRect([tabw, dw, dw], dw/2);
			}	
				
			hull() {
				// plate for servo horn
				translate([0,0,7])
					cylinder(r=21/2, h=dw);
			
				// front tab
				translate([offsetX - tabw/2, offsetY, 7])
					roundedRect([tabw, tw, dw], tw/2);
					
				// cuper holder tab
				translate([offsetX + tabw/2 - hh + tw, offsetY + st + dw + hg , 7 + dw])
					rotate([0,180, -90])
					trapezoidPrism(dw, hg, hh-tw, hg-dw, dw, center=false);
				
			} 
			
			// back tab
			translate([-offsetX - tabw/2, offsetY, 7 + dw - tabh])
				roundedRect([tabw, tw, tabh], tw/2);
			
			// back tab 2
			translate([-offsetX - tabw/2, offsetY + st + tw, 7 + dw - tabh])
				roundedRect([tabw, dw, tabh], dw/2);
			
			// back tab bridge
			hull() {
				// back tab
				translate([-offsetX - tabw/2, offsetY, 7 + dw - tabh - dw+eta])
					roundedRect([tabw, tw, dw], tw/2);
			
				// back tab 2
				translate([-offsetX - tabw/2, offsetY + st + tw, 7 + dw - tabh - dw+eta])
					roundedRect([tabw, dw, dw], dw/2);
			}
			
			// back web
			translate([-offsetX + tabw/2 -dw, offsetY + tw - 1, -6])
				cube([2perim, st + dw, SAM3_height/2 + 7 - sw/2]);
			
			
			// front tab
			translate([-offsetX - tabw/2 + (2*offsetX), offsetY, 7  - tabh])
				roundedRect([tabw, tw, tabh + dw], tw/2);
				
			// center spring
			hull() {
				translate([- tabw/2, offsetY + tw + perim, 7 + dw - tabh])
					cylinder(r=perim, h=tabh/2);
					
				translate([offsetX + tabw/2 - hh + tw, offsetY + st + dw + hg + dw/2 , 7 - tabh + dw])
					cylinder(r=dw/2, h=tabh);
			}	
				
					
			// cuper holder
			translate([offsetX + tabw/2 - hh + tw, offsetY + st + dw + hg , 7 + dw])
					rotate([0,180, -90])
					trapezoidPrism(dw, hg, hh-tw, hg-dw, tabh+dw, center=false);
					
			// cup holder bridge
			hull() {
				translate([offsetX - tabw/2, offsetY, 7 - tabh - dw])
					roundedRect([tabw, tw, dw], tw/2);
					
				translate([offsetX + tabw/2 - hh + tw, offsetY + st + dw + hg , 7 - tabh])
					rotate([0,180, -90])
					trapezoidPrism(dw, hg, hh-tw, hg-dw, dw, center=false);
			}
			
			// fillets
			for (i=[0,1])
				mirror([i,0,0])
				translate([-offsetX + 2, offsetY+1, 7])
				rotate([0,90,180 + 20])
				right_triangle(8, 10, dw, center = true);
				
				
			// cup holder web
			translate([offsetX - tabw/2 + 1, offsetY + tw - 1, -6])
				cube([2perim, st + hg + 2, SAM3_height/2 + 7 - sw/2]);
				
			// back stop
			*hull() {
				translate([-offsetX - tabw/2 - dw - tw, offsetY + tw, 7 + dw -tabh])
					cube([dw, tw, 9]);
					
				translate([-offsetX - tabw/2 - dw/2, offsetY + tw/2 + dw/2, 7 + dw -tabh + 9])
					cylinder(r=dw/2, h=tabh-9);
			}
			
			// back stop support
			*hull() {
				translate([-offsetX - tabw/2 + tw/2, offsetY + tw/2, 7 +dw -tabh + 9])
					cylinder(r=tw/2, h=tabh-9);
					
				translate([-offsetX - tabw/2 - dw/2, offsetY + tw/2 + dw/2, 7 + dw -tabh + 9])
					cylinder(r=dw/2, h=tabh-9);
			}
			
		}
		
		// M2 fixing holes
		for(i=[0:3])
			rotate([0,0,i*90 + 45])
			translate([15.5/2, 0, 7-eta])
			cylinder(r=2.3/2, h=dw+2);
			
		// CS
		for(i=[0:3])
			rotate([0,0,i*90 + 45])
			translate([15/2, 0, 7+dw+layers])
			cylinder(r=screw_head_radius(M2p5_cap_screw), h=5);
			
		// centre hole for access to servo horn screw
		cylinder(r=3.5/2, h=100, center=true);
			
		// magnet holes
		for (i=[0,1])
			translate([-offsetX + i*(2*offsetX), offsetY-eta, -SAM3_height/2])
			rotate([-90,0,0])
			cylinder(r=md/2+0.3, h=tw-1.4, $fn=16);
    			
	}
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