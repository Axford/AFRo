


module CableGuideAssembly() {

	assembly("assemblies/CableGuide.scad", "Cable Guide", "CableGuideAssembly()") {

        // alu channel
        translate([ShoulderWidth/2, TorsoRodSpacing/2 - 12 + 10/2, 0])
            color(alu_color)
            rotate([0,0,-90])
            aluAngle(10,10,TorsoRodLength - 80,1);
        
        
        // bottom bracket
        CableGuideBottomBracket_stl();
    
	}
}



module CableGuideBottomBracket_stl() {
	bod = ball_bearing_od(TorsoBearing);
	bh =  ball_bearing_width(TorsoBearing);
	nl = NEMA_length(NEMA17);

	t = TorsoBaseThickness;
	
	x1 = 8;
	w = ShoulderWidth/2 - x1;
	y1 = TorsoRodSpacing/2 - 12 - 10/2;
	d = 25;

	color(Level2PlasticColor)
	render()
	difference() {
		union() {
			hull() {
				translate([x1, y1, 0])
					cube([w, 10, t]);
					
				translate([x1 + w/2, y1 + d - w/2, 0])
					cylinder(r=w/2, h= tw);
			}
		}
		
		// hollow for base
		translate([0,0,-1])
			hull() {
				for (i=[0,1])
					mirror([0,i,0])
					translate([0, TorsoRodSpacing/2, 0])
					cylinder(r=TorsoRodDia/2 + tw , h=t+2);
			
				translate([0,0, 0])
					cylinder(r=bod/2 + 2 + tw , h=t+2);
			
			}
		
		// hole for cable tie
		translate([x1 + w/2, y1 + d - w/2, -1])
			cylinder(r=2, h=t+2);
		
			
		// clamping bolt holes
		for (i=[0,1])
			mirror([0,i,0])
			translate([-1, TorsoRodSpacing/2 - 12, t/2]) {
			
				rotate([0,90,0])
					cylinder(r=3.3/2, h=100, center=true);
					
				// nut trap
				*translate([8,0,0])
					rotate([0,90,0])
					rotate([0,0,30])
					cylinder(r=nut_radius(M3_nut)+0.1, h=100, $fn=6);
					
				// cs
				*translate([-8,0,0])
					rotate([0,-90,0])
					rotate([0,0,30])
					cylinder(r=washer_radius(M3_washer)+0.1, h=100);
			
			}
		
	}
}

