v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 690 -400 690 -350 {lab=g}
N 690 -400 800 -400 {lab=g}
N 690 -290 690 -240 {lab=0}
N 690 -240 840 -240 {lab=0}
N 840 -370 840 -240 {lab=0}
N 840 -240 970 -240 {lab=0}
N 970 -290 970 -240 {lab=0}
N 970 -240 1110 -240 {lab=0}
N 1110 -290 1110 -240 {lab=0}
N 1110 -240 1250 -240 {lab=0}
N 1250 -290 1250 -240 {lab=0}
N 840 -400 970 -400 {lab=b}
N 970 -400 970 -350 {lab=b}
N 840 -470 840 -430 {lab=d}
N 840 -470 1110 -470 {lab=d}
N 1110 -470 1110 -350 {lab=d}
N 1250 -400 1250 -350 {lab=n}
C {vsource.sym} 690 -320 0 0 {name=vg value="DC 0.6 AC 1" savecurrent=false}
C {vsource.sym} 970 -320 0 0 {name=vb value=0 savecurrent=false}
C {vsource.sym} 1110 -320 0 0 {name=vd value=0.6 savecurrent=false}
C {ccvs.sym} 1250 -320 0 0 {name=Hn vnam=vd value=1}
C {lab_wire.sym} 970 -470 0 0 {name=p1 sig_type=std_logic lab=d}
C {lab_wire.sym} 970 -400 0 0 {name=p2 sig_type=std_logic lab=b}
C {lab_wire.sym} 760 -400 0 0 {name=p3 sig_type=std_logic lab=g}
C {lab_wire.sym} 1250 -400 0 0 {name=p4 sig_type=std_logic lab=n}
C {simulator_commands_shown.sym} 680 -960 0 0 {name=Simulator2
simulator=ngspice
only_toplevel=false 
value="
.save @n.xm1.nsg13_lv_nmos[cdd]
.save @n.xm1.nsg13_lv_nmos[cgb]
.save @n.xm1.nsg13_lv_nmos[cgd]
.save @n.xm1.nsg13_lv_nmos[cgdol]
.save @n.xm1.nsg13_lv_nmos[cgg]
.save @n.xm1.nsg13_lv_nmos[cgs]
.save @n.xm1.nsg13_lv_nmos[cgsol]
.save @n.xm1.nsg13_lv_nmos[cjd]
.save @n.xm1.nsg13_lv_nmos[cjs]
.save @n.xm1.nsg13_lv_nmos[css]
.save @n.xm1.nsg13_lv_nmos[gds]
.save @n.xm1.nsg13_lv_nmos[gm]
.save @n.xm1.nsg13_lv_nmos[gmb]
.save @n.xm1.nsg13_lv_nmos[ids]
.save @n.xm1.nsg13_lv_nmos[l]
.save @n.xm1.nsg13_lv_nmos[sfl]
.save @n.xm1.nsg13_lv_nmos[sid]
.save @n.xm1.nsg13_lv_nmos[vth]
.save @vb[dc]
.save @vd[dc]
.save @vg[dc]
.save onoise.m.xm1.nsg13_lv_nmos.id
.save onoise.m.xm1.nsg13_lv_nmos.1overf
.save g d b n
"}
C {simulator_commands_shown.sym} 10 -960 0 0 {name=Simulator1
simulator=ngspice
only_toplevel=false 
value="
.param wx=5u lx=0.72u
.op

.control
option numdgt = 3
set wr_singlescale
set wr_vecnames

compose l_vec  values 0.72u 0.73u 0.74u 0.75u 0.76u 0.77u 0.78u 0.79u
+ 0.8u 0.9u 1u 2u 3u 4u 5u
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
        wrdata techsweep_sg13_lv_nmos_rf.txt all
        destroy all
        set appendwrite
        unset set wr_vecnames  
      end
    end 
  end
end
unset appendwrite

alterparam lx=0.72u
reset
op
show
write techsweep_sg13_lv_nmos_rf.raw
.endc
"}
C {launcher.sym} 1180 -620 0 0 {name=h1
descr="save, netlist & simulate"
tclcommand="xschem save; xschem netlist; xschem simulate"}
C {launcher.sym} 1180 -560 0 0 {name=h2
descr="load op & annotate" 
tclcommand="xschem raw_read $netlist_dir/techsweep_sg13_lv_nmos.raw; set show_hidden_texts 1; xschem annotate_op"}
C {devices/ngspice_get_value.sym} 1360 -390 0 0 {name=r2 node=v(@n.xm1.nsg13_lv_nmos[vth])
descr="Vt="}
C {devices/ngspice_get_value.sym} 1360 -350 0 0 {name=r3 node=@n.xm1.nsg13_lv_nmos[cgg]
descr="cgg="}
C {devices/ngspice_get_expr.sym} 1470 -310 0 0 {name=r4 
node="[format %.4g [expr [ngspice::get_node \{@n.xm1.nsg13_lv_nmos[gm]\}] / [ngspice::get_node \{@n.xm1.nsg13_lv_nmos[gds]\}]]]"
descr="gm/gds="}
C {devices/ngspice_get_value.sym} 1360 -310 0 0 {name=r5 node=@n.xm1.nsg13_lv_nmos[cjd]
descr="cjd="}
C {devices/ngspice_get_value.sym} 1360 -270 0 0 {name=r6 node=@n.xm1.nsg13_lv_nmos[cjs]
descr="cjs="}
C {devices/ngspice_get_expr.sym} 1470 -350 0 0 {name=r7 
node="[format %.4g [expr [ngspice::get_node \{@n.xm1.nsg13_lv_nmos[gm]\}] / [ngspice::get_node \{@n.xm1.nsg13_lv_nmos[cgg]\}] / 6.283]]"
descr="fT_intrinsic="}
C {devices/ngspice_get_expr.sym} 1470 -390 0 0 {name=r8 
node="[format %.4g [expr [ngspice::get_node \{@n.xm1.nsg13_lv_nmos[gm]\}] / [ngspice::get_node \{i(@n.xm1.nsg13_lv_nmos[ids])\}]]]"
descr="gm/ID="}
C {title.sym} 180 -50 0 0 {name=l1 author="James Patrick"}
C {lab_wire.sym} 760 -240 0 0 {name=p5 sig_type=std_logic lab=0}
C {simulator_commands_shown.sym} 690 -160 0 0 {name=Libs_Ngspice
simulator=ngspice
only_toplevel=false 
value="
.lib cornerMOSlv.lib mos_tt
"}
C {sg13cmos5l_pr/sg13_lv_rf_nmos.sym} 820 -400 0 0 {name=M1
l=\{lx\}
w=\{wx\}
ng=1
 m=1
 rfmode=1
  mm_ok=1
 model=sg13_lv_nmos
lvs_model=rfnmos
spiceprefix=X
}
