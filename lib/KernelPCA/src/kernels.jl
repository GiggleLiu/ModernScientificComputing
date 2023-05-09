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
Base.length(::Point{N}) where N = N

dist2(x::Number, y::Number) = abs2(x - y)
dist2(x::Point, y::Point) = sum(abs2, x - y)

######################### Kernels
abstract type AbstractKernel end
# the matrix representation of Kernel on a basis
matrix(kf::AbstractKernel, basis::AbstractVector) = kf.(basis, reshape(basis, 1, :))

# a function represented as a combination of kernel functions
function kernelf(kernel::AbstractKernel, constants::AbstractVector, anchors::AbstractVector)
    @assert length(constants) == length(anchors) "the lengths of constants and anchors must be the same."
    return x -> sum(i->constants[i] * kernel(x, anchors[i]), 1:length(constants))
end

"""
    RBFKernel <: AbstractKernel
    RBFKernel(σ::Real)

RBF Kernel.
"""
struct RBFKernel <: AbstractKernel
    sigma::Float64
end
(k::RBFKernel)(x, y) = rbf_kernel_function(x, y, k.sigma)
rbf_kernel_function(x, y, σ::Real) = exp(-1/2σ * dist2(x, y))

"""
    PolyKernel <: AbstractKernel
    PolyKernel{order}()

Polynomial Kernel.
"""
struct PolyKernel{order} <: AbstractKernel end
(k::PolyKernel{order})(x, y) where order = poly_kernel_function(x, y, order)
poly_kernel_function(x, y, order::Int) = dot(x, y)^order
get_order(::PolyKernel{order}) where order = order

# take `k.order` elements from input vector `x`.
function ϕ(::PolyKernel{order}, x) where order
    vec([prod(i->x[i], ci.I) for ci in CartesianIndices(ntuple(i->length(x), order))])
end

const LinearKernel = PolyKernel{1}