# SKY130

## Related presentation material 
[IEEE SSCS Chipathon, July 25, 2024: Transistor sizing basics](https://docs.google.com/presentation/d/e/2PACX-1vSLguBdByfrYl4dXrtKhNEulK_ybnILiF-jkwRwuG9YQStD4rTFOme-KROtFEr1gg/pub?start=false&loop=false&delayms=3000&pli=1&slide=id.p1)  
[IEEE SSCS Chipathon, August 1, 2024: Sizing a 5T OTA](https://docs.google.com/presentation/d/e/2PACX-1vRsXkpKEN2FEDzwbIBuY0PNdsgYScAbR_Q8w63SJDVIkGk4zOPSOtIKFO_bpm6jJg/pub?start=false&loop=false&delayms=3000&slide=id.p1)

## Modeling issues to be aware of
* Based on the $g_m/I_D$ versus $V_{GS}$ curves, the pfet models look non-physical in moderate and weak inversion. These models should probably not be used for designs with $V_{GS}-V_t < 150 mV$.
* The pfet_01v8 model has unrealistic intrinsic gain ($g_m/g_{ds}$) for long channels (e.g., ~1000 for $L=3\mu m$)
* The fringe capacitances of the pfets (cgsov, cgdov) are on the order of 20-50 $aF/\mu m$. This is unrealistically small.
* Not a modeling issue per se, but still important: The Ngspice op listing does not include the gate/drain fringe capacitances in cgg. However, these caps are included by Ngspice when running any other simulation, e.g. tran. The lookup tables generated here include estimates of the fringe caps in cgg so that we can properly design with these data.