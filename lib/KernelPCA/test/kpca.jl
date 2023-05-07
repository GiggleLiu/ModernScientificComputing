using KernelPCA, Test
using GLMakie: scatter, contour, Figure, Axis
using LinearAlgebra

@testset "kpca" begin
    # normalization condition
    #kernel = RBFKernel(0.5)
    kernel = PolyKernel(2)
    #kernel = LinearKernel()
    dataset = KernelPCA.DataSets.quadratic(100)
    #dataset = KernelPCA.DataSets.linear(100)
    res = kpca(kernel, dataset; centered=false)
    # check normalization
    for k in 1:length(res.lambda)
        @test res.lambda[k] * norm(res.vectors[:, k])^2 ≈ 1
    end
    # check the eigenvalue problem
    Φ = [ϕ(x) for x in dataset]
    C = sum(x->1/length(dataset) .* x * x', Φ)
    V1 = sum([alpha * x  for (alpha, x) in zip(res.vectors[:, 1], Φ)])
    for k in 1:length(res.lambda)
        @test res.lambda[1] * V1 ≈ C * V1
    end
    plot(res)
end

@testset "centered kpca" begin
    kernel = PolyKernel(2)
    #kernel = LinearKernel()
    dataset = KernelPCA.DataSets.quadratic(100)
    res = kpca(kernel, dataset; centered=true)

    ϕ(x) = [x[1]^2, x[1]*x[2], x[2]*x[1], x[2]^2]
    Φ = [ϕ(x) for x in dataset]
    Φ = Φ .- Ref(sum(Φ) ./ length(Φ))
    C = sum(x->1/length(dataset) .* x * x', Φ)
    V1 = sum([alpha * x  for (alpha, x) in zip(res.vectors[:, 1], Φ)])

    @info res.lambda
    for k in 1:length(res.lambda)
        @test res.lambda[1] * V1 ≈ C * V1
    end
    #plot(res)
end

function plot(res)
    dataset = res.anchors
    x, y = getindex.(dataset, 1), getindex.(dataset, 2)
    @show res.lambda
    kf = kernelf(res, 1)
    f = Figure()
    ax = Axis(f[1, 1])
    X, Y = -2:0.01:2, -2:0.01:2
    #levels = -0.1:0.01:0.1
    contour!(ax, X, Y, kf.(Point.(X, Y')); labels=true)
    scatter!(ax, x, y)
    display(f)
end