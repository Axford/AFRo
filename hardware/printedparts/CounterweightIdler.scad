module CounterweightIdler_stl() {
	// extends in y+
	// sits on top of Torso smooth rod
	rod = TorsoRodDia;
	h=-CounterweightIdler_offsetZ + 4 + tw;
	od = rod + 2*dw;
	
	bw = ball_bearing_width(BB624);
	slotw = bw + 2*washer_thickness(M4_washer) + 1;  // room for small washers and some clamping pressure
	
	w = slotw + 2*dw;
	
    printedPart("printedparts/CounterweightIdler.scad", "Counterweight Idler", "CounterweightIdler_stl()") {

        view(t=[-4, -1, 4], r=[48,0,54], d=734);

        if (UseSTL) {
            import(str(STLPath, "CounterweightIdler.stl"));
        } else {
            render()
            difference() {
                union() {
                    // cap
                    cylinder(r=rod/2+dw, h=dw);

                    hull() {
                        // sleeve
                        translate([0,0,-h + dw - 5])
                            cylinder(r=od/2, h=h + 5);

                        // axle housing
                        translate([-w/2, CounterweightIdler_offsetY - tw - 2, -h+dw])
                            cube([w, 4+2*tw, h]);
                    }
                }

                // hollow for smooth rod
                translate([0,0,-50])
                    cylinder(r=rod/2+0.2, h=50);

                // hollow for bearing
                translate([-slotw/2, od/2, -50])
                    cube([slotw, 50, 100]);

                // slot for clamp
                translate([0,4,0])
                    cube([2,12,100], center=true);

                // hollow for bearing axle
                translate([0, CounterweightIdler_offsetY, CounterweightIdler_offsetZ])
                    rotate([0,90,0])
                    cylinder(r=4.3/2, h=100, center=true);
            }
        }
    }
}