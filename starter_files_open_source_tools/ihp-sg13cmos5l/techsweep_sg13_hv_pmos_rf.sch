v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 930 -360 930 -330 {
lab=n}
N 670 -310 670 -280 {
lab=d}
N 550 -340 630 -340 {
lab=g}
N 550 -380 550 -340 {
lab=g}
N 550 -460 550 -440 {
lab=0}
N 550 -460 670 -460 {
lab=0}
N 670 -460 670 -370 {
lab=0}
N 670 -460 760 -460 {
lab=0}
N 760 -460 760 -440 {
lab=0}
N 760 -380 760 -340 {
lab=b}
N 670 -340 760 -340 {
lab=b}
N 760 -460 850 -460 {
lab=0}
N 850 -460 850 -440 {
lab=0}
N 850 -380 850 -280 {
lab=d}
N 670 -280 850 -280 {
lab=d}
N 850 -460 930 -460 {
lab=0}
N 930 -460 930 -420 {
lab=0}
C {simulator_commands_shown.sym} 540 -160 0 0 {name=Libs_Ngspice
simulator=ngspice
only_toplevel=false 
value="
.lib cornerMOShv.lib mos_tt
"}
C {simulator_commands_shown.sym} 530 -960 0 0 {name=Simulator2
simulator=ngspice
only_toplevel=false 
value="
.save @n.xm1.nsg13_hv_pmos[cdd]
.save @n.xm1.nsg13_hv_pmos[cgb]
.save @n.xm1.nsg13_hv_pmos[cgd]
.save @n.xm1.nsg13_hv_pmos[cgdol]
.save @n.xm1.nsg13_hv_pmos[cgg]
.save @n.xm1.nsg13_hv_pmos[cgs]
.save @n.xm1.nsg13_hv_pmos[cgsol]
.save @n.xm1.nsg13_hv_pmos[cjd]
.save @n.xm1.nsg13_hv_pmos[cjs]
.save @n.xm1.nsg13_hv_pmos[css]
.save @n.xm1.nsg13_hv_pmos[gds]
.save @n.xm1.nsg13_hv_pmos[gm]
.save @n.xm1.nsg13_hv_pmos[gmb]
.save @n.xm1.nsg13_hv_pmos[ids]
.save @n.xm1.nsg13_hv_pmos[l]
.save @n.xm1.nsg13_hv_pmos[sfl]
.save @n.xm1.nsg13_hv_pmos[sid]
.save @n.xm1.nsg13_hv_pmos[vth]
.save @vb[dc]
.save @vd[dc]
.save @vg[dc]
.save onoise.m.xm1.nsg13_hv_pmos.id
.save onoise.m.xm1.nsg13_hv_pmos.1overf
.save g d b n
"}
C {simulator_commands_shown.sym} 10 -960 0 0 {name=Simulator1
simulator=ngspice
only_toplevel=false 
value="
.param wx=5u lx=0.4u
.op

.control
option numdgt = 3
set wr_singlescale
set wr_vecnames

compose l_vec  values 0.4u 0.45u 0.5u 0.55u
+ 0.6u 0.7u 0.8u 0.9u 1u 2u 3u
compose vg_vec start= 0 stop=3.301  step=25m
compose vd_vec start= 0 stop=3.301  step=25m
compose vb_vec start= 0 stop=-0.6   step=-0.2

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
        wrdata techsweep_sg13_hv_pmos_rf.txt all
        destroy all
        set appendwrite
        unset set wr_vecnames  
      end
    end 
  end
end
unset appendwrite

alterparam lx=0.4u
reset
op
show
write techsweep_sg13_hv_pmos_rf.raw
.endc
"}
C {launcher.sym} 950 -620 0 0 {name=h1
descr="save, netlist & simulate"
tclcommand="xschem save; xschem netlist; xschem simulate"}
C {launcher.sym} 950 -560 0 0 {name=h2
descr="load op & annotate" 
tclcommand="xschem raw_read $netlist_dir/techsweep_sg13_lv_nmos.raw; set show_hidden_texts 1; xschem annotate_op"}
C {title.sym} 180 -50 0 0 {name=l1 author="James Patrick"}
C {devices/ngspice_get_value.sym} 1050 -410 0 0 {name=r1 node=v(@n.xm1.nsg13_hv_pmos[vth])
descr="Vt="}
C {devices/ngspice_get_value.sym} 1050 -370 0 0 {name=r2 node=@n.xm1.nsg13_hv_pmos[cgg]
descr="cgg="}
C {devices/ngspice_get_expr.sym} 1160 -330 0 0 {name=r4 
node="[format %.4g [expr [ngspice::get_node \{@n.xm1.nsg13_hv_pmos[gm]\}] / [ngspice::get_node \{@n.xm1.nsg13_hv_pmos[gds]\}]]]"
descr="gm/gds="}
C {devices/ngspice_get_value.sym} 1050 -330 0 0 {name=r3 node=@n.xm1.nsg13_hv_pmos[cjd]
descr="cjd="}
C {devices/ngspice_get_value.sym} 1050 -290 0 0 {name=r5 node=@n.xm1.nsg13_hv_pmos[cjs]
descr="cjs="}
C {devices/ngspice_get_expr.sym} 1160 -370 0 0 {name=r6 
node="[format %.4g [expr [ngspice::get_node \{@n.xm1.nsg13_hv_pmos[gm]\}] / [ngspice::get_node \{@n.xm1.nsg13_hv_pmos[cgg]\}] / 6.283]]"
descr="fT_intrinsic="}
C {devices/ngspice_get_expr.sym} 1160 -410 0 0 {name=r7 
node="[format %.4g [expr [ngspice::get_node \{@n.xm1.nsg13_hv_pmos[gm]\}] / [ngspice::get_node \{i(@n.xm1.nsg13_hv_pmos[ids])\}]]]"
descr="gm/ID="}
C {devices/ccvs.sym} 930 -390 0 0 {name=Hn vnam=vd value=1}
C {devices/lab_wire.sym} 930 -330 0 0 {name=p4 sig_type=std_logic lab=n}
C {devices/vsource.sym} 550 -410 0 0 {name=vg value="DC 0.8 AC 1" savecurrent=false}
C {devices/vsource.sym} 850 -410 0 0 {name=vd value=1.65 savecurrent=false}
C {devices/lab_wire.sym} 760 -340 0 0 {name=p2 sig_type=std_logic lab=b}
C {devices/lab_wire.sym} 760 -280 0 0 {name=p3 sig_type=std_logic lab=d}
C {devices/lab_wire.sym} 580 -340 0 0 {name=p1 sig_type=std_logic lab=g}
C {devices/vsource.sym} 760 -410 0 0 {name=vb value="0" savecurrent=false}
C {devices/lab_wire.sym} 580 -460 0 0 {name=p5 sig_type=std_logic lab=0}
C {sg13cmos5l_pr/sg13_hv_rf_pmos.sym} 650 -340 0 0 {name=M1
l=\{lx\}
w=\{wx\}
ng=1
 m=1
 rfmode=1
  mm_ok=1
 model=sg13_hv_pmos
lvs_model=rfpmoshv
spiceprefix=X
}
