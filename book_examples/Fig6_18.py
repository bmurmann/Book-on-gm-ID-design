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


def folded_cascode( s, d):
    kB = 1.3806488e-23

    # Fetch device parameters
    gm_gds1 = PCH.look_up( 'GM_GDS', GM_ID=d['gm_ID1'], L=d['L1'])
    wt1 = PCH.look_up( 'GM_CGG', GM_ID=d['gm_ID1'], L=d['L1'])
    cgd_cgg1 = PCH.look_up( 'CGD_CGG', GM_ID=d['gm_ID1'], L=d['L1'])
    gm_gds2 = NCH.look_up( 'GM_GDS', GM_ID=d['gm_IDcas'], L=d['Lcas'])
    cdd_gm3 = NCH.look_up( 'CDD_GM', GM_ID=d['gm_IDcas'], L=d['Lcas'])
    cdd_gm4 = PCH.look_up( 'CDD_GM', GM_ID=d['gm_IDcas'], L=d['Lcas'])

    # Initialize output structures
    m1 = {'ID': np.full(len(d['beta']), np.nan), 'gm_ID': np.full(len(d['beta']), np.nan)}
    p = {'cltot': np.full(len(d['beta']), np.nan), 'cself': np.full(len(d['beta']), np.nan)}

    for j in range(len(d['beta'])):
        beta = d['beta'][j]
        alpha = 2 * d['gamma'] * (1 + d['gm_IDcas'] / d['gm_ID1'] + 2 * d['gm_IDcas'] / d['gm_ID1'])
        cltot = alpha / beta * kB * 300 / s['vod_noise'] ** 2
        CF = (cltot - d['cself']) / (s['FO'] * s['G'] + 1 - beta)
        CS = s['G'] * CF
        kappa = 1 / (1 + 1 / gm_gds1 * d['gm_ID1'] / d['gm_IDcas'] + 2 / gm_gds2)
        gm1 = 2 * np.pi * s['fu1'] * cltot / beta / kappa
        ID1 = gm1 / d['gm_ID1']
        cgs1 = gm1 / wt1
        cin = cgs1 * (1 + cgd_cgg1 * d['gm_ID1'] / d['gm_IDcas'])
        beta_actual = CF / (CF + CS + cin)
        m = np.argmin(np.abs(beta_actual - beta))

        m1['ID'][j] = ID1[m]
        m1['gm_ID'][j] = d['gm_ID1'][m]
        p['cltot'][j] = cltot[m]

    # Compute self-loading
    gm34 = m1['ID'] * d['gm_IDcas']
    p['cself'] = gm34 * cdd_gm3 + gm34 * cdd_gm4

    return m1, p


# Define the system and design specifications
s = {
    'ts': 5e-9,
    'ed': 0.1e-2,
    'fu1': 1 / (2 * np.pi) * np.log(1 / 0.1e-2) / 5e-9,
    'vod_noise': 400e-6,
    'FO': 0.5,
    'G': 2
}
beta_max = 1 / (1 + s['G'])
s['fu1'] = 1 / (2 * np.pi) * np.log(1 / s['ed']) / s['ts']

# Constants for another design
d = {
    'gamma': 0.7,
    'Lcas': 0.4,
    'gm_IDcas': 15,
    'cself': 0,
    'gm_ID1': np.arange(3, 27.01, 0.01),
    'beta': beta_max * np.arange(0.2, 1.001, 0.001)
}

# Channel length sweep
L1 = [0.1, 0.2, 0.3, 0.4]
m1 = []
p = []

for i in L1:
    d['L1'] = i
    m, pi = folded_cascode(s, d)  # You need to implement or provide this function
    m1.append(m)
    p.append(pi)
plt.style.use('seaborn-poster')

# Plotting setup
fig, axs = plt.subplots(2, 1, figsize=(10, 12))

# Plot ID versus gm/ID for different L values
for i, length in enumerate(L1):
    label = f'{length * 1e3:.0f}nm'  # Convert L from meters to nm for label
    axs[0].plot(m1[i]['gm_ID'], m1[i]['ID'] * 1e3, label=label)  # ID in mA
axs[0].set_xlabel(r'$(g_m/I_D)_1$ (S/A)')
axs[0].set_ylabel(r'$I_{D1}$ (mA)')
axs[0].legend(loc='upper center', ncol=3, frameon=False)
axs[0].grid(True)

# Plot cself/cltot versus gm/ID for different L values
for i, length in enumerate(L1):
    label = f'{length * 1e3:.0f}nm'
    axs[1].plot(m1[i]['gm_ID'], p[i]['cself'] / p[i]['cltot'], label=label)
axs[1].set_xlabel(r'$(g_m/I_D)_1$ (S/A)')
axs[1].set_ylabel(r'$r_{self} = C_{self}/C_{ltot}$')
axs[1].legend(loc='best', frameon=False)
axs[1].grid(True)

plt.tight_layout()
plt.show()

# Save using your custom function
format_and_save((fig, axs), 'Fig6_18', W=10, H=12)