LowerArmLeftSide_Con_Default = DefConRight;

module LowerArmLeftSide(complete=false) {

    vt = [25,40,16];
    vr = [163,339,90];

    if (DebugCoordinateFrames) frame();
    if (DebugConnectors) {
        connector(LowerArmLeftSide_Con_Default);
    }

    cutPart(
        "cutparts/LowerArmLeftSide.scad",
        "Lower Arm Left Side",
        "LowerArmLeftSide()",
        "LowerArmLeftSide(true)", 
        2, 
        complete
        ) {
        
        view(t=vt, r=vr);
        
        step(1, str("Cut aluminium angle to ", LowerArmLength,"mm")) {
            view(t=vt, r=vr);
            
            LowerArmLeftSide_Start();
        }
    
        step(2, "Drill 4mm diameter fixing holes") {
            view(t=vt, r=vr);
            
            // FIXME: Replace with correct hole pattern
            color(alu_color)
                render()
                difference() {
                    LowerArmLeftSide_Start();

                    translate([0,10,30])
                        rotate([0,90,0])
                        cylinder(r=3, h=10, center=true);
                }
        }
        
        
    
    }
}

module LowerArmLeftSide_Start() {
    aluAngle(10,40,LowerArmLength,1.5);
}