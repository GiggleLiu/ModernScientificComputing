using KernelPCA, Test
using LinearAlgebra, Random
using Plots

@testset "kpca" begin
    Random.seed!(4)
    # normalization condition
    #kernel = RBFKernel(0.5)
    kernel = PolyKernel{2}()
    dataset = KernelPCA.DataSets.rings(100)
    #dataset = KernelPCA.DataSets.linear(100)
    res = kpca(kernel, dataset; centered=false)
    # check normalization
    for k in 1:length(res.lambda)
        @test res.lambda[k] * norm(res.vectors[:, k])^2 ≈ 1
    end
    @show res.lambda
    display(showres(res))
end

@testset "kpca" begin
    Random.seed!(4)
    # normalization condition
    #kernel = RBFKernel(0.5)
    kernel = PolyKernel{2}()
    dataset = KernelPCA.DataSets.curve(100)
    #dataset = KernelPCA.DataSets.linear(100)
    res = kpca(kernel, dataset; centered=false)
    # check normalization
    for k in 1:length(res.lambda)
        @test res.lambda[k] * norm(res.vectors[:, k])^2 ≈ 1
    end
    # check the eigenvalue problem
    Φ = [ϕ(kernel, x) for x in dataset]
    C = sum(x->1/length(dataset) .* x * x', Φ)
    V1 = sum([alpha * x  for (alpha, x) in zip(res.vectors[:, 1], Φ)])
    for k in 1:length(res.lambda)
        @test res.lambda[1] * V1 ≈ C * V1
    end
    showres(res)
end

@testset "centered kpca" begin
    Random.seed!(2)
    kernel = PolyKernel{2}()
    #kernel = LinearKernel()
    dataset = KernelPCA.DataSets.curve(100)
    res = kpca(kernel, dataset; centered=true)

    Φ = [ϕ(kernel, x) for x in dataset]
    Φ = Φ .- Ref(sum(Φ) ./ length(Φ))
    C = sum(x->1/length(dataset) .* x * x', Φ)
    V1 = sum([alpha * x  for (alpha, x) in zip(res.vectors[:, 1], Φ)])

    @info res.lambda
    for k in 1:length(res.lambda)
        @test res.lambda[1] * V1 ≈ C * V1
    end
    display(showres(res))
end

function showres(res)
    dataset = res.anchors
    x, y = getindex.(dataset, 1), getindex.(dataset, 2)
    @show res.lambda
    kf = kernelf(res, 1)
    X, Y = minimum(x):0.01:maximum(x), minimum(y):0.01:maximum(y)
    @show X, Y
    #levels = -0.1:0.01:0.1
    plt = Plots.contour(X, Y, kf.(KernelPCA.Point.(X', Y)); label="")
    Plots.scatter!(plt, x, y; label="data")
end