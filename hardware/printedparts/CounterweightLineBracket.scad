module CounterweightLineBracket_stl() {
	w = ShoulderWidth;
	d = 2*tw;
	
    printedPart("printedparts/CounterweightLineBracket.scad", "Counterweight Line Bracket", "CounterweightLineBracket_stl()") {

        view(t=[-4, -1, 4], r=[48,0,54], d=734);

        if (UseSTL) {
            import(str(STLPath, "CounterweightLineBracket.stl"));
        } else {
            render()
            difference() {
                union() {
                    hull() {
                        translate([-w/2, -d/2, -tw])
                            cube([w, d, tw]);

                        translate([0,0,-2*tw])
                            cylinder(r=4/2, h=2*tw, $fn=12);		
                    }
                }

                // hole for line
                cylinder(r=3/2, h=1200, center=true);

            }
        }
    }
}