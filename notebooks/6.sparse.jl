### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ b335d357-4489-4ea8-bcdb-d6d6c40b32fb
using LinearAlgebra

# ╔═╡ bd863cec-be0d-11ed-1807-1f609b6c2112
function arnoldi_iteration(A::AbstractMatrix{T}, x0::AbstractVector{T}) where T
	h = zero(A)
	q = zero(A)
	q[:,1] .= normalize(x0)
	n = length(x0)
	@assert size(A) == (n, n)
	for k = 1:n
		qk = view(q, :, k)
		u = A * qk    # generate next vector
		for j = 1:k  # subtract from new vector its components in all preceding vectors
			h[j, k] = qk' * u
			u = u - h[j, k] * qk
		end
		hkk = norm(u)
		if abs(hkk) < 1e-8 || k >=n # stop if matrix is reducible
			return q, h
		else
			h[k+1, k] = hkk
			q[:,k+1] .= u ./ hkk
		end
	end
	return q, h
end

# ╔═╡ a21d2e51-8a41-4fac-8642-204c91b89e75
let
	A = randn(10, 10)
	q, h = arnoldi_iteration(A, randn(10))
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "ac1187e548c6ab173ac57d4e72da1620216bce54"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"
"""

# ╔═╡ Cell order:
# ╠═b335d357-4489-4ea8-bcdb-d6d6c40b32fb
# ╠═bd863cec-be0d-11ed-1807-1f609b6c2112
# ╠═a21d2e51-8a41-4fac-8642-204c91b89e75
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
