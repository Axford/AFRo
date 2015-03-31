module ShoulderBracketLeft_stl() {

	bod = linear_bearing_od(ShoulderRodBearing);
	bh = linear_bearing_height(ShoulderRodBearing);
	
	bigod = linear_bearing_od(LM20UU);
	
	l = 15 + TorsoRodSpacing/2 + 50;
	
	t=8;

    printedPart("printedparts/ShoulderBracketLeft.scad", "Shoulder Bracket Left", "ShoulderBracketLeft_stl()") {

        view(t=[-22,-24,-4], r=[61,0,47], d=545);

        if (UseSTL) {
            import(str(STLPath, "ShoulderBracketLeft.stl"));
        } else {

            // big bearing clamp
            difference() {
                union() {

                    // front fixings
                    for (i=[0,1])
                        translate([
                            -ShoulderWidth/2, 
                            -TorsoRodSpacing/2 - bod/2 - 2*tw, 
                            bh - 2*tw - i*(ShoulderHeight-4*tw)])
                        roundedRectX([ShoulderWidth/2-1, 2*tw, 2*tw],tw/4);

                    // small bearing casing
                    translate([
                            -ShoulderWidth/2, 
                            -TorsoRodSpacing/2 - (bod+2*tw)/2, 
                            0])
                        roundedRectX([ShoulderWidth/2-1, bod+2*tw, bh],tw/4);

                    // mid fixings
                    for (i=[0,1])
                        translate([
                            -ShoulderWidth/2, 
                            -bigod/2 - 2*tw, 
                            bh - 2*tw - i*(ShoulderHeight-4*tw)])
                        roundedRectX([ShoulderWidth/2-1, 2*tw, 2*tw],tw/4);

                    // big bearing casing
                    translate([
                            -ShoulderWidth/2, 
                            - (bigod+2*tw)/2, 
                            bh-ShoulderHeight])
                        roundedRectX([ShoulderWidth/2-1, bigod+2*tw, ShoulderHeight],tw/4);

                    // back fixings
                    for (i=[0,1])
                        translate([
                            -ShoulderWidth/2, 
                            bigod/2, 
                            bh - 2*tw - i*(ShoulderHeight-4*tw)])
                        roundedRectX([ShoulderWidth/2-1, 2*tw, 2*tw],tw/4);


                    // outer frame
                    translate([-ShoulderWidth/2, -TorsoRodSpacing/2 - bod/2 - tw, bh-ShoulderHeight+3*tw])
                        roundedRectX([tw, bigod/2 + TorsoRodSpacing/2 + bod/2, ShoulderHeight- 4*tw], tw, center=false, shell=tw);

                    *translate([-ShoulderWidth/2, -TorsoRodSpacing/2 - 15, bh - ShoulderHeight])
                        cube([ShoulderWidth/2-1, l, ShoulderHeight],3);
                }


                // hollow for little bearing
                translate([0,-TorsoRodSpacing/2,0])
                    cylinder(r=bod/2, h=200, center=true);

                // hollow for big bearing
                cylinder(r=bigod/2, h=200, center=true);

                //weight loss
                translate([0, 0, bh-ShoulderHeight/2])
                    rotate([0,90,0])
                    cylinder(r=bigod/2-1, h=100, center=true);

                translate([0, -TorsoRodSpacing/2, bh/2])
                    rotate([0,90,0])
                    cylinder(r=bod/2-1, h=100, center=true);


                // back fixings
                for (i=[0,1])
                    translate([0, bigod/2 + tw, bh - tw - i*(ShoulderHeight-4*tw)])
                    rotate([0,90,0])
                    cylinder(r=4.3/2, h=100, center=true);

                // mid fixings
                for (i=[0,1])
                    translate([0, -bigod/2 - tw, bh - tw - i*(ShoulderHeight-4*tw)])
                    rotate([0,90,0])
                    cylinder(r=4.3/2, h=100, center=true);

                // front fixings
                for (i=[0,1])
                    translate([0, -TorsoRodSpacing/2 - bod/2 - tw, bh - tw - i*(ShoulderHeight-4*tw)])
                    rotate([0,90,0])
                    cylinder(r=4.3/2, h=100, center=true);

                // motor plate fixing
                translate([-ShoulderWidth/2 + tw, bigod/2 + tw+1, bh - ShoulderHeight/2 + 2])
                    rotate([90,0,0])
                    cylinder(r=2.6/2, h=12);

            }	
        }
    }
}