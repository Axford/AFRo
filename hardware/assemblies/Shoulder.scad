module ShoulderAssembly() {
	
	h = NEMA_length(NEMA17);
	
	bod = linear_bearing_od(ShoulderRodBearing);
	bh = linear_bearing_height(ShoulderRodBearing);
	
	bigod = linear_bearing_od(ShoulderPostBearing);
	
	assembly("assemblies/Shoulder.scad", "Shoulder", "ShoulderAssembly()") {
    
        // linear bearing
        translate([0, -TorsoRodSpacing/2, bh/2])
            rotate([0,90,0])
            linear_bearing(ShoulderRodBearing);
        
        
        // big lin bearing
        translate([0,0, -linear_bearing_height(LM20UU)/2 + bh])
            rotate([0,90,0])
            linear_bearing(LM20UU);
        
    
        // left (x-)
        ShoulderBracketLeft_stl();
    
        // right (x+)
        ShoulderBracketRight_stl();
    
        // belt clamp
        translate([20,-40,0])
            mirror([1,0,0])
            ShoulderBeltClamp_stl();
        
    
        // sides
        for (i=[0,1])
            mirror([i,0,0])
            translate([ShoulderWidth/2 + 1.5, -UpperArmLength - TorsoRodSpacing/2, bh + 1.5])
            rotate([-90,0,0])
            mirror([1,0,0])
            aluAngle(10,40,250,1.5);
        
    
        // elbow stepper
        translate([0, ElbowMotorOffset, bh - dw])
            rotate([0,0,0])
            NEMA(NEMA11);
        *translate([0, 45.5, bh + 1.5])
            rotate([0,0,0])
            NEMA(NEMA17S);
        
        // drive pulley
        translate([0, 45.5, bh + 27])
            rotate([180,0,0])
            ElbowDrivePulley_stl();
        
        ElbowMotorPlate_stl();
        
    
        // counterweight line bracket
        translate([0,-TorsoRodSpacing/2 - CounterweightIdler_offsetY - 8, bh])
            CounterweightLineBracket_stl();
        
        
        // elbow joint and lower arm
        translate([0,-UpperArmLength - TorsoRodSpacing/2, bh-ShoulderHeight]) {
    
            ElbowJointAssembly();
    
            translate([0,0,-3]) 
                rotate([0,0,ElbowAngle])
                LowerArmAssembly();
        }
    
	}
	
}


module ElbowJointAssembly() {
	bw = ball_bearing_width(BB608);
	bod = ball_bearing_od(BB608);
	
	d = bod + 2*tw;

	assembly("assemblies/Shoulder.scad", "Elbow Joint", "ElbowJointAssembly()") {
    
        // pulley lock nut
        translate([0,0,ShoulderHeight+21])
            nut(M6_nut, nyloc=true);
    
        // pulley washer
        translate([0,0,ShoulderHeight+19])
            washer(M8_washer);
    
        // pulley
        translate([0,0,ShoulderHeight+2])
            ElbowDrivenPulley_stl();
        
        // belt
        translate([0,0,ShoulderHeight+14])
            rotate([0,0,90])
            belt(T2p5x6, 0, 0, 12, UpperArmLength + TorsoRodSpacing/2 + 46, 0, 12, gap = 0);
    
        // top nut
        translate([0,0,ShoulderHeight+2])
            nut(M6_nut);
    
        // upper washer
        translate([0,0,ShoulderHeight])
            washer(M8_washer);
    
        // upper bearing
        translate([0,0, ShoulderHeight-bw/2])
            ball_bearing(BB608);
    
        // tube
        translate([0,0,-40])
            color(alu_color)
            tube(8/2, 8/2-1, ShoulderHeight+40, center=false);
    
        // threaded rod
        translate([0,0,-ShoulderHeight-6])
            cylinder(r=6/2, h=115);
    
        // lower bearing
        translate([0,0,bw/2-2])
            ball_bearing(BB608);
        
        // lower washer
        translate([0,0,-3])
            washer(M8_washer);
        
        // bottom nut
        translate([0,0,-ShoulderHeight-5])
            nut(M6_nut);
        
        
        // stl
        ElbowJoint_stl();
    
    
	}
	
}

