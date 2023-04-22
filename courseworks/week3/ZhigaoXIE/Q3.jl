using LinearAlgebra
using Test

function gauss_jordan_inverse(A::Matrix{Float64})
    n = size(A, 1)
    I = LinearAlgebra.I(n)
    aug = [A I]

    # Perform row operations to get A on the left side
    for i in 1:n
        # Swap rows if necessary
        if aug[i,i] == 0
            for j in (i+1):n
                if aug[j,i] != 0
                    aug[[i,j],:] = aug[[j,i],:]
                    break
                end
            end
        end

        # Divide row i by the pivot to make it 1
        pivot = aug[i,i]
        if pivot != 1
            aug[i,:] /= pivot
        end

        # Subtract a multiple of row i from all other rows to make their entries 0
        for j in 1:n
            if j != i
                factor = aug[j,i]
                aug[j,:] -= factor * aug[i,:]
            end
        end
    end
    # The inverse of A is on the right side of the augmented matrix
    A_inv = aug[:, (n+1):end]

    return A_inv
end

#gauss_jordan_inverse (generic function with 1 method)
@testset "Gauss-Jordan inverse" begin
n = 10
A = randn(n, n)
@test gauss_jordan_inverse(A) * A ≈ Matrix{Float64}(I, n, n)
end


