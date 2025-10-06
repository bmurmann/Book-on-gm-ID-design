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


# Constants
pi = np.pi
wu = 2 * pi * 1e9
L = 0.1
G = np.array([1, 2, 4, 8])
FO = 2. / G
gm_ID = np.arange(3, 29.1, 0.1)

wTi = NCH.look_up( 'GM_CGS', GM_ID=gm_ID, L=L)


# Initialize beta and K matrices
beta = np.full((len(FO), len(gm_ID)), np.nan)
K = np.full((len(FO), len(gm_ID)), np.nan)

# Compute K factor
for i in range(len(FO)):
    beta[i, :] = (1 - (1 + FO[i] * G[i]) * wu / wTi) / (1 + G[i] - (wu / wTi))
    beta[i, beta[i, :] < 0] = np.nan  # Set negative values to NaN
    with np.errstate(divide='ignore', invalid='ignore'):
        K[i, :] = 1 / (beta[i, :] ** 2) / gm_ID

print("Beta values check:", beta)
print("K values check:", K)


if np.nanmin(K) > 0:  # Ensures there is at least one non-NaN value
    K /= np.nanmin(K)
else:
    print("All values in K are NaN.")

print("Normalized K:", K)


Kmin = np.array([np.nanmin(row) if np.any(~np.isnan(row)) else np.nan for row in K])
idx = np.array([np.nanargmin(row) if np.any(~np.isnan(row)) else -1 for row in K])

print("Minimum K values:", Kmin)
print("Indices of minimum K values:", idx)


# Parameter values at minimum current
gm_ID_opt = gm_ID[idx]
fT_opt = wTi[idx] / (2 * pi)
beta_opt = np.diag(beta[:, idx])
beta_max = 1 / (1 + G)
beta_opt_max = beta_opt / beta_max
cgs_cs_cf = 1 / beta_opt_max - 1

# Plotting
fig, axs = plt.subplots(2, 1, figsize=(10, 12))

linestyles = ['-', '-', '--', '-.']
linewidths = [3, 2, 2, 2]   # to mimic the thick G=1 line
color = 'k'

# First subplot
handles = []
for i in range(len(G)):
    h, = axs[0].plot(
        gm_ID, beta[i, :] / beta_max[i],
        linestyle=linestyles[i], linewidth=linewidths[i], color=color
    )
    handles.append(h)
    # keep the optimal-point markers out of the legend
    axs[0].plot(gm_ID[idx[i]], beta_opt_max[i], 'ko', label='_nolegend_')

axs[0].set_xlabel(r'$g_m/I_D$ (S/A)')
axs[0].set_ylabel(r'$\beta/\beta_{max}$')
axs[0].set_xlim([np.min(gm_ID), np.max(gm_ID) + 1])
axs[0].set_ylim([0, 1])
axs[0].grid(True)

# legend with the actual line handles
axs[0].legend(handles, [f'G = {g}' for g in G], loc='best', frameon=True, handlelength=3)

# Second subplot
for i in range(len(G)):
    axs[1].plot(
        gm_ID, K[i, :],
        linestyle=linestyles[i], linewidth=linewidths[i], color=color
    )
    axs[1].plot(gm_ID[idx[i]], Kmin[i], 'ko', label='_nolegend_')

axs[1].set_xlabel(r'$g_m/I_D$ (S/A)')
axs[1].set_ylabel('K (normalized to minimum)')
axs[1].set_xlim([np.min(gm_ID), np.max(gm_ID) + 1])
axs[1].set_ylim([0, 30])
axs[1].grid(True)

plt.tight_layout()
plt.show()

print("Min K:", np.min(K))
print("Max K:", np.max(K))
print("Sample K values:", K[:, :5])  #

format_and_save((fig, axs), 'Fig6_6', W=8, H=8)