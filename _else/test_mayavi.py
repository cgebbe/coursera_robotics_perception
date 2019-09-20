import numpy as np
import mayavi.mlab as mlab


# from https://docs.enthought.com/mayavi/mayavi/auto/mlab_helper_functions.html#mayavi.mlab.plot3d
def test_plot3d():
    n_mer, n_long = 6, 11
    dphi = np.pi / 1000.0
    phi = np.arange(0.0, 2 * np.pi + 0.5 * dphi, dphi)
    mu = phi * n_mer
    x = np.cos(mu) * (1 + np.cos(n_long * mu / n_mer) * 0.5)
    y = np.sin(mu) * (1 + np.cos(n_long * mu / n_mer) * 0.5)
    z = np.sin(n_long * mu / n_mer) * 0.5

    l = mlab.plot3d(x, y, z, np.sin(mu), tube_radius=0.025, colormap='Spectral')
    mlab.show()


def test_mesh():
    """A very pretty picture of spherical harmonics translated from
    the octaviz example."""
    pi = np.pi
    cos = np.cos
    sin = np.sin
    dphi, dtheta = pi / 250.0, pi / 250.0
    [phi, theta] = np.mgrid[0:pi + dphi * 1.5:dphi,
                   0:2 * pi + dtheta * 1.5:dtheta]
    m0 = 4
    m1 = 3
    m2 = 2
    m3 = 3
    m4 = 6
    m5 = 2
    m6 = 6
    m7 = 4
    r = sin(m0 * phi) ** m1 + cos(m2 * phi) ** m3 + \
        sin(m4 * theta) ** m5 + cos(m6 * theta) ** m7
    x = r * sin(phi) * cos(theta)
    y = r * cos(phi)
    z = r * sin(phi) * sin(theta)

    return mlab.mesh(x, y, z, colormap="bone")


# at origin
mlab.quiver3d(0, 0, 0, 1, 0, 0, mode='arrow', color=(1, 0, 0))
mlab.quiver3d(0, 0, 0, 0, 1, 0, mode='arrow', color=(0, 1, 0))
mlab.quiver3d(0, 0, 0, 0, 0, 1, mode='arrow', color=(0, 0, 1))

# create an image plane
x, y = np.meshgrid(np.linspace(-1, 1, 5), np.linspace(-1, 1, 10))
z = np.ones_like(x)
mlab.mesh(x, y, z,
          color=(1, 1, 1),
          opacity=0.5,
          reset_zoom=True,
          )

# set initial view behind image plane
angle_view = 33
mlab.view(azimuth=-angle_view, elevation=180 - angle_view, roll=180, focalpoint=[0, 0, 1], distance=5)

# add line as optical axis
val = 1E-6  # somehow does not work if val=0 ?!?!
mlab.plot3d([val, val], [val, val], [0, 1E3],
            line_width=10,
            color=(0, 0, 0),
            reset_zoom=False,
            )

mlab.show()
