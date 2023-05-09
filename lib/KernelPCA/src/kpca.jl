# https://link.springer.com/chapter/10.1007/BFb0020217

struct KPCAResult{KT<:AbstractKernel, T, VT<:AbstractVector{T}, MT<:AbstractMatrix{T}, AVT<:AbstractVector}
    kernel::KT
    lambda::VT
    vectors::MT
    anchors::AVT
end

# Kernel Principle Component analysis
# The inverse map could be found by using the technique of "Learning to Find Pre-Images"
# https://papers.nips.cc/paper_files/paper/2003/hash/ac1ad983e08ad3304a97e147f522747e-Abstract.html
function kpca(kernel::AbstractKernel, dataset::AbstractVector; atol=1e-10, centered::Bool=true)
    K = matrix(kernel, dataset)
    n = length(dataset)
    # centralize: K = K - 1ₙK - K1ₙ + 1ₙK1ₙ, where (1ₙ)_{i,j} := 1/n
    if centered
        K .= K .- sum(K; dims=1) ./ n .- sum(K; dims=2) ./ n .+ sum(K) ./ n^2
    end
    # solving the eigenvalue problem λα = Kα
    E, U = eigen(Hermitian(K))

    # truncate small values
    idx = findfirst(E) do lambda
        if lambda < -1e-8
            error("Kernel matrix is not possitive definite, got eigenvalue: $lambda")
        end
        lambda >= atol
    end
    # re-order the eigenvalues from large to small, and normalize it
    E = E[end:-1:idx] ./ n
    # normalize the eigen vectors in the RKHS
    U = U[:, end:-1:idx] .* inv.(sqrt.(reshape(E, 1, :)))
    return KPCAResult(kernel, E, U, dataset)
end

function kernelf(kpca::KPCAResult, i::Int)
    return kernelf(kpca.kernel, kpca.vectors[:,i], kpca.anchors)
end