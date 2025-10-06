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


# Constants and setup
s = {'ts': 5e-9, 'ed': 0.1e-2, 'vod_noise': 400e-6, 'FO': 0.5, 'G': 2}
s['fu1'] = 1 / (2 * np.pi) * np.log(1 / s['ed']) / s['ts']
fp2 = 2e9
print(fp2 / s['fu1'])

beta_max = 1 / (1 + s['G'])

# Device characteristics and initial parameters
d = {'gamma': 0.7, 'Lcas': 0.4, 'gm_IDcas': 15, 'L1': 0.2, 'cself': 0}
d['gm_ID1'] = np.arange(5, 27.01, 0.01)
d['beta'] = beta_max * np.linspace(0.2, 1, 801)

# Self loading sweep
cself = np.zeros(6)
ID1 = np.zeros_like(cself)
gm_ID1 = np.zeros_like(cself)
cltot = np.zeros_like(cself)
beta = np.zeros_like(cself)

for i in range(len(cself)):
    d['cself'] = cself[i]
    m1, p = folded_cascode( s, d)
    ID1[i] = np.min(m1['ID'])
    m = np.argmin(m1['ID'])
    gm_ID1[i] = m1['gm_ID'][m]
    cltot[i] = p['cltot'][m]
    beta[i] = d['beta'][m]

    if i + 1 < len(cself):
        cself[i + 1] = p['cself'][m]


plt.style.use('seaborn-poster')

# Plotting results
fig, axs = plt.subplots(2, 1, figsize=(8, 10))

# r_self vs iteration
axs[0].plot(range(1, len(cself)), cself[:-1] / cltot[:-1], 'k-o', linewidth=2, markersize=10)
axs[0].set_xlabel('Iteration ')
axs[0].set_ylabel(r'$r_{self} = C_{self}/C_{ltot}$')
axs[0].set_xlim([1, len(cself) - 1])
axs[0].set_ylim([0, 0.3])
axs[0].grid(True)

# ID1 vs iteration
axs[1].plot(range(1, len(ID1) + 1), ID1 * 1e3, 'k-o', linewidth=2, markersize=10)
axs[1].set_xlabel('Iteration ')
axs[1].set_ylabel(r'$I_{D1}$ (mA)')
axs[1].set_xlim([1, len(ID1)])
axs[1].set_ylim([0, 0.2])
axs[1].grid(True)

plt.tight_layout()
plt.show()

# Save figure
format_and_save((fig, axs), 'Fig6_19', W=8, H=10)

# Final sizing point
ID1_opt = ID1[-1]
gm_ID1_opt = gm_ID1[-1]
beta_opt = beta[-1]
CLtot = cltot[-1]
Cself = cself[-1]

# Computing capacitances
CF = (CLtot - Cself) / (s['FO'] * s['G'] + 1 - beta_opt)
CS = s['G'] * CF
CL = s['FO'] * CS

# Print ratios and other details for check
print(beta_opt / beta_max)

# Using lookup to get current densities
ID_W1 = PCH.look_up( 'ID_W', GM_ID=gm_ID1_opt, L=d['L1'])
ID_W2 = NCH.look_up( 'ID_W', GM_ID=15, L=d['Lcas'], VDS=0.2)
ID_W5 = PCH.look_up( 'ID_W', GM_ID=15, L=d['Lcas'], VDS=0.2)

# Calculating widths
W1 = ID1_opt / ID_W1
W2 = 2 * ID1_opt / ID_W2
W3 = W2 / 2
W5 = ID1_opt / ID_W5
W4 = W5

# Printing the results just like MATLAB's terminal output
print("Width W1:", W1, "um")
print("Width W2:", W2, "um")
print("Width W3:", W3, "um")
print("Width W4:", W4, "um")
print("Width W5:", W5, "um")