module HandAssembly() {
	
	assembly("Hand");
		
		
	WristBracket_stl();
		
	
	translate([
		dynamixel_height(DYNAMIXELAX12)/2 + dynamixel_horn_thickness(DYNAMIXELAX12) -2,
		0,
		-dynamixel_depth(DYNAMIXELAX12) + 13 - tw
	])
		rotate([-90,0,-90])
		{
			DynamixelAX12();
			
			rotate([0,0,SpoonAngle])
				SpoonHolder_stl();
		}
		

	end("Hand");
	
}


module WristBracket_stl() {
	// x+ side
	// origin is aligned with top of shoulder servo horn at joint origin
	
	sw = dynamixel_width(DYNAMIXELAX12)-6; 
	w = dynamixel_height(DYNAMIXELAX12);
	h = tw;
	d = dynamixel_width(DYNAMIXELAX12);
	
	
	fixingSpacing = 2*(sparLen - LowerArmLength/2) - 20;
	
	render()
	difference() {
		union() {
			hull() {
				translate([0,0,-h])
					cylinder(r=12, h=h);
			
				translate([-w/2, -d/2, -h])
					roundedRect([w, d, h], 2);
				
			}
				
			// i-beam top/bottom
			for (i=[0,1])
				translate([-w/2 + i*(w-3), -d/2+3, -h-5+eta + 0.2])
				cube([3, d-6, 7]);
		
		}
	
		
		// hollow for horn fixings
		for (i=[0:3])
				translate([0, 0, 0])
				rotate([0,0,i*90])
				translate([0,16/2, 0]) {
					// through hole
					translate([0,0,0])
						cylinder(r=2.3/2, h=100, center=true);
				
					// CS
					translate([0,0, -h-eta])
						cylinder(r=5/2, h=tw/2);
				}
		
	
		// hollow for servo side fixings
		for (y=[0,1], x=[0,1])	
			mirror([x,0,0])
			mirror([0,y,0])
			translate([0, 0, -h-2.5]) {
				translate([w/2-3-5, 25.5/2-8, 0])
					cube([5, 8, 20]);
					
				translate([w/2-3-5, -25.5/2, 2.5-eta])
					cube([5, 22.5, 1]);
			
				// screw holes
				translate([ w/2-5, 8, 4 - 2.5])
					rotate([0,90,0])
					cylinder(r=2.3/2, h=10, $fn=8);
					
				// countersink
				translate([w/2-1, 8, 4 - 2.5])
					rotate([0,90,0])
					cylinder(r=4/2, h=10, $fn=12);
			}
			
		// central hole for horn fixing
		cylinder(r=6/2, h=100, center=true);
						
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
	
	offsetY = 18;
	offsetX = 20;

	render()
	difference() {
		union() {
			hull() {
				// plate for servo horn
				translate([0,0,0])
					cylinder(r=22/2, h=tw);
				
				// back tab
				translate([-offsetX - tabw/2, offsetY, 0])
					roundedRect([tabw, tw, tw], tw/2);
					
				// back tab 2
				translate([-offsetX - tabw/2, offsetY + st + tw, 0])
					roundedRect([tabw, dw, tw], dw/2);
			}	
				
			hull() {
				// plate for servo horn
				translate([0,0,0])
					cylinder(r=22/2, h=tw);
			
				// front tab
				translate([offsetX - tabw/2, offsetY, 0])
					roundedRect([tabw, tw, tw], tw/2);
					
				// cuper holder tab
				translate([offsetX + tabw/2 - hh + tw, offsetY + st + dw + hg , tw])
					rotate([0,180, -90])
					trapezoidPrism(dw, hg, hh-tw, hg-dw, tw, center=false);
				
			} 
			
			// back tab
			translate([-offsetX - tabw/2, offsetY, dw - tabh])
				roundedRect([tabw, tw, tabh], tw/2);
			
			// back tab 2
			translate([-offsetX - tabw/2, offsetY + st + tw, dw - tabh])
				roundedRect([tabw, dw, tabh], dw/2);
			
			// back tab bridge
			hull() {
				// back tab
				translate([-offsetX - tabw/2, offsetY, dw - tabh - dw+eta])
					roundedRect([tabw, tw, dw], tw/2);
			
				// back tab 2
				translate([-offsetX - tabw/2, offsetY + st + tw, dw - tabh - dw+eta])
					roundedRect([tabw, dw, dw], dw/2);
			}
			
			// back web
			translate([-offsetX + tabw/2 -dw, offsetY + tw - 1, -12])
				cube([2perim, st + dw, 14]);
			
			
			// front tab
			translate([-offsetX - tabw/2 + (2*offsetX), offsetY, - tabh])
				roundedRect([tabw, tw, tabh + dw], tw/2);
				
			// center spring
			hull() {
				translate([- tabw/2, offsetY + tw + perim, dw - tabh])
					cylinder(r=perim, h=tabh/2);
					
				translate([offsetX + tabw/2 - hh + tw, offsetY + st + dw + hg + dw/2 ,  - tabh + dw])
					cylinder(r=perim, h=tabh);
			}	
				
					
			// cuper holder
			translate([offsetX + tabw/2 - hh + tw, offsetY + st + dw + hg ,  dw])
					rotate([0,180, -90])
					trapezoidPrism(dw, hg, hh-tw, hg-dw, tabh+dw, center=false);
					
			// cup holder bridge
			hull() {
				translate([offsetX - tabw/2, offsetY, - tabh - dw])
					roundedRect([tabw, tw, dw], tw/2);
					
				translate([offsetX + tabw/2 - hh + tw, offsetY + st + dw + hg ,  - tabh])
					rotate([0,180, -90])
					trapezoidPrism(dw, hg, hh-tw, hg-dw, dw, center=false);
			}
			
			// fillets
			for (i=[0,1])
				mirror([i,0,0])
				translate([-offsetX + 2, offsetY+1, 0])
				rotate([0,90,180 + 20])
				right_triangle(8, 9, dw, center = true);
				
				
			// cup holder web
			translate([offsetX - tabw/2 + 1, offsetY + tw - 1, -6])
				cube([2perim, st + hg + 2, SAM3_height/2 - sw/2]);
			
			
		}
		
		// servo horn fixings
		for (i=[0:3])
			translate([0, 0, 0])
			rotate([0,0,i*90])
			translate([0,16/2, 0]) {
				// through hole
				translate([0,0,0])
					cylinder(r=2.3/2, h=100, center=true);
			
				// CS
				translate([0,0, dw])
					cylinder(r=5/2, h=10);
			}
			
		// centre hole for servo horn
		cylinder(r=6/2, h=100, center=true);
    			
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