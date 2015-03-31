module CounterweightBracket_stl() {
	
	// weight dimensions
	ww = CounterweightWidth;
	wd = CounterweightDepth;
	wh = CounterweightHeight;
	
	oy = 10;  // offset of weights in y

	od = TorsoRodDia;

    printedPart("printedparts/CounterweightBracket.scad", "Counterweight Bracket", "CounterweightBracket_stl()") {

        view(t=[-4, 15, -27], r=[73,0,133], d=500);

        if (UseSTL) {
            import(str(STLPath, "CounterweightBracket.stl"));
        } else {
            render()
            difference() {
                union() {
                    // top/bottom plates
                    for (i=[0,1])
                        translate([0,0,-dw - i*(wh + dw)]) {
                            hull() {
                                cylinder(r=od/2 + tw, h=dw);

                                translate([-ww/2-dw, oy+wd/2, 0])
                                    cube([ww + 2*dw, wd/2+dw, dw]);	

                            }

                            // retaining ridge
                            mirror([0,0,i])
                                translate([ww/4, oy - tw, eta-i*dw])
                                rotate([-90,0,90])
                                trapezoidPrism(1, tw, (tw-1)/2, (tw-1)/2, ww/2);
                        }

                    // back plate
                    for (i=[-1,1])
                        translate([-tw/2 + i*(ww/2), oy+wd, -wh-2*dw])
                        cube([tw, dw, wh+2*dw]);


                    // side webbing
                    for (i=[-1,1])
                        translate([-dw/2 + i*(ww/2 + dw/2), oy+wd/2, -wh-2*dw])
                        cube([dw, wd/2, wh+2*dw]);

                    // line block
                    hull() {
                        translate([0,oy+wd/2,5])
                            rotate([-90,0,0])
                            cylinder(r=3/2+tw, h=dw, $fn=20);

                        translate([0,oy+wd/2,5])
                            rotate([-90,0,0])
                            cylinder(r=3/2+1, h=wd/2+dw, $fn=20);

                        translate([-6, oy+wd/2, -1])
                            cube([12, wd/2+dw, 1]);
                    }

                    // line block reinforcing
                    translate([-ww/2, oy+wd, -tw-dw+eta])
                        cube([ww, dw, tw]);

                    // OSHW logo
                    translate([0, oy+wd+dw, -ww/2-tw-dw+eta])
                        rotate([90,0,0])
                        linear_extrude(height=dw)
                        oshw_logo_2d(ww);


                    // AFRo text
                    translate([11, oy+wd, -dw-wh+5.5])
                        rotate([-90,0,0])
                        rotate([0, 0, 90])
                        scale([1.3,1.5,1])
                        fnt_str_p( ["A","F","R","o"], 
                            [0,
                            aa,
                            aa+ff,
                            aa+ff+rr], 
                            4, 10, 2 );
                }

                // line hole
                translate([0,oy+wd/2,5])
                            rotate([-90,0,0])
                            cylinder(r=3/2, h=100, center=true);

                // hollow for smooth rod - sliding fit
                cylinder(r=TorsoRodDia/2+0.5, h=200, center=true);

            }
        }
    }
}