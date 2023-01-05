### A Pluto.jl notebook ###
# v0.19.16

using Markdown
using InteractiveUtils

# ╔═╡ 57b09830-8b37-11ed-024f-0da7546ee872
md"# Automatic Differentiation"

# ╔═╡ 94702b7b-c6bb-4214-abd1-42fca9281065
md"## Forward mode automatic differentiation"

# ╔═╡ a75103f8-e503-4c55-a89f-c6f7e8032629
md"The Taylor expansion"

# ╔═╡ 29f772c3-4ba5-4fa9-af04-d0e41dbef184
md"Reverse mode automatic differentiation"

# ╔═╡ 2d56b03f-9374-4000-a723-23f0f9a27da1
function matmul!(C::Matrix{<:Real}, A::Matrix{<:Real}, B::Matrix{<:Real})
	@assert size(A, 2) == size(B, 1)
	for i=1:size(A, 1), j=1:size(A, 2), k=1:size(B, 2)
		C[i,k] += A[i, j] * B[j, k]
	end
	return C
end

# ╔═╡ bc8d29ab-c1b9-4bab-98bc-bfc610321bc9
A, B = randn(4, 4), randn(4, 4)

# ╔═╡ 1d1c8be1-0375-4bf4-8a91-72d3265d092b
matmul!(zeros(4, 4), A, B) ≈ A * B

# ╔═╡ 15193873-ab3d-4bc1-8e26-d4524cf14466
function backward_matmul!(C::Matrix{<:Real}, C̄::Matrix{<:Real}, A::Matrix{<:Real}, Ā::Matrix{<:Real}, B::Matrix{<:Real}, B̄::Matrix{<:Real})
	@assert size(A, 2) == size(B, 1)
	for i=size(A, 1):-1:1, j=1:size(A, 2):-1:1, k=1:size(B, 2):-1:1
		# C[i,k] += A[i, j] * B[j, k]
		Ā[i, j] += C̄[i, k] * B[j, k]
	end
	return C
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.4"
manifest_format = "2.0"
project_hash = "da39a3ee5e6b4b0d3255bfef95601890afd80709"

[deps]
"""

# ╔═╡ Cell order:
# ╟─57b09830-8b37-11ed-024f-0da7546ee872
# ╟─94702b7b-c6bb-4214-abd1-42fca9281065
# ╟─a75103f8-e503-4c55-a89f-c6f7e8032629
# ╟─29f772c3-4ba5-4fa9-af04-d0e41dbef184
# ╠═2d56b03f-9374-4000-a723-23f0f9a27da1
# ╠═bc8d29ab-c1b9-4bab-98bc-bfc610321bc9
# ╠═1d1c8be1-0375-4bf4-8a91-72d3265d092b
# ╠═15193873-ab3d-4bc1-8e26-d4524cf14466
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
