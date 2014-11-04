

module LowerArmAssembly() {
	
	sw = dynamixel_width(DYNAMIXELAX12);
	
	assembly("assemblies/LowerArm.scad", "Lower Arm", "LowerArmAssembly()") {
	        
        // sides
        for (i=[0,1])
            mirror([i,0,0])
            translate([sw/2 + 1.5, -LowerArmLength, 0])
            rotate([-90,0,0])
            mirror([1,0,0])
            aluAngle(10,40,LowerArmLength,1.5);
    
        ElbowJoint2_stl();
    
        LowerArmServoBracket_stl();
    
        mirror([1,0,0])
            LowerArmServoBracket_stl();
    
    
        translate([0, -LowerArmLength, -42]) {
            rotate([0,180,180])
                DynamixelAX12();
        
            rotate([0,0, WristAngle])
                HandAssembly();
        }
    
	}
	
}

