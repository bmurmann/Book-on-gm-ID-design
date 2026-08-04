v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 910 -600 1710 -200 {flags=graph
y1=-23.2
y2=-15.2
ypos1=0
ypos2=2
divy=5
subdivy=8
unity=1
x1=-0.95215373
x2=10.047838
divx=5
subdivx=8
xlabmag=1.0
ylabmag=1.0


dataset=-1
unitx=1
logx=1
logy=1


color=4
node=onoise_spectrum
hilight_wave=-1}
T {tcleval(
sfl = [to_eng [xschem raw value \\@n.xm1.nsg13_lv_nmos\\\\[sfl\\\\]  0]]
sid = [to_eng [xschem raw value \\@n.xm1.nsg13_lv_nmos\\\\[sid\\\\]  0]]
gm = [to_eng [xschem raw value \\@n.xm1.nsg13_lv_nmos\\\\[gm\\\\]  0]]
ID = [to_eng [xschem raw value i(\\@n.xm1.nsg13_lv_nmos\\\\[ids\\\\])  0]]
gm/ID = [to_eng [xschem raw value \\@n.xm1.nsg13_lv_nmos\\\\[gm\\\\]  0]/[xschem raw value i(\\@n.xm1.nsg13_lv_nmos\\\\[ids\\\\])  0]]
gamma = [to_eng [expr [xschem raw value \\@n.xm1.nsg13_lv_nmos\\\\[sid\\\\]  0]/[xschem raw value \\@n.xm1.nsg13_lv_nmos\\\\[gm\\\\]  0]/4/1.38e-23/300 ]]
)} 560 -630 0 0 0.3 0.3 {floater=1}
N 550 -400 550 -380 {
lab=d}
N 430 -230 430 -200 {
lab=0}
N 740 -230 740 -200 {
lab=0}
N 650 -230 650 -200 {
lab=0}
N 550 -320 550 -200 {
lab=0}
N 650 -350 650 -290 {
lab=b}
N 430 -350 430 -290 {
lab=g}
N 430 -350 510 -350 {
lab=g}
N 550 -350 650 -350 {
lab=b}
N 550 -400 740 -400 {
lab=d}
N 740 -400 740 -290 {
lab=d}
N 820 -230 820 -200 {
lab=0}
N 820 -330 820 -290 {
lab=n}
N 740 -200 820 -200 {lab=0}
N 650 -200 740 -200 {lab=0}
N 550 -200 650 -200 {lab=0}
N 430 -200 550 -200 {lab=0}
C {devices/vsource.sym} 430 -260 0 0 {name=vg value="DC 0.6 AC 1" savecurrent=false}
C {devices/vsource.sym} 740 -260 0 0 {name=vd value=0.6 savecurrent=false}
C {devices/vsource.sym} 650 -260 0 1 {name=vb value=0 savecurrent=false}
C {devices/lab_wire.sym} 480 -350 0 0 {name=p1 sig_type=std_logic lab=g}
C {devices/lab_wire.sym} 650 -400 0 0 {name=p2 sig_type=std_logic lab=d}
C {devices/lab_wire.sym} 650 -350 0 0 {name=p3 sig_type=std_logic lab=b}
C {devices/code_shown.sym} 20 -700 0 0 {name=COMMANDS1 only_toplevel=false
value="
.param wx=5u lx=0.13u
.save all
.save @n.xm1.nsg13_lv_nmos[sfl]
.save @n.xm1.nsg13_lv_nmos[sid]
.save @n.xm1.nsg13_lv_nmos[gm]
.save @n.xm1.nsg13_lv_nmos[ids]

.control
set sqrnoise
noise v(n) vg dec 1 1 1e11 1
write noisetest_sg13_lv_nmos.raw noise1.all
setplot noise1
display
print onoise_n.xm1.nsg13_lv_nmos_flicker
print onoise_n.xm1.nsg13_lv_nmos_idid
print onoise_n.xm1.nsg13_lv_nmos_igig
op
print @n.xm1.nsg13_lv_nmos[sfl]
print @n.xm1.nsg13_lv_nmos[sid]
.endc
"}
C {devices/launcher.sym} 530 -730 0 0 {name=h3
descr="save, netlist & simulate"
tclcommand="xschem save; xschem netlist; xschem simulate"
value="
.param wx=5 lx=0.15 vbx=0
.save all
.save @m.xm1.msky130_fd_pr__nfet_01v8_lvt[gm]
.save @m.xm1.msky130_fd_pr__nfet_01v8_lvt[id]

.control
noise v(n) vg dec 10 1 1e11 1
dc vg 0.5 1 0.5
noise v(n) vg lin  1 1 1 1
echo $plots
*write noisetest_nfet_01v8_lvt.raw noise1.all
write noisetest_nfet_01v8_lvt.raw dc2.all noise1.all
wrdata noisetest_nfet_01v8_lvt.txt dc2.all noise1.all

setplot noise3
print onoise_spectrum
print onoise.m.xm1.msky130_fd_pr__nfet_01v8_lvt.1overf
print onoise.m.xm1.msky130_fd_pr__nfet_01v8_lvt.id
.endc
"}
C {devices/ccvs.sym} 820 -260 0 0 {name=Hn vnam=vd value=1}
C {devices/lab_wire.sym} 820 -330 0 0 {name=p4 sig_type=std_logic lab=n}
C {devices/launcher.sym} 530 -690 0 0 {name=h27
descr="load noise" 
tclcommand="
xschem raw_read $netlist_dir/[file tail [file rootname [xschem get current_name]]].raw noise; set show_hidden_texts 1 

"
}
C {devices/code_shown.sym} 70 -150 0 0 {name=MODEL only_toplevel=true
format="tcleval( @value )"
value="
.lib cornerMOSlv.lib mos_tt
"}
C {devices/lab_wire.sym} 480 -200 0 0 {name=p5 sig_type=std_logic lab=0}
C {title.sym} 180 -50 0 0 {name=l1 author="James Patrick"}
C {sg13cmos5l_pr/sg13_lv_nmos.sym} 530 -350 0 0 {name=M1
l=\{lx\}
w=\{wx\}
ng=1
m=1
mm_ok=1
model=sg13_lv_nmos
spiceprefix=X
}
