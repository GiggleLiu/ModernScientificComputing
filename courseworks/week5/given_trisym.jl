using LinearAlgebra,Test, Random

function givens_trisym!()

end

@testset "Givens rotation For Triangular Symmetric Matrices"begin
    n = 10
    triSym = Diagonal(randn(Float64,n,n))
    off_diag = randn(Float64,n-1,n-1)
    for i in 1:n-1
        triSym[i+1,i] = off_diag[i]
        triSym[i,i+1] = off_diag[i]
    end
    Q,R = givens_trisym!()
    @test givens_tri
end
