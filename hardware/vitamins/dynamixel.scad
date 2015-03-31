//
// Dynamixel
//
// GNU GPL v2
// damian@axford.me.uk
//
// Dynamixel servo models
//

//             external dims (exc horn) | body dims (exc tabs) | horn   
//                width, depth, height,   width, depth, height,  od, t     
DYNAMIXELAX12  = [32,    50,    38,       26,    47,    38,      22, 4   ];

function dynamixel_width(dyna) = dyna[0]; 
function dynamixel_depth(dyna) = dyna[1]; 
function dynamixel_height(dyna) = dyna[2];
function dynamixel_inner_height(dyna) = dyna[2] - 5;
function dynamixel_horn_thickness(dyna) = dyna[7];  


// connectors

DynamixelAX12_Con_HornFixings =[
    [[8,0,0], [0,0,-1], 0,0,0],
    [[0,8,0], [0,0,-1], 0,0,0],
    [[-8,0,0], [0,0,-1], 0,0,0],
    [[0,-8,0], [0,0,-1], 0,0,0]
];

// x- z+
DynamixelAX12_Con_TopLeft = [
    [[-27/2, -6.5, -5], [0,0,-1], 0,0,0],
    [[-27/2, -6.5-8, -5], [0,0,-1], 0,0,0],
    [[-27/2,-6.5-16, -5], [0,0,-1], 0,0,0],
    [[-27/2,-6.5-24, -5], [0,0,-1], 0,0,0]
];

// x+ z+
DynamixelAX12_Con_TopRight = [
    [[27/2, -6.5, -5], [0,0,-1], 0,0,0],
    [[27/2, -6.5-8, -5], [0,0,-1], 0,0,0],
    [[27/2,-6.5-16, -5], [0,0,-1], 0,0,0],
    [[27/2,-6.5-24, -5], [0,0,-1], 0,0,0]
];

// x- z-
DynamixelAX12_Con_BottomLeft = [
    [[-27/2, -6.5, -37], [0,0,1], 0,0,0],
    [[-27/2, -6.5-8, -37], [0,0,1], 0,0,0],
    [[-27/2,-6.5-16, -37], [0,0,1], 0,0,0],
    [[-27/2,-6.5-24, -37], [0,0,1], 0,0,0]
];

// x+ z-
DynamixelAX12_Con_BottomRight = [
    [[27/2, -6.5, -37], [0,0,1], 0,0,0],
    [[27/2, -6.5-8, -37], [0,0,1], 0,0,0],
    [[27/2,-6.5-16, -37], [0,0,1], 0,0,0],
    [[27/2,-6.5-24, -37], [0,0,1], 0,0,0]
];

// y- z+
DynamixelAX12_Con_BackTop = [
    [[-16/2, -36, -5], [0,0,-1], 0,0,0],
    [[16/2, -36, -5], [0,0,-1], 0,0,0]
];

// y- z-
DynamixelAX12_Con_BackBottom = [
    [[-16/2, -36, -37], [0,0,1], 0,0,0],
    [[16/2, -36, -37], [0,0,1], 0,0,0]
];

function DynamixelAX12_Con_Nut(dir=[1,0,0]) = [[0,0,0], dir, 0,0,0];

function DynamixelAX12_Con_NutTrap(con, dir=[1,0,0]) = [
    [con[0][0], con[0][1], con[0][2] + con[1][2] * 3],
    dir,
    0,0,0
];

module DynamixelAX12() {
	// local coordinate system places origin centred on upper surface of control horn
	// body of servo extends along y-

    w1 = DYNAMIXELAX12[0];
    d1 = DYNAMIXELAX12[1];
    h1 = DYNAMIXELAX12[2];
    
    w2 = DYNAMIXELAX12[3];
    d2 = DYNAMIXELAX12[4];
    h2 = DYNAMIXELAX12[5];
    
    hOD = DYNAMIXELAX12[6];
    hT = DYNAMIXELAX12[7];
    
    if (DebugCoordinateFrames) frame();
    if (DebugConnectors) {
        for (i=[0:3]) {
            connector(DynamixelAX12_Con_HornFixings[i]);
        
            connector(DynamixelAX12_Con_TopLeft[i]);
            connector(DynamixelAX12_Con_TopRight[i]);
            
            connector(DynamixelAX12_Con_BottomLeft[i]);
            connector(DynamixelAX12_Con_BottomRight[i]);
        }
        
        for (i=[0:1]) {
            connector(DynamixelAX12_Con_BackTop[i]);
            connector(DynamixelAX12_Con_BackBottom[i]);
        }
    }
    
    vitamin("vitamins/dynamixel.scad", "Dynamixel AX12", "DynamixelAX12()") {
        view(t=[0, -10, -20]);

        // horn
        color(grey20) 
            difference() {
                translate([0,0,-hT])
                    cylinder(r=hOD/2, h=hT);

                // fixing holes
                for (i=[0:3]) 
                    rotate([0,0,i*90])
                    translate([8,0,-hT-1])
                    cylinder(r=2/2, h=hT+2);
            }

        // body
        DynamixelAX12_Body();

        // serial connectors
        color("white")
            translate([-23/2, -18, -34])
            cube([23, 7, 10]);
    
    }
}


module DynamixelAX12_Body() {
    
    w1 = DYNAMIXELAX12[0];
    d1 = DYNAMIXELAX12[1];
    h1 = DYNAMIXELAX12[2];
    
    w2 = DYNAMIXELAX12[3];
    d2 = DYNAMIXELAX12[4];
    h2 = DYNAMIXELAX12[5];
    
    hOD = DYNAMIXELAX12[6];
    hT = DYNAMIXELAX12[7];


    //part("DynamixelAX12_Body", "DynamixelAX12_Body()");

    // FIXME: this needs to return a manifold part to render correctly!
    color(grey20)
        if (UseVitaminSTL && false) {
            import(str(VitaminSTL,"DynamixelAX12_Body.stl"));
        } 
        else 
        {
            difference() {
                union() {
                    // main body
                    translate([0,0,-32-5])
                        linear_extrude(32)
                        hull() {
                            translate([w2/2-5, 11.5-5, 0])
                                circle(r=5);
                            translate([-w2/2+5, 11.5-5, 0])
                                circle(r=5);
                            translate([-w2/2,-35,0])
                                square([w2, 1]);
                        }

                    // upper bulge
                    difference() {
                        translate([-10, -32, -5])
                            cube([20, 24, 3]);

                        translate([0,0,-6])
                            cylinder(r=hOD/2+0.5, h=hT+2);
                    }

                    // lower hub
                    translate([0,0,-40])
                        cylinder(r=10/2, h=h1);

                    // lower blocks
                    for (i=[0,1])
                        mirror([i,0,0])
                        translate([16/2, -30.5, -40 + 1.5])
                        cube([7,7,3],center=true);

                    // side tabs
                    for (x=[0,1], y=[0:3], z=[0,1])
                        mirror([x,0,0])
                        translate([27/2, -6.5 - y*8, -10 - z*27]) 
                        difference() {
                            translate([-3/2, -7/2, 0])
                                cube([3.5, 7, 5]);

                            translate([0,0,-1])
                                cylinder(r=1, h=10);
                        }


                    // end tabs
                    for (x=[0,1], z=[0,1])
                        mirror([x,0,0])
                        translate([16/2, -36, -10 - z*27]) 
                        difference() {
                            translate([-7/2, -3/2-0.5, 0])
                                cube([7, 3.5, 5]);

                            translate([0,0,-1])
                                cylinder(r=1, h=10);
                        }

                    // back bulge
                    translate([-9/2, -37, -32])
                        cube([9, 5, 22]);

                }


                // serial connectors
                translate([-23/2, -18, -40])
                    cube([23, 7, 10]);

                // hub
                translate([0,0,-50])
                    cylinder(r=3/2, h=50);

            }
        }
}