import numpy as np

A = np.asarray([
    [1, 1, -1, -1],
    [1, - 1, -1, 1],
    [1, 1, 1, 1]
])
B = np.asarray([
    [-1.2131, 0.0851, -1.2334],
    [-1.4413, -0.7858, 0.5525],
    [0.3470, -1.6594, 0.3550],
    [0.5752, -0.7885, -1.4309]
])
B = np.transpose(B)

R1 = [[-0.8941, 0.1141, -0.4330],
      [0.4368, 0.4355, -0.7871],
      [0.0988, -0.8930, - 0.4392]
      ]
R2 = [[0.0623, -0.0121, 0.9980],
      [0.3400, -0.9399, -0.0327],
      [0.9384, 0.3413, -0.0545]
      ]
R3 = [[0.6580, -0.7189, 0.2242],
      [-0.7370, -0.6759, -0.0042],
      [0.1545, -0.1625, -0.9745]
      ]
R_all = [
    np.transpose(np.asarray(R1)),
    np.transpose(np.asarray(R2)),
    np.transpose(np.asarray(R3)),
]

for idx, R in enumerate(R_all):
    err = np.linalg.norm(A - np.matmul(R,B))
    print("{}={}".format(idx, err))