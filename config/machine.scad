
// Machine specific config



// Co-ordinate system
// ------------
//


// General

ThickWall = perim * 8;
tw = ThickWall;

DefaultWall = perim * 4;
dw = DefaultWall;


ServoBracketOpening = 41;  // distance between top and bottom horn faces


// Base

FanOffsetX = -34;

// Shoulder

ShoulderVerticalTravel = 300;
ShoulderPostDia = 20;
ShoulderAxisDia = 8;
ShoulderPostAxisOffset = 50;
ShoulderPostJointOffset = 105;

ShoulderPostLinearBearing = LM20UU;

ShoulderBracketHeight = ServoBracketOpening + 2*tw;
ShoulderBracketWidth = 50;

ShoulderAngle = 130;
ShoulderPosition = 0;

// Upper Arm

UpperArmLength = 200;  // distance between joint centres
UpperArmWidth = 32;
UpperArmHeight = 38;

// Elbow

ElbowAngle = 130;

// Lower Arm

LowerArmLength = 200;  // distance between joint centres
LowerArmWidth = 32;

// Wrist

WristAngle = 90;


PostLength = ShoulderVerticalTravel + ShoulderBracketHeight + 75;
ZAxisLength = ShoulderVerticalTravel + ShoulderBracketHeight + 4;