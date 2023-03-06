using LinearAlgebra, Test


function gauss_jordan(M::AbstractMatrix)
    return inv(M)
end


@testset "Gauss Jordan" begin
	n = 10
	A = randn(n, n)
	@test gauss_jordan(A) * A ≈ Matrix{Float64}(I, n, n)
end
