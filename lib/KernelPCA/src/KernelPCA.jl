module KernelPCA

using LinearAlgebra

export RBFKernel, PolyKernel, LinearKernel, kernelf, matrix, Point
export kpca, KPCAResult, ϕ

include("kernels.jl")
include("kpca.jl")
include("dataset.jl")

end
