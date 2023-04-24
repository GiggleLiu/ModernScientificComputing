# source: https://gist.github.com/yegortk/ce18975200e7dffd1759125972cd54f4
module L1Convex

using LinearAlgebra
export OWLQN, step!

# This is a Julia module implementing OWL-QN algorithm for large-scale L1-regularized convex optimization
# https://www.microsoft.com/en-us/research/wp-content/uploads/2007/01/andrew07scalable.pdf
# http://proceedings.mlr.press/v37/gonga15.pdf

# The algorithm minimizes loss of the form: f(x) + lambda * ||x||_1
# where f(x) is a differentiable convex function
# ||x||_1 is the L1 norm of the parameter vector x
# lambda is the regularization strength

# L-BFGS component implementation is based on:
# https://en.wikipedia.org/wiki/Limited-memory_BFGS
# https://mitpress.mit.edu/books/algorithms-optimization
# https://bitbucket.org/rtaylor/pylbfgs/src/master/

# libary to support ⋅ vector dot product notation

# struct with key algorithm parameters
mutable struct OWLQN
    s                # param_t+1 - param_t [max size of m]
    y                # grad_t+1 - grad_t [max size of m]
    rho              # 1/s[i]'y[i]
    m::Int           # L-BFGS history length 
    t::Int           # iteration
    lambda::Float64  # L1 penalty
end

# constructor
function OWLQN(x::Vector{Float64}; lambda = 1.0)
    s = []
    y = []
    rho = []
    m = 6
    t = 0
    OWLQN(s, y, rho, m, t, lambda)
end

# projected gradient based on raw gradient, parameter values, and L1 reg. strength
function pseudo_gradient(g::Vector{Float64}, x::Vector{Float64}, lambda::Float64)
    pg = zeros(size(g))
    for i in 1:size(g)[1]
        if x[i] > 0
            pg[i] = g[i] + lambda
        elseif x[i] < 0
            pg[i] = g[i] - lambda
        else
            if g[i] + lambda < 0
                pg[i] = g[i] + lambda
            elseif g[i] - lambda > 0
                pg[i] = g[i] - lambda
            end
        end
    end
    return pg
end

# pi alignment operator - projection of a on orthat defined by b
function project!(a::Vector{Float64}, b::Vector{Float64})
    for i in 1:size(a)[1]
        if sign(a[i]) != sign(b[i])
            a[i] = 0.0
        end
    end
end

# projected backtracking line search
function projected_backtracking_line_search_update(f::Function, pg::Vector{Float64}, x::Vector{Float64}, z::Vector{Float64}, lambda::Float64; alpha=1.0, beta=0.5, gamma=1e-4)
    y = f(x) + lambda*sum(abs.(x))

    # choose orthant for the new point
    xi = sign.(x)
    for i in 1:size(xi)[1]
        if xi[i] == 0
            xi[i] = sign(-pg[i])
        end
    end

    while true
        # update current point
        xt = x - alpha * z

        # project point onto orthant
        project!(xt, xi)

        # sufficient decrease condition
        if f(xt) + lambda*sum(abs.(xt)) <= y + gamma * (pg ⋅ (xt - x))
            x .= xt
            break
        end

        # update step size
        alpha *= beta
    end
end

# single update of parameters x
function step!(M::OWLQN, f::Function, ∇f::Function, x::Vector{Float64})
    s, y, rho, lambda, g = M.s, M.y, M.rho, M.lambda, ∇f(x)
    
    if all(g .== 0.0)
        println("(Local) minimum found: ∇f(x) == 0")
        return
    end
    
    m = min(M.m, size(s)[1])
    M.t += 1
    
    x_copy = deepcopy(x)
    g_copy = deepcopy(g)
    
    pg = pseudo_gradient(g, x, lambda)
    Q = deepcopy(pg)
    
    if m > 0

        # L-BFGS computation of Hessian-scaled gradient z = H_inv * g
        alpha = []
        for i in m : -1 : 1
            push!(alpha, rho[i] * (s[i] ⋅ Q))
            Q -= alpha[end] * y[i]
        end
        reverse!(alpha)
        z = Q .* (s[end] ⋅ y[end]) / (y[end] ⋅ y[end])
        for i in 1 : m
            z += s[i] * (alpha[i] - rho[i] * (y[i] ⋅ z))
        end
        
        # zeroing out all elements in z if sign(z[i]) != sign(g[i])
        # that is, if scaling changes gradient sign
        project!(z, pg)
        
        # fancy way to do x .-= z
        projected_backtracking_line_search_update(f, pg, x, z, lambda)
    else
        # fancy way to do  x .-= g
        projected_backtracking_line_search_update(f, pg, x, pg, lambda, alpha = 1 / norm(pg, 2))
    end
    
    push!(s, x - x_copy)
    push!(y, ∇f(x) - g_copy)
    push!(rho, 1/(y[end] ⋅ s[end]))
    
    while length(s) > M.m
        popfirst!(s)
        popfirst!(y)
        popfirst!(rho)
    end
end

end