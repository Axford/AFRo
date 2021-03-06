//
// Mendel90
//
// GNU GPL v2
// nop.head@gmail.com
// hydraraptor.blogspot.com
//
// NEMA stepper motor model
//

//                       corner  body    boss    boss          shaft
//         side, length, radius, radius, radius, depth, shaft, length, holes, typesuffix
NEMA17  = [42.3, 47,     53.6/2, 25,     11,     2,     5,     24,     31,    "17"];
NEMA17S = [42.3, 34,     53.6/2, 25,     11,     2,     5,     24,     31,    "17S" ];
NEMA14  = [35.2, 36,     46.4/2, 21,     11,     2,     5,     21,     26,    "14" ];
NEMA11  = [28.2, 51,     18,   18,     22/2,   2,     5,     21,     23,      "11" ];

stepper_body_color = grey20;
stepper_cap_color  = grey80;

function NEMA_width(motor)    = motor[0];
function NEMA_length(motor)   = motor[1];
function NEMA_radius(motor)   = motor[2];
function NEMA_holes(motor)    = [-motor[8]/2, motor[8]/2];
function NEMA_big_hole(motor) = motor[4] + 0.2;
function NEMA_shaft_dia(motor) = motor[6];
function NEMA_shaft_length(motor) = motor[7];
function NEMA_hole_pitch(motor) = motor[8];

// connectors
NEMA_Con_Default = [[0,0,0], [0,0,-1], 0,0,0];

function NEMA_Con_Fixings(m) = [
    [[m[8]/2, m[8]/2, 0], [0,0,-1], 0,0,0],
    [[m[8]/2, -m[8]/2, 0], [0,0,-1], 0,0,0],
    [[-m[8]/2, -m[8]/2, 0], [0,0,-1], 0,0,0],
    [[-m[8]/2, m[8]/2, 0], [0,0,-1], 0,0,0]
];

module NEMA(motor) {
    side = NEMA_width(motor);
    length = NEMA_length(motor);
    body_rad = motor[3];
    boss_rad = motor[4];
    boss_height = motor[5];
    shaft_rad = NEMA_shaft_dia(motor) / 2;
    cap = 8;
    //vitamin(str("NEMA", round(motor[0] / 2.54), length * 10, ": NEMA", round(motor[0] / 2.54), " x ", length, "mm stepper motor"));
    
    tn = motor[9];
     vitamin("vitamins/stepper-motors.scad", str("NEMA",tn," Stepper Motor"), str("NEMA(NEMA",tn,")")) {
        view(t=[0,-7,-12]);
    }
    
    if (DebugCoordinateFrames) frame();
    if (DebugConnectors) {
        connector(NEMA_Con_Default);
        for (i=[0:3])
            connector(NEMA_Con_Fixings(motor)[i]);
    }
    
    union() {
        color(stepper_body_color) render()                                                     // black laminations
            translate([0,0, -length / 2])
                intersection() {
                    cube([side, side, length - cap * 2],center = true);
                    cylinder(r = body_rad, h = 2 * length, center = true);
                }
        color(stepper_cap_color) render() {                                     // aluminium end caps
            difference() {
                union() {
                    intersection() {
                        union() {
                            translate([0,0, -cap / 2])
                                cube([side,side,cap], center = true);
                            translate([0,0, -length + cap / 2])
                                cube([side,side,cap], center = true);
                        }
                        cylinder(r = NEMA_radius(motor), h = 3 * length, center = true);
                    }
                    difference() {
                        cylinder(r = boss_rad, h = boss_height * 2, center = true);                 // raised boss
                        cylinder(r = shaft_rad + 2, h = boss_height * 2 + 1, center = true);
                    }
                    cylinder(r = shaft_rad, h = NEMA_shaft_length(motor) * 2, center = true);  // shaft
                }
                for(x = NEMA_holes(motor))
                    for(y = NEMA_holes(motor))
                        translate([x, y, 0])
                            cylinder(r = 3/2, h = 9, center = true);
            }
        }

        translate([0, side / 2, -length + cap / 2])
            rotate([90, 0, 0])
                for(i = [0:3])
                    rotate([0, 0, 225 + i * 90])
                        color(["red", "blue","green","black"][i]) render()
                            translate([1, 0, 0])
                                cylinder(r = 1.5 / 2, h = 12, center = true);


    }
}

module NEMA_screws(motor, n = 4, screw_length = 8, screw_type = M3_pan_screw) {
    for(a = [0: 90 : 90 * (n - 1)])
        rotate([0, 0, a])
            translate([motor[8]/2, motor[8]/2, 0])
                screw_and_washer(screw_type, screw_length, true);
}
