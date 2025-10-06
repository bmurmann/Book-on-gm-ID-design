import matplotlib.pyplot as plt

def format_and_save(fighandle, filename, fmt='pdf', **kwargs):
    # default values for optional parameters
    defaultW = 4
    defaultH = 3
    defaultFontSize = 9

    # parse optional parameters
    par = {'W': defaultW, 'H': defaultH, 'FontSize': defaultFontSize}
    par.update(kwargs)

    fig, ax = fighandle 

    # Set figure size
    fig.set_size_inches(par['W'], par['H'])

    
    fig.canvas.draw()

    # Save the figure
    savename = filename + '.' + fmt
    fig.savefig(savename, format=fmt, dpi=600)


    plt.close(fig)

# Usage:
# format_and_save((fig, ax), 'Fig3_6', fmt='pdf', W=5.3, H=4)