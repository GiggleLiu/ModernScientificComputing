using LatticeGasCA
using Test, CUDA

@testset "hpp" begin
    include("hpp.jl")
end

if CUDA.functional()
    include("cuda.jl")
end