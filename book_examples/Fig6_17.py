import numpy as np
import matplotlib.pyplot as plt
from pygmid import Lookup as lk
from format_and_save import format_and_save
from scipy.interpolate import interp1d
# setup matplotlib
plt.rcParams['axes.spines.right'] = False
plt.rcParams['axes.spines.top'] = False
plt.rcParams.update({"axes.grid": True})

# Interpolation function
def interp1(x, y, value):
    # Perform cubic interpolation using interp1d
    f = interp1d(x, y, kind='cubic')
    return f(value)
# Specify appropriate path...
NCH = lk('65nch.mat')  # load MATLAB data into pygmid lookup object
PCH = lk('65pch.mat')


# Design specifications and assumptions
G = 2
beta_max = 1 / (1 + G)
beta = 0.75 * beta_max
kappa = 0.7
gm_ID = 15

# Channel length sweep
L = np.linspace(0.06, 1, 100)


# Lookup calls
gm_gds2 = NCH.look_up( 'GM_GDS', GM_ID=gm_ID, VDS=0.2, VSB=0, L=L)
gm_gds3 = NCH.look_up( 'GM_GDS', GM_ID=gm_ID, VDS=0.4, VSB=0.2, L=L)
gm_gds4 = PCH.look_up( 'GM_GDS', GM_ID=gm_ID, VDS=0.4, VSB=0.2, L=L)
gm_gds5 = PCH.look_up( 'GM_GDS', GM_ID=gm_ID, VDS=0.2, VSB=0, L=L)

# Loop gain calculation
L0 = np.zeros((len(L), len(L)))
for j in range(len(L)):
    L0[j, :] = beta * kappa / (1 / (1 + gm_gds5) / gm_gds4 + 1 / (1 + gm_gds2[j] / 3) / gm_gds3[j])

plt.style.use('seaborn-poster')

# Plotting
fig, ax = plt.subplots(figsize=(8, 6))

C = ax.contour(L, L, L0, colors='k')
ax.clabel(C, fmt='%d', fontsize=9)
ax.set_xlabel(r'$L_{2,3}$ ($\mu$m)')
ax.set_ylabel(r'$L_{4,5}$ ($\mu$m)')
ax.plot(0.4, 0.4, 'k+', markersize=9, linewidth=2)

plt.tight_layout()
plt.show()


format_and_save((fig, ax), 'Fig6_17', W=8, H=6)


# Chosen length
L23 = 0.4

# Resulting device parameters using the chosen length L23
gmb_gm3 =NCH.look_up( 'GMB_GM', GM_ID=gm_ID, VDS=0.4, VSB=0.2, L=L23)
gm_css3 = NCH.look_up( 'GM_CSS', GM_ID=gm_ID, VDS=0.4, VSB=0.2, L=L23)
cdd_css3 = NCH.look_up( 'CDD_CSS', GM_ID=gm_ID, VDS=0.4, VSB=0.2, L=L23)
cdd_w3 = NCH.look_up( 'CDD_CSS', GM_ID=gm_ID, VDS=0.4, VSB=0.2, L=L23)
cdd_w2 = NCH.look_up( 'CDD_CSS', GM_ID=gm_ID, VDS=0.2, VSB=0, L=L23)

# Nondominant pole frequency
fp2 = 1 / (2 * np.pi) * gm_css3 * (1 + gmb_gm3) / (1 + 2 * cdd_css3 * 2 * (cdd_w2 / cdd_w3))
print(f'Nondominant pole frequency: {fp2}')