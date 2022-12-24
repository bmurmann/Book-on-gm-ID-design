**Book**

| Page | Problem | Correction | Comment |
|:-------:|---------|------------|---------|
| 13 | In Table 1.1: $J_D$ $( \mu A/m)$ | $J_D$ $(A/m)$ | |
| 13 | Equation (1.6) uses the wrong value for $I_D/W$ (149 A/m)| Using the currect value form Table 1.1 (162 A/m), the correct result is $W = 12.3 \mu \,m$ | |
| 139 | The situation is similar for larger signals, which require lower q when the same distortion level must be maintained. | The situation is similar for larger signals, which require higher q when the same distortion level must be maintained. | |
| 192 | <img src="table5.7_old.png" width="300" /> | <img src="table5.7_new.png" width="300" /> | |
| 194 | Table 5.8, row 1, column 9: $V_{GS2}$ | Replace with $V_B$ | |
| 244 | $t_{lin} = \tau ln({1 \over \epsilon_d} \cdot {v_{OD,final} \over v_{OD,lin}})$  (6.34) | $t_{lin} = \tau ln({1 \over \epsilon_d} \cdot {v_{OD,lin} \over v_{OD,final}})$  (6.34) | |
| 244 | $t_s = t_{slew}+t_{lin} = \tau (X-1+ln({1 \over \epsilon_d} \cdot X)$  (6.35) | $t_s = t_{slew}+t_{lin} = \tau (X-1+ln({1 \over \epsilon_d \cdot X})$  (6.35) | |
| 244 | $\omega_u = {1 \over \tau} = {1 \over t_s} (X-1+ln({1 \over \epsilon_d} \cdot X)$  (6.37) | $\omega_u = {1 \over \tau} = {1 \over t_s} (X-1+ln({1 \over \epsilon_d \cdot X})$  (6.37)   | |
| 283 | $\omega_{u1} = {1 \over \tau} = {1 \over t_s} (X-1+ln({1 \over \epsilon_d} \cdot X)$  (6.75) | $\omega_{u1} = {1 \over \tau} = {1 \over t_s} (X-1+ln({1 \over \epsilon_d \cdot X})$  (6.75)   | |

**Matlab Files Hosted by Publisher**  
(These problems have been fixed in the respective files provided in this repo) 

| MATLAB File | Line | Problem | Correction | Comment |
|-------------|------|---------|------------|---------|
|lookup.m | | Some users see the error message: "No constructor 'lookup' with matching signature found." This error occurs due to a method named "lookup" in the Bloomberg toolbox (introduced in R2014a), which overloads the definition of lookup.m. |Reinstall Matlab without Bloomberg Datafeed toolbox or rename lookup.m.
|lookup.m | 153 | % If gm/Cgg or gm/Cgs is the x value, find maximum and limit search range to VGS values to the LEFT<br> elseif strcmp(numerator,'GM') && (strcmp(denominator,'CGG') &#124;&#124; strcmp(denominator,'CGG')) | % If gm/Cgg or gm/Cgs is the x value, find maximum and limit search range to VGS values to the LEFT<br> elseif strcmp(numerator,'GM') && (strcmp(denominator,'CGG') &#124;&#124; strcmp(denominator,'CGS'))| |
| two_stage.m | 24 | gmR = sqrt(s.L0)./d.beta | gmR = sqrt(s.L0./d.beta) | |
