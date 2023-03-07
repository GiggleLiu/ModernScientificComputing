using LinearAlgebra, Test, BenchmarkTools


function gauss_jordan(M::AbstractMatrix{T}) where T <: Number
    m,n = size(M)
    @assert m == n
    MI = hcat(M,Matrix{eltype(M)}(I,m,m))
    return _gauss_jordan_helper!(MI)
end

function _gauss_jordan_helper!(MI_partial::AbstractMatrix{T}) where T <: Number
    m,n = size(MI_partial)
    fct = 0.0
    if n == m
        return MI_partial
    else
        cur_idx = 2 * m - n + 1
        fct = MI_partial[cur_idx,1]

        @inbounds for j in 1:n
            MI_partial[cur_idx,j] /= fct
        end

        @inbounds for i in 1:m
            if i != cur_idx
                fct = MI_partial[i,1]
                @inbounds for j in 1:n
                    MI_partial[i,j] -= fct * MI_partial[cur_idx,j]
                end
            end
        end
        return _gauss_jordan_helper!(MI_partial[:,2:end])
    end

end

@testset "Gauss Jordan" begin
	n = 10
	A = randn(n, n)
	@test gauss_jordan(A) * A ≈ Matrix{Float64}(I, n, n)
end

begin
    n = 10
    A = randn(n, n)
    @benchmark gauss_jordan(A)
    @benchmark inv(A)
end
