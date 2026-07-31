v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 540 -400 540 -350 {lab=g}
N 540 -400 650 -400 {lab=g}
N 540 -290 540 -240 {lab=0}
N 540 -240 690 -240 {lab=0}
N 690 -370 690 -240 {lab=0}
N 690 -240 820 -240 {lab=0}
N 820 -290 820 -240 {lab=0}
N 820 -240 960 -240 {lab=0}
N 960 -290 960 -240 {lab=0}
N 960 -240 1100 -240 {lab=0}
N 1100 -290 1100 -240 {lab=0}
N 690 -400 820 -400 {lab=b}
N 820 -400 820 -350 {lab=b}
N 690 -470 690 -430 {lab=d}
N 690 -470 960 -470 {lab=d}
N 960 -470 960 -350 {lab=d}
N 1100 -400 1100 -350 {lab=n}
C {vsource.sym} 540 -320 0 0 {name=vg value="DC 0.6 AC 1" savecurrent=false}
C {vsource.sym} 820 -320 0 0 {name=vb value=0 savecurrent=false}
C {vsource.sym} 960 -320 0 0 {name=vd value=1.65 savecurrent=false}
C {ccvs.sym} 1100 -320 0 0 {name=Hn vnam=vd value=1}
C {lab_wire.sym} 820 -470 0 0 {name=p1 sig_type=std_logic lab=d}
C {lab_wire.sym} 820 -400 0 0 {name=p2 sig_type=std_logic lab=b}
C {lab_wire.sym} 610 -400 0 0 {name=p3 sig_type=std_logic lab=g}
C {lab_wire.sym} 1100 -400 0 0 {name=p4 sig_type=std_logic lab=n}
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
.save @n.xm1.nsg13_hv_nmos[cdd]
.save @n.xm1.nsg13_hv_nmos[cgb]
.save @n.xm1.nsg13_hv_nmos[cgd]
.save @n.xm1.nsg13_hv_nmos[cgdol]
.save @n.xm1.nsg13_hv_nmos[cgg]
.save @n.xm1.nsg13_hv_nmos[cgs]
.save @n.xm1.nsg13_hv_nmos[cgsol]
.save @n.xm1.nsg13_hv_nmos[cjd]
.save @n.xm1.nsg13_hv_nmos[cjs]
.save @n.xm1.nsg13_hv_nmos[css]
.save @n.xm1.nsg13_hv_nmos[gds]
.save @n.xm1.nsg13_hv_nmos[gm]
.save @n.xm1.nsg13_hv_nmos[gmb]
.save @n.xm1.nsg13_hv_nmos[ids]
.save @n.xm1.nsg13_hv_nmos[l]
.save @n.xm1.nsg13_hv_nmos[sfl]
.save @n.xm1.nsg13_hv_nmos[sid]
.save @n.xm1.nsg13_hv_nmos[vth]
.save @vb[dc]
.save @vd[dc]
.save @vg[dc]
.save onoise.m.xm1.nsg13_hv_nmos.id
.save onoise.m.xm1.nsg13_hv_nmos.1overf
.save g d b n
"}
C {simulator_commands_shown.sym} 10 -960 0 0 {name=Simulator1
simulator=ngspice
only_toplevel=false 
value="
.param wx=5u lx=0.8u
.op

.control
option numdgt = 3
set wr_singlescale
set wr_vecnames

compose l_vec  values 0.8u 0.85u 0.89 0.95u 1u
+ 2u 3u 4u 5u
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
        wrdata techsweep_sg13_hv_nmos_rf.txt all
        destroy all
        set appendwrite
        unset set wr_vecnames  
      end
    end 
  end
end
unset appendwrite

alterparam lx=0.8u
reset
op
show
write techsweep_sg13_hv_nmos_rf.raw
.endc
"}
C {launcher.sym} 950 -620 0 0 {name=h1
descr="save, netlist & simulate"
tclcommand="xschem save; xschem netlist; xschem simulate"}
C {launcher.sym} 950 -560 0 0 {name=h2
descr="load op & annotate" 
tclcommand="xschem raw_read $netlist_dir/techsweep_sg13_lv_nmos.raw; set show_hidden_texts 1; xschem annotate_op"}
C {devices/ngspice_get_value.sym} 1210 -390 0 0 {name=r2 node=v(@n.xm1.nsg13_hv_nmos[vth])
descr="Vt="}
C {devices/ngspice_get_value.sym} 1210 -350 0 0 {name=r3 node=@n.xm1.nsg13_hv_nmos[cgg]
descr="cgg="}
C {devices/ngspice_get_expr.sym} 1320 -310 0 0 {name=r4 
node="[format %.4g [expr [ngspice::get_node \{@n.xm1.nsg13_hv_nmos[gm]\}] / [ngspice::get_node \{@n.xm1.nsg13_hv_nmos[gds]\}]]]"
descr="gm/gds="}
C {devices/ngspice_get_value.sym} 1210 -310 0 0 {name=r5 node=@n.xm1.nsg13_hv_nmos[cjd]
descr="cjd="}
C {devices/ngspice_get_value.sym} 1210 -270 0 0 {name=r6 node=@n.xm1.nsg13_hv_nmos[cjs]
descr="cjs="}
C {devices/ngspice_get_expr.sym} 1320 -350 0 0 {name=r7 
node="[format %.4g [expr [ngspice::get_node \{@n.xm1.nsg13_hv_nmos[gm]\}] / [ngspice::get_node \{@n.xm1.nsg13_hv_nmos[cgg]\}] / 6.283]]"
descr="fT_intrinsic="}
C {devices/ngspice_get_expr.sym} 1320 -390 0 0 {name=r8 
node="[format %.4g [expr [ngspice::get_node \{@n.xm1.nsg13_hv_nmos[gm]\}] / [ngspice::get_node \{i(@n.xm1.nsg13_hv_nmos[ids])\}]]]"
descr="gm/ID="}
C {title.sym} 180 -50 0 0 {name=l1 author="James Patrick"}
C {lab_wire.sym} 610 -240 0 0 {name=p5 sig_type=std_logic lab=0}
C {sg13cmos5l_pr/sg13_hv_rf_nmos.sym} 670 -400 0 0 {name=M1
l=\{lx\}
w=\{wx\}
ng=1
 m=1
 rfmode=1
  mm_ok=1
 model=sg13_hv_nmos
lvs_model=rfnmoshv
spiceprefix=X
}
