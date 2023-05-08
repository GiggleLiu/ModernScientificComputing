abstract type AbstractKernel end
struct Point{N,T}
    coo::NTuple{N,T}
end
Point(arg::T, args::T...) where T<:Number = Point((arg, args...))
Base.:(+)(x::Point{N,T}, y::Point{N,T}) where {N, T} = Point(x.coo .+ y.coo)
Base.:(-)(x::Point{N,T}, y::Point{N,T}) where {N, T} = Point(x.coo .- y.coo)
Base.:(-)(x::Point{N,T}) where {N, T} = Point(Base.:(-).(x.coo))
Base.adjoint(x::Point) = x
Base.:(*)(x::Number, y::Point) = Point(y.coo .* x)
Base.:(*)(y::Point, x::Number) = Point(y.coo .* x)
Base.iterate(x::Point, args...) = Base.iterate(x.coo, args...)
Base.getindex(x::Point, i::Int) = x.coo[i]

rbf_kernel_function(x, y, σ::Real) = exp(-1/2σ * dist2(x, y))
dist2(x::Number, y::Number) = abs2(x - y)
dist2(x::Point, y::Point) = sum(abs2, x - y)

"""
    RBFKernel <: AbstractKernel
    RBFKernel(σ::Real)

RBF Kernel.
"""
struct RBFKernel <: AbstractKernel
    sigma::Float64
end
(k::RBFKernel)(x, y) = rbf_kernel_function(x, y, k.sigma)

# the matrix representation of Kernel on a basis
matrix(rbf::RBFKernel, basis::AbstractVector) = rbf.(basis, basis')

# a function represented as a combination of kernel functions
function kernelf(kernel::AbstractKernel, constants::AbstractVector, anchors::AbstractVector)
    @assert length(constants) == length(anchors) "the lengths of constants and anchors must be the same."
    return x -> sum(i->constants[i] * kernel(x, anchors[i]), 1:length(constants))
end