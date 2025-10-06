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




# Constants and Parameters
pi = np.pi
wu = 2 * pi * 1e9
L = 0.1
G = 2
FO = np.array([0.5, 1, 2, 4])
gm_ID = np.arange(2, 29.1, 0.1)

wTi = NCH.look_up( 'GM_CGS', GM_ID=gm_ID, L=L)

# Initialize arrays
beta = np.full((len(FO), len(gm_ID)), np.nan)
K = np.full((len(FO), len(gm_ID)), np.nan)

# Compute K factor
for i in range(len(FO)):
    beta[i, :] = (1 - (1 + FO[i] * G) * wu / wTi) / (1 + G - (wu / wTi))
    beta[i, beta[i, :] < 0] = np.nan  # Exclude invalid beta values
    K[i, :] = 1 / (beta[i, :] ** 2) / gm_ID

# Normalize K
K /= np.nanmin(K)

# Find minimum K and corresponding indexes
Kmin = np.nanmin(K, axis=1)
idx = np.nanargmin(K, axis=1)

# Calculate optimal parameters
gm_ID_opt = gm_ID[idx]
fT_opt = wTi[idx] / (2 * pi)
beta_opt = np.diag(beta[:, idx])
beta_max = 1 / (1 + G)
beta_opt_max = beta_opt / beta_max
cgs_cs_cf = 1 / beta_opt_max - 1
# Plotting

fig, ax = plt.subplots(figsize=(8, 6))


styles = ['k-', 'k--', 'k-.', 'k:']
widths = [2.5, 2.5, 2.5, 2.5]  # thicker lines

for i, fo in enumerate(FO):
    style = styles[i % len(styles)]
    lw = widths[i % len(widths)]
    ax.plot(beta[i, :] / beta_max, K[i, :], style, linewidth=lw, label=f'FO = {fo}', zorder=1)
    ax.plot(beta_opt_max[i], Kmin[i], 'ko', markersize=6, zorder=5)

# Reference line
ax.axvline(0.75, color='gray', linewidth=2)

# Labels and formatting
ax.set_xlabel(r'$\beta/\beta_{max}$')
ax.set_ylabel('K (normalized to minimum)')
ax.set_xlim(0.2, 1)
ax.set_ylim(0, 8)
ax.grid(True)
ax.legend(loc='best')

fig.tight_layout()
plt.show()

format_and_save((fig, ax), 'Fig6_7', W=8, H=6)
