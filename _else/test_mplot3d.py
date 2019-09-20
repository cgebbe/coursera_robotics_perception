'''
Problem:
    Create a simple 3D scene with an image plane and a coordinate system shown as errors.
    Which framework to use?

Approach:
    Try to use matplotlib.mplot3d

Result:
    An issue occurs even with this very simple scene and a longer z-axis.
    Depending on the viewing angle, the z-axis is simply not shown?!

Next
    --> switch to mayavi, as recommended by https://matplotlib.org/mpl_toolkits/mplot3d/faq.html

'''
import mpl_toolkits.mplot3d as mpl3d
import matplotlib.pyplot as plt
import numpy as np
#
# init figure
fig = plt.figure()
ax = mpl3d.Axes3D(fig)
ax.set_axis_off()

# draw coordinate system using three arrows
x, y, z = np.zeros((3, 3))
u, v, w = np.array([[1, 0, 0], [0, 1, 0], [0, 0, 100]])
arrows = ax.quiver(x, y, z, u, v, w, arrow_length_ratio=0.2)
arrows.set_edgecolor((0, 0, 0, 1))

# create a camera plane
points3d = []
z = 1
center_xy = (0, 0)
extent_xy = (1, 1)
points3d.append((center_xy[0] - 0.5 * extent_xy[0], center_xy[1] - 0.5 * extent_xy[1], z))
points3d.append((center_xy[0] + 0.5 * extent_xy[0], center_xy[1] - 0.5 * extent_xy[1], z))
points3d.append((center_xy[0] + 0.5 * extent_xy[0], center_xy[1] + 0.5 * extent_xy[1], z))
points3d.append((center_xy[0] - 0.5 * extent_xy[0], center_xy[1] + 0.5 * extent_xy[1], z))
poly = mpl3d.art3d.Poly3DCollection([points3d])
poly.set_facecolor((1, 0, 0, 0.2))
poly.set_edgecolor((0, 0, 1, 0.8))
ax.add_collection3d(poly)

# show plot
ax.set_xlim([0, 2])
ax.set_ylim([0, 2])
ax.set_zlim([0, 2])
plt.show()
