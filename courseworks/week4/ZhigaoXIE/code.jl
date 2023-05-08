using LinearAlgebra
using Test

function givens_rotation(a, b)
    if abs(b) < 1e-15
        c = copysign(1.0, a)
        s = 0.0
    else
        r = hypot(a, b)
        c = a / r
        s = b / r
    end
    return c, s
end

function symmetric_triangular_qr(T)
    m, n = size(T)
    Q = Matrix{Float64}(I, m, m)
    R = copy(T)

    for j = 1:n
        for i = m:-1:(j + 1)
            c, s = givens_rotation(R[i - 1, j], R[i, j])

            # Update R
            R[i - 1:i, j:n] = [c s; -s c] * R[i - 1:i, j:n]

            # Update Q
            Q[:, i - 1:i] = Q[:, i - 1:i] * [c -s; s c]
        end
    end

    return Q, R
end


# Test
using Random

function rand_A(n)
    A = Matrix(Tridiagonal(rand(n - 1), rand(n), rand(n - 1)))
    return A
end


using Test

@testset "Givens Rotation" begin
	for i in 1:100
		n = rand(1:100)
		A = rand_A(n)
		Q, R = symmetric_triangular_qr(A)
		@test Q * R ≈ A
	end
end
