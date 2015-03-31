module BaseBracket_stl() {
	// origin at surface of base plate (i.e. z=3)
	// centred on bearing post

	h = NEMA_length(NEMA17);

	sw = NEMA_width(NEMA17) + 0.2;  // stepper width + with a little tolerance
	d = 2 * (TorsoPostAxisOffset - NEMA_width(NEMA17)/2 - 12);
	
	printedPart("printedparts/BaseBracket.scad", "Base Bracket", "BaseBracket_stl()") {

        view(t=[-5, 10, 16]);

        if (UseSTL) {
            import(str(STLPath, "BaseBracket.stl"));
        } else {
            render()
            difference() {
                union() {

                    // post support
                    //cylinder(r=d/2, h=h);

                    // outer box
                    translate([-sw/2, -d/2, 0])
                        roundedRect([sw, d, h],5);

                }

                // hollow for post
                translate([0,0,-1])
                    cylinder(r=TorsoPostDia/2, h=PostLength);

                // slot for post clamp
                translate([-sw/2-1,-dw/2,-1])
                    cube([sw+2,dw,h+2]);

                // post clamp fixings - through bolts!  Allow for M5, will prob use smaller
                for (i=[0,1], j=[0,1])
                    mirror([j,0,0])
                    translate([-TorsoPostDia/2 - 5, 0, 10 + i*(h-20)])
                    rotate([90,0,0])
                    cylinder(r=5.3/2, h=100, center=true);

            }
        }
	}
}