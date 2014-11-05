

LowerArm_Con_Elbow = DefConUp;

LowerArm_Con_Wrist = [[0, -LowerArmLength, -42], [0,0,1], 0,0,0];

LowerArm_Con_LeftSide = [[dynamixel_width(DYNAMIXELAX12)/2 + 1.5, 0, 0], [-1,0,0], 90,0,0];

module LowerArmAssembly() {
	
	sw = dynamixel_width(DYNAMIXELAX12);
    
    if (DebugCoordinateFrames) frame();
    if (DebugConnectors) {
        connector(LowerArm_Con_Elbow);
        connector(LowerArm_Con_Wrist);
        connector(LowerArm_Con_LeftSide);
        
    }
	
	assembly("assemblies/LowerArm.scad", "Lower Arm", "LowerArmAssembly()") {
	        
        step(1, "Push the servo brackets onto the servo, optionally screw them into place") {
            view(t=[-29, -56, -55], r=[66,0,26], d=936);
            
            attach(DefConLeft, DefConLeft)
                attach(LowerArm_Con_Wrist, LowerArmServoBracket_Con_Servo, ExplodeSpacing=20)
                LowerArmServoBracket_stl();
        
            mirror([1,0,0])
                attach(DefConLeft, DefConLeft)
                attach(LowerArm_Con_Wrist, LowerArmServoBracket_Con_Servo, ExplodeSpacing=20)
                LowerArmServoBracket_stl();

            attach(LowerArm_Con_Wrist, DefConUp, $Explode=false) {
                rotate([0,0, WristAngle])
                    HandAssembly();
            }
        
        }
            
        step(2, "Bolt through the aluminium channels and servo brackets") {
            view(t=[-29, -56, -55], r=[66,0,26], d=936);
            // sides
            attach(LowerArm_Con_LeftSide, LowerArmLeftSide_Con_Default, ExplodeSpacing=20, offset=10)
                LowerArmLeftSide(complete=true);
                
            // FIXME: replace with proper cutpart
            mirror([1,0,0])
                attach(LowerArm_Con_LeftSide, LowerArmLeftSide_Con_Default, ExplodeSpacing=20, offset=10)
                LowerArmLeftSide(complete=true);
                
            // bolts
            
        }
    
    
        step(3, "Bolt through the aluminium channels and elbow joint") {
            view(t=[-29, -56, -55], r=[66,0,26], d=936);
            
            attach(DefConBack, DefConBack, ExplodeSpacing=20, offset=15)
                ElbowJoint2_stl();
            
            // bolts
            
        }
        
	}
	
}

