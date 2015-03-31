

module AFRoAssembly() {
    w = 140;  // width of base, excluding cover sheet
    iw = NEMA_width(NEMA17)+24;  // inner width, excluding cover sheet
    h = NEMA_length(NEMA17);
    ih = 20;
    
	assembly("assemblies/AFRo.scad", "AFRo", "AFRoAssembly()") {
    
        view(size=[1024,768], t=[-150, 25, 243], r=[70, 0, 71], d=3775);
	
        // base plate - plywood
        translate([-140/2,  -TorsoPostAxisOffset -NEMA_width(NEMA17)/2 - 12 -1, 0])
            color(grey20)
            cube([140, 206, 12]);
        
        translate([0,0,12]) {
    
            // RAMPS assembly
            *translate([-18, 20, 0])
                {	
                    // at origin
                    color(grey50)
                        translate([26,57,0])
                        rotate([0,0,0])
                        import("utils/MEGA2560_and_RAMPS14.stl");
                }
        
            *translate([FanOffsetX, 110 - fan_thickness(fan30x10)/2, fan_width(fan30x10)/2 + 10])
                rotate([90,0,180])
                fan_assembly(fan40x11, 12, include_fan=true);
    
    
            BaseBracket_stl();
        
            // wood plates
    
            // inner front
            translate([-NEMA_width(NEMA17)/2, -TorsoPostAxisOffset + NEMA_width(NEMA17)/2,0])
                color(wood_color)
                cube([NEMA_width(NEMA17),12,47]);
        
            // inner back
            translate([-NEMA_width(NEMA17)/2, + (TorsoPostAxisOffset-NEMA_width(NEMA17)/2) - 12,0])
                color(wood_color)
                cube([NEMA_width(NEMA17),12,47]);
        
            // side
            for (i=[0,1])
                mirror([i,0,0])
                translate([-NEMA_width(NEMA17)/2-12, -TorsoPostAxisOffset -NEMA_width(NEMA17)/2 -1,0])
                color(wood_color)
                difference() {
                    cube([12, 183, 47]);
                
                    translate([-1, 102,-5])
                        roundedRectX([14, 63, 38 +5],5);
                    
                    translate([-1, 5,-5])
                        roundedRectX([14, 35, 38 +5],5);
                }
            
            // front
            translate([0, -TorsoPostAxisOffset -NEMA_width(NEMA17)/2 - 12 -1,0])
                color(wood_color)
                translate([-w/2,0,0])
                cube([w, 12, 47]);
            
            
            // back
            translate([0, 110,0])
                color(wood_color)
                difference() {
                    translate([-w/2,0,0])
                        cube([w, 12, 47]);
                    
                    translate([0,0,25])
                        rotate([90,0,0])
                        cylinder(r=38/2, h=100,center=true);
                }
            
    
            // turntable post
            translate([0,0,0])
                color(grey80)
                cylinder(r=TorsoPostDia/2, h=PostLength);
    
    
            // Torso (turntable)
            translate([0,0,0]) 
                rotate([0,0,ShoulderAngle])
                TorsoAssembly();
        
            // torso drive
            translate([0, -TorsoPostAxisOffset, 0])
                TorsoDriveAssembly();
            
        
            // cable guide from base to torso base
            *color(grey20)
                curvedPipe(
                    [ 
                        [0, 130, 50],
                        [-50 * sin(ShoulderAngle/3), 130, 80 + 50*cos(ShoulderAngle/2)],
                        [-110 * sin(ShoulderAngle/2), 110 * cos(ShoulderAngle/2), 80 + 50*cos(ShoulderAngle/2)],
                        [-100 * sin(ShoulderAngle), 100 * cos(ShoulderAngle), 80],
                        [-90 * sin(ShoulderAngle), 90 * cos(ShoulderAngle), 80]
                    ],
                    4,
                    [10, 10 + abs(50*sin(ShoulderAngle)),10,10],
                    10,
                    0);
        
        }
    
	}
	
}
