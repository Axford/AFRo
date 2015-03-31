module TorsoEndStopBracket_stl() {

	h = 5;
	
    printedPart("printedparts/TorsoEndStopBracket.scad", "Torso EndStop Bracket", "TorsoEndStopBracket_stl()") {

        view(t=[-4, -1, 4], r=[48,0,54], d=734);

        if (UseSTL) {
            import(str(STLPath, "TorsoEndStopBracket.stl"));
        } else {
            render()
            difference() {
                linear_extrude(h) 
                    difference() {
                        union() {
                            circle(r=TorsoPostDia/2 + dw);			

                            // clamp tabs
                            translate([-tw, -TorsoPostDia/2 - 18, 0])
                                square([2*tw, 18]);

                        }

                        // Torso post
                        circle(r=TorsoPostDia/2);

                        // clamp slot
                        translate([-1, -TorsoPostDia/2 - 19, 0])
                                square([2, 30]);

                    }

                // servo fixings
                for(i=[0,1])
                    translate([0,-EndStopOffsetY - i*(microswitch2_fixingCentres),h/2])
                    rotate([0,90,0])
                    cylinder(r=microswitch2_fixingRadius, h=100, center=true);
            }
        }
    }
}