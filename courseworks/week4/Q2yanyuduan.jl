using LinearAlgebra,Test, Random

struct GivensMatrix{T} <: AbstractArray{T, 2}
	c::T
	s::T
	i::Int
	j::Int
	n::Int
end

Base.size(g::GivensMatrix) = (g.n, g.n)

Base.size(g::GivensMatrix, i::Int) = i == 1 || i == 2 ? g.n : 1

function givens(A, i, j)
	x, y = A[i, 1], A[j, 1]
	norm = sqrt(x^2 + y^2)
	c = x/norm
	s = y/norm
	return GivensMatrix(c, s, i, j, size(A, 1))
end

function left_mul!(A::AbstractMatrix, givens::GivensMatrix)
	@inbounds for col in 1:min(size(A, 2),3)
		vi, vj = A[givens.i, col], A[givens.j, col]
		A[givens.i, col] = vi * givens.c + vj * givens.s
		A[givens.j, col] = -vi * givens.s + vj * givens.c
	end
	return A
end
function right_mul!(A::AbstractMatrix, givens::GivensMatrix)
	@inbounds for row in 1:size(A, 1)
		vi, vj = A[row, givens.i], A[row, givens.j]
		A[row, givens.i] = vi * givens.c + vj * givens.s
		A[row, givens.j] = -vi * givens.s + vj * givens.c
	end
	return A
end

function givens_trisym!(Q::AbstractMatrix,A::AbstractMatrix)
    m, n = size(A)
	if m == 1
		return Q, A
	else
		g = givens(A, 1, 2)
		left_mul!(A, g)
		right_mul!(Q, g)

		givens_trisym!(view(Q, :, 2:m), view(A, 2:m, 2:n))
		return Q, A
	end
end

@testset "test givens" begin
    n = 5
    triSym = diagm(randn(Float64,n))
    off_diag = randn(Float64,n-1,n-1)
    for i in 1:n-1
        triSym[i+1,i] = off_diag[i]
        triSym[i,i+1] = off_diag[i]
    end

    display(triSym)
    triSym_me= copy(triSym)
    my_Q,my_R = givens_trisym!(Matrix{Float64}(I,n,n),triSym_me)
    display(my_Q)
    display(my_R)
    @test my_Q * my_R  ≈ triSym
    @test my_Q * my_Q' ≈ I
end
     


#= Runing Results

5×5 Matrix{Float64}:
 -0.246606   1.91883   0.0        0.0        0.0       
  1.91883   -0.019324  1.28907    0.0        0.0       
  0.0        1.28907   0.796961   1.94356    0.0       
  0.0        0.0       1.94356   -2.17894    0.650809  
  0.0        0.0       0.0        0.650809  -1.22553   
5×5 Matrix{Float64}:
 -0.12747   0.820867  -0.156001  -0.511581    0.154522 
  0.991842  0.105497  -0.020049  -0.0657478   0.0198589
  0.0       0.561291   0.231914   0.760526   -0.229715 
  0.0       0.0        0.959936  -0.268248    0.0810237
  0.0       0.0        0.0        0.289145    0.957285 
5×5 Matrix{Float64}:
 1.93461  -0.263761   1.27855       0.0       0.0      
 0.0       2.29661    0.583319      1.0909    0.0
 0.0       0.0        2.02467      -1.64091   0.624735
 0.0       0.0       -1.11022e-16   2.2508   -0.528934
 0.0       0.0        0.0           0.0      -1.12045
Test Summary: | Pass  Total  Time
test givens   |    2      2  1.5s
Test.DefaultTestSet("test givens", Any[], 2, false, false, true, 1.684315116915e9, 1.684315118368e9)

=#