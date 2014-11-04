//
// Derived from a design within the Mendel90 project by:
//
// GNU GPL v2
// nop.head@gmail.com
// hydraraptor.blogspot.com
//
// Couples the 8mm smooth rod to the stepper motor
//
//include <../config/config.scad>


studding_dia = 8 + 1;

shaft_dia = 5 + 1;               // includes tubing
squeeze = 0.5;                  // how much holes undersized
holeR = M3_clearance_radius;
nutR = M3_nut_radius;
nutH = M3_nut_trap_depth;
corner_cut = 26;
wall = 3*perim;
gap = wall;

holeX = 7.5;
holeY2 = studding_dia / 2 + M3_clearance_radius;
holeY1 = shaft_dia    / 2 + M3_clearance_radius;

nut_flat_radius = M3_nut_radius * cos(30);
width = 2 * (max(holeY2, holeY1) + nut_flat_radius + wall);
length = 30;
tubing_length = (length - gap) / 2 + 2;

function z_coupling_length() = length;
function z_coupling_gap() = gap;

depth = 8;
centre_line = depth / 2;

rad = M3_nut_radius + wall;

module coupling_stl(){
    stl("coupling");

    translate([0, 0, depth / 2]) 
    	render()
    	union() {
        difference(){
            linear_extrude(height = depth, center = true)
                hull() {
                    polygon([
                        [ length / 2,  shaft_dia / 2 + 1],
                        [ length / 2, -shaft_dia / 2 - 1],
                        [-length / 2, -studding_dia / 2 - 1],
                        [-length / 2,  studding_dia / 2 + 1]
                    ]);
                    translate([holeX, holeY1])
                        circle(r = rad, center = true);
                    translate([holeX, -holeY1])
                        circle(r = rad, center = true);
                    translate([-holeX, holeY2])
                        circle(r = rad, center = true);
                    translate([-holeX, -holeY2])
                        circle(r = rad, center = true);
                }

           //nut holes
            translate([ holeX, -holeY1, - depth / 2]) rotate([0,0, 30]) cylinder(h = nutH * 2, r=nutR, $fn=6, center=true);
            translate([-holeX,  holeY2, - depth / 2]) rotate([0,0,-30]) cylinder(h = nutH * 2, r=nutR, $fn=6, center=true);

            //shaft groves
            translate([-gap / 2, 0, centre_line]) rotate([0,-90,0])  cylinder(h = length, r = (studding_dia - squeeze) / 2);
            translate([ gap / 2, 0, centre_line]) rotate([0, 90,0])  cylinder(h = length, r = (shaft_dia - squeeze) / 2);

            //screw holes
            for(y = [-1, 1]) {
                translate([ holeX,  y * holeY1, -10]) rotate([0,0, y * 360/28]) poly_cylinder(h = 20, r=holeR);
                translate([-holeX,  y * holeY2, -10]) rotate([0,0, y * 360/28]) poly_cylinder(h = 20, r=holeR);
            }
            //slots to prevent screw holes beading into the shaft holes
            translate([holeX, 0, centre_line])
                cube([2 * holeR, 2 * holeY1, shaft_dia], center = true);

            translate([-holeX, 0, centre_line])
                cube([2 * holeR, 2 * holeY2, studding_dia], center = true);

        }
         // bridge
        translate([ holeX, -holeY1, nutH - depth / 2]) cylinder(h = 0.4, r=nutR+0.1,  center=true);
        translate([-holeX,  holeY2, nutH - depth / 2]) cylinder(h = 0.4, r=nutR+0.1,  center=true);
    }
}
