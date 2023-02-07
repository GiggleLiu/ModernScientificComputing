### A Pluto.jl notebook ###
# v0.19.19

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ d0ce80b6-5a9c-4fb1-9bf0-b6046a756335
begin
	using Pkg
	if !isdefined(@__MODULE__, :PlutoLecturing)
		Pkg.develop(path="https://github.com/GiggleLiu/PlutoLecturing.jl.git")
	end
	using PlutoLecturing
	TableOfContents(aside=true)
end

# ╔═╡ cfb94985-f1f9-4829-bd75-1e661e837f24
using Plots

# ╔═╡ 372c0fc6-8867-4dd0-a159-b3029f9087e8
using Primes

# ╔═╡ 0ff806be-1af8-4240-acd7-96d75d84ee83
using StaticArrays

# ╔═╡ 3707e877-a2e1-4b12-ac8c-926669f223dc
include("mods.jl")

# ╔═╡ f3bcbd98-94de-11ed-2a30-4b3760dd28a5
md"# Number system"

# ╔═╡ b6944552-94ca-47ce-b309-e1b0e6404bda
md"## Integers"

# ╔═╡ f4bb01e4-93e5-40fc-8e10-b9b2974e1006
md"Integer type range is"

# ╔═╡ 7a2aee19-9f19-40c0-aa0b-21c74e80f4d5
typemin(Int64)

# ╔═╡ ea89aaa9-4694-465b-bad6-d33dfc3fe184
bitstring(typemin(Int64))

# ╔═╡ 2d2d3ab7-91ae-440f-b912-eb33dc79bb9b
bitstring(typemin(Int64) + 1)

# ╔═╡ 09f2eaaa-0907-4b41-9c14-c4ff809b1918
bitstring(0)

# ╔═╡ 4b1db5d4-7839-45cb-8835-45b1d6ed5f51
md" $(@bind show_minus1 CheckBox()) Show the bitstring for -1 (binded to `show_minus1`)"

# ╔═╡ 171abcd7-29c2-412f-8bd7-d11fdf8a68c1
show_minus1 && bitstring(-1)

# ╔═╡ 66033524-ec1f-4c90-86b9-942283fc9ed7
typemax(Int64)

# ╔═╡ 407b0ea5-f712-4780-bdf0-b833a6247098
bitstring(typemax(Int64))

# ╔═╡ 106dfaeb-7501-49d5-b861-882fbb514306
# the following expression can not 
9223372036854775807 - (-9223372036854775808) + 1

# ╔═╡ 21694b6e-6d93-4348-a79c-b52e1ada03d3
md"Use arbitrary precision integers to show the data range."

# ╔═╡ c96e3f63-7403-4502-8159-b2436e8cc5b3
BigInt(9223372036854775807) - BigInt(-9223372036854775808) + 1

# ╔═╡ 2ec98a85-3ac8-4143-bfde-c335189b91d2
BigInt(2)^64

# ╔═╡ 75422c2a-47df-4114-92df-2045ff1d8a5a
md"""
## Fixed point numbers and logarithmic numbers
"""

# ╔═╡ 5d82bd79-1dbc-4ee6-90c2-555918b3b7cd
md"## Floating point numbers"

# ╔═╡ 783ca284-7544-47d3-be61-a68b47a44077
LocalResource("float-format.png")

# ╔═╡ f69000ea-5389-4167-9432-5cc2e0af0f01
md"image source: https://en.wikipedia.org/wiki/IEEE_754"

# ╔═╡ 682dbbd8-e75d-4ea1-91a4-7ba7a73c9794
bitstring(0.15625f0)

# ╔═╡ 7ab18508-ea23-43ff-a54f-41512cffdf05
exponent(0.15625f0)

# ╔═╡ 5abd51f6-3395-468d-aeb3-50ffe92175c9
md"The significant is in range [1, 2)"

# ╔═╡ 36179a93-0d26-45e9-ae16-32b0e3241f83
significand(0.15625f0)

# ╔═╡ 80770e27-2852-4f48-ac9c-aeba5174294f
@xbind generate_random_float Button("Generate!")

# ╔═╡ a20a3534-dd33-4979-903b-0692491b1578
random_float = let
	generate_random_float
	randn(Float32)
end

# ╔═╡ ce2304d9-95ae-4f5e-89cf-418f6970cd81
exponent(random_float)

# ╔═╡ 01913482-6732-496f-ba36-11a3fcd1700d
significand(random_float)

# ╔═╡ ca83a2cd-65ab-4b83-a0ad-7b9d42d63373
let
	s = bitstring(random_float)
	Markdown.parse("""
```
   $(s[1])  -  $(s[2:9])  -  $(s[10:end])

(sign)  (exponent)          (mantissa)
```
""")
end

# ╔═╡ 78c09e28-1660-4255-8aa4-ef9e04da5d48
md"Floating point numbers is a poor approximation to field, but having balanced absolute error and relative error."

# ╔═╡ 02003ba0-b490-4be0-853c-8d5e17349cca
md"The distribution of floating point numbers"

# ╔═╡ b0ee0182-d729-4d1e-8d58-2e198b437f6c
@xbind npoints Slider(1:10000; default=1000, show_value=true)

# ╔═╡ 1fea164a-7bb8-4a08-bda1-c067c4f97e80
xs = filter(!isnan, reinterpret(Float64, rand(Int64, npoints)));

# ╔═╡ 0500cfb2-6209-4a48-823c-621bcdff0306
md"From the linear scale plot, you will see data concentrated around 0
(each vertical bar is a sample)"

# ╔═╡ 996f1902-22b7-4902-b5e4-e698eaad4cb2
scatter(xs, zeros(length(xs)), xlim=(-1e300, 1e300), label="", size=(600, 100), yaxis=:off, markersize=30, markershape=:vline)

# ╔═╡ 982a2888-ae28-4114-98a4-6585dec65f0c
md"If we use logarithmic x-axis"

# ╔═╡ 185ee1f1-98e4-4e89-80b2-1d810df8cf75
@xbind smearing_factor Slider(0.1:0.1:5.0; show_value=true, default=0.5)

# ╔═╡ deaf96c2-6cb2-4c07-937f-b7d15633eb95
let
	logxs = sign.(xs) .* log10.(abs.(xs))
	ax = scatter(logxs, zeros(length(xs)), xlim=(-300, 300), label="", size=(600, 100), yaxis=:off, markersize=30, markershape=:vline)
	a = -300:300
	m = 1/π/smearing_factor ./ (((a' .- logxs) ./ smearing_factor) .^ 2 .+ 1)
	plot!(ax, a, dropdims(sum(m, dims=1), dims=1); label="probability")
end

# ╔═╡ b3510c08-a39d-45a6-824b-1853a1b1df4d
bitstring(Inf)

# ╔═╡ 0b29449a-37ac-42b2-a6c9-38c7743e5a7d
bitstring(-Inf)

# ╔═╡ 342ea0f9-77d7-47d9-94d8-f1762ba7cae4
bitstring(NaN)

# ╔═╡ 0df63330-78af-4a60-a355-c6da15cacf8e
Inf isa Float64

# ╔═╡ 4b75fbf4-e7ec-4579-8acd-bcebce58d0aa
NaN isa Float64

# ╔═╡ 90c46bcd-fff0-4a4f-a00d-0db7058fa21a
Inf ^ -1

# ╔═╡ 0ba0b49b-b8fa-417b-a5cf-3d629d26cc8f
NaN ^ (-1)

# ╔═╡ c45109f1-06aa-490a-84f6-0904c192bbb7
Inf-Inf

# ╔═╡ 603fc7fc-65b4-46c9-821f-14b74422f278
0 * NaN

# ╔═╡ c87d26c2-0fd4-4abf-8161-7c68c269ea53
md"## Roundoff error of floating point numbers"

# ╔═╡ 79643734-c48c-47aa-a9f6-dc1ff010e843
md"""Both real numbers and complex numbers are fields. Here we need to use finite data length to represent real numbers. As a result, we have errors when representing a real number, or the rounding error.
"""

# ╔═╡ 761dc0c7-7cf2-4def-a404-bd1393df15b9
md"""
Suppose $x \in \mathbb{R}^n$ is an approximation to $x \in \mathbb{R}^n$. For a given vector norm $\|\cdot\|$ we say that"""

# ╔═╡ fd3b72c7-5c9a-40d6-af90-8d03ef35a987
md"""$\epsilon_{\rm abs} = \|\hat x-x\|$ is the absolute error in $\hat x$."""

# ╔═╡ ffcfb21c-5a25-4202-b4da-af427529f0cd
md"""$\epsilon_{\rm rel} = \frac{\|\hat x-x\|}{\|x\|}$ is the relative error in $\hat x$."""

# ╔═╡ a9d59e61-aa38-489c-aff5-24e5d59e3888
typemax(Float64)

# ╔═╡ c70667c3-f069-45ab-981c-c4f1af3c45e8
prevfloat(Inf)

# ╔═╡ dbbb3372-0e9a-4ac1-933c-5fb33a130818
md"The roundoff error of a floating point number is defined as the gap between itself and the subsequent number."

# ╔═╡ b58ff831-5e07-441d-884a-c0b3c52b4dea
nextfloat(5.0) - 5.0

# ╔═╡ 93f2c90f-d8ab-4f3e-a131-f3d6c79d0192
eps(5.0)

# ╔═╡ 077465f1-4d11-417c-b93e-b5413e377982
md"The precision of floating point number is defined as the roundoff error at 1.0"

# ╔═╡ a1babd2a-4105-423a-8921-8fd575c3c527
eps(1.0)

# ╔═╡ 740b0a54-0dd4-4a44-8e3b-0fe2dbd966c5
eps(Float64)

# ╔═╡ d8b3e865-49e5-4b8f-a04e-df5e024499a0
eps(100.0)

# ╔═╡ e642ccaa-83ad-41fb-a34d-75b508256352
eps(10000.0)

# ╔═╡ e9d9eb17-a384-4dbe-a100-81ab2c02c529
md"""
```math
{\rm fl}(x) = x ( 1+ \delta),~~~~~~ |\delta| \leq \mathbf{u}
```
"""

# ╔═╡ dd9e9f2b-372b-4083-a85f-b6ed478b0e47
md"""where $\mathbf{u}$ is the unit roundoff defined by
```math
\mathbf{u} = \frac 1 2 \times {\rm eps}(1.0).
```
"""

# ╔═╡ 47470524-f50e-46df-9555-81bab95d39cc
md"the fundamental axiom offloating point arithmetic (Trefethen and Bau (NLA))"

# ╔═╡ 2dd9f7c5-9fa5-4ebb-893e-6340655e2cbc
md"""
```math
\texttt{fl}(x \texttt{ op } y) = (x \texttt{ op } y) ( 1+ \delta),~~~~~~ |\delta| \leq \mathbf{u}
```
"""

# ╔═╡ 95088b4c-8d01-496b-a013-4b8ef84e4bff
md"""where $\texttt{op}$ is one of $\{+, -, \times, /\}$"""

# ╔═╡ 956b67c6-683e-450f-9d83-e5c19d98401d
md"Floating point number is not associative"

# ╔═╡ e55c091e-3db4-486d-90a8-3a8a1dec1a79
md"""
```math
x = 1.24 \times 10^0 ,~~~~ y = -1.23\times 10^0,~~~~ z = 1.00 \times 10^{-3}
```
"""

# ╔═╡ a9d4e2f8-d434-4a52-8d44-5a390f88eef8
md"""
```math
\texttt{fl}(\texttt{fl}(x+y)+z) = 1.10 \times 10^{-2}
```
while
```math
\texttt{fl}(x+\texttt{fl}(y+z)) = 1.00 \times 10^{-2}
```
"""

# ╔═╡ d5ceb65c-df38-41ed-b089-a47ccac6ea88
md"## Complex numbers"

# ╔═╡ b99d14e0-4d3b-4513-a890-b8d32fc4fcbb
md"## Tropical numbers"

# ╔═╡ 8d5ad8f3-98bc-4fd4-8bac-ca47736ed1f4
md"## Dual numbers"

# ╔═╡ 7d4899f3-392f-4300-8b36-16ea8e5a3343
md"""
```math
f(a + b\epsilon) = f(a) + f'(a)b\epsilon
```
"""

# ╔═╡ e2c3be56-b452-4281-a143-8cad18ff8a02
md"""## Conclusion
Floating point numbers is only an approximation to field, it has the .
"""

# ╔═╡ de1e262b-d234-4a26-925f-86100cdad9d9
md"## Arbitrary precision numbers"

# ╔═╡ 34bf9bcc-e9cc-474b-9e08-74f6086da295
fib(n::Int) = n < 2 ? 1 : fib(n-1) + fib(n-2)

# ╔═╡ 2646c513-bda7-4114-b7d8-443943a447a5
md"oops, too slow!"

# ╔═╡ 56aef1eb-2f2b-4cfd-a9cd-b0752eedaa08
fib(40)

# ╔═╡ 5e39d894-d57a-4450-97ef-ed2b352f4d53
fib_matrix = [0 1; 1 1]

# ╔═╡ 2c51514d-2d24-4f41-a597-344356032976
function fib_fast(n::Integer)
	return ([0 1; 1 1] ^ (n-1) * [1, 1])[2]
end

# ╔═╡ 92192db0-06e6-408a-9aca-fdc5fe166f55
fib_fast(40)

# ╔═╡ 3d226a74-abe6-47d7-8283-62c9a2cabac1
fib_fast(1000)

# ╔═╡ 66456b4e-0704-4acd-9589-21dfb4a91240
fib_fast(BigInt(1000))

# ╔═╡ 0511a857-2a7e-4631-8b0e-03a8ec72834c
md"## Finite field algebra"

# ╔═╡ 93088b7b-724a-4b2d-b539-156acd6879c9
function gg(p::Ti, n::Int) where {Ti}
	((Mod{Ti}.(Ti[0 1; 1 1], p)) ^ n)[1]
end

# ╔═╡ 25537401-cd0f-46e5-831d-aaa5359668de
CRT(BigInt, [2, 3], [7, 5])

# ╔═╡ 5343fa93-21c9-4817-8b4c-158829e54616
CRT_improve(BigInt(2), BigInt(7), 3, 5)

# ╔═╡ 4cf84585-97b3-4446-9587-5ebeaa0d50dd
big_integer_solve(Int64, 10^5) do p
	((Mod{Int64}.(Int64[0 1; 1 1], p)) ^ (10^5))[4]
end

# ╔═╡ ff70cdfa-65d0-45a4-b0d5-77fd52e6c707
fib_fast(BigInt(100000))

# ╔═╡ 03b655c9-5bfe-4741-b96a-c091bde54b43
md"## Tip: go faster with `StaticArrays`"

# ╔═╡ 3f665091-9ac1-48a4-82e8-2d981c15ed71
function fib_superfast(n::Int)
	return (SMatrix{2,2}(0, 1, 1, 1) ^ (n-1) * SVector{2}(1, 1))[2]
end

# ╔═╡ 1ab04b23-abb4-4986-9b3c-71e4a4fa0fc6
fib_superfast(40)

# ╔═╡ Cell order:
# ╠═d0ce80b6-5a9c-4fb1-9bf0-b6046a756335
# ╟─f3bcbd98-94de-11ed-2a30-4b3760dd28a5
# ╟─b6944552-94ca-47ce-b309-e1b0e6404bda
# ╟─f4bb01e4-93e5-40fc-8e10-b9b2974e1006
# ╠═7a2aee19-9f19-40c0-aa0b-21c74e80f4d5
# ╠═ea89aaa9-4694-465b-bad6-d33dfc3fe184
# ╠═2d2d3ab7-91ae-440f-b912-eb33dc79bb9b
# ╠═09f2eaaa-0907-4b41-9c14-c4ff809b1918
# ╟─4b1db5d4-7839-45cb-8835-45b1d6ed5f51
# ╠═171abcd7-29c2-412f-8bd7-d11fdf8a68c1
# ╠═66033524-ec1f-4c90-86b9-942283fc9ed7
# ╠═407b0ea5-f712-4780-bdf0-b833a6247098
# ╠═106dfaeb-7501-49d5-b861-882fbb514306
# ╟─21694b6e-6d93-4348-a79c-b52e1ada03d3
# ╠═c96e3f63-7403-4502-8159-b2436e8cc5b3
# ╠═2ec98a85-3ac8-4143-bfde-c335189b91d2
# ╟─75422c2a-47df-4114-92df-2045ff1d8a5a
# ╟─5d82bd79-1dbc-4ee6-90c2-555918b3b7cd
# ╟─783ca284-7544-47d3-be61-a68b47a44077
# ╟─f69000ea-5389-4167-9432-5cc2e0af0f01
# ╠═682dbbd8-e75d-4ea1-91a4-7ba7a73c9794
# ╠═7ab18508-ea23-43ff-a54f-41512cffdf05
# ╟─5abd51f6-3395-468d-aeb3-50ffe92175c9
# ╠═36179a93-0d26-45e9-ae16-32b0e3241f83
# ╟─80770e27-2852-4f48-ac9c-aeba5174294f
# ╠═a20a3534-dd33-4979-903b-0692491b1578
# ╠═ce2304d9-95ae-4f5e-89cf-418f6970cd81
# ╠═01913482-6732-496f-ba36-11a3fcd1700d
# ╟─ca83a2cd-65ab-4b83-a0ad-7b9d42d63373
# ╟─78c09e28-1660-4255-8aa4-ef9e04da5d48
# ╠═cfb94985-f1f9-4829-bd75-1e661e837f24
# ╟─02003ba0-b490-4be0-853c-8d5e17349cca
# ╟─b0ee0182-d729-4d1e-8d58-2e198b437f6c
# ╠═1fea164a-7bb8-4a08-bda1-c067c4f97e80
# ╟─0500cfb2-6209-4a48-823c-621bcdff0306
# ╟─996f1902-22b7-4902-b5e4-e698eaad4cb2
# ╟─982a2888-ae28-4114-98a4-6585dec65f0c
# ╟─185ee1f1-98e4-4e89-80b2-1d810df8cf75
# ╟─deaf96c2-6cb2-4c07-937f-b7d15633eb95
# ╠═b3510c08-a39d-45a6-824b-1853a1b1df4d
# ╠═0b29449a-37ac-42b2-a6c9-38c7743e5a7d
# ╠═342ea0f9-77d7-47d9-94d8-f1762ba7cae4
# ╠═0df63330-78af-4a60-a355-c6da15cacf8e
# ╠═4b75fbf4-e7ec-4579-8acd-bcebce58d0aa
# ╠═90c46bcd-fff0-4a4f-a00d-0db7058fa21a
# ╠═0ba0b49b-b8fa-417b-a5cf-3d629d26cc8f
# ╠═c45109f1-06aa-490a-84f6-0904c192bbb7
# ╠═603fc7fc-65b4-46c9-821f-14b74422f278
# ╟─c87d26c2-0fd4-4abf-8161-7c68c269ea53
# ╟─79643734-c48c-47aa-a9f6-dc1ff010e843
# ╟─761dc0c7-7cf2-4def-a404-bd1393df15b9
# ╟─fd3b72c7-5c9a-40d6-af90-8d03ef35a987
# ╟─ffcfb21c-5a25-4202-b4da-af427529f0cd
# ╠═a9d59e61-aa38-489c-aff5-24e5d59e3888
# ╠═c70667c3-f069-45ab-981c-c4f1af3c45e8
# ╟─dbbb3372-0e9a-4ac1-933c-5fb33a130818
# ╠═b58ff831-5e07-441d-884a-c0b3c52b4dea
# ╠═93f2c90f-d8ab-4f3e-a131-f3d6c79d0192
# ╟─077465f1-4d11-417c-b93e-b5413e377982
# ╠═a1babd2a-4105-423a-8921-8fd575c3c527
# ╠═740b0a54-0dd4-4a44-8e3b-0fe2dbd966c5
# ╠═d8b3e865-49e5-4b8f-a04e-df5e024499a0
# ╠═e642ccaa-83ad-41fb-a34d-75b508256352
# ╟─e9d9eb17-a384-4dbe-a100-81ab2c02c529
# ╟─dd9e9f2b-372b-4083-a85f-b6ed478b0e47
# ╟─47470524-f50e-46df-9555-81bab95d39cc
# ╟─2dd9f7c5-9fa5-4ebb-893e-6340655e2cbc
# ╟─95088b4c-8d01-496b-a013-4b8ef84e4bff
# ╟─956b67c6-683e-450f-9d83-e5c19d98401d
# ╟─e55c091e-3db4-486d-90a8-3a8a1dec1a79
# ╟─a9d4e2f8-d434-4a52-8d44-5a390f88eef8
# ╟─d5ceb65c-df38-41ed-b089-a47ccac6ea88
# ╟─b99d14e0-4d3b-4513-a890-b8d32fc4fcbb
# ╟─8d5ad8f3-98bc-4fd4-8bac-ca47736ed1f4
# ╟─7d4899f3-392f-4300-8b36-16ea8e5a3343
# ╟─e2c3be56-b452-4281-a143-8cad18ff8a02
# ╟─de1e262b-d234-4a26-925f-86100cdad9d9
# ╠═34bf9bcc-e9cc-474b-9e08-74f6086da295
# ╟─2646c513-bda7-4114-b7d8-443943a447a5
# ╠═56aef1eb-2f2b-4cfd-a9cd-b0752eedaa08
# ╠═5e39d894-d57a-4450-97ef-ed2b352f4d53
# ╠═2c51514d-2d24-4f41-a597-344356032976
# ╠═92192db0-06e6-408a-9aca-fdc5fe166f55
# ╠═3d226a74-abe6-47d7-8283-62c9a2cabac1
# ╠═66456b4e-0704-4acd-9589-21dfb4a91240
# ╟─0511a857-2a7e-4631-8b0e-03a8ec72834c
# ╠═372c0fc6-8867-4dd0-a159-b3029f9087e8
# ╠═3707e877-a2e1-4b12-ac8c-926669f223dc
# ╠═93088b7b-724a-4b2d-b539-156acd6879c9
# ╠═25537401-cd0f-46e5-831d-aaa5359668de
# ╠═5343fa93-21c9-4817-8b4c-158829e54616
# ╠═4cf84585-97b3-4446-9587-5ebeaa0d50dd
# ╠═ff70cdfa-65d0-45a4-b0d5-77fd52e6c707
# ╟─03b655c9-5bfe-4741-b96a-c091bde54b43
# ╠═0ff806be-1af8-4240-acd7-96d75d84ee83
# ╠═3f665091-9ac1-48a4-82e8-2d981c15ed71
# ╠═1ab04b23-abb4-4986-9b3c-71e4a4fa0fc6
