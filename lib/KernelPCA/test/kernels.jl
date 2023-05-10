using KernelPCA, Test, LinearAlgebra

@testset "rbf" begin
    ker = RBFKernel(0.56)
    m = matrix(ker, 0:0.01:0.99)
    @test m isa Matrix && size(m) == (100, 100)
    @test diag(m) ≈ ones(100)
end

@testset "poly" begin
    ker = PolyKernel{2}()
    x, y = Point(0.2, 0.5), Point(0.4, 0.9)
    @test ker(x, y) == ϕ(ker, x)' * ϕ(ker, y)

    ker = PolyKernel{3}()
    x, y = Point(0.2, 0.5), Point(0.4, 0.9)
    @test ker(x, y) == ϕ(ker, x)' * ϕ(ker, y)

    # linear kernel
    ker = LinearKernel()
    @test ker(x, y) == ϕ(ker, x)' * ϕ(ker, y)
    @test ker(x, y) == collect(x)' * collect(y)
end