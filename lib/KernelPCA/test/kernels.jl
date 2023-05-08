using KernelPCA, Test, LinearAlgebra

@testset "rbf" begin
    ker = RBFKernel(0.56)
    m = matrix(ker, 0:0.01:0.99)
    @test m isa Matrix && size(m) == (100, 100)
    @test diag(m) ≈ ones(100)
end

using Plots

# 1D
x = -2:0.01:2
constants = [0.8, 0.1, 0.5]
anchors = [0.8, 0.01, -0.5]
ker = RBFKernel(0.1)
kf = kernelf(ker, constants, anchors)
plot(x, kf.(x); label="1D function")

# 2D
xaxis, yaxis = -2:0.05:2, -2:0.05:2
x2 = [Point(a, b) for a in xaxis, b in yaxis]
constants2 = [0.8, 0.1, 0.5]
anchors2 = Point.([(0.8, 0.2), (0.01, 0.9), (-0.5, -0.5)])
kf2 = kernelf(ker, constants, anchors2)
heatmap(xaxis, yaxis, kf2.(x2); label="2D function")