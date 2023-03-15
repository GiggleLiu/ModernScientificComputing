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

# ╔═╡ 84c14a09-2c9e-4919-bfb1-cdf4d5a61776
# ╠═╡ show_logs = false
begin
	using AbstractTrees, PlutoUI, Reexport
	include("../lib/PlutoLecturing/src/PlutoLecturing.jl")
	using .PlutoLecturing
	presentmode()
	TableOfContents(aside=true)
end

# ╔═╡ a88e6865-235b-428a-9546-5da2daa3e03c
using Plots

# ╔═╡ b8d442b2-8b3d-11ed-2ac7-1f0fbfa7836d
using BenchmarkTools

# ╔═╡ cf591ae5-3b55-47c5-b7a2-6c8aefa72b7a
using LinearAlgebra: mul!

# ╔═╡ 8776764c-4483-476b-bfff-a3e779431a68
using Random

# ╔═╡ 292dc84c-b2ed-4a35-b817-be6266b40ff1
using Profile

# ╔═╡ 5c5f6214-61c5-4532-ac05-85a43e5639cc
md"""
# About this course (10min)
## What is scientific computing?
"""

# ╔═╡ 0fe286ff-1359-4eb4-ab6c-28b231f9d56e
PlutoLecturing.leftright(PlutoLecturing.netimage("https://upload.wikimedia.org/wikipedia/commons/c/ce/Genegolub.jpg"), md"""
Scientific computing is the collection of tools, techniques and theories required to solve $(PlutoLecturing.highlight("on a computer")) the $(PlutoLecturing.highlight("mathematical models")) of problems in $(PlutoLecturing.highlight("science and engineering")).

-- Gene H. Golub and James M. Ortega
"""; left=0.3)

# ╔═╡ c51b55d2-c899-421f-a633-1daa4168c6d5
md"## Textbook"

# ╔═╡ d59dce7b-5fed-45ba-9f9f-f4b93cf4b89f
PlutoLecturing.leftright(md"""
$(PlutoLecturing.localimage("images/textbook.jpg"))
""", md"""
#### Chapters
1. Scientific Computing
2. Systems of linear equations
3. Linear least squares
4. Eigenvalue problems
5. Nonlinear equations
6. Optimization
7. Interpolation
8. $(PlutoLecturing.del("Numerical integration and differentiation"))
9. $(PlutoLecturing.del("Initial value problems for ordinary differential equations"))
10. $(PlutoLecturing.del("Boundary value problems for ordinary differential equations"))
11. $(PlutoLecturing.del("Partial differential equations"))
12. Fast fourier transform
13. Random numbers and stochastic simulation
"""; width=660, left=0.4)

# ╔═╡ f36e7b45-193e-4028-aae5-352711b8406d
md"# Lecture 1: Understanding our computing devices"

# ╔═╡ 72924c3a-0bbe-4d74-b2a9-60b250db4ec2
PlutoLecturing.blackboard("What is inside a computer?  <br>(40min)")

# ╔═╡ 163016e4-9133-4c61-a7ac-82e41e6db234
md"## Get hardware information (Linux)"

# ╔═╡ a3d7aa29-1099-48c5-94d8-b6148fa1e0fd
PlutoLecturing.blackboard("Get hardware information"; coding=true, subtitle="&#36; lscpu <br>&#36; lsmem <br>&#36; top")

# ╔═╡ f5ad618c-0a00-475f-b05d-97deba0faaef
@xbind show_cpuinfo CheckBox()

# ╔═╡ d5c2f523-80dd-40df-bf11-dd58cd493606
if show_cpuinfo run(`lscpu`) end

# ╔═╡ d6dca51b-978e-456e-b7c0-b658d894101d
@xbind show_meminfo CheckBox()

# ╔═╡ c0aa6f21-47d5-4f03-8b9b-a8df5c18a1b8
if show_meminfo run(`lsmem`) end

# ╔═╡ 2c92ab20-c105-4623-83c2-239462d59707
@xbind show_processinfo CheckBox()

# ╔═╡ 96c87a95-ca76-4cf5-8920-8d1f014ba47b
if show_processinfo run(`top -n 1 -b`) end

# ╔═╡ c0db86ae-d6b3-49b4-bde1-d6c2585090e8
md"# Number system (20min)"

# ╔═╡ c80e2cc0-8cd9-438c-a2c5-7a5b0dc9aa7a
md"## Integers"

# ╔═╡ 17f877cd-3958-4b49-a0cc-fb0529800223
md"Integer type range is"

# ╔═╡ 5a5fd311-4c9f-4fa0-8f5a-d3f5acba3106
typemin(Int64)

# ╔═╡ 24684e2a-e99e-43f3-ba66-881634e4ba1b
bitstring(typemin(Int64))

# ╔═╡ 79565487-c1fb-47d7-b50d-a0a39a8849d9
bitstring(typemin(Int64) + 1)

# ╔═╡ baeefdd1-09ef-4b5d-8cf4-c4eeb98d3335
bitstring(0)

# ╔═╡ 4cf1e164-c510-47da-a138-f4582bfa0270
md" $(@bind show_minus1 CheckBox()) Show the bitstring for -1 (binded to `show_minus1`)"

# ╔═╡ 07b3e56b-78fd-4894-b310-096281009764
if show_minus1 bitstring(-1) end

# ╔═╡ cc2e0ab8-83cc-44fe-9782-eabee896bcc0
typemax(Int64)

# ╔═╡ e51adfeb-3868-43c2-8f64-21bd1a4e8522
bitstring(typemax(Int64))

# ╔═╡ 9186b86b-88b1-4165-94ac-b738882a2c23
md"## Floating point numbers"

# ╔═╡ 31d784e6-22b5-430a-a571-6aad7aaefee1
LocalResource("images/float-format.png")

# ╔═╡ 5a10796f-c084-451e-89f5-75ba8364f2d8
md"image source: https://en.wikipedia.org/wiki/IEEE_754"

# ╔═╡ 8eff13e4-1d93-4add-b516-46307fca965a
bitstring(0.15625f0)

# ╔═╡ c3db170e-20f0-4488-98b0-7a65090728a1
exponent(0.15625f0)

# ╔═╡ 2fd28ddf-b74c-485b-a5d4-dabb1bfdc6c7
md"The significant is in range [1, 2)"

# ╔═╡ 27212a7a-fdd0-423d-a008-83c6f6e257c6
significand(0.15625f0)  # the fraction

# ╔═╡ e5c3c192-e398-4bb1-9933-6c6070b10756
typemax(Float64)

# ╔═╡ c761fcf3-7386-437a-b37c-af256e189a10
bitstring(Inf)

# ╔═╡ 9f58f7f1-ab35-499b-aefe-6bdecd137e1d
prevfloat(Inf)

# ╔═╡ 5f27ff9c-2d86-4d8c-9d95-025e72e56c95
typemin(Float64)

# ╔═╡ 21bfac50-1d7d-4737-bf1e-aef799353734
bitstring(-Inf)

# ╔═╡ 129207a7-b88a-47bd-a853-e5db71ed65c5
prevfloat(0.0)

# ╔═╡ d49a05c0-e60d-471d-ba19-e5e9708fa4f7
nextfloat(0.0)

# ╔═╡ 7275c2ec-996a-4335-ac8b-9b94719a765f
Inf-Inf

# ╔═╡ 1eab94a9-c00d-4d12-95fb-08f26d05b4d4
0 * NaN

# ╔═╡ ccc49ad6-e8c2-479c-8341-fc16877b50cf
bitstring(NaN)

# ╔═╡ 1d75ba45-2b66-47b2-a528-0e30e982c5e7
md"## The distribution of floating point numbers"

# ╔═╡ 1baa4439-9325-4e7f-bdd5-53410a200d41
md"The distribution of floating point numbers"

# ╔═╡ 9513bd15-5789-4a56-961b-175f8dabfdaf
@xbind npoints Slider(1:10000; default=1000, show_value=true)

# ╔═╡ 38e23738-f7fb-4b9e-9067-200d42f6a1e4
xs = filter(!isnan, reinterpret(Float64, rand(Int64, npoints)));

# ╔═╡ 8fd31129-f150-4114-afa5-8106dba8009f
md"From the linear scale plot, you will see data concentrated around 0
(each vertical bar is a sample)"

# ╔═╡ e59b8bb2-95df-492e-bd15-24a1de2573f5
scatter(xs, zeros(length(xs)), xlim=(-1e300, 1e300), label="", size=(600, 100), yaxis=:off, markersize=30, markershape=:vline)

# ╔═╡ c64ed02d-0c62-4cab-9bcf-35dfbfedddc6
md"If we use logarithmic x-axis"

# ╔═╡ c13955ef-4986-4d56-8e1e-48c6becd213a
@xbind smearing_factor Slider(0.1:0.1:5.0; show_value=true, default=1.0)

# ╔═╡ be7247b8-ac5d-4b3a-ba3b-e8da37ef1e08
let
	logxs = sign.(xs) .* log10.(abs.(xs))
	ax = scatter(logxs, zeros(length(xs)), xlim=(-300, 300), label="", size=(600, 100), yaxis=:off, markersize=30, markershape=:vline)
	a = -300:300
	# smoothen the distribution with Lorentz function
	m = 1/π/smearing_factor ./ (((a' .- logxs) ./ smearing_factor) .^ 2 .+ 1)
	plot!(ax, a, dropdims(sum(m, dims=1), dims=1); label="probability")
end

# ╔═╡ 16dc1e93-9f16-4299-9e8e-59dff16b6fd9
md"# Estimating the computing power of your devices (20min)"

# ╔═╡ 5c13904a-505b-4fec-9e32-0ffa54a9dad8
md"""## Example 1: Matrix multiplication
```math
C_{ik} = \sum_j A_{ij} \times B_{jk}
```
"""

# ╔═╡ 13dabaa8-7310-4557-ad06-e64f566ca256
md"""
Let the matrix size be `n x n`, the peudocode for general matrix multiply (GEMM) is
```
for i=1:n
	for j=1:n
		for k=1:n
			C[i, k] = A[i, j] * B[j, k]
		end
	end
end
```
"""

# ╔═╡ 37e9697d-e2ed-4fa4-882b-5cd77586d719
md"GEMM is CPU bottlenecked"

# ╔═╡ 040fc63d-0b5c-4b33-ac8e-946573dc1c0c
@xbind matrix_size NumberField(2:3000; default=1000)

# ╔═╡ 054c57f7-22cb-4d47-a79c-7ef035586f0c
@xbind benchmark_example1 CheckBox()

# ╔═╡ 88d538e9-3757-4f87-88c5-68078aef681f
md"Loading the package for benchmarking"

# ╔═╡ ead892c7-dc0d-452b-9443-15a854683f43
md"Loading the matrix multiplication function"

# ╔═╡ 4dba5c49-7bfb-426b-8461-f062a9c4a365
if benchmark_example1
	let
		# creating random vectors with normal distribution/zero elements
		A = randn(Float64, matrix_size, matrix_size)
		B = randn(Float64, matrix_size, matrix_size)
		C = zeros(Float64, matrix_size, matrix_size)
		@benchmark mul!($C, $A, $B)
	end
end

# ╔═╡ 407219ae-51df-487e-a831-c6087428159c
md"Calculating the **floating point operations per second**"

# ╔═╡ 4dcdfdd5-24e2-4fc6-86dd-335fb12b8bb4
PlutoLecturing.blackboard("FLOPS for computing GEMM<br><span style='font-size: 10pt'>the number of floating point operations / the number of seconds</span>")

# ╔═╡ a87eb239-70a5-4da2-a8ce-4d3a93d976b4
md"""
## Example 2: axpy
"""

# ╔═╡ 330c3319-7954-466d-9100-f6ec19f43fcc
md"""
axpy! is memory I/O bottlenecked
"""

# ╔═╡ 9acd075f-bd77-41da-8455-e54063cbc8b4
function axpy!(a::Real, x::AbstractVector, y::AbstractVector)
	@assert length(x) == length(y) "the input size of x and y mismatch, got $(length(x)) and $(length(y))"
	@inbounds for i=1:length(x)
		y[i] += a * x[i]
	end
	return y
end

# ╔═╡ 9abf93ab-ad22-4911-b459-fa5c6f139152
@xbind axpy_vector_size NumberField(2:10000000; default=1000)

# ╔═╡ 85d0bce1-ca15-4a86-821f-87d3ec0b715c
@xbind benchmark_axpy CheckBox()

# ╔═╡ f5edd248-eb04-41d1-b435-21aa77b010b7
if benchmark_axpy
	let
		x = randn(Float64, axpy_vector_size)
		y = randn(Float64, axpy_vector_size)
		@benchmark axpy!(2.0, $x, $y)
	end
end

# ╔═╡ 0e3bfc93-33ff-487e-ac73-71922fabf660
PlutoLecturing.blackboard("FLOPS for computing axpy", subtitle="the number of floating point operations / the number of seconds")

# ╔═╡ 13ff13dd-1146-46f7-99a0-c9ee7e878931
md"## Example 3: modified axpy"

# ╔═╡ d381fcf1-3b53-49fa-a5af-1a242c83d05c
function bad_axpy!(a::Real, x::AbstractVector, y::AbstractVector, indices::AbstractVector{Int})
	@assert length(x) == length(y) == length(indices) "the input size of x and y mismatch, got $(length(x)), $(length(y)) and $(length(indices))"
	@inbounds for i in indices
		y[i] += a * x[i]
	end
	return y
end

# ╔═╡ bb0e95c9-0a73-4367-b738-f42994758ffc
md"I will show this function is latency bottlenecked"

# ╔═╡ 94016043-b913-4413-8c6a-e2b2a75dd9dd
@xbind bad_axpy_vector_size NumberField(2:10000000; default=1000)

# ╔═╡ 7fa987b4-3d97-40e0-b4e0-fd4c5759c48b
@xbind benchmark_bad_axpy CheckBox()

# ╔═╡ 5245a31a-62c3-422d-8d04-d2bdf496cbcc
if benchmark_bad_axpy
	let
		x = randn(Float64, bad_axpy_vector_size)
		y = randn(Float64, bad_axpy_vector_size)
		indices = randperm(bad_axpy_vector_size)
		@benchmark bad_axpy!(2.0, $x, $y, $indices)
	end
end

# ╔═╡ d41f8743-d3ba-437e-b7db-a9b6d1756543
PlutoLecturing.blackboard("FLOPS for computing bad axpy", subtitle="the number of floating point operations / the number of seconds")

# ╔═╡ f48ae9b5-51dd-4434-870d-4c5e73497433
md"""
# Programming on a device （30min）
"""

# ╔═╡ 035f8874-d463-4fa8-92cc-49f1fd226d23
md"## You program are compiled to binary"

# ╔═╡ 7f0ff65f-40fd-4907-b54a-9a5ba4fcccca
with_terminal() do
	x, y = randn(10), randn(10)
	@code_native axpy!(2.0, x, y)
end

# ╔═╡ e5d9327e-75b2-4f99-97da-d3be1c8cd405
md"Let us check an easier one"

# ╔═╡ 39c580e0-d184-4400-8562-b5ba6a2d4a81
function oneton(n::Int)
   res = zero(n)
   for i = 1:n
		res+=i
   end
	return res
end

# ╔═╡ b52078f1-605a-47aa-87f8-ce3b000aa10a
with_terminal() do
	@code_native oneton(10)
end

# ╔═╡ f37d0016-16ab-4bdd-8728-00f26f6e87a9
md"An instruct has a binary correspondence: [check the online decoder](https://defuse.ca/online-x86-assembler.htm#disassembly)"

# ╔═╡ 980dac9e-092a-47e0-bcca-85c7e5ededab
md"## Measuring the performance"

# ╔═╡ 56c9c50e-bb43-4c27-88a6-ea3a26288b57
@xbind profile_axpy CheckBox()

# ╔═╡ d31f0924-aca0-446d-b06c-92a3daa65ae2
if profile_axpy
	with_terminal() do
		# clear previous profiling data
		Profile.init(; n=10^6, delay=0.001)
		x, y = randn(100000000), randn(100000000)
		@profile axpy!(2.0, x, y)
		Profile.print()
	end
end

# ╔═╡ 4fc93548-0253-4e09-b2a2-61f08818105d
PlutoLecturing.blackboard("How does profiling work?", subtitle="* function call stack <br> * two approaches: instrumentation and sampling</span>")

# ╔═╡ d7784369-1591-4c22-ad17-e9ce7d31dff0
md"# Summarize
1. understanding the components of our computing devices
2. the bottlenecks of our computing devices
3. how to get our program compiled and executed
3. how to measure the performance of a program with profiling
"

# ╔═╡ 752a7d31-5065-4d13-86b8-63eb279d1f7b
md"""
# Next lecture
We have have a $(PlutoLecturing.highlight("coding seminar")).
I will show you some cheatsheets about
* Linux operation system
* Vim
* Git
* SSH
* Julia installation Guide

Please bring your laptops and get your hands dirty!
If you are already an expert, please let me know, I need some help in preparing the cheatsheets.
"""

# ╔═╡ 68176e03-544b-4a30-a096-c117c6625113
md"## Pre-reading"

# ╔═╡ 103bf89d-c74a-4666-bfcb-8e50695ae971
md"Strong recommended course: [missing-semester](https://missing.csail.mit.edu/2020/)"

# ╔═╡ dec1a9dd-de98-4dc3-bc82-ee34efb000ab
md"""
* $(PlutoLecturing.highlight("1/13: Course overview + the shell (1 - expert)"))
* $(PlutoLecturing.highlight("1/14: Shell Tools and Scripting (4 - basic)"))
* $(PlutoLecturing.highlight("1/15: Editors (Vim) (2 - basic)"))
* 1/16: Data Wrangling
* 1/21: Command-line Environment
* $(PlutoLecturing.highlight("1/22: Version Control (Git) (3 - expert)"))
* 1/23: Debugging and Profiling
* 1/27: Metaprogramming (build systems, dependency management, testing, CI)
* 1/28: Security and Cryptography
* 1/29: Potpourri
* 1/30: Q&A
"""

# ╔═╡ a5fbf397-70d1-4dfd-a1ea-abff06007239
md"""
!!! note
    *  Yellow backgrounded lectures are required by AMAT5315
    * (n - basic) is the reading order and the level of familiarity
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractTrees = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Profile = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
Reexport = "189a3867-3050-52da-a836-e630ba90ab69"

[compat]
AbstractTrees = "~0.4.4"
BenchmarkTools = "~1.3.2"
Plots = "~1.38.7"
PlutoUI = "~0.7.50"
Reexport = "~1.2.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0-beta3"
manifest_format = "2.0"
project_hash = "f1f63bbf2a4374d09e428af67f7664b036592dec"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.AbstractTrees]]
git-tree-sha1 = "faa260e4cb5aba097a73fab382dd4b5819d8ec8c"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "d9a9701b899b30332bbcb3e1679c41cce81fb0e8"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.2"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "9c209fb7536406834aa938fb149964b985de6c83"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.1"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random", "SnoopPrecompile"]
git-tree-sha1 = "aa3edc8f8dea6cbfa176ee12f7c2fc82f0608ed3"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.20.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "7a60c856b9fa189eb34f5f8a6f6b5529b7942957"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.6.1"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "e8119c1a33d267e16108be441a287a6981ba1630"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.14.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "660b2ea2ec2b010bb02823c6d0ff6afd9bdc5c16"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.71.7"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "d5e1fd17ac7f3aa4c5287a61ee28d4f8b8e98873"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.71.7+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "37e4657cd56b11abe3d10cd4a1ec5fbdb4180263"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.7.4"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

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

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "2422f47b34d4b127720a18f86fa7b1aa2e141f29"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.18"

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

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "0a1b7c2863e44523180fdb3146534e265a91870b"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.23"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "cedb76b37bc5a6c702ade66be44f831fa23c681e"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.0"

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

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "6503b77492fd7fcb9379bf73cd31035670e3c509"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.3.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9ff31d101d987eb9d66bd8b176ac7c277beccd09"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.20+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+0"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "478ac6c952fddd4399e71d4779797c538d0ff2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.8"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "c95373e73290cf50a8a22c3375e4625ded5c5280"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.4"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SnoopPrecompile", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "cfcd24ebf8b066b4f8e42bade600c8558212ed83"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.38.7"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

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

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "261dddd3b862bd2c940cf6ca4d1c8fe593e457c8"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.3"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase", "SnoopPrecompile"]
git-tree-sha1 = "e974477be88cb5e3040009f3767611bc6357846f"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.11"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "ef28127915f4229c971eb43f3fc075dd3fe91880"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.2.0"

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

    [deps.SpecialFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "94f38103c984f89cf77c402f2a68dbd870f8165f"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.11"

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

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "ed8d92d9774b077c53e1da50fd81a36af3744c1c"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "93c41695bc1c08c46c5899f4fe06d6ead504bb73"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.3+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c6edfe154ad7b313c01aceca188c05c835c67360"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.4+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.2.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╟─84c14a09-2c9e-4919-bfb1-cdf4d5a61776
# ╟─5c5f6214-61c5-4532-ac05-85a43e5639cc
# ╟─0fe286ff-1359-4eb4-ab6c-28b231f9d56e
# ╟─c51b55d2-c899-421f-a633-1daa4168c6d5
# ╟─d59dce7b-5fed-45ba-9f9f-f4b93cf4b89f
# ╟─f36e7b45-193e-4028-aae5-352711b8406d
# ╟─72924c3a-0bbe-4d74-b2a9-60b250db4ec2
# ╟─163016e4-9133-4c61-a7ac-82e41e6db234
# ╟─a3d7aa29-1099-48c5-94d8-b6148fa1e0fd
# ╟─f5ad618c-0a00-475f-b05d-97deba0faaef
# ╠═d5c2f523-80dd-40df-bf11-dd58cd493606
# ╟─d6dca51b-978e-456e-b7c0-b658d894101d
# ╠═c0aa6f21-47d5-4f03-8b9b-a8df5c18a1b8
# ╟─2c92ab20-c105-4623-83c2-239462d59707
# ╠═96c87a95-ca76-4cf5-8920-8d1f014ba47b
# ╟─c0db86ae-d6b3-49b4-bde1-d6c2585090e8
# ╟─c80e2cc0-8cd9-438c-a2c5-7a5b0dc9aa7a
# ╟─17f877cd-3958-4b49-a0cc-fb0529800223
# ╠═5a5fd311-4c9f-4fa0-8f5a-d3f5acba3106
# ╠═24684e2a-e99e-43f3-ba66-881634e4ba1b
# ╠═79565487-c1fb-47d7-b50d-a0a39a8849d9
# ╠═baeefdd1-09ef-4b5d-8cf4-c4eeb98d3335
# ╟─4cf1e164-c510-47da-a138-f4582bfa0270
# ╠═07b3e56b-78fd-4894-b310-096281009764
# ╠═cc2e0ab8-83cc-44fe-9782-eabee896bcc0
# ╠═e51adfeb-3868-43c2-8f64-21bd1a4e8522
# ╟─9186b86b-88b1-4165-94ac-b738882a2c23
# ╟─31d784e6-22b5-430a-a571-6aad7aaefee1
# ╟─5a10796f-c084-451e-89f5-75ba8364f2d8
# ╠═8eff13e4-1d93-4add-b516-46307fca965a
# ╠═c3db170e-20f0-4488-98b0-7a65090728a1
# ╟─2fd28ddf-b74c-485b-a5d4-dabb1bfdc6c7
# ╠═27212a7a-fdd0-423d-a008-83c6f6e257c6
# ╠═e5c3c192-e398-4bb1-9933-6c6070b10756
# ╠═c761fcf3-7386-437a-b37c-af256e189a10
# ╠═9f58f7f1-ab35-499b-aefe-6bdecd137e1d
# ╠═5f27ff9c-2d86-4d8c-9d95-025e72e56c95
# ╠═21bfac50-1d7d-4737-bf1e-aef799353734
# ╠═129207a7-b88a-47bd-a853-e5db71ed65c5
# ╠═d49a05c0-e60d-471d-ba19-e5e9708fa4f7
# ╠═7275c2ec-996a-4335-ac8b-9b94719a765f
# ╠═1eab94a9-c00d-4d12-95fb-08f26d05b4d4
# ╠═ccc49ad6-e8c2-479c-8341-fc16877b50cf
# ╟─1d75ba45-2b66-47b2-a528-0e30e982c5e7
# ╟─1baa4439-9325-4e7f-bdd5-53410a200d41
# ╟─9513bd15-5789-4a56-961b-175f8dabfdaf
# ╠═38e23738-f7fb-4b9e-9067-200d42f6a1e4
# ╟─8fd31129-f150-4114-afa5-8106dba8009f
# ╠═a88e6865-235b-428a-9546-5da2daa3e03c
# ╠═e59b8bb2-95df-492e-bd15-24a1de2573f5
# ╟─c64ed02d-0c62-4cab-9bcf-35dfbfedddc6
# ╟─c13955ef-4986-4d56-8e1e-48c6becd213a
# ╠═be7247b8-ac5d-4b3a-ba3b-e8da37ef1e08
# ╟─16dc1e93-9f16-4299-9e8e-59dff16b6fd9
# ╟─5c13904a-505b-4fec-9e32-0ffa54a9dad8
# ╟─13dabaa8-7310-4557-ad06-e64f566ca256
# ╟─37e9697d-e2ed-4fa4-882b-5cd77586d719
# ╟─040fc63d-0b5c-4b33-ac8e-946573dc1c0c
# ╟─054c57f7-22cb-4d47-a79c-7ef035586f0c
# ╟─88d538e9-3757-4f87-88c5-68078aef681f
# ╠═b8d442b2-8b3d-11ed-2ac7-1f0fbfa7836d
# ╟─ead892c7-dc0d-452b-9443-15a854683f43
# ╠═cf591ae5-3b55-47c5-b7a2-6c8aefa72b7a
# ╠═4dba5c49-7bfb-426b-8461-f062a9c4a365
# ╟─407219ae-51df-487e-a831-c6087428159c
# ╟─4dcdfdd5-24e2-4fc6-86dd-335fb12b8bb4
# ╟─a87eb239-70a5-4da2-a8ce-4d3a93d976b4
# ╟─330c3319-7954-466d-9100-f6ec19f43fcc
# ╠═9acd075f-bd77-41da-8455-e54063cbc8b4
# ╟─9abf93ab-ad22-4911-b459-fa5c6f139152
# ╟─85d0bce1-ca15-4a86-821f-87d3ec0b715c
# ╠═f5edd248-eb04-41d1-b435-21aa77b010b7
# ╟─0e3bfc93-33ff-487e-ac73-71922fabf660
# ╟─13ff13dd-1146-46f7-99a0-c9ee7e878931
# ╠═d381fcf1-3b53-49fa-a5af-1a242c83d05c
# ╟─bb0e95c9-0a73-4367-b738-f42994758ffc
# ╟─94016043-b913-4413-8c6a-e2b2a75dd9dd
# ╠═7fa987b4-3d97-40e0-b4e0-fd4c5759c48b
# ╠═8776764c-4483-476b-bfff-a3e779431a68
# ╠═5245a31a-62c3-422d-8d04-d2bdf496cbcc
# ╟─d41f8743-d3ba-437e-b7db-a9b6d1756543
# ╟─f48ae9b5-51dd-4434-870d-4c5e73497433
# ╟─035f8874-d463-4fa8-92cc-49f1fd226d23
# ╠═7f0ff65f-40fd-4907-b54a-9a5ba4fcccca
# ╟─e5d9327e-75b2-4f99-97da-d3be1c8cd405
# ╠═39c580e0-d184-4400-8562-b5ba6a2d4a81
# ╠═b52078f1-605a-47aa-87f8-ce3b000aa10a
# ╟─f37d0016-16ab-4bdd-8728-00f26f6e87a9
# ╟─980dac9e-092a-47e0-bcca-85c7e5ededab
# ╠═292dc84c-b2ed-4a35-b817-be6266b40ff1
# ╟─56c9c50e-bb43-4c27-88a6-ea3a26288b57
# ╠═d31f0924-aca0-446d-b06c-92a3daa65ae2
# ╟─4fc93548-0253-4e09-b2a2-61f08818105d
# ╟─d7784369-1591-4c22-ad17-e9ce7d31dff0
# ╟─752a7d31-5065-4d13-86b8-63eb279d1f7b
# ╟─68176e03-544b-4a30-a096-c117c6625113
# ╟─103bf89d-c74a-4666-bfcb-8e50695ae971
# ╟─dec1a9dd-de98-4dc3-bc82-ee34efb000ab
# ╟─a5fbf397-70d1-4dfd-a1ea-abff06007239
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
