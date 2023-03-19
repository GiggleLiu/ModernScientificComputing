using Test, LinearAlgebra

# following code from
function lanczos(A, q1::AbstractVector{T}; abstol, maxiter) where T
	# normalize the input vector
	q1 = normalize(q1)
	# the first iteration
	q = [q1]
	Aq1 = A * q1
	α = [q1' * Aq1]
	rk = Aq1 .- α[1] .* q1
	β = [norm(rk)]
	for k = 2:min(length(q1), maxiter)
		# the k-th orthonormal vector in Q
		push!(q, rk ./ β[k-1])
		Aqk = A * q[k]
		# compute the diagonal element as αₖ = qₖᵀ A qₖ
		push!(α, q[k]' * Aqk)
		rk = Aqk .- α[k] .* q[k] .- β[k-1] * q[k-1]
		# compute the off-diagonal element as βₖ = |rₖ|
		nrk = norm(rk)
		# break if βₖ is smaller than abstol or the maximum number of iteration is reached
		if abs(nrk) < abstol || k == length(q1)
			break
		end
		push!(β, nrk)
	end
	# returns T and Q
    # I improve based on Prof Liu's comment on Xuanzhao's work
	return SymTridiagonal(α, β), cat(q1,q[2:end]...;dims=2)
end

function lanczos_restart(A,p1::AbstractVector{T};atol,maxiter) where T

end

@testset "lanczos-restart" begin
    q1 = normalize!(randn(500))
    A_rand = randn(500,500)

    A = SymTridiagonal(A + A')
    T_origin , Q_origin = lanczos(A,q1;atol=1e-5,maxiter=100)


end
