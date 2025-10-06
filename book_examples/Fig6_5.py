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
NCH = lk('65nch.mat')
PCH = lk('65pch.mat')


# Parameters
wu = 2 * np.pi * 1e9
L = 0.1
G = 2
FO = [0.5, 1, 2, 4]
gm_ID = np.arange(3, 29.1, 0.1)
wTi = NCH.look_up( 'GM_CGS', GM_ID=gm_ID, L=L)
beta = np.full((len(FO), len(gm_ID)), np.nan)
K = np.full((len(FO), len(gm_ID)), np.nan)

# Compute K factor
for i in range(len(FO)):
    beta[i, :] = (1 - (1 + FO[i] * G) * wu / wTi) / (1 + G - (wu / wTi))
    beta[beta < 0] = np.nan
    K[i, :] = 1 / beta[i, :] ** 2 / gm_ID

# Normalize and find minimum current
K = K / np.nanmin(np.nanmin(K, axis=1))

Kmin = np.nanmin(K, axis=1)
idx = np.nanargmin(K, axis=1)

# Parameter values at minimum current
gm_ID_opt = gm_ID[idx]
fT_opt = wTi[idx] / (2 * np.pi)
beta_opt = np.diag(beta[:, idx])
beta_max = 1 / (1 + G)
beta_opt_max = beta_opt / beta_max
cgs_cs_cf = 1 / beta_opt_max - 1

# Plot

fig, axs = plt.subplots()

plt.subplot(2, 1, 1)
plt.plot(gm_ID, beta[0, :] / beta_max, 'k-', linewidth=2)
plt.plot(gm_ID, beta[1, :] / beta_max, 'k-')
plt.plot(gm_ID, beta[2, :] / beta_max, 'k--')
plt.plot(gm_ID, beta[3, :] / beta_max, 'k-.')
for i in range(len(FO)):
    plt.plot(gm_ID[idx[i]], beta_opt_max[i], 'ko')
plt.xlabel('$g_m/I_D$ (S/A)')
plt.ylabel('$\\beta/\\beta_{max}$')
plt.axis([min(gm_ID), max(gm_ID) + 1, 0, 1])
plt.legend(['FO = 0.5', 'FO = 1', 'FO = 2', 'FO = 4', 'Optimum'])
plt.grid(True)

plt.subplot(2, 1, 2)
plt.plot(gm_ID, K[0, :], 'k-', linewidth=2)
plt.plot(gm_ID, K[1, :], 'k-')
plt.plot(gm_ID, K[2, :], 'k--')
plt.plot(gm_ID, K[3, :], 'k-.')
for i in range(len(FO)):
    plt.plot(gm_ID[idx[i]], Kmin[i], 'ko')
plt.xlabel('$g_m/I_D$ (S/A)')
plt.ylabel('$K$ (normalized to minimum)')
plt.axis([min(gm_ID), max(gm_ID) + 1, 0, 10])
plt.grid(True)

plt.tight_layout()
plt.show()

format_and_save((fig, axs), 'Fig6_5', W=6, H=4)