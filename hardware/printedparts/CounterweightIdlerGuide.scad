module CounterweightIdlerGuide_stl() {
	bw = ball_bearing_width(BB624);
	bod = ball_bearing_od(BB624) + 0.4;
	
    printedPart("printedparts/CounterweightIdlerGuide.scad", "Counterweight Idler Guide", "CounterweightIdlerGuide_stl()") {

        view(t=[-4, -1, 4], r=[48,0,54], d=734);

        if (UseSTL) {
            import(str(STLPath, "CounterweightIdlerGuide.stl"));
        } else {
            render()
            difference() {
                union() {
                    for (i=[0,1])
                        mirror([0,0,i])
                        translate([0,0,-eta])
                        cylinder(r1=bod/2+2perim, r2=bod/2+dw, h=bw/2);
                }

                // hollow for bearing
                *cylinder(r=bod/2, h=100, center=true);

                // hollow for M4 bolt
                cylinder(r=4.3/2, h=100, center=true);
            }
        }
    }
}