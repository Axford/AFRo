//
// PMount
//
// Configuration file
//
bom = 0;                        // 0 no bom, 1 assemblies and stls, 2 vitamins as well
exploded = 0;                   // 1 for exploded view
simplify = false;    			// reduces complexity of some parts, e.g. alu extrusions

show_jigs = true;               // show printed jigs required to build the machine
show_support = true;            // show support structures, must be set when generating STLs

debugConnectors = false;  //  show "attach" points

// Real-world colors for various parts & vitamins
use_realistic_colors = true;    // true for "real" colors, false for "distinct" colors (useful during design and for build instructions)
printed_plastic_color = "orange";
cable_strip_real_color = "fuchsia";
belt_real_color = "yellow";
bulldog_real_color ="black";

eta = 0.01;                     // small fudge factor to stop CSG barfing on coincident faces.
$fa = 5;
$fs = 0.5;

perim = 0.5;    // perim extrusion width for 0.2 or 0.3 layer height
layers = 0.3;
2perim = 2*perim;
4perim = 4*perim;


// Debugging

DebugConnectors = 1;  			// set to 1 to debug, set to 0 for production
DebugCoordinateFrames = 1; 		// set to 1 to debug, set to 0 for production


// Visualisation

// set to true to use STL for printed parts rather than rendering on the fly
UseSTL = true;
STLPath = "../printedparts/stl/";
UseVitaminSTL = true;
VitaminSTL = "../vitamins/stl/";

$Explode  = false;
$ShowStep = 100;

$DefaultViewSize = [400, 300];


//
// Hole sizes
//
No2_pilot_radius = 1.7 / 2;       // self tapper into ABS
No4_pilot_radius = 2.0 / 2;       // wood screw into soft wood
No6_pilot_radius = 2.0 / 2;       // wood screw into soft wood

No2_clearance_radius = 2.5 / 2;
No4_clearance_radius = 3.5 / 2;
No6_clearance_radius = 4.0 / 2;

M2_tap_radius = 1.5 / 2;
M2_clearance_radius = 2.3 / 2;
M2_nut_radius = 4.6 / 2;
M2_nut_trap_depth = 2;

M2p5_tap_radius = 2.05 / 2;
M2p5_clearance_radius= 2.8 / 2;   // M2.5
M2p5_nut_trap_depth = 2.5;

M3_tap_radius = 2.5 / 2;
M3_clearance_radius = 3.3 / 2;
M3_nut_radius = 6.5 / 2;
M3_nut_trap_depth = 3;

M4_tap_radius = 3.3 / 2;
M4_clearance_radius = 2.2;
M4_nut_radius = 8.2 / 2;
M4_nut_trap_depth = 4;

M5_tap_radius = 4.2 / 2;
M5_clearance_radius = 5.3 / 2;
M5_nut_radius = 9.2 / 2;
M5_nut_depth = 4;

M6_tap_radius = 5 / 2;
M6_clearance_radius = 6.4 / 2;
M6_nut_radius = 11.6 / 2;
M6_nut_depth = 5;

M8_tap_radius = 6.75 / 2;
M8_clearance_radius = 8.4 / 2;
M8_nut_radius = 15.4 / 2;
M8_nut_depth = 6.5;

M10_tap_radius = 8 / 2;
M10_clearance_radius = 10.4 / 2;
M10_nut_radius = 19.6 / 2;
M10_nut_depth = 8;



include <colors.scad>
include <utils.scad>
include <vitamins.scad>
include <machine.scad>
include <cutparts.scad>
include <printedparts.scad>
include <assemblies.scad>


