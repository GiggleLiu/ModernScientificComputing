using SparseArrays, Test

@testset "sparse matrix - vector multiplication" begin
	for k = 1:100
		m, n = rand(1:100, 2)
		density = rand()
		sp = sprand(m, n, density)
		v = randn(n)
        @test Matrix(sp) * v ≈ my_spv(sp, v)
	end
end
