using LinearAlgebra
using Test

function givens_rotation(a, b)
    if abs(b) < 1e-15
        c = copysign(1.0, a)
        s = 0.0
    else
        r = hypot(a, b)
        c = a / r
        s = -b / r
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

# Test with a symmetric triangular matrix T
T = [
    1.0 2.0 0.0 0.0 0.0;
    2.0 3.0 4.0 0.0 0.0;
    0.0 4.0 5.0 6.0 0.0;
    0.0 0.0 6.0 7.0 8.0;
    0.0 0.0 0.0 8.0 9.0;
]

Q, R = symmetric_triangular_qr(T)

println("Q:")
println(Q)
println("R:")
println(R)
println("Q * R:")
println(Q * R)

# Test
@testset "symmetric_triangular_qr" begin
    
    A = Q * R
    @test size(Q) == (5, 5)
    @test size(R) == (5, 5)
    @test Q * R ≈ A
    @test Q' * Q  ≈  I
end

