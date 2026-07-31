v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 1060 -340 1060 -310 {
lab=n}
N 800 -290 800 -260 {
lab=d}
N 680 -320 760 -320 {
lab=g}
N 680 -360 680 -320 {
lab=g}
N 680 -440 680 -420 {
lab=0}
N 680 -440 800 -440 {
lab=0}
N 800 -440 800 -350 {
lab=0}
N 800 -440 890 -440 {
lab=0}
N 890 -440 890 -420 {
lab=0}
N 890 -360 890 -320 {
lab=b}
N 800 -320 890 -320 {
lab=b}
N 890 -440 980 -440 {
lab=0}
N 980 -440 980 -420 {
lab=0}
N 980 -360 980 -260 {
lab=d}
N 800 -260 980 -260 {
lab=d}
N 980 -440 1060 -440 {
lab=0}
N 1060 -440 1060 -400 {
lab=0}
C {simulator_commands_shown.sym} 680 -960 0 0 {name=Simulator2
simulator=ngspice
only_toplevel=false 
value="
.save @n.xm1.nsg13_lv_pmos[cdd]
.save @n.xm1.nsg13_lv_pmos[cgb]
.save @n.xm1.nsg13_lv_pmos[cgd]
.save @n.xm1.nsg13_lv_pmos[cgdol]
.save @n.xm1.nsg13_lv_pmos[cgg]
.save @n.xm1.nsg13_lv_pmos[cgs]
.save @n.xm1.nsg13_lv_pmos[cgsol]
.save @n.xm1.nsg13_lv_pmos[cjd]
.save @n.xm1.nsg13_lv_pmos[cjs]
.save @n.xm1.nsg13_lv_pmos[css]
.save @n.xm1.nsg13_lv_pmos[gds]
.save @n.xm1.nsg13_lv_pmos[gm]
.save @n.xm1.nsg13_lv_pmos[gmb]
.save @n.xm1.nsg13_lv_pmos[ids]
.save @n.xm1.nsg13_lv_pmos[l]
.save @n.xm1.nsg13_lv_pmos[sfl]
.save @n.xm1.nsg13_lv_pmos[sid]
.save @n.xm1.nsg13_lv_pmos[vth]
.save @vb[dc]
.save @vd[dc]
.save @vg[dc]
.save onoise.m.xm1.nsg13_lv_pmos.id
.save onoise.m.xm1.nsg13_lv_pmos.1overf
.save g d b n
"}
C {simulator_commands_shown.sym} 10 -960 0 0 {name=Simulator1
simulator=ngspice
only_toplevel=false 
value="
.param wx=5u lx=0.13u
.op

.control
option numdgt = 3
set wr_singlescale
set wr_vecnames

compose l_vec  values 0.13u 0.14u 0.15u 0.16u 0.17u 0.18u 0.19u
+ 0.2u 0.3u 0.4u 0.5u 0.6u 0.7u 0.8u 0.9u 1u 2u 3u
compose vg_vec start= 0 stop=1.201  step=25m
compose vd_vec start= 0 stop=1.201  step=25m
compose vb_vec start= 0 stop=-0.4 step=-0.2

foreach var1 $&l_vec
  alterparam lx=$var1
  reset
  foreach var2 $&vg_vec
    alter vg $var2
    foreach var3 $&vd_vec
      alter vd $var3
      foreach var4 $&vb_vec
        alter vb $var4
        run
        wrdata techsweep_sg13_lv_pmos.txt all
        destroy all
        set appendwrite
        unset set wr_vecnames  
      end
    end 
  end
end
unset appendwrite

alterparam lx=0.13u
reset
op
show
write techsweep_sg13_lv_pmos.raw
.endc
"}
C {launcher.sym} 1100 -620 0 0 {name=h1
descr="save, netlist & simulate"
tclcommand="xschem save; xschem netlist; xschem simulate"}
C {launcher.sym} 1100 -560 0 0 {name=h2
descr="load op & annotate" 
tclcommand="xschem raw_read $netlist_dir/techsweep_sg13_lv_nmos.raw; set show_hidden_texts 1; xschem annotate_op"}
C {devices/ngspice_get_value.sym} 1210 -390 0 0 {name=r2 node=v(@n.xm1.nsg13_lv_pmos[vth])
descr="Vt="}
C {devices/ngspice_get_value.sym} 1210 -350 0 0 {name=r3 node=@n.xm1.nsg13_lv_pmos[cgg]
descr="cgg="}
C {devices/ngspice_get_expr.sym} 1320 -310 0 0 {name=r4 
node="[format %.4g [expr [ngspice::get_node \{@n.xm1.nsg13_lv_pmos[gm]\}] / [ngspice::get_node \{@n.xm1.nsg13_lv_pmos[gds]\}]]]"
descr="gm/gds="}
C {devices/ngspice_get_value.sym} 1210 -310 0 0 {name=r5 node=@n.xm1.nsg13_lv_pmos[cjd]
descr="cjd="}
C {devices/ngspice_get_value.sym} 1210 -270 0 0 {name=r6 node=@n.xm1.nsg13_lv_pmos[cjs]
descr="cjs="}
C {devices/ngspice_get_expr.sym} 1320 -350 0 0 {name=r7 
node="[format %.4g [expr [ngspice::get_node \{@n.xm1.nsg13_lv_pmos[gm]\}] / [ngspice::get_node \{@n.xm1.nsg13_lv_pmos[cgg]\}] / 6.283]]"
descr="fT_intrinsic="}
C {devices/ngspice_get_expr.sym} 1320 -390 0 0 {name=r8 
node="[format %.4g [expr [ngspice::get_node \{@n.xm1.nsg13_lv_pmos[gm]\}] / [ngspice::get_node \{i(@n.xm1.nsg13_lv_pmos[ids])\}]]]"
descr="gm/ID="}
C {title.sym} 180 -50 0 0 {name=l1 author="James Patrick"}
C {simulator_commands_shown.sym} 680 -170 0 0 {name=Libs_Ngspice
simulator=ngspice
only_toplevel=false 
value="
.lib cornerMOSlv.lib mos_tt
"}
C {devices/ccvs.sym} 1060 -370 0 0 {name=Hn vnam=vd value=1}
C {devices/lab_wire.sym} 1060 -310 0 0 {name=p6 sig_type=std_logic lab=n}
C {devices/vsource.sym} 680 -390 0 0 {name=vg value="DC 0.6 AC 1" savecurrent=false}
C {devices/vsource.sym} 980 -390 0 0 {name=vd value=0.6 savecurrent=false}
C {devices/lab_wire.sym} 890 -320 0 0 {name=p7 sig_type=std_logic lab=b}
C {devices/lab_wire.sym} 890 -260 0 0 {name=p8 sig_type=std_logic lab=d}
C {devices/lab_wire.sym} 710 -320 0 0 {name=p9 sig_type=std_logic lab=g}
C {devices/vsource.sym} 890 -390 0 0 {name=vb value="0" savecurrent=false}
C {devices/lab_wire.sym} 710 -440 0 0 {name=p10 sig_type=std_logic lab=0}
C {sg13cmos5l_pr/sg13_lv_pmos.sym} 780 -320 0 0 {name=M1
l=\{lx\}
w=\{wx\}
ng=1
m=1
mm_ok=1
model=sg13_lv_pmos
spiceprefix=X
}
