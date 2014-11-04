//Created by Austin Floyd
//austin.floyd (at) 3DprintGeeks (dot) com


//Adjust the bearing distance from rod (higher is farther away)
GapTolerance=0.99;
//Bearing Diameter
BearingDia=19;
// Bearing thickness
BearingHeight = 6; 
//Bearing Diameter
BearingInnerDiameter = 5.9;
//Smooth Rod Diameter
RodDiameter = 8;
//desired mm/per rotation
Pitch = 5; 
//Rotates the bearings around the rod
bearingOffset = 30;

//Thickness of the frame
MountHeight = 14;
//Base captive nut (small) outer diameter
BaseNutDiameter = 8;
//Base bolt diameter
BaseBoltDiamter = 5;
//Extra compression nut (small) outer diameter
CompressionNutDiameter = 8;
//Extra compression bolt diameter
CompressionBoltDiameter = 5;
//Extra compression bolt head diameter
CompressionBoltHeadDiameter = 8;
//Bearing center race offset percentage (of bearing height)
BearingRaceOffset = 0.15; // [0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4]

/* [Hidden] */
cylFn=32;
RodRadius = RodDiameter/2;
BearingOR = BearingDia / 2;
BearingHoleOD = BearingOR+.6; //Hole for bearing to sit in
bOR2rOR2=RodRadius*2+BearingOR*2;
MountRadius = bOR2rOR2;
bearingTolerance = (RodRadius+BearingOR)* GapTolerance;
Angle = atan(Pitch/(2*PI*RodRadius));
BearingIR = BearingInnerDiameter/2;
BaseNutR = BaseNutDiameter / 2;
BaseBoltR = BaseBoltDiamter / 2;
CompNutR = CompressionNutDiameter / 2;
CompBoltR = CompressionBoltDiameter / 2;
CompBoltHR = CompressionBoltHeadDiameter / 2;
mhD2bhD2 = MountHeight/3+BearingHeight/2;
brOffset = BearingHeight*BearingRaceOffset;//bearing race offset
baseThick = MountHeight*.5;

module ThreadlessBallscrew() {
	difference () {	
		union() {
			hull () {
				//translate ([0,0,0]) cylinder (h=MountHeight,r=MountRadius, center=true, $fn=cylFn);
				for(bearingNum=[1:3]) 
					rotate(-bearingOffset+bearingNum*360/3,[0,0,1])
					translate([0,bearingTolerance,0])
					cylinder(h=MountHeight,r=BearingOR+2, center=true, $fn=cylFn);
			
				translate ([bOR2rOR2/2+RodRadius,0,0]) cube ([bOR2rOR2,bOR2rOR2*.75,MountHeight], true);
				
				translate ([-RodRadius - BearingOR*2,0,0]) cube ([4,bOR2rOR2*0.75,MountHeight], true);
			}
		}
		translate ([(BearingOR*2+RodRadius*4)/2+RodRadius-1,0,0]) cube ([BearingOR*2+RodRadius*4,RodDiameter*.4,MountHeight+2], true);//compression slot cutout

		//spacing around rod
		translate ([0,0,-1]) cylinder (h=MountHeight*2, r=RodRadius+.5, center=true, $fn=cylFn);

		for(bearingNum=[1:3]) {
			rotate(-bearingOffset+bearingNum*360/3,[0,0,1])
			translate([0,bearingTolerance,0])
			topBearing(bearingNum==1 ? 44 :(bearingNum==2 ? 164 : 284));
		
			//rotate(bearingOffset+bearingNum*360/3,[0,0,1])
			rotate(-bearingOffset+bearingNum*360/3,[0,0,1])
			translate([0,bearingTolerance,0])
			bottomBearing(bearingNum==1 ? 83 :(bearingNum==2 ? 203 : 323));
		}
		
		//compression bolt
		translate ([bOR2rOR2-RodRadius/2,0,0]) rotate ([90,0,0]) cylinder (h=bOR2rOR2*2,r=CompBoltR, center=true, $fn=cylFn);
		translate ([bOR2rOR2-RodRadius/2,-bOR2rOR2*.75,0]) rotate ([90,0,0]) cylinder (h=RodDiameter*2,r=CompNutR, center=true, $fn=6);
		translate ([bOR2rOR2-RodRadius/2,bOR2rOR2*.75,0]) rotate ([90,0,0]) cylinder (h=RodDiameter*2,r=CompBoltHR, center=true, $fn=12);
	}
}


module topBearing(zAngle) {
	rotate([0,Angle*.71,0])
	union () {
		translate ([0,0,MountHeight/2]) cylinder (h=MountHeight*4, r=BearingIR, center = true, $fn=cylFn);//bearing bolt hole
		translate ([0,0,mhD2bhD2]) cylinder (h=BearingHeight, r=BearingHoleOD, center = true, $fn=cylFn);
		*translate ([0,0,mhD2bhD2]) cylinder (h=BearingHeight, r=BearingOR, center = true, $fn=cylFn);//bearing
		difference() { //raise center bearing race
			translate ([0,0,mhD2bhD2-brOffset]) cylinder (h=BearingHeight, r=BearingHoleOD, center = true, $fn=cylFn);
			translate ([0,0,mhD2bhD2-brOffset]) cylinder (h=BearingHeight, r=BearingHoleOD/1.5, center = true, $fn=cylFn);
		}
	}
}

module bottomBearing(zAngle) {
	rotate([0,Angle*.71,0])	
 	union () {
		translate ([0,0,-mhD2bhD2])  cylinder (h=BearingHeight, r=BearingHoleOD, center=true, $fn=cylFn);
		*translate ([0,0,-mhD2bhD2]) cylinder (h=BearingHeight, r=BearingOR, center=true, $fn=cylFn); //bearing
		difference() {
			translate ([0,0,-mhD2bhD2+brOffset]) cylinder (h=BearingHeight, r=BearingHoleOD, center = true, $fn=cylFn);
			translate ([0,0,-mhD2bhD2+brOffset]) cylinder (h=BearingHeight, r=BearingHoleOD/1.5, center = true, $fn=cylFn);
		}
	}
}