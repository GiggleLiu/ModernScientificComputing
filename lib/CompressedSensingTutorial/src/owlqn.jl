# source: https://gist.github.com/yegortk/ce18975200e7dffd1759125972cd54f4
module L1Convex

using LinearAlgebra, NLSolversBase
export OWLQN, step!, SimpleLinesearch

# This is a Julia module implementing OWL-QN algorithm for large-scale L1-regularized convex optimization
# https://www.microsoft.com/en-us/research/wp-content/uploads/2007/01/andrew07scalable.pdf
# http://proceedings.mlr.press/v37/gonga15.pdf

# The algorithm minimizes loss of the form: f(x) + λ * ||x||_1
# where f(x) is a differentiable convex function
# ||x||_1 is the L1 norm of the parameter vector x
# λ is the regularization strength

# L-BFGS component implementation is based on:
# https://en.wikipedia.org/wiki/Limited-memory_BFGS
# https://mitpress.mit.edu/books/algorithms-optimization
# https://bitbucket.org/rtaylor/pylbfgs/src/master/

# libary to support ⋅ vector dot product notation

# struct with key algorithm parameters
struct OWLQN{T, L, AT<:AbstractArray{T}}
    Δx::Vector{AT}                # param_t+1 - param_t [max size of m]
    Δg::Vector{AT}                # grad_t+1 - grad_t [max size of m]
    rho::Vector{T}                # 1/Δx[i]'Δg[i]
    m::Int                        # L-BFGS history length 
    λ::T                          # L1 penalty
    linesearch!::L                # line searcher
end
# constructor
function OWLQN(::Type{AT}; λ = 1.0, m::Int=6, linesearch=SimpleLinesearch()) where {T, AT<:AbstractArray{T}}
    return OWLQN(AT[], AT[], T[], m, Float64(λ), linesearch)
end

# projected gradient based on raw gradient, parameter values, and L1 reg. strength
function pseudo_gradient(g::AbstractArray{T}, x::AbstractArray{T}, λ::T) where T
    @assert size(g) == size(x)
    return map(g, x) do gi, xi
        if xi > 0
            gi + λ
        elseif xi < 0
            gi - λ
        else
            if gi < -λ
                gi + λ
            elseif gi > λ
                gi - λ
            else
                zero(T)
            end
        end
    end
end

# single update of parameters x
function step!(M::OWLQN, f::Function, ∇f::Function, x::AbstractArray{T}) where T
    Δx, Δg, rho, λ, g = M.Δx, M.Δg, M.rho, M.λ, ∇f(x)
    
    # "(Local) minimum found: ∇f(x) == 0"
    all(iszero, g) && return
    m = min(M.m, length(Δx))
    pg = pseudo_gradient(g, x, λ)
    
    if m > 0
        # L-BFGS computation of Hessian-scaled gradient z = H_inv * g
        α = T[]
        Q = copy(pg)
        for i in m:-1:1
            push!(α, rho[i] .* dot(Δx[i], Q))
            Q .-= α[end] .* Δg[i]
        end
        reverse!(α)
        z = Q .* (dot(Δx[end], Δg[end]) / norm(Δg[end]))
        for i in 1:m
            z .+= Δx[i] .* (α[i] - rho[i] * dot(Δg[i], z))
        end
        
        # zeroing out all elements in z if sign(z[i]) != sign(g[i])
        # that is, if scaling changes gradient sign
        project!(z, pg)
        
        # fancy way to do x .-= z
        # TODO: optimize
        xnew = line_search(M.linesearch!, f, ∇f, pg, x, -z, λ)
    else
        # fancy way to do  x .-= g
        xnew = line_search(M.linesearch!, f, ∇f, pg, x, -pg, λ, α = 1 / norm(pg, 2))
    end
    
    push!(Δx, xnew .- x)
    push!(Δg, ∇f(xnew) .- g)
    push!(rho, 1 / dot(Δg[end], Δx[end]))
    
    while length(Δx) > M.m
        popfirst!(Δx)
        popfirst!(Δg)
        popfirst!(rho)
    end
    return xnew
end

# projected backtracking line search
function line_search(method, f, ∇f, pg::AbstractArray{T},
            x::AbstractArray{T}, z::AbstractArray{T},
            λ::Float64;
            α::Real=1.0,
        ) where T
    # the loss function
    loss(x) = f(x) + λ * norm(x, 1)
    φ_0 = loss(x)
    # the gradient function
    g!(store, x) = (store .= pseudo_gradient(∇f(x), x, λ); store)
    dφ_0 =  dot(pg, z)

    xnew = similar(x)
    method(NLSolversBase.OnceDifferentiable(loss, g!, x), x, z, α, xnew, φ_0, dφ_0)
    return xnew
end

####################### The line search method implements the interface in `LineSearches``.
Base.@kwdef struct SimpleLinesearch
    β::Real=0.5           # decay rate of the step size α
    γ::Real=1e-4          # determine the sufficient decrease condition
    iterations::Int=100  # maximum number of iterations
end
function (ls::SimpleLinesearch)(df::NLSolversBase.AbstractObjective, x::AbstractArray{T},
                          s::AbstractArray{T}, α::Real,
                          x_new::AbstractArray{T}, phi_0::Real, dphi_0::Real) where T
    @assert dphi_0 < 0 "the direction can not reduce the loss!"
    β, γ, iterations = ls.β, ls.γ, ls.iterations
    # choose orthant for the new point
    orthant(xi, pgi) = iszero(xi) ? sign(pgi) : sign(xi)
    xi = orthant.(x, s)

    for _ = 1:iterations
        # update current point
        x_new .= x .+ α .* s

        # project point onto orthant
        project!(x_new, xi)

        # sufficient decrease condition
        y = NLSolversBase.value!(df, x_new)
        if y <= phi_0 + γ * dphi_0 * α
            break
        end

        # update step size
        α *= β
    end
    return α, phi_0 + γ * dphi_0 * α
end
# pi alignment operator - projection of a on orthat defined by b
function project!(a::AbstractArray{T}, b::AbstractArray{T}) where T
    project(ai, bi) = sign(ai) == sign(bi) ? ai : zero(ai)
    a .= project.(a, b)
    return a
end

end

import .L1Convex: SimpleLinesearch
