module ShoulderBeltClamp_stl() {
	bod = linear_bearing_od(ShoulderRodBearing);
	bh = linear_bearing_height(ShoulderRodBearing);
	
	bigod = linear_bearing_od(LM20UU);
	
	l = 15 + TorsoRodSpacing/2 + 50;
	
	t=8;

    printedPart("printedparts/ShoulderBeltClamp.scad", "Shoulder Belt Clamp", "ShoulderBeltClamp_stl()") {

        view(t=[-4, -1, 4], r=[48,0,54], d=734);

        if (UseSTL) {
            import(str(STLPath, "ShoulderBeltClamp.stl"));
        } else {
            difference() {
                union() {

                    // belt clamp base
                    translate([
                            ShoulderWidth/2- tw - 2.5, 
                            -5- 2*tw, 
                            bh - 4*tw])
                        roundedRectX([tw + 2.5, 10 + 4*tw, 4*tw],tw);
                }

                //hollow for belts
                translate([ShoulderWidth/2 - tw - 2.5 - 1, -5, -50])
                    cube([2.2+1, 10, 100]);

                // belt clamp fixings
                for(i=[-1,1])
                    translate([
                            ShoulderWidth/2- 8.5, 
                            i*(5+tw), 
                            bh - 2*tw])
                        rotate([0,90,0])
                        cylinder(r=3.5/2, h=100, center=true);

            }	
        }
    }
}