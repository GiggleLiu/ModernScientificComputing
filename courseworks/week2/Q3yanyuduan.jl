using LinearAlgebra

function gauss_jordan(A_in)
    A = copy(A_in)
    n = size(A,1)
    B = Matrix{Float64}(I, n, n)
    for i = 1:n
        for j = 1:n
            if j != i
                c_ji = A[j, i] / A[i, i]
                for k = 1 : i
                    B[j, k] -= B[i, k] * c_ji
                end 
                for k = i : n
                    A[j, k] -= A[i, k] * c_ji
                end
            end
        end
    end

    for i = 1:n
        for j in 1:n
            B[i, j] = B[i, j] / A[i, i]            
        end
    end
    return B
end

#gauss_jordan (generic function with 1 method)


A_example = [1. 2 2; 4 4 2; 4 6 4]
B = gauss_jordan(A_example)

B * Matrix(A_example)
     

using Test
@testset "Gauss Jordan" begin
	n = 10
	A = randn(n, n)
	@test gauss_jordan(A) * A ≈ Matrix{Float64}(I, n, n)
end

#=

Test Summary: | Pass  Total  Time
Gauss Jordan  |    1      1  0.7s

=#