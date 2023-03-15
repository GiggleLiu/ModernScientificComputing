using PlutoLecturing
using Test

@testset "PlutoLecturing.jl" begin
    # Write your tests here.
end

@testset "trees" begin
    @test print_dependency_tree(PlutoLecturing) isa HTML
    @test print_dir_tree(".") isa Text
    @test print_type_tree(".") isa Text
end
