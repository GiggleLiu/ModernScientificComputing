using Test

@testset "compressed sensing 2d" begin
    include("compressed_sensing_2d.jl")
end

@testset "owlqn" begin
    include("owlqn.jl")
end