include <config/config.scad>


// animation
ShoulderPosition = ShoulderVerticalTravel * (1+cos($t * 360))/2;
ShoulderAngle = 130 * cos($t * 360);
ElbowAngle = 130 * cos($t * 360 * 2);
WristAngle = 300/2 * cos($t * 360 * 4);

// No animation
ShoulderPosition = 100;
ShoulderAngle = 0;
ElbowAngle = 85;
WristAngle = -30;
SpoonAngle = 90;

AFRoAssembly();


// worktop mockup
if (false) {
	
	// table
	translate([-500, -500, -10])
		cube([1000,1000,10]);
	
	// dinner plate with guard
	translate([250, - 250, 0]) {
		color("white")
			difference() {
				union() {
					cylinder(r1=170/2, r2=250/2, h=10);
					translate([0,0,10-eta])
						cylinder(r=250/2, h=5);
				}
			
				translate([0,0,10])
					cylinder(r1=170/2, r2=250/2, h=10);
			}

		// guard
		*translate([0,0,5])
			rotate([0,0,225])
			color([1,1,1,0.5])
			difference() {
				sector(r=260/2, a=270, h=40, center = false);
			
				translate([0,0,-1])
					cylinder(r=250/2, h=50);
			}

	}

}