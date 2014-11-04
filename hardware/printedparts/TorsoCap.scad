module TorsoCap_stl() {
	bod = ball_bearing_od(TorsoBearing);
	bh =  ball_bearing_width(TorsoBearing);
	nw = NEMA_width(NEMA17);
	nl = NEMA_length(NEMA17);

	h = bh + dw;

	t = TorsoBaseThickness;

    printedPart("printedparts/TorsoCap.scad", "Torso Cap", "TorsoCap_stl()") {

        view(t=[-4, -1, 4], r=[48,0,54], d=734);

        if (UseSTL) {
            import(str(STLPath, "TorsoCap.stl"));
        } else {
            difference() {
                union() {

                    // bearing collar
                    cylinder(r=bod/2 + tw, h=h);

                    // post supports
                    for (i=[0,1])
                            mirror([0,i,0])
                            translate([0, TorsoRodSpacing/2, 0])
                            cylinder(r2=TorsoRodDia/2 + dw, r1=TorsoRodDia/2 + tw, h=18.5);


                    // webbing
                    hull() {
                        for (i=[0,1])
                            mirror([0,i,0])
                            translate([0, TorsoRodSpacing/2, 0])
                            cylinder(r=TorsoRodDia/2 + tw, h=t);

                        translate([0,0,0])
                            cylinder(r=bod/2 + tw, h=t);

                    }

                    // stepper mount
                    translate([-nw/2, -nl/2-tw, 0])
                        roundedRect([nw, tw, TorsoStepperZOffset], tw/2);

                    // fillet
                    translate([0, -nl/2-tw+0.5, t])
                        rotate([0,-90,180])
                        right_triangle(20, 20, dw, center = true);

                    // alternate stepper mount
                    *translate([0, -nl/2-nl+18-tw, 0])
                        hull() {
                            translate([-nw/2+7,0,0])
                                roundedRect([nw-14, tw, 1], tw/2);
                            translate([-nw/2,0,TorsoStepperZOffset-20])
                                roundedRect([nw, tw, 20], tw/2);
                        }

                    // fillet
                    *translate([0, -nl/2-nl+18-tw+0.5, t])
                        rotate([0,-90,0])
                        right_triangle(20, 20, dw, center = true);
                }

                // belt slots
                for (i=[0,1]) 
                    mirror([i,0,0])
                    translate([6, -nl/2 - 22, -1])
                    cube([5, 10, 50]);

                // motor fixings / boss
                translate([0, -nl/2 - 20, TorsoStepperZOffset]) 
                    rotate([90,0,0]) {
                    // boss
                    cylinder(r=NEMA_big_hole(NEMA17), h=50, center=true);

                    // motor fixings
                    for(a = [0: 90 : 90 * (4 - 1)])
                        rotate([0, 0, a])
                        translate([NEMA_holes(NEMA17)[0], NEMA_holes(NEMA17)[1], 0])
                        cylinder(r=screw_clearance_radius(M3_cap_screw), h=50, center=true);
                }

                // hollow for post
                cylinder(r=25/2 + 7, h=100, center=true);

                // flare the hollow
                translate([0,0,bh-eta])
                    cylinder(r1=bod/2, r2=bod/2 -dw, h=dw+2*eta);

                // bearing recess
                translate([0,0,-1])
                    cylinder(r=bod/2, h=bh + 1);

                // hollow for smooth rods
                for (i=[0,1])
                    mirror([0,i,0])
                    translate([0, TorsoRodSpacing/2, -20])
                    cylinder(r=TorsoRodDia/2+0.1, h=TorsoRodLength);

                // clamping slots
                for (i=[0,1])
                    mirror([0,i,0])
                    translate([-1, TorsoRodSpacing/2 - 25, -1])
                    cube([2,25,17]);

                // clamping bolt holes
                for (i=[0,1])
                    mirror([0,i,0])
                    translate([-1, TorsoRodSpacing/2 - 12, t/2]) {

                        rotate([0,90,0])
                            cylinder(r=3.2/2, h=100, center=true);

                        // nut trap
                        translate([8,0,0])
                            rotate([0,90,0])
                            rotate([0,0,30])
                            cylinder(r=nut_radius(M3_nut)+0.1, h=100, $fn=6);

                        // cs
                        translate([-8,0,0])
                            rotate([0,-90,0])
                            rotate([0,0,30])
                            cylinder(r=washer_radius(M3_washer)+0.1, h=100);

                    }

                // weight loss
                translate([0,43,0])
                    cylinder(r=13, h=100, center=true);

            }
        }
    }
}