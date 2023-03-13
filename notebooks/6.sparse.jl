### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ 4b6307f7-af43-4990-a5c4-5be2b6b11364
using PlutoUI

# ╔═╡ e548acb6-bf53-11ed-1988-7325c1e2b481
using SparseArrays

# ╔═╡ 455f8887-9b2c-4e67-abe5-5449efe55ce5
using LinearAlgebra

# ╔═╡ 0c8bf832-0cf8-4b56-b064-1dd177aceae8
using KrylovKit

# ╔═╡ 5b764297-3d06-4899-a8ae-f4378427a6e5
using Graphs  # for generating sparse matrices

# ╔═╡ 8d0d3889-14c0-4e2e-b710-8830e2dab827
TableOfContents()

# ╔═╡ 2add4589-251b-47d0-a800-f0db7f204b61
html"""<button onclick="present()">present</button>"""

# ╔═╡ 4990344c-81e8-48cf-93c0-fa1460e0470b
md"# Overview
1. Sparse matrix representation.
    * COOrdinate (COO) format
    * Compressed Sparse Column/Row (CSC/CSR) format
2. Solving the dominant eigenvalue problem.
    * Symmetric Lanczos process
    * Anoldi process
"

# ╔═╡ 49a32422-2415-487e-b3be-28a0436bb552
md"# Sparse Matrices"

# ╔═╡ be9e7da9-a3c9-411e-bf2a-082c10e19bf5
sp = sprand(100, 100, 0.1)

# ╔═╡ 3133cc77-6647-45c5-b693-5eaa1b9528bc
fieldnames(sp |> typeof)

# ╔═╡ 0ea729be-40b2-41ab-991a-c87c8a79fbdf
md"""
## How to multiply a vector efficiently
"""

# ╔═╡ fffdf566-3d54-4cbe-8543-bc88bd669f4c
md"# Large sparse eigenvalue problem"

# ╔═╡ f14621f1-a002-46c5-b0c0-15d008ab382c
md"""
## Dominant eigenvalue problem
"""

# ╔═╡ 3b75625c-2d92-4499-9662-ee1c7a173c30
md"Power method"

# ╔═╡ a51ddacf-7e9f-4ab5-be9b-f2ed4e9952aa
md"The rate of convergence is dedicated by $|\lambda_2/\lambda_1|^k$."

# ╔═╡ 50717c84-e8cf-4e19-b344-7d50b0b290ff
md"## The symmetric Lanczos process"

# ╔═╡ 166d4ddc-5e58-4210-a389-997c1ea82de2
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
	return SymTridiagonal(α, β), hcat(q...)
end

# ╔═╡ 294e1dea-4f2f-4731-9327-b1c04c82d2db
graphsize = 10

# ╔═╡ 3b299d74-e209-4c1e-a831-fce40c4f43f4
lmat = laplacian_matrix(random_regular_graph(graphsize, 3))

# ╔═╡ 1b403168-63b7-4850-8d49-20869d00f71b
tri, Q = lanczos(lmat, randn(graphsize); abstol=1e-8, maxiter=100)

# ╔═╡ e11c71bb-a079-4748-9598-e6c49dfce7a7
eigen(tri).values

# ╔═╡ 95e3a70a-0c2a-4c87-a7c6-963b607c63ad
Q' * Q

# ╔═╡ 05411446-466b-4c6c-bb8a-0caebb516770
let
	n = 100
	graph = random_regular_graph(n, 3)
	A = laplacian_matrix(graph)
	q1 = randn(n)
	tr, Q = lanczos(A, q1; abstol=1e-8, maxiter=100)
	@info eigsolve(A, q1, 2, :SR)
	eigen(tr).values
end

# ╔═╡ e68e3e51-2084-45bf-a8d0-42e4f22d0aea
md"""
## Reorthogonalization
"""

# ╔═╡ 75d297f9-892e-44c4-80a4-1e1beb5d7d9c
md"**The following 4 cells are copied from notebook: 5.linear-least-square.jl**"

# ╔═╡ 191f0c0a-fb45-402e-9fdc-f3427c70bf25
struct HouseholderMatrix{T} <: AbstractArray{T, 2}
	v::Vector{T}
	β::T
end

# ╔═╡ af4d73c4-2f8e-4aaa-aa40-3be0ded47323
# the `mul!` interfaces can take two extra factors.
function left_mul!(B, A::HouseholderMatrix)
	B .-= (A.β .* A.v) * (A.v' * B)
	return B
end

# ╔═╡ 571936d4-3ce6-48e8-be5d-7dbc73e2d3d4
# the `mul!` interfaces can take two extra factors.
function right_mul!(A, B::HouseholderMatrix)
	A .= A .- (A * (B.β .* B.v)) * B.v'
	return A
end

# ╔═╡ 84408a62-5062-41fd-8f49-2ace02d7d685
function householder_matrix(v::AbstractVector{T}) where T
	v = copy(v)
	v[1] -= norm(v, 2)
	return HouseholderMatrix(v, 2/norm(v, 2)^2)
end

# ╔═╡ 5e6a089b-e61b-4945-b8dc-1e069d8f0d92
md"The Lanczos algorithm with complete orthogonalization."

# ╔═╡ 91ab0a42-1a2f-4944-98f5-bda041fa9ff1
function lanczos_reorthogonalize(A, q1::AbstractVector{T}; abstol, maxiter) where T
	n = length(q1)
	# normalize the input vector
	q1 = normalize(q1)
	# the first iteration
	q = [q1]
	Aq1 = A * q1
	α = [q1' * Aq1]
	rk = Aq1 .- α[1] .* q1
	β = [norm(rk)]
	householders = [householder_matrix(q1)]
	for k = 2:min(n, maxiter)
		# reorthogonalize rk: 1. compute the k-th householder matrix
		for j = 1:k-1
			left_mul!(view(rk, j:n), householders[j])
		end
		push!(householders, householder_matrix(view(rk, k:n)))
		# reorthogonalize rk: 2. compute the k-th orthonormal vector in Q
		qk = zeros(T, n); qk[k] = 1  # qₖ = H₁H₂…Hₖeₖ
		for j = k:-1:1
			left_mul!(view(qk, j:n), householders[j])
		end
		push!(q, qk)
		Aqk = A * q[k]
		# compute the diagonal element as αₖ = qₖᵀ A qₖ
		push!(α, q[k]' * Aqk)
		rk = Aqk .- α[k] .* q[k] .- β[k-1] * q[k-1]
		# compute the off-diagonal element as βₖ = |rₖ|
		nrk = norm(rk)
		# break if βₖ is smaller than abstol or the maximum number of iteration is reached
		if abs(nrk) < abstol || k == n
			break
		end
		push!(β, nrk)
	end
	return SymTridiagonal(α, β), hcat(q...)
end

# ╔═╡ 06d4453f-ea4e-4e5f-9aea-72a84cd56e99
let
	n = 1000
	graph = random_regular_graph(n, 3)
	A = laplacian_matrix(graph)
	q1 = randn(n)
	tr, Q = lanczos_reorthogonalize(A, q1; abstol=1e-5, maxiter=100)
	@info eigsolve(A, q1, 2, :SR)
	eigen(tr)
end

# ╔═╡ bb65395e-4d11-439d-9dba-e25c7048df9f
md"""
## Notes on Lanczos
1. In practise, we do not store all $q$ vectors to save space.
2. Blocking technique is required if we want to compute multiple eigenvectors or a degenerate eigenvector.
2. Restarting technique can be used to improve the solution.
"""

# ╔═╡ d6487a34-1c62-4879-a92a-7fcfb7080d85
md"""
## The Arnoldi Process
"""

# ╔═╡ d0776be5-6a56-41c2-981c-e992ec8afdc5
md"If $A$ is not symmetric, then the orthogonal tridiagonalization $Q^T A Q = T$ does not exist in general. The Arnoldi approach involves the column by column generation of an orthogonal $Q$ such athat $Q^TAQ$ is the Hessenberg reduction."

# ╔═╡ 71ebaf5b-5f20-4f73-b530-3ae1aea071f2
function arnoldi_iteration(A::AbstractMatrix{T}, x0::AbstractVector{T}; maxiter) where T
	h = Vector{T}[]
	q = [normalize(x0)]
	n = length(x0)
	@assert size(A) == (n, n)
	for k = 1:min(maxiter, n)
		u = A * q[k]    # generate next vector
		hk = zeros(T, k+1)
		for j = 1:k # subtract from new vector its components in all preceding vectors
			hk[j] = q[j]' * u
			u = u - hk[j] * q[j]
		end
		hkk = norm(u)
		hk[k+1] = hkk
		push!(h, hk)
		if abs(hkk) < 1e-8 || k >=n # stop if matrix is reducible
			break
		else
			push!(q, u ./ hkk)
		end
	end

	# construct `h`
	kmax = length(h)
	H = zeros(T, kmax, kmax)
	for k = 1:length(h)
		if k == kmax
			H[1:k, k] .= h[k][1:k]
		else
			H[1:k+1, k] .= h[k]
		end
	end
	return H, hcat(q...)
end

# ╔═╡ 68e61322-1f14-4098-ab3b-6349aaab669a
let
	A = randn(10, 10)
	h, q = arnoldi_iteration(A, randn(10); maxiter=100)
	@info eigen(A).values
	eigen(h).values
end

# ╔═╡ fd1fb365-0079-4fb0-ba26-9cbf2d9ec676
md"""
## Comments

### Jacobi-Davidson
"""

# ╔═╡ 5beef884-84c3-43ef-8928-1b647b3e1e0f
md"""
1. Blocking technique is required to handle degenerate eigenvalues properly.
2. Restarting can improve the subspace vectors.
"""

# ╔═╡ 16d9fb85-95c5-4c46-8d9b-1403bb15c67c
md"""
# Large sparse linear equation
"""

# ╔═╡ fb385c98-cd94-4d5b-b5cb-c299fbb9b236
md"""
## Generalized minimum residual (GMRES) method
"""

# ╔═╡ b0b1e888-98d9-405c-8b01-a3b4f8cae1dd
md"# Assignment"

# ╔═╡ 1fd7a9d3-1f63-407b-b44c-1bd198351039
md"""

"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Graphs = "86223c79-3864-5bf0-83f7-82e725a168b6"
KrylovKit = "0b1a1467-8014-51b9-945f-bf0ae24f4b77"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[compat]
Graphs = "~1.8.0"
KrylovKit = "~0.6.0"
PlutoUI = "~0.7.50"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "2810da36ff5c96af693608e9e35c2889d5a7d14b"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "cc37d689f599e8df4f464b2fa3870ff7db7492ef"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.6.1"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c6d890a52d2c4d55d326439580c3b8d0875a77d9"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.7"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "61fdd77467a5c3ad071ef8277ac6bd6af7dd4c04"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.6.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "1cd7f0af1aa58abc02ea1d872953a97359cb87fa"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.4"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "1cf1d7dcb4bc32d7b4a5add4232db3750c27ecb4"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.8.0"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.Inflate]]
git-tree-sha1 = "5cd07aab533df5170988219191dfad0519391428"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.KrylovKit]]
deps = ["ChainRulesCore", "GPUArraysCore", "LinearAlgebra", "Printf"]
git-tree-sha1 = "1a5e1d9941c783b0119897d29f2eb665d876ecf3"
uuid = "0b1a1467-8014-51b9-945f-bf0ae24f4b77"
version = "0.6.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "6f4fbcd1ad45905a5dee3f4256fabb49aa2110c6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.7"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "5bb5129fdd62a2bbbe17c2756932259acf467386"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.50"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "2d7d9e1ddadc8407ffd460e24218e37ef52dd9a3"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.16"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╠═4b6307f7-af43-4990-a5c4-5be2b6b11364
# ╟─8d0d3889-14c0-4e2e-b710-8830e2dab827
# ╟─2add4589-251b-47d0-a800-f0db7f204b61
# ╟─4990344c-81e8-48cf-93c0-fa1460e0470b
# ╟─49a32422-2415-487e-b3be-28a0436bb552
# ╠═e548acb6-bf53-11ed-1988-7325c1e2b481
# ╠═455f8887-9b2c-4e67-abe5-5449efe55ce5
# ╠═0c8bf832-0cf8-4b56-b064-1dd177aceae8
# ╠═be9e7da9-a3c9-411e-bf2a-082c10e19bf5
# ╠═3133cc77-6647-45c5-b693-5eaa1b9528bc
# ╟─0ea729be-40b2-41ab-991a-c87c8a79fbdf
# ╟─fffdf566-3d54-4cbe-8543-bc88bd669f4c
# ╟─f14621f1-a002-46c5-b0c0-15d008ab382c
# ╟─3b75625c-2d92-4499-9662-ee1c7a173c30
# ╟─a51ddacf-7e9f-4ab5-be9b-f2ed4e9952aa
# ╟─50717c84-e8cf-4e19-b344-7d50b0b290ff
# ╠═166d4ddc-5e58-4210-a389-997c1ea82de2
# ╠═5b764297-3d06-4899-a8ae-f4378427a6e5
# ╠═294e1dea-4f2f-4731-9327-b1c04c82d2db
# ╠═3b299d74-e209-4c1e-a831-fce40c4f43f4
# ╠═1b403168-63b7-4850-8d49-20869d00f71b
# ╠═e11c71bb-a079-4748-9598-e6c49dfce7a7
# ╠═95e3a70a-0c2a-4c87-a7c6-963b607c63ad
# ╠═05411446-466b-4c6c-bb8a-0caebb516770
# ╟─e68e3e51-2084-45bf-a8d0-42e4f22d0aea
# ╟─75d297f9-892e-44c4-80a4-1e1beb5d7d9c
# ╠═191f0c0a-fb45-402e-9fdc-f3427c70bf25
# ╠═af4d73c4-2f8e-4aaa-aa40-3be0ded47323
# ╠═571936d4-3ce6-48e8-be5d-7dbc73e2d3d4
# ╠═84408a62-5062-41fd-8f49-2ace02d7d685
# ╟─5e6a089b-e61b-4945-b8dc-1e069d8f0d92
# ╠═91ab0a42-1a2f-4944-98f5-bda041fa9ff1
# ╠═06d4453f-ea4e-4e5f-9aea-72a84cd56e99
# ╟─bb65395e-4d11-439d-9dba-e25c7048df9f
# ╟─d6487a34-1c62-4879-a92a-7fcfb7080d85
# ╟─d0776be5-6a56-41c2-981c-e992ec8afdc5
# ╠═71ebaf5b-5f20-4f73-b530-3ae1aea071f2
# ╠═68e61322-1f14-4098-ab3b-6349aaab669a
# ╟─fd1fb365-0079-4fb0-ba26-9cbf2d9ec676
# ╠═5beef884-84c3-43ef-8928-1b647b3e1e0f
# ╟─16d9fb85-95c5-4c46-8d9b-1403bb15c67c
# ╟─fb385c98-cd94-4d5b-b5cb-c299fbb9b236
# ╟─b0b1e888-98d9-405c-8b01-a3b4f8cae1dd
# ╠═1fd7a9d3-1f63-407b-b44c-1bd198351039
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002