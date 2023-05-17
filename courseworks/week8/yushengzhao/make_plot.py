import numpy as np
import matplotlib.pyplot as plt

# out of despair with Julia's plotting feature
# I used Xuanzhao's code for plotting
# works like a charm
best_x = [2.24904,
          1.29474,
          1.6992,
          0.482469,
          0.949905,
          1.03159,
          1.08223,
          0.281151,
          0.57102,
          0.0,
          1.16214,
          1.4029,
          0.652543,
          1.93076,
          1.20322,
          0.764078,
          0.0,
          1.29914,
          0.467247,
          0.566929]

E = [(1, 2), (1, 3),
	(2, 3), (2, 4), (2, 5), (2, 6),
	(3, 5), (3, 6), (3, 7),
	(4, 5), (4, 8),
	(5, 6), (5, 8), (5, 9),
	(6, 7), (6, 8), (6, 9),
	(7,9), (8, 9), (8, 10), (9, 10)]

theta = np.linspace(0, 2 * np.pi, 100)
x_0 = np.cos(theta)
y_0 = np.sin(theta)

plt.figure(dpi = 150)
for i in range(10):
    plt.scatter(best_x[2 * i], best_x[2 * i + 1])
    x_i = best_x[2 * i] + x_0
    y_i = best_x[2 * i + 1] + y_0
    plt.plot(x_i, y_i, label = str(i + 1))

for i in range(10):
    for j in range(i, 10):
        if (i + 1, j + 1) in E:
            plt.plot([best_x[2 * i], best_x[2 * j]], [best_x[2 * i + 1], best_x[2 * j + 1]], 'black')

plt.legend(ncol = 2)
plt.gca().set_aspect(1)
plt.savefig('unit_disk_py.png')
