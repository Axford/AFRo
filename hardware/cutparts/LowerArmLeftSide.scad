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

                    // Wrist fixings
                    attach([[LowerArmWidth/2 + 1.5,42,LowerArmLength], [0,-1,0], 180,0,0], LowerArmServoBracket_Con_Servo, $Explode=false) 
                        for(i=[0:1])                        
                        attach(LowerArmServoBracket_Con_Fixings[i], DefConDown, ExplodeSpacing=20)
                            cylinder(r=4/2, h=100, center=true);
                            
                    // Elbow fixings
                    
                }
        }
        
        
    
    }
}

module LowerArmLeftSide_Start() {
    aluAngle(10,40,LowerArmLength,1.5);
}