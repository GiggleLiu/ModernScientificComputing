# source: https://gist.github.com/yegortk/ce18975200e7dffd1759125972cd54f4
module L1Convex

using LinearAlgebra
export OWLQN, step!

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
struct OWLQN{T, AT<:AbstractArray{T}}
    Δx::Vector{AT}                # param_t+1 - param_t [max size of m]
    Δg::Vector{AT}                # grad_t+1 - grad_t [max size of m]
    rho::Vector{T}                # 1/Δx[i]'Δg[i]
    m::Int                        # L-BFGS history length 
    λ::Float64                    # L1 penalty
    line_search_iterations::Int
end
# constructor
function OWLQN(::Type{AT}; λ = 1.0, m::Int=6, line_search_iterations::Int=20) where {T, AT<:AbstractArray{T}}
    return OWLQN(AT[], AT[], T[], m, Float64(λ), line_search_iterations)
end

# projected gradient based on raw gradient, parameter values, and L1 reg. strength
function pseudo_gradient(g::AbstractArray{T}, x::AbstractArray{T}, λ::Real) where T
    @assert size(g) == size(x)
    return map(g, x) do gi, xi
        if xi > 0
            gi + λ
        elseif xi < 0
            gi - λ
        else
            if gi + λ < 0
                gi + λ
            else
                gi - λ
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
    
    x_copy = copy(x)
    g_copy = g
    
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
        line_search!(f, pg, x, z, λ; iterations=M.line_search_iterations)
    else
        # fancy way to do  x .-= g
        line_search!(f, pg, x, pg, λ, α = 1 / norm(pg, 2); iterations=M.line_search_iterations)
    end
    
    push!(Δx, x .- x_copy)
    push!(Δg, ∇f(x) .- g_copy)
    push!(rho, 1 ./ dot(Δg[end], Δx[end]))
    
    while length(Δx) > M.m
        popfirst!(Δx)
        popfirst!(Δg)
        popfirst!(rho)
    end
end

# projected backtracking line search
function line_search!(f::Function, pg::AbstractArray{T},
            x::AbstractArray{T}, z::AbstractArray{T},
            λ::Float64;
            α::Real=1.0,
            β::Real=0.5,
            γ::Real=1e-4,
            iterations::Int=20,
        ) where T
    # the loss
    loss(x) = f(x) + λ * norm(x, 1)
    y = loss(x)

    # choose orthant for the new point
    orthant(xi, pgi) = iszero(xi) ? sign(-pgi) : sign(xi)
    xi = orthant.(x, pg)

    xt = similar(x)
    for _ = 1:iterations
        # update current point
        xt .= x .- α .* z

        # project point onto orthant
        project!(xt, xi)

        # sufficient decrease condition
        if loss(xt) <= y .+ γ .* dot(pg, xt .- x)
            break
        end

        # update step size
        α *= β
    end
    x .= xt
    return x
end
# pi alignment operator - projection of a on orthat defined by b
function project!(a::AbstractArray{T}, b::AbstractArray{T}) where T
    project(ai, bi) = sign(ai) == sign(bi) ? ai : zero(ai)
    a .= project.(a, b)
    return a
end

end