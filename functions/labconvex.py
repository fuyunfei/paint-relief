from color_histogram.io_util.image import loadRGB
from color_histogram.core.hist_3d import Hist3D
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import  numpy as np
from scipy.spatial import ConvexHull

# Load image.
image = loadRGB('7.png')

# 16 bins, rgb color space
hist3D = Hist3D(image, num_bins=255, color_space='Lab')

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
hist3D.plot(ax)
vs= [
        [
            62.0070164688,
            -23.4659787223,
            -12.9463413357
        ],
        [
            100.409562663,
            2.9859782616,
            -9.0728531732
        ],
        [
            -4.85583594611,
            -8.57160085891,
            -6.62002503029
        ],
        [
            52.7760787206,
            74.0586148013,
            69.0603637824
        ],
        [
            7.93947944138,
            31.7299007512,
            21.6140843711
        ],
        [
            17.979327872,
            12.9425661512,
            -40.582473457
        ],
        [
            69.7839261866,
            -16.8646459746,
            -40.0210475383
        ],
        [
            109.763141803,
            -18.5892033919,
            -0.540175787924
        ],
        [
            2.59630991524,
            -13.0235296149,
            15.9177894542
        ],
        [
            80.81699057114272,
            10.765956215340807,
            74.30941946766103
        ]
    ]
vs = np.asarray(vs)
hull = ConvexHull(vs)
ax.plot(vs.T[0], vs.T[1], vs.T[2], "ko")
for s in hull.simplices:
    s = np.append(s, s[0])  # Here we cycle back to the first coordinate
    ax.plot(vs[s, 0], vs[s, 1], vs[s, 2], "r-")
plt.show()