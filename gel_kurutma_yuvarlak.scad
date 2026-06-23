// Yuvarlak gel kurutma cercevesi - alt + ust
// Units: mm
// Same logic as previous frame: gel edge is clamped, center stays open.

$fn = 120;

outer_d = 120;      // dis cap
inner_d = 82;       // ortadaki bos pencere capi
frame_z = 4;        // her cerceve kalinligi
foot_d = 13;
foot_z = 10;
foot_r_pos = 48;    // ayaklarin merkezden uzakligi
hole_d = 3.4;       // M3 vida/klips deligi; istersen mandal/lastik icin de kullanilir
hole_r_pos = 52;    // deliklerin merkezden uzakligi
peg_d = 2.7;        // alt cercevede hizalama pimi
peg_h = 2;
rib_h = 0.7;        // jel kenarini kaydirmasini azaltan hafif halka nervur
rib_w = 1.2;

PART = "assembly"; // lower, upper, assembly

module ring(z=frame_z) {
    difference() {
        cylinder(h=z, d=outer_d, center=true);
        cylinder(h=z+1, d=inner_d, center=true);
        // 4 adet M3 delik
        for (a=[45,135,225,315])
            rotate([0,0,a]) translate([hole_r_pos,0,0]) cylinder(h=z+2, d=hole_d, center=true);
    }
}

module pressure_ribs() {
    // ic ve dis kenara yakin cok hafif cikinti; jeli kesmeden tutmaya yardimci olur
    translate([0,0,frame_z/2 + rib_h/2]) difference() {
        cylinder(h=rib_h, d=inner_d + 8, center=true);
        cylinder(h=rib_h+0.2, d=inner_d + 8 - 2*rib_w, center=true);
    }
    translate([0,0,frame_z/2 + rib_h/2]) difference() {
        cylinder(h=rib_h, d=outer_d - 8 + 2*rib_w, center=true);
        cylinder(h=rib_h+0.2, d=outer_d - 8, center=true);
    }
}

module lower_frame() {
    union() {
        ring(frame_z);
        pressure_ribs();
        // 4 ayak: alttan hava gecsin
        for (a=[45,135,225,315])
            rotate([0,0,a]) translate([foot_r_pos,0,-frame_z/2-foot_z/2]) cylinder(h=foot_z, d=foot_d, center=true);
        // 4 kucuk hizalama pimi; ust parcanin deliklerine girer
        for (a=[45,135,225,315])
            rotate([0,0,a]) translate([hole_r_pos,0,frame_z/2]) cylinder(h=peg_h, d=peg_d, center=false);
    }
}

module upper_frame() {
    union() {
        ring(frame_z);
        pressure_ribs();
        // tutup kaldirmak icin iki kucuk kulak
        for (a=[0,180])
            rotate([0,0,a]) translate([outer_d/2 + 7,0,0]) difference() {
                cylinder(h=frame_z, d=16, center=true);
                translate([0,0,0]) cylinder(h=frame_z+1, d=6, center=true);
            }
    }
}

if (PART == "lower") lower_frame();
else if (PART == "upper") upper_frame();
else { lower_frame(); translate([0,0,8]) upper_frame(); }
