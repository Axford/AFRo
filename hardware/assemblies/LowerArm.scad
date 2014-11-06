

LowerArm_Con_Elbow = DefConUp;

LowerArm_Con_Wrist = [[0, -LowerArmLength, -42], [0,0,1], 0,0,0];

LowerArm_Con_LeftSide = [[dynamixel_width(DYNAMIXELAX12)/2 + 1.5, 0, 0], [-1,0,0], 90,0,0];

LowerArm_Con_WristFixingsLeft = [
    [[LowerArmWidth/2 + 1.5, -LowerArmLength + 50 - 2*tw, -1.5 - LowerArmHeight/2 + 10], [-1,0,0], 0,0,0],
    [[LowerArmWidth/2 + 1.5, -LowerArmLength + 50 - 2*tw, -1.5 - LowerArmHeight/2 - 10], [-1,0,0], 0,0,0],
];

LowerArm_Con_WristFixingsRight = [
    [[-LowerArmWidth/2 - 1.5, -LowerArmLength + 50 - 2*tw, -1.5 - LowerArmHeight/2 + 10], [1,0,0], 0,0,0],
    [[-LowerArmWidth/2 - 1.5, -LowerArmLength + 50 - 2*tw, -1.5 - LowerArmHeight/2 - 10], [1,0,0], 0,0,0],
];

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
            
            attach(DefConLeft, DefConLeft, showVector=false)
                attach(LowerArm_Con_Wrist, LowerArmServoBracket_Con_Servo, ExplodeSpacing=20)
                LowerArmServoBracket_stl();
        
            mirror([1,0,0])
                attach(DefConLeft, DefConLeft, showVector=false)
                attach(LowerArm_Con_Wrist, LowerArmServoBracket_Con_Servo, ExplodeSpacing=20)
                LowerArmServoBracket_stl();

            attach(LowerArm_Con_Wrist, DefConUp, $Explode=false) {
                HandAssembly();
            }
        
        }
            
        step(2, "Bolt through the aluminium channels and servo brackets") {
            view(t=[-21, -71, -47], r=[66, 0, 7], d=1000);
            // sides
            attach(LowerArm_Con_LeftSide, LowerArmLeftSide_Con_Default, ExplodeSpacing=10, offset=10)
                LowerArmLeftSide(complete=true);
                
            // FIXME: replace with proper cutpart
            mirror([1,0,0])
                attach(LowerArm_Con_LeftSide, LowerArmLeftSide_Con_Default, ExplodeSpacing=10, offset=10)
                LowerArmLeftSide(complete=true);
                
            // washers and bolts
            for (i=[0:1])
                attach(LowerArm_Con_WristFixingsRight[i], DefConDown, ExplodeSpacing=20, $ExplodeChildren=$Explode) 
                washer(M4_washer, ExplodeSpacing=45)
                screw(M4_hex_screw, 40);
                
            // washers and nuts
            for (i=[0:1])
                attach(LowerArm_Con_WristFixingsLeft[i], DefConDown, ExplodeSpacing=15, $ExplodeChildren=$Explode) 
                washer(M4_washer, ExplodeSpacing=10)
                nut(M4_nut, nyloc=true);
            
            
        }
    
    
        step(3, "Bolt through the aluminium channels and elbow joint") {
            view(t=[-29, -56, -55], r=[66,0,26], d=936);
            
            attach(DefConBack, DefConBack, ExplodeSpacing=20, offset=15)
                ElbowJoint2_stl();
            
            // bolts
            
        }
        
	}
	
}

