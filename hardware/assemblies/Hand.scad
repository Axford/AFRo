Hand_Con_SpoonAssembly = [
    [
        dynamixel_height(DYNAMIXELAX12)/2 +dynamixel_horn_thickness(DYNAMIXELAX12) -2,
        0,
        -dynamixel_depth(DYNAMIXELAX12) + 13 - tw
    ], [1,0,0], -90,0,0];
    
    
Hand_Con_WristServo = [[0,0,0],[0,0,-1],180,0,0];

module HandAssembly() {
	
    if (DebugCoordinateFrames) frame();
    
	assembly("assemblies/Hand.scad", "Hand", "HandAssembly()") {
            
        step(1, "Screw the wrist bracket onto the wrist servo") {
            view(t=[6, -6, 6], r=[108, 0, 345], d=500);
            
            attach(Hand_Con_WristServo, DefConUp, $Explode=false)
                DynamixelAX12();
                
            rotate([0,0,WristAngle]) {
                attach(attachedConnector(Hand_Con_WristServo, DefConUp, DefConDown, $Explode=false), DefConUp)
                    WristBracket_stl();

                // screws
                for (i=[0:3])
                    attach(attachedConnector(Hand_Con_WristServo, DefConUp, DynamixelAX12_Con_HornFixings[i], $Explode=false), DefConDown, ExplodeSpacing=25)
                    screw(M2_pan_screw, 6);
            }
        }
        
        step(2, "Push the spoon assembly into the wrist bracket") {
            view(t=[20, -26, -22], r=[103, 0, 325], d=753);
            
            rotate([0,0,WristAngle])
                attach(DefConUp, DefConUp, offset=-tw)
                attach(Hand_Con_SpoonAssembly, DefConUp)
                SpoonAssembly();
        }
        
        step(3, "Screw through the bracket into the servo fixings") {
            view(t=[20, -26, -22], r=[108, 0, 334], d=753);
            
            rotate([0,0,WristAngle])
                for (i=[0:1]) {
                    attach(attachedConnector(Hand_Con_SpoonAssembly, DefConUp, offsetConnector(DynamixelAX12_Con_BackTop[i],[0,0,dw]), $Explode=false), DefConDown, offset=6)
                        screw(M2_pan_screw, 6);

                    attach(attachedConnector(Hand_Con_SpoonAssembly, DefConUp, offsetConnector(DynamixelAX12_Con_BackBottom[i],[0,0,-dw]), $Explode=false), DefConDown, offset=6)
                        screw(M2_pan_screw, 6);
            }
        }
        

	}
	
}



module SpoonAssembly() {
    assembly("assemblies/Hand.scad", "Spoon", "SpoonAssembly()") {            
        view(t=[-3,3,-20], r=[54,0,139], d=640);

        DynamixelAX12();
        
        step(1, "Push M2 nuts into the back of the servo fixing tabs") {
            view(t=[-3,6,-42], r=[70,0,48], d=640);
            
            for (i=[0:1]) {
                attach(DynamixelAX12_Con_NutTrap(DynamixelAX12_Con_BackTop[i], [0,1,0]), DynamixelAX12_Con_Nut([0,1,0]))
                    translate([0,0,-0.7])
                    nut(M2_nut);
                    
                attach(DynamixelAX12_Con_NutTrap(DynamixelAX12_Con_BackBottom[i], [0,1,0]), DynamixelAX12_Con_Nut([0,1,0]))
                    translate([0,0,-0.7])
                    nut(M2_nut);
            }
        }

        step(2, "Attach the spoon holder to the servo") {
            view(t=[5,2,-5], r=[73,0,40], d=600);
            
            // screws
            for (i=[0:3])
                attach(offsetConnector(DynamixelAX12_Con_HornFixings[i], [0,0,dw]), DefConDown, ExplodeSpacing=25)
                screw(M2_pan_screw, 6);
            
            // bracket and spoon
            rotate([0,0,SpoonAngle])
                attach(DefConDown, DefConDown) {
                    SpoonHolder_stl();

                    attach(SpoonHolder_Con_Spoon, Spoon_Con_Base)
                        Spoon();

                }
        }
    }
}