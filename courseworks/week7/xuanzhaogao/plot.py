import numpy as np
import matplotlib.pyplot as plt

best_x = [-0.37354377570439323, 0.8379216308295349, 0.24309099431276804, 1.2378621542600936, 0.3552623814205562, 0.7428824430541134, 0.6837170659648447, 1.938135055810309, 0.8138713932381817, 1.3638018591988728, 0.924572957832151, 0.8753080473134458, 1.0547272851055045, 0.3009748507020766, 1.3831819696496568, 1.4962274634583885, 1.495353356757569, 1.0012477522524468, 2.111988126774288, 1.4011882756837912]

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
