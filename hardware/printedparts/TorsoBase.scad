module TorsoBase_stl() {
	bod = ball_bearing_od(TorsoBearing);
	bh =  ball_bearing_width(TorsoBearing);
	nl = NEMA_length(NEMA17);

	t = TorsoBaseThickness;
	
	idlerWidth = 14.8;

    printedPart("printedparts/TorsoBase.scad", "Torso Base", "TorsoBase_stl()") {

        view(t=[-4, -1, 4], r=[48,0,54], d=734);

        if (UseSTL) {
            import(str(STLPath, "TorsoBase.stl"));
        } else {
            difference() {
                union() {

                    // post supports
                    for (i=[0,1])
                            mirror([0,i,0])
                            translate([0, TorsoRodSpacing/2, 0])
                            cylinder(r2=TorsoRodDia/2 + dw, r1=TorsoRodDia/2 + tw, h=30);


                    // webbing
                    hull() {
                        for (i=[0,1])
                            mirror([0,i,0])
                            translate([0, TorsoRodSpacing/2, 0])
                            cylinder(r=TorsoRodDia/2 + tw, h=t);

                        translate([0,0, 0])
                            cylinder(r=bod/2 + 2 + tw, h=t);

                    }

                    // idler supports
                    translate([0, -nl/2 - 17, 0])
                        for (i=[0,1])
                        mirror([0,i,0])
                        translate([-2-tw, -idlerWidth/2 - tw, 0])
                        cube([4+2*tw, tw, 25]);

                }


                // hollow for post
                translate([0,0,-1])
                    cylinder(r1= 25/2+7, r2=bod/2+2 - tw, h=t+2);

                // hollow for idler bolt
                translate([0, -nl/2 - 17, 19])
                    rotate([90,0,0])
                    cylinder(r=4.3/2, h=50, center=true);


                // hollow for smooth rods
                for (i=[0,1])
                    mirror([0,i,0])
                    translate([0, TorsoRodSpacing/2, -20])
                    cylinder(r=TorsoRodDia/2+0.1, h=TorsoRodLength);

                // clamping slots
                for (i=[0,1])
                    mirror([0,i,0])
                    translate([-1, TorsoRodSpacing/2 - 25, -1])
                    cube([2,25,25]);

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

                // fixings to big gear
                for (i=[0,1])
                    mirror([i,0,0])
                    translate([bod/2 + 2, 0, -1])
                    cylinder(r=3.5/2, h=100);

                // weight loss
                translate([0,43,0])
                    cylinder(r=13, h=100, center=true);
                translate([0,-40.5,0])
                    cylinder(r=7, h=100, center=true);

            }
        }
    }
}