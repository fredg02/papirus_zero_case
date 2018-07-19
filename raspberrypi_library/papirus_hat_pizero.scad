/* (c) 2018 by fredg02 
 *  https://github.com/fredg02/raspberrypi_library
 *
 * PaPiRus hat model library for generating cases etc.
 *
 * Based on model library from Saarbastler:
 * https://github.com/saarbastler/library.scad
 *
 */

$fn=100;

// female header
module female_header(pins, rows) {
  color("black") cube([2.54*pins,2.54*rows,3.5]);
}

// PaPiRus HAT for Raspberry Pi Zero W
module papirus_hat_pizero() {
    // PCB
    color("white") difference() {
        hull() {
          translate([-(65-6)/2,-(30-6)/2,0]) cylinder(r=3, h=1.4 );
          translate([-(65-6)/2, (30-6)/2,0]) cylinder(r=3, h=1.4 );
          translate([ (65-6)/2,-(30-6)/2,0]) cylinder(r=3, h=1.4 );
          translate([ (65-6)/2, (30-6)/2,0]) cylinder(r=3, h=1.4 );
        }
        // holes
        translate([-65/2+3.5,-23/2,-1]) cylinder(d=2.75, h=3);
        translate([-65/2+3.5, 23/2,-1]) cylinder(d=2.75, h=3);
    }

    translate([3.5-65/2+29-10*2.54,30/2-3.5-2.54,0]) {
        mirror([0,0,1]) female_header(20,2);
    }
    
    translate([-65/2,-30/2,-1.4]) {
        // jumper
        color("silver") translate([-0.5,17-6/2,-0.5]) cube([8,6,2]);    

        // buttons
        for(x=[10, 19, 28, 37, 46]) {
            color("silver") translate([x-2/2, -0.25,0.5]) cube([2, 1.5, 1]);
        }
    
        // screen port
        screen_port_width=23;
        color("darkgrey") translate([65-3.5,(30-screen_port_width)/2,0]) cube([4, screen_port_width, 1.5]);  
    }
    // pads
    color("lightgrey") translate([-17, -5, 1.4]) cube([10, 10, 1.7]);
    color("lightgrey") translate([5, -5, 1.4]) cube([10, 10, 1.7]);
    
    // screen
    color("lightgrey") translate([-23, -14, 3.1]) cube([50, 27, 0.5]);  
}

papirus_hat_pizero();