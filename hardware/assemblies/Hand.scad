module HandAssembly() {
	
	assembly("assemblies/Hand.scad", "Hand", "HandAssembly()") {
                
        assign($Explode=false, $ShowStep=100)
            translate([
                dynamixel_height(DYNAMIXELAX12)/2 + dynamixel_horn_thickness(DYNAMIXELAX12) -2,
                0,
                -dynamixel_depth(DYNAMIXELAX12) + 13 - tw
            ])
                rotate([-90,0,-90])
                {
                    SpoonAssembly();
                }
                
        step(1, "Push M2 nuts into back of the servo fixing tabs") {
            view(t=[-3,6,-42], r=[70,0,48], d=640);
            
        }

        step(2, "Push the bracket onto the servo") {
            view(t=[-3,6,-42], r=[70,0,48], d=640);
            
            attach(DefConDown, DefConDown)
                WristBracket_stl();
        }
        
        step(3, "Screw through the bracket into the servo fixings") {
            view(t=[-3,6,-42], r=[70,0,48], d=640);
            
        }
        

	}
	
}



module SpoonAssembly() {
    assembly("assemblies/Hand.scad", "Spoon", "SpoonAssembly()") {            
        view(t=[-3,3,-20], r=[54,0,139], d=640);

        DynamixelAX12();

        step(1, "Attach the spoon holder to the servo") {
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