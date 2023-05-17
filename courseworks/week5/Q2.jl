using SparseArrays, Test

function my_spv(sp::SparseMatrixCSC{T1},v::AbstractVector{T2}) where {T1,T2}
	T = promote_type(T1,T2)
	@assert size(sp,2) == size(v,1)
	rowval, colval, nzval = Int[], Int[], T[]
	@inbounds for j in 1:size(sp,2)
		@inbounds for i in nzrange(sp,j)
			push!(rowval,sp.rowval[i])
			push!(colval,1)
			push!(nzval,sp.nzval[i]*v[j])
		end
	end
	return sparse(rowval,colval,nzval,size(sp,1),size(v,2))
end

@testset "sparse matrix - vector multiplication" begin
	for k = 1:100
		m, n = rand(1:100, 2)
		density = rand()
		sp = sprand(m, n, density)
		v = randn(n)
        @test Matrix(sp) * v ≈ my_spv(sp, v)
	end

    #Test Summary:                         | Pass  Total  Time
    #sparse matrix - vector multiplication |  100    100  0.8s
	
