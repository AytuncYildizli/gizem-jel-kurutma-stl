// Yuvarlak gel kurutma cercevesi V2 - DIS KULAKLI, BELIRGIN M3 VIDA DELIKLI
// Alt ve ust parcanin 4 kulaginda birebir hizali delikler vardir.
// Units: mm
$fn = 128;

outer_d = 120;      // ana halka dis cap
inner_d = 82;       // orta bosluk capi
frame_z = 4;        // cerceve kalinligi
lug_d = 18;         // vida kulagi capi
lug_r = 68;         // kulak merkezinin merkezden uzakligi
hole_d = 3.6;       // M3 vida gecis deligi; rahat gecsin diye 3.6
counter_d = 7.0;    // vida/pul basi icin ustte hafif yuva
counter_h = 1.0;
foot_d = 13;
foot_z = 10;
foot_r = 46;
rib_h = 0.7;
rib_w = 1.2;
PART = "assembly"; // lower, upper, assembly

module main_ring() {
  difference() {
    union() {
      cylinder(h=frame_z, d=outer_d, center=true);
      // 4 dis kulak
      for(a=[45,135,225,315]) rotate([0,0,a]) translate([lug_r,0,0]) cylinder(h=frame_z, d=lug_d, center=true);
    }
    cylinder(h=frame_z+1, d=inner_d, center=true);
    // kulak delikleri: alt-ust tamamen delik
    for(a=[45,135,225,315]) rotate([0,0,a]) translate([lug_r,0,0]) cylinder(h=frame_z+2, d=hole_d, center=true);
    // ust yuzeyde vida basi/pul icin hafif havsa/yuva
    for(a=[45,135,225,315]) rotate([0,0,a]) translate([lug_r,0,frame_z/2-counter_h/2]) cylinder(h=counter_h+0.05, d=counter_d, center=true);
  }
}

module grip_ribs() {
  // jelin kenarini kaydirmamasi icin ic/disa yakin iki ince halka
  translate([0,0,frame_z/2 + rib_h/2]) difference() {
    cylinder(h=rib_h, d=inner_d+8, center=true);
    cylinder(h=rib_h+0.2, d=inner_d+8-2*rib_w, center=true);
  }
  translate([0,0,frame_z/2 + rib_h/2]) difference() {
    cylinder(h=rib_h, d=outer_d-9+2*rib_w, center=true);
    cylinder(h=rib_h+0.2, d=outer_d-9, center=true);
  }
}

module lower_frame() {
  union() {
    main_ring();
    grip_ribs();
    // ayaklar: vida kulaklarina denk gelmesin diye 0/90/180/270 derece
    for(a=[0,90,180,270]) rotate([0,0,a]) translate([foot_r,0,-frame_z/2-foot_z/2]) cylinder(h=foot_z, d=foot_d, center=true);
  }
}

module upper_frame() {
  union() {
    main_ring();
    grip_ribs();
    // elle kaldirmak icin iki kucuk kulp, deliklerden ayri
    for(a=[0,180]) rotate([0,0,a]) translate([outer_d/2+10,0,0]) difference(){
      cylinder(h=frame_z, d=18, center=true);
      cylinder(h=frame_z+1, d=7, center=true);
    }
  }
}

if(PART=="lower") lower_frame();
else if(PART=="upper") upper_frame();
else { lower_frame(); translate([0,0,8]) upper_frame(); }
