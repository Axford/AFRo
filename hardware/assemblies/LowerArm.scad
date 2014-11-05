

module LowerArmAssembly() {
	
	sw = dynamixel_width(DYNAMIXELAX12);
	
	assembly("assemblies/LowerArm.scad", "Lower Arm", "LowerArmAssembly()") {
	        
        step(1, "Push the servo brackets onto the servo, optionally screw them into place") {
            view(t=[-29, -56, -55], r=[66,0,26], d=936);
            
            attach(DefConLeft,DefConLeft, ExplodeSpacing=20)
                LowerArmServoBracket_stl();
        
            attach(DefConRight,DefConRight, ExplodeSpacing=20)
                mirror([1,0,0])
                LowerArmServoBracket_stl();

            translate([0, -LowerArmLength, -42]) {
                rotate([0,0, WristAngle])
                    HandAssembly();
            }
        
        }
            
        step(2, "Bolt through the aluminium channels and servo brackets") {
            view(t=[-29, -56, -55], r=[66,0,26], d=936);
            // sides
            *for (i=[0,1])
                mirror([i,0,0])
                attach(DefConLeft, DefConLeft, ExplodeSpacing=20, offset=-7)
                translate([sw/2 + 1.5, -LowerArmLength, 0])
                rotate([-90,0,0])
                mirror([1,0,0])
                aluAngle(10,40,LowerArmLength,1.5);
                
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

