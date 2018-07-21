$fn=100;

pi_zero_width=30;
pi_zero_length=65;
wall_width=2.8; //resulting thickness is half of this value
floor_thickness=wall_width/2; // should be half of the wall_width

ic_width=pi_zero_width+2.5; // inner case width
ic_length=pi_zero_length+8; // inner case length

bottom_ic_height=10; // height of bottom inner case 
top_ic_height=8; // height of top inner case 

ridge_width=1.2; // resulting width is half of this value
ridge_height=1.5;

use <library.scad/raspberrypi.scad>;
use <raspberrypi_library/papirus_hat_pizero.scad>;

module port_hole(length, width=5.5, height=3.5, dist_from_side, dist_from_bottom) {
     translate([dist_from_side, pi_zero_width/2, dist_from_bottom+floor_thickness]) {
        cube([length, width, height], true); 
    }
}

module pegs() {
    peg_base_height=2;
    peg_base_radius=2;
    peg_height=2.5;
    peg_radius=1;

    hole_dist_x=58;
    hole_dist_y=23;
     
    for(x=[-(hole_dist_x/2), hole_dist_x/2]) {
        for(y=[-(hole_dist_y/2), hole_dist_y/2]) {
            translate([x, y, floor_thickness-0.1]) {
                // peg_base
                cylinder(peg_base_height+0.2, r=peg_base_radius);
                translate([0,0, peg_base_height-0.1]) {
                    // peg
                    cylinder(peg_height+0.2, r=peg_radius);
                }
            }
        }
    }
}

module bottom_case() {
    difference() {
        union() {
            translate([0,0,bottom_ic_height/2]) {
                difference() {
                    union() {
                        // main body
                        cube([ic_length+wall_width, ic_width+wall_width,  bottom_ic_height], true);
                        // ridge
                        translate([0, 0, ridge_height/2]) {
                            cube([ic_length+ridge_width, ic_width+ridge_width,  bottom_ic_height+ridge_height], true);
                        }
                    }
                    // cut-out cube
                    translate([0, 0, floor_thickness+0.5]) {
                        cube([ic_length, ic_width, bottom_ic_height+1], true);
                    }
                    translate([-13, ic_width/2+1.1, bottom_ic_height/2+1.75]) {
                        // buttons cutout with a little margin
                        color("gray") buttons(bw=3.5, bl=3, bh=3.5, margin=0.2);
                    }
                }
            }
            pegs();
        }
        // HDMI port hole
        port_hole(length=12.5, height=4, dist_from_side=pi_zero_length/2-12.4, dist_from_bottom=5.4);
        // USB port 1
        port_hole(length=9, dist_from_side=pi_zero_length/2-41.4, dist_from_bottom=5.2);
        // USB port 2
        port_hole(length=9, dist_from_side=pi_zero_length/2-54, dist_from_bottom=5.2);
    }    
}

module top_case() {
    cutout_length=51;
    cutout_width=28;
    
    difference() {
        color("red") cube([ic_length+wall_width, ic_width+wall_width,  top_ic_height], true);
        translate([0, 0,-floor_thickness]) {
            color("blue") cube([ic_length, ic_width, top_ic_height], true);
        }
        // ridge
        translate([0, 0, -top_ic_height/2]) {
             color("green") cube([ic_length+ridge_width-0.4, ic_width+ridge_width+0.4, ridge_height*2], true);
        }
        translate([-13, ic_width/2+1.1, -top_ic_height/2+0.75]) {
            // buttons cutout with a little margin
            color("gray") buttons(bw=3.5, bl=3, bh=3.5, margin=0.2);
        }
        // screen cutout
        translate([-1.5, 0,  top_ic_height/2]) {
            color("pink") cube([cutout_length, cutout_width, 3], true);
        }
    }
}

module buttons(bw=3, bl=2.5, bh=2, margin=0.0) {
    // bw = button width
    // bl = button length
    // bh = button height
    
    for(x=[0, 9, 18, 27, 36]) {
        translate([x, 0, 0]) {
            union() {
                cube([bw, bl, bh], true);
                translate([0, -1,  0]) {
                    // button back plate
                    cube([bw+1+margin, 0.7, bh+1+margin], true);
                }
            }
        }
    }
}

module dev() {
    difference() {
        //intersection() {
         union () {
            rotate([0, 0, 180]) {
                translate([0, 0, 3.7]) {
                    zero(1);
                }
                translate([-0.5, 0, 12.5]) {
                    papirus_hat_pizero();
                }
            }
            
            bottom_case();
        //} 
            translate([0, 0,  top_ic_height/2 + bottom_ic_height]) {
                color("red") top_case();
            }
            translate([-13, ic_width/2+1, bottom_ic_height+1.25]) {
                color("lightblue") buttons();
            }
        }
        // cut through box
        //translate([25, 0,  0]) {
        //    cube([50, 50, 50], true);
        // }
     }
 }
 
 module print() {
    bottom_case();
    translate([0, pi_zero_width+10,  top_ic_height/2]) {
        rotate([180, 0, 0]) {
            top_case();
        }
    }
    translate([-16, 38, 1.2]) {
        rotate([90, 0, 0]) {
            buttons();
        }
    }
}

//dev();
print();

//TODO: clips
