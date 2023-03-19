using Test, LinearAlgebra

# following code from notebook
function lanczos(A, q1::AbstractVector{T}; abstol, maxiter) where {T}
    # normalize the input vector
    q1 = normalize(q1)
    # the first iteration
    q = [q1]
    Aq1 = A * q1
    α = [q1' * Aq1]
    rk = Aq1 .- α[1] .* q1
    β = [norm(rk)]
    for k = 2:min(length(q1), maxiter)
        # the k-th orthonormal vector in Q
        push!(q, rk ./ β[k-1])
        Aqk = A * q[k]
        # compute the diagonal element as αₖ = qₖᵀ A qₖ
        push!(α, q[k]' * Aqk)
        rk = Aqk .- α[k] .* q[k] .- β[k-1] * q[k-1]
        # compute the off-diagonal element as βₖ = |rₖ|
        nrk = norm(rk)
        # break if βₖ is smaller than abstol or the maximum number of iteration is reached
        if abs(nrk) < abstol || k == length(q1)
            break
        end
        push!(β, nrk)
    end
    # returns T and Q
    # I improve based on Prof Liu's comment on Xuanzhao's work
    return SymTridiagonal(α, β), cat(q1, q[2:end]...; dims=2)
end

struct HouseholderMatrix{T} <: AbstractArray{T,2}
    v::Vector{T}
    β::T
end

# the `mul!` interfaces can take two extra factors.
function left_mul!(B, A::HouseholderMatrix)
    B .-= (A.β .* A.v) * (A.v' * B)
    return B
end

# the `mul!` interfaces can take two extra factors.
function left_mul!(B, A::HouseholderMatrix)
    B .-= (A.β .* A.v) * (A.v' * B)
    return B
end

function householder_matrix(v::AbstractVector{T}) where {T}
    v = copy(v)
    v[1] -= norm(v, 2)
    return HouseholderMatrix(v, 2 / norm(v, 2)^2)
end

function lanczos_restart(A, q1::AbstractVector{T}; abstol, maxiter) where {T}
    tr, Q = lanczos(A, q1; abstol=abstol, maxiter=maxiter)
    ts = Q' * A * Q
    eig_data = eigen(ts)
    u1 = eig_data.vectors[:, end]
    q1_new = Q * u1
    return lanczos(A, q1_new; abstol=abstol, maxiter=maxiter)
end

@testset "lanczos-restart" begin
    q1 = normalize!(randn(400))
    A_rand = randn(400, 400)

    A = SymTridiagonal(A_rand + A_rand')
    T_origin, Q_origin = lanczos(A, q1; abstol=1e-5, maxiter=100)
    eig_origin_data = eigen(T_origin)
    T_restart, Q_restart = lanczos_restart(A, q1; abstol=1e-5, maxiter=100)
    eig_restart_data = eigen(T_restart)
    eig_data = eigen(A)
    @test abs(eig_origin_data.values[end] - eig_data.values[end]) < abs(eig_restart_data.values[end] - eig_data.values[end])

end
