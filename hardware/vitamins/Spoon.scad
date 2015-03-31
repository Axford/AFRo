// Base of spoon
Spoon_Con_Base = [[0,0,0], [0,-1,0], 0,0,0];

module Spoon() {
	// coordinate system places origin at tip of handle
	// spoon lies along y+
    
    if (DebugConnectors)
        connector(Spoon_Con_Base);
    
    vitamin("vitamins/Spoon.scad", "Spoon", "Spoon()") {
        view(t=[30, 43, 34], r=[58,0,36], d=850);
        
        color(grey80)
            union() {
                translate([-7/2, 0, 0])
                    cube([7,160,2]);

                translate([0, 152, 0])	
                    scale([4/6,1,1])
                    cylinder(r=60/2, h=2);
        }
    }
}