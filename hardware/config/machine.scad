
// Machine specific config
// for mk2


// Co-ordinate system
// ------------
//


// General

ThickWall = perim * 8;
tw = ThickWall;

DefaultWall = perim * 4;
dw = DefaultWall;


ServoBracketOpening = 41;  // distance between top and bottom horn faces

font_spacing = 1;

// Base

FanOffsetX = 0;


// Torso

TorsoVerticalTravel = 300;
TorsoPostDia = 20;
TorsoRodDia = 8;  // smooth rod diameter
TorsoRodSpacing = 160;  // spacing of smooth rods
TorsoPostElbowOffset = 150; 

TorsoPostAxisOffset = 50;  // motor offset

TorsoBearing = BB6205_2RS;

TorsoAngle = 130;
TorsoPosition = 0;

TorsoBaseThickness = 8;

// Counterweight

CounterweightIdler_offsetY = 15;
CounterweightIdler_offsetZ = -ball_bearing_od(BB624)/2 + dw;

// Shoulder

ShoulderRodBearing = LM8UU;
ShoulderPostBearing = LM20UU;
ElbowMotorOffset = linear_bearing_od(ShoulderPostBearing)/2 + 3*tw + NEMA_width(NEMA11)/2 + 0.3;
ShoulderPosition = 100;
ShoulderAngle = 0;

ShoulderWidth = 36;  // space between alu channel sides
ShoulderHeight = 40-1.5;  // vertical space "inside" channel sides

// Upper Arm

UpperArmLength = 150;  // distance between TorsoRod and elbow joint center
UpperArmWidth = 32;
UpperArmHeight = 38;

// Elbow

ElbowAngle = 130;

// Lower Arm

LowerArmLength = 200;  // distance between joint centres
LowerArmWidth = 32;
LowerArmHeight = 38;

// Wrist

WristAngle = 0;

SpoonAngle = 0;

//PostLength = TorsoVerticalTravel + 75;
PostLength = 500;
//TorsoRodLength = TorsoVerticalTravel + 25;
TorsoRodLength = 500;

ZAxisLength = TorsoVerticalTravel + 4;

EndStopOffsetY = TorsoPostDia/2 + 2*tw;


// Counterweight
CounterweightWidth = 38.5;
CounterweightDepth = 26;
CounterweightHeight = 51.5;