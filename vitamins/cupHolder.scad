// Cup holder/adapter, for use with AFRo

cupHolder_od = 78;
cupHolder_height = 10;
cupHolder_hookWidth = 20;
cupHolder_hookGap = 5;
cupHolder_hookHeight = 20;

cupHolderCon = [[0, -cupHolder_od/2 - cupHolder_hookGap - 2*1.8, 78],[0,0,-1],0];  // positioned at top edge of outside surface of hook, pointing down


module cupHolderAssembly() {
	// local origin is centred at base of cup

	cup();
	
	translate([0,0,78])
		cupHolder_stl();
		
	connector(cupHolderCon);
}


module cupHolder_stl() {
	// local origin as centred at top edge of holder
	// hook is at y-
	
	od1 = cupHolder_od - 1;
	od2 = cupHolder_od;
	h = cupHolder_height;
	wall = 1.4;
	hw = cupHolder_hookWidth;
	hg = cupHolder_hookGap;
	hh = cupHolder_hookHeight;
	
	
	color(plastic_color)
		render()
		difference() {
			union() {
				translate([0,0,-h])
					conicalTube(od1/2+wall, od1/2, od2/2+wall, od2/2, h);
				
				// hook base
				translate([-hw/2, -od1/2 - hg - 2*dw , -tw])
					cube([hw, hg + 2*dw, tw]);
				
				// hook
				translate([-hw/2, -od1/2 - hg - 2*dw , 0])
					rotate([-90,0,0])
					trapezoidPrism(hw/2, hw, hh, hw/4, dw, center=false);
					
				// slide plate
				translate([-hw/4, -od1/2-hg + dw, 0])
					rotate([-90,0,-90])
					trapezoidPrism(2perim, hg, hh, hg-2perim, hw/2, center=false);
					
				// buffer plate
				translate([hw/4, -od1/2 -dw, 0])
					rotate([-90,0,90])
					trapezoidPrism(2perim, dw, hh, dw, hw/2, center=false);
			}
		
		}
}


module cup() {
	od1 = 59;
	od2 = 78;
	h1 = 87;
	h2 = 22;

	color(grey20)
		render()
		difference() {
			union() {
				cylinder(r=od1/2, h=2);
			
				conicalTube(od1/2, od1/2-perim, od2/2, od2/2-perim, h1);
				
				translate([0,0,h1])
					tube(od2/2, od2/2-perim, h2);
			}
		
		}
}
