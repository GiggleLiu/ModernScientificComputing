# Q2.jl

using SparseArrays, Test
using LinearAlgebra

function my_spv(A::SparseMatrixCSC{T1}, x::AbstractVector{T2}) where {T1, T2}
    T = promote_type(T1, T2)
    @assert size(A, 2) == length(x)
    y = zeros(T, size(A,1))
    for j in 1:size(A, 2)
        for k in nzrange(A, j)
            y[A.rowval[k]] += A.nzval[k] * x[j]
        end
    end
    return y
end

@testset "sparse matrix - vector multiplication" begin
    for k = 1:100
        m, n = rand(1:100, 2)
        density = rand()
        sp = sprand(m, n, density)
        v = randn(n)
        @test Matrix(sp) * v ≈ my_spv(sp, v)
    end
end

