import Plots
using KernelPCA

################## Linear Kernel ###################
xaxis, yaxis = -2:0.05:2, -2:0.05:2
x2 = [KernelPCA.Point(a, b) for a in xaxis, b in yaxis]
constants = [0.8, 0.1, 0.5]
anchors2 = KernelPCA.Point.([(0.8, 0.2), (0.01, -0.9), (-0.5, -0.5)])
lkf = kernelf(KernelPCA.LinearKernel(), constants, anchors2)
Plots.contour(xaxis, yaxis, lkf.(x2); label="2D function")

# linear kernel can always be reduced to single component
constants_simplified = [1.0]
anchors_simplified = [[0.8, 0.1, 0.5]' * KernelPCA.Point.([(0.8, 0.2), (0.01, -0.9), (-0.5, -0.5)])]
lkf = kernelf(KernelPCA.LinearKernel(), constants_simplified, anchors_simplified)
Plots.contour(xaxis, yaxis, lkf.(x2); label="2D function")

################## Polynomial Kernel ###################
xaxis, yaxis = -2:0.05:2, -2:0.05:2
x2 = [KernelPCA.Point(a, b) for a in xaxis, b in yaxis]
constants2 = [0.8, 0.1, 0.5]
anchors2 = KernelPCA.Point.([(0.8, 0.2), (0.01, -0.9), (-0.5, -0.5)])
kfp = kernelf(PolyKernel{2}(), constants, anchors2)
Plots.contour(xaxis, yaxis, kfp.(x2); label="2D function")

kfp = kernelf(PolyKernel{2}(), constants_simplified, anchors_simplified)
Plots.contour(xaxis, yaxis, kfp.(x2); label="2D function")

################## RBF Kernel ###################
# 1D
x = -2:0.01:2
constants = [0.8, 0.1, 0.5]
anchors = [0.8, 0.01, -0.5]
ker = RBFKernel(0.1)
kf = kernelf(ker, constants, anchors)
Plots.plot(x, kf.(x); label="1D function")

# 2D
xaxis, yaxis = -2:0.05:2, -2:0.05:2
x2 = [KernelPCA.Point(a, b) for a in xaxis, b in yaxis]
constants2 = [0.8, 0.1, 0.5]
anchors2 = KernelPCA.Point.([(0.8, 0.2), (0.01, 0.9), (-0.5, -0.5)])
kf2 = kernelf(ker, constants, anchors2)
Plots.contour(xaxis, yaxis, kf2.(x2); label="2D function")