using LatticeGasCA, Test, CUDA
CUDA.allowscalar(false)

@testset "hpp" begin
    hpp = cu(hpp_singledot())
    hpp2 = simulate(hpp, 76; verbose=true)
    @test !(hpp === hpp2) && hpp == hpp2
end