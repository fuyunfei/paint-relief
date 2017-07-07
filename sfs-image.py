import numpy as np
import skfmm
import plotly
import plotly.graph_objs as go
import scipy.ndimage as spim
import matplotlib.pyplot as plt 

im = spim.imread('7-1.png', True)
#     im = im[im.shape[0] / 2:, im.shape[1] / 2:]

N = np.gradient(im)
N = np.concatenate((N[1][..., None], N[0][..., None], np.ones_like(N[0][..., None])), axis=2)
N = N / np.sqrt((N ** 2).sum(2))[..., None]

L = N.dot([0, 0, 1])
epsilon = 1e-3

W = np.sqrt(1 / L ** 2 - 1)
W[W < epsilon] = epsilon
W[~np.isfinite(W)] = epsilon

p = np.empty_like(W)
p[...] = -1
#     p[704, 1485] = 1
# p[20, 20] = 0
p[im < (10)] = 0

t = skfmm.travel_time(p, 1.0 / W)

data = [go.Surface(z=t.tolist(), colorscale='Viridis')]

layout = go.Layout(
    width=1800,
    height=1600,
    autosize=False,
    title='bas-relief dataset',
    scene=dict(
        xaxis=dict(
            gridcolor='rgb(255, 255, 255)',
            zerolinecolor='rgb(255, 255, 255)',
            showbackground=True,
            backgroundcolor='rgb(230, 230,230)'
        ),
        yaxis=dict(
            gridcolor='rgb(255, 255, 255)',
            zerolinecolor='rgb(255, 255, 255)',
            showbackground=True,
            backgroundcolor='rgb(230, 230,230)'
        ),
        zaxis=dict(
            gridcolor='rgb(255, 255, 255)',
            zerolinecolor='rgb(255, 255, 255)',
            showbackground=True,
            backgroundcolor='rgb(230, 230,230)'
        ),
        aspectratio=dict(x=1, y=1, z=0.1),
        aspectmode='manual'
    )
)

fig = dict(data=data, layout=layout)

# plt.figure()     
# plt.imshow(im, cmap='gray') 
# plt.figure()
# plt.imshow(N, cmap='gray')
# plt.figure()
# plt.imshow(L, cmap='gray')
# plt.figure()
# plt.imshow(W, cmap='gray')
# plt.figure()
# plt.imshow(p, cmap='gray')
# plt.figure()
# plt.imshow(-t, cmap='gray')
# plt.show()

# IPython notebook
# py.iplot(fig, filename='pandas-3d-surface', height=700, validate=False)

url = plotly.offline.plot(fig, filename='SFS-surface')
