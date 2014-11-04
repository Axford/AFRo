module TorsoBearingCollar_stl() {
	h = ball_bearing_width(TorsoBearing) + tw;
	od = ball_bearing_od(TorsoBearing);
	id = ball_bearing_id(TorsoBearing);
	
    printedPart("printedparts/TorsoBearingCollar.scad", "Torso Bearing Collar", "TorsoBearingCollar_stl()") {

        view(t=[-5, 10, 16]);

        if (UseSTL) {
            import(str(STLPath, "TorsoBearingCollar.stl"));
        } else {
    
            difference() {
                union() {
                    // inner support
                    cylinder(r=id/2, h=h);

                    // shelf
                    cylinder(r=id/2 + 4, h=tw);

                }

                // post
                translate()
                    cylinder(r=TorsoPostDia/2+0.1, h=100, center=true);
            }
        }
    }
}