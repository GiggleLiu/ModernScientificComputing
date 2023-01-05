### A Pluto.jl notebook ###
# v0.19.16

using Markdown
using InteractiveUtils

# ╔═╡ 1e34812e-8b31-11ed-13f3-655553806360
using LinearAlgebra

# ╔═╡ b41bcad5-a03c-4d35-8481-84dfc4f6f61b
using SparseArrays

# ╔═╡ 7aeaf1b2-2ce0-4bfd-9c93-b9aa7f58768c
md"""
# Sparsity in data
"""

# ╔═╡ ccf31e50-cd38-446a-abb6-cb926ab161e5
md"""
## Special Matrices
"""

# ╔═╡ c421bff1-90d6-449a-9acd-1f3176b85c35
md"A linear operator ``A`` is unitary if ``A^\dagger A = I.``"

# ╔═╡ 8d30b828-38a2-4412-938e-df0aa51b684a
md"""
## Singular value decomposition
"""

# ╔═╡ e4cec181-82d3-498c-b927-dc72bdd8320c


# ╔═╡ 8a5ff352-2244-4e93-9bf8-6ce7b4282717


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.4"
manifest_format = "2.0"
project_hash = "6865b0a5e609d4d4358ebe0134f60aa2e67c548e"

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

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"
"""

# ╔═╡ Cell order:
# ╟─7aeaf1b2-2ce0-4bfd-9c93-b9aa7f58768c
# ╟─ccf31e50-cd38-446a-abb6-cb926ab161e5
# ╟─c421bff1-90d6-449a-9acd-1f3176b85c35
# ╠═1e34812e-8b31-11ed-13f3-655553806360
# ╟─8d30b828-38a2-4412-938e-df0aa51b684a
# ╠═e4cec181-82d3-498c-b927-dc72bdd8320c
# ╠═b41bcad5-a03c-4d35-8481-84dfc4f6f61b
# ╠═8a5ff352-2244-4e93-9bf8-6ce7b4282717
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
