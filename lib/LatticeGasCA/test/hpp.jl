using LatticeGasCA, Test

@testset "hpp" begin
    hpp = hpp_singledot()
    hpp2 = simulate(hpp, 76; verbose=true)
    @test !(hpp === hpp2) && hpp == hpp2
end