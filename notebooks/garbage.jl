### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ e22644db-e459-4f5d-a865-c98b78407359
using LinearAlgebra

# ╔═╡ 25017c0c-d37e-4a19-be9c-3090ab07df8e
md"## Moved From Lecture 5"

# ╔═╡ 458fd57c-bb42-11ed-107b-97a351332fba
function qr_tridiag!(T::AbstractMatrix)
	n = size(T, 2)
	for k = 1:n-1
		m = min(k+2, n)
		g = givens(view(T, :, k:m), k, k+1)
		left_mul!(view(T, :, k:m), g)
	end
	return T
end;

# ╔═╡ c67dfe5c-66f2-4d94-9d0e-f84ed214a010
let
	n = 5
	T = Matrix(Tridiagonal(randn(n, n)))
	qr_tridiag!(T)
end;

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
# ╠═e22644db-e459-4f5d-a865-c98b78407359
# ╟─25017c0c-d37e-4a19-be9c-3090ab07df8e
# ╠═458fd57c-bb42-11ed-107b-97a351332fba
# ╠═c67dfe5c-66f2-4d94-9d0e-f84ed214a010
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
