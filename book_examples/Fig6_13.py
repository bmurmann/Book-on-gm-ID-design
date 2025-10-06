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


# Constants and design specifications
kB = 1.3806488e-23
T = 300
gamma = 0.7
vod_noise = 100e-6
G = 2
FO = 1
CL_CFtot = G * FO
ed = 0.1e-2
ts = 1.1e-9
beta_max = 1 / (1 + G)
L = 0.1

# Search parameters
vodfinal = np.array([0.01, 0.8, 1.6])
gm_ID = np.arange(5, 28.01, 0.01)
beta = np.arange(0.25 * beta_max, beta_max + 0.001, 0.001)
beta_rel = beta / beta_max

# Initialize result arrays
ID_valid = np.full((len(beta), len(vodfinal)), np.nan)
gm_ID_valid = np.full((len(beta), len(vodfinal)), np.nan)
X_valid = np.full((len(beta), len(vodfinal)), np.nan)

# pre-compute wti
wti = NCH.look_up('GM_CGS', GM_ID=gm_ID, L=L)

# Computations
for i, vod in enumerate(vodfinal):
    for j, b in enumerate(beta):
        CLtot = 2 * kB * T * gamma / b / vod_noise**2
        CFtot = CLtot / (CL_CFtot + 1 - b)

        X = vod * b / 2 * gm_ID
        X[X < 1] = 1
        ID = CLtot / b / gm_ID / ts * (X - 1 - np.log(ed * X))

        gm = gm_ID * ID
        Cgs = gm / wti

        beta_actual = CFtot / (CFtot * (1 + G) + Cgs)
        # Interpolation to find self-consistent point
        interp_func = interp1d(beta_actual, np.arange(len(beta_actual)), kind='nearest', fill_value='extrapolate')
        m = int(interp_func(b))
        if m:
            gm_ID_valid[j, i] = gm_ID[m]
            ID_valid[j, i] = ID[m]
            X_valid[j, i] = X[m]

# Minimum ID calculation
ID_min = np.nanmin(ID_valid, axis=0)
idx = np.nanargmin(ID_valid, axis=0)

gm_ID_opt = gm_ID_valid[idx, np.arange(len(vodfinal))]
slew_pct = (X_valid - 1) / (X_valid - 1 - np.log(ed * X_valid))

# Plotting
fig, axs = plt.subplots(3, 1, figsize=(12, 18))

# 1st subplot
for i, label in enumerate(['small signal', '0.8V', '1.6V']):
    axs[0].plot(gm_ID_valid[:, i], ID_valid[:, i] * 1e3, label=label)
    axs[0].plot(gm_ID_opt[i], ID_min[i] * 1e3, 'ko')
axs[0].set_xlabel('g_m/I_D (S/A)')
axs[0].set_ylabel('I_D (mA)')
axs[0].legend()
axs[0].grid()

# 2nd subplot
for i in range(len(vodfinal)):
    axs[1].plot(gm_ID_valid[:, i], beta_rel, label=f'{vodfinal[i]}V')
axs[1].set_xlabel('g_m/I_D (S/A)')
axs[1].set_ylabel('β/β_max')
axs[1].legend()
axs[1].grid()

# 3rd subplot
for i in range(len(vodfinal)):
    axs[2].plot(gm_ID_valid[:, i], slew_pct[:, i], label=f'{vodfinal[i]}V')
axs[2].set_xlabel('g_m/I_D (S/A)')
axs[2].set_ylabel('t_slew/t_s')
axs[2].legend()
axs[2].grid()

plt.tight_layout()
plt.show()

# Save using your custom function
format_and_save((fig, axs), 'Fig6_13', W=12, H=18)

# Selection of parameters for a specific design point
gm_ID_selected = gm_ID_opt[1]  # Corresponds to the second vodfinal condition
beta_selected = beta[idx[1]]  # Selected beta for the design
ID_selected = ID_min[1]  # Selected ID for the design
vodfinal_selected = vodfinal[1]  # Second value in vodfinal

# Compute additional design parameters
CLtot = 2 * kB * T * gamma / beta_selected / vod_noise**2
gm = ID_selected * gm_ID_selected


JD = NCH.look_up('ID_W', GM_ID=gm_ID_selected, L=L)
W = ID_selected / JD
Cgd = W * NCH.look_up( 'CGD_W', GM_ID= gm_ID_selected, L= L)
Cdb = W * NCH.look_up( 'CDD_W', GM_ID=gm_ID_selected, L= L) - Cgd


CFtot = CLtot / (CL_CFtot + 1 - beta_selected)
CS = G * CFtot
CL = CL_CFtot * CFtot

CF = CFtot - Cgd

SR = 2 * ID_selected / CLtot
tau = CLtot / gm / beta_selected
vodlin = 2 / gm_ID_selected / beta_selected
tslew = tau * (vodfinal_selected / vodlin - 1)

# Print the calculated variables
print(f'Inversion level for design (gm/ID): {gm_ID_selected}')
print(f'Beta for design: {beta_selected}')
print(f'Drain current ID (A): {ID_selected}')
print(f'Final Vod (V): {vodfinal_selected}')
print(f'Total load capacitance CLtot (F): {CLtot}')
print(f'Transconductance gm (S): {gm}')
print(f'Total width W (um): {W}')
print(f'Total feedback capacitance CFtot (F): {CFtot}')
print(f'CS capacitance  (F): {CS}')
print(f'Load capacitance CL (F): {CL}')
print(f'Gate-drain capacitance Cgd (F): {Cgd}')
print(f'Feedback capacitance CF (F): {CF}')
print(f'Capacitance at the drain-bulk Cdb (F): {Cdb}')
print(f'Slew rate SR (V/s): {SR}')
print(f'Time constant tau (s): {tau}')
print(f'Linear region voltage Vodlin (V): {vodlin}')
print(f'Slew time tslew (s): {tslew}')
