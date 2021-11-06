$fa=1;
$fs=1;

/*
========================USER DEFINED VARIABLES========================
*/
//strip minimal width
smw=5;
//bottle base diameter (double of the distance between hole and cutting space)
bd=110;
//blade thickness
bt=1;
//blade width
bw=10;
//cutting side
cs=-1;//[-1,1]
//rope passing hole size (proportion of blade width)
hr=0.7;//[0.01:0.01:1]
//wood screws diameter
wsd=4;
//screw diameter
sd=3;
//nut thickness
nt=3;
//nut width
nw=5;
//body plate height
bph=5;
//nuber of steps
nbs=6;
//step size
ss=1;
//spacer base height
sbh=20;
//body center walls thickness
bcwt=5;
//spacer holder height
shh=7;
//spacer disgaging probe ("stick") diameter
spd=4;
//cutting space angle ratio
csar=0.98;//[0.01:0.01:1]
/*
========================VARIABLES DECLARATION========================
*/
bbr=bd/2;//bottle base radius

bcw=bw+(bcwt*2);//body center width
ssl=(bbr-bcw/2)/nbs;//spacer step length

bl=bbr*2+bcw;//body length
bch=bph+sbh+smw;//body center height


sw=bw;//spacer width

pbw=wsd*2;//plate border width
bpw=bcw+(pbw*2);//body plate width

bho=bbr/3;//blade holders offset
bhh=nt*3.5;//blade holders height
bhl=nw*2;//blade holders length
nho=nt*0.75;//nut holder offset

csh=(bch-bph)*2;//cuting space height

bbh=shh+bph;//base bottom height

/*
========================MODULES DECLARATION========================
*/
module spacer(){
    union(){
        for(i=[0:nbs-1]){
            translate([0,(i+1)*ssl/2,(sbh-i*ss)/2]) cube([sw,(i+1)*ssl,sbh-i*ss],center=true);
        }
    }
}


module body(){
    difference(){
        union(){
            //body plate
            translate([0,0,bph/2]) cube([bpw,bl,bph],center=true);
            //body center
            translate([0,0,bch/2]) cube([bcw,bl,bch],center=true);
            //blade holding screw mount
            translate([0,-bho,bch]) difference(){
                cube([bcw,bhl,bhh],center=true);
                cylinder(d=sd,h=bch,center=true);
                translate([0,0,nho]) cube([bcw*2,nw,nt],center=true);
                }
            //secondary blade holder
            translate([0,bho,bch]) cube([bcw,bhl,bt*4],center=true);
            
            //spacer holding screw mount  
            translate([((bcw/2)+(nt*0.9))*cs,0,bph+shh/2]) cube([nt*2,nw*2,shh],center=true);
            
        }
        
        //body center hollow element
        translate([0,-bcw,bph+(sbh/2)]) cube([sw,bl,sbh],center=true);
        
        //spacer disgaging "poke with a stick" acess latch ("hole")
        translate([0,0,bph+spd/2]) rotate([-90,0,0]) cylinder(d=spd,h=bl);
        
        //plate holding wood screws
        for(i=[-1,1]){
            for(j=[-1,1]){
                translate([(bpw/2-wsd)*i,(bl/2-wsd)*j,0]) cylinder (d=wsd,h=20,center=true);
            }
        }
        //rope passing hole
        translate([0,bl/2-bcw/2,bch]) rotate([45,0,0]) cylinder(d=bw*hr,h=bch*1.5,center=true);
        //spacer holding screw nut mount
        translate([((bcw/2)+(nt*0.9))*cs,0,0]) cube([3,5,100],center=true);
        //spacer holding screw hole
        translate([((bcw/2)+(nt*0.9))*cs,0,bph+shh/2]) rotate([0,90,0]) cylinder(d=sd,h=30,center=true);
        //cutting space
        translate([0,0,bch]) cube([bpw,1.5,csh],center=true);
        //blade groove element
        translate([0,-bcw,bch]) cube([bw,bl,bt],center=true);
    }
}





module base(){
    difference(){
        //cuting space angle elements
        for(i=[-1,1]){
            translate([0,bbr*i,bch]) cylinder(h=bch*2,r1=bbr,r2=bbr*csar,center=true);
        }
        //extremity cube (allow for more precise forming on rope end)
        translate([-bbr,bl/2-bcw/2,-bch/2]) cube([bbr*2,bbr*2,bch*3]);
    }
    //rope end modeling cylinder
    translate([0,bl/2-bcw/2,bch]) cylinder(h=bch*2,d=bcw,center=true);
    //spacer holder rectifier (prevent it from being deformed when carving cuting space angle)
    translate([0,-bcw/2,bbh/2]) cube([bpw,bl,bbh],center=true);
    //body plate element (to prevent it from being removed by keeping it in selection)
    translate([0,0,bph/2]) cube([bpw,bl,bph],center=true);
    
}


module attachment(){
    difference(){
        cylinder(d=bhl,h=nt,center=true);
        cylinder(d=sd,h=nt*2,center=true);
        difference(){
                cylinder(d=bhl*1.5,h=nt/2,center=true);
                cylinder(d=bhl/1.5,h=nt,center=true);
            }
    }
}


intersection(){
    body();
    base();
}

translate([bpw/2+sw,0,0]) spacer();
translate([bpw/2+sw+bhl*1.5,bhl/2,nt/2]) attachment();

echo(bl);





