### A Pluto.jl notebook ###
# v0.19.25

using Markdown
using InteractiveUtils

# ╔═╡ f2d7dc70-2de3-4411-ab1d-973980693f46
using PlutoUI, Test

# ╔═╡ 075a4141-5860-4cf1-888d-23f9e090c48e
using CUDA; CUDA.allowscalar(false)

# ╔═╡ 0ea829bc-87f1-479d-b0ee-cd222afcb173
using BenchmarkTools

# ╔═╡ 695af2cf-7905-4282-a735-4e5f3e6e2879
TableOfContents()

# ╔═╡ f26db3f9-04a0-4e72-93ee-219e4743b1d9
function highlight(str)
	HTML("""<span style="background-color:yellow">$(str)</span>""")
end

# ╔═╡ 0b956e8e-e5a1-11ed-2cfd-ddc0643b1144
md"""
# Kernel principle component analysis
"""

# ╔═╡ 88f7b1b8-c60f-4969-997a-6f8b47d51e34
md"# Simulting lattice gas cellular automata"

# ╔═╡ 050b3d36-6d01-4eb2-b5ea-6308225eced0
md"""
## Cellular automata
* A descretized space and time,
* A state defined on the space,
* A simple set of rules (local & finite) to describe the evolution of the state.
"""

# ╔═╡ 6739234e-c3f4-42bb-a056-8c31e0913d10
md"""
Reference:
* Hardy J, Pomeau Y, De Pazzis O. Time evolution of a two‐dimensional model system. I. Invariant states and time correlation functions[J]. Journal of Mathematical Physics, 1973, 14(12): 1746-1759.
"""

# ╔═╡ 02154869-eefb-44e6-8b2c-9b471b1ba250
md"""
![](https://upload.wikimedia.org/wikipedia/commons/e/ef/HppModelExamples.jpg)
"""

# ╔═╡ 3659db4f-d7f1-4e8b-9806-e5e58408912f
md"""
* Particles exist only on the grid points, never on the edges or surface of the lattice.
* Each particle has an associated direction (from one grid point to another immediately adjacent grid point).
* Each lattice grid cell can only contain a maximum of one particle for each direction, i.e., contain a total of between zero and four particles.

The following rules also govern the model:

* A single particle moves in a fixed direction until it experiences a collision.
* Two particles experiencing a head-on collision are deflected perpendicularly.
* Two particles experience a collision which isn't head-on simply pass through each other and continue in the same direction.
* Optionally, when a particles collides with the edges of a lattice it can rebound.
"""

# ╔═╡ 7326ecb5-6ac6-41e1-a4e1-e8c3d2e4c5cd
md"""
# CUDA programming with Julia
CUDA programming is a $(highlight("parallel computing platform and programming model")) developed by NVIDIA for performing general-purpose computations on its GPUs (Graphics Processing Units). CUDA stands for Compute Unified Device Architecture.

References:
1. [JuliaComputing/Training](https://github.com/JuliaComputing/Training)
2. [arXiv: 1712.03112](https://arxiv.org/abs/1712.03112)
"""

# ╔═╡ e4772a9c-ef82-4710-9459-c4652399867c
md"""
## Goal
1. Run a CUDA program
3. Write your own CUDA kernel
4. Create a CUDA project
"""

# ╔═╡ 788e09ee-072d-4192-86da-46cfb110aab7
md"## Run a CUDA program"

# ╔═╡ afcda842-6a4f-4898-aec2-f036f006cc81
md"""
1. Make sure you have a NVIDIA GPU device and its driver is properly installed.
"""

# ╔═╡ c6ff8e8f-270d-4cfe-b09e-b8ecba71d3b9
run(`nvidia-smi`)

# ╔═╡ ec84fd61-8e6f-4c95-ba30-44f23af04bcb
md"""2. Install the [CUDA.jl](https://github.com/JuliaGPU/CUDA.jl) package, and disable scalar indexing of CUDA arrays.

CUDA.jl provides wrappers for several CUDA libraries that are part of the CUDA toolkit:

* Driver library: manage the device, $(highlight("launch kernels")), etc.
* CUBLAS: linear algebra
* CURAND: random number generation
* CUFFT: fast fourier transform
* CUSPARSE: sparse arrays
* CUSOLVER: decompositions & linear systems

There's also support for a couple of libraries that aren't part of the CUDA toolkit, but are commonly used:

* CUDNN: deep neural networks
* CUTENSOR: linear algebra with tensors
"""

# ╔═╡ 57437cc1-d3b8-4fe0-a884-a3f373b5baac
CUDA.versioninfo()

# ╔═╡ 1fee5ca3-c7fa-4b92-96fc-f338e4190534
md"""
3. Choose a device (if multiple devices are available).
"""

# ╔═╡ 58906955-9355-4029-bef2-1fe7d49a5ca7
devices()

# ╔═╡ 14e07e25-62bf-4bb2-8091-20a23d7944dc
dev = CuDevice(0)

# ╔═╡ 8819ab5f-6834-4fa4-932a-810428fdd8c8
md"grid > block > thread"

# ╔═╡ bf8970df-d3a6-4a73-9458-00b9e531d2c6
attribute(dev, CUDA.DEVICE_ATTRIBUTE_MAX_THREADS_PER_BLOCK)

# ╔═╡ 2646178f-1d46-4d4c-9054-cceaa84cd3b3
attribute(dev, CUDA.CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_X)

# ╔═╡ 242c6d2f-8be8-4a78-8c17-407f1bc96bec
attribute(dev, CUDA.CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_X)

# ╔═╡ 09e1e603-caef-4ee9-959f-1154efaf1557
md"4. Create a CUDA Array"

# ╔═╡ 5cb9f3f9-9244-4785-9b19-f04e19ee58d7
CUDA.zeros(10)

# ╔═╡ ada9cb01-c2c7-4354-8581-d84c63b82b34
cuarray1 = CUDA.randn(10)

# ╔═╡ f51579f8-b662-4050-bdbe-9ebcd6d6c172
@test_throws ErrorException cuarray1[3]

# ╔═╡ ded2a67f-f6c8-4f8a-b9df-325daf86442d
CUDA.@allowscalar cuarray1[3] += 10

# ╔═╡ 6617d8ae-60cb-4257-9414-079b8964759d
md"Upload a CPU Array to GPU"

# ╔═╡ a3eb5495-c4f5-4b20-b045-86b75d8c8e58
CuArray(randn(10))

# ╔═╡ adaeb3b3-4632-44c5-baf8-6fc8777cde89
md"5. Compute"

# ╔═╡ cf9931db-ac03-445b-8b50-252d202ad5b8
md"""
Computing a function on GPU Arrays
1. Launch a CUDA job - a few micro seconds
2. Launch more CUDA jobs...
3. Synchronize threads - a few micro seconds
"""

# ╔═╡ 8a2dbc92-2f0d-4e73-914e-d78291f9fb39
md"Computing matrix multiplication."

# ╔═╡ 1fcad444-1c0f-4ee9-ba61-03a399674338
@elapsed rand(2000,2000) * rand(2000,2000)

# ╔═╡ 7e002aa5-fc10-4583-bbae-6499d9cd48b3
@elapsed CUDA.@sync CUDA.rand(2000,2000) * CUDA.rand(2000,2000)

# ╔═╡ 7e6abc2d-97ca-44d9-91b2-ae888e413be2
md"Broadcasting a native Julia function
Julia -> LLVM (optimized for CUDA) -> CUDA
"

# ╔═╡ 0a4a816a-ec1a-45dc-8519-9cc92fb25051
factorial(n) = n == 1 ? 1 : factorial(n-1)*n

# ╔═╡ d5005144-80ae-457a-aa2b-03971784059f
# this function is copied from lecture 9
function poor_besselj(ν::Int, z::T; atol=eps(T)) where T
    k = 0
    s = (z/2)^ν / factorial(ν)
    out = s::T
    while abs(s) > atol
        k += 1
        s *= -(k+ν) * (z/2)^2 / k
        out += s
    end
    out
end

# ╔═╡ 610521c2-d36f-4174-816f-82b36d052c94
x = CUDA.CuArray(0.0:0.01:10)

# ╔═╡ fc4e9b3b-c716-4b27-90cb-7f90fb762148
poor_besselj.(1, x)

# ╔═╡ c84dcaf6-7165-4473-aa0b-0cf15562f50d
md"6. manage your GPU devices"

# ╔═╡ 142d4bda-85b9-4eb3-adb7-0ad61c82d2f1
nvml_dev = NVML.Device(parent_uuid(device()))

# ╔═╡ 90a4d05b-02d9-414b-b571-4680043edf36
NVML.power_usage(nvml_dev)

# ╔═╡ bb6ec433-d2e9-41c5-9a50-3617f666a455
NVML.utilization_rates(nvml_dev)

# ╔═╡ c45650c7-413a-4ef0-848d-9f4b3ca5055d
NVML.compute_processes(nvml_dev)

# ╔═╡ e1f2b080-3bfe-43ce-b3e0-956441251578
md"## CUDA libraries and Kernel Programming"

# ╔═╡ 2f2de6d7-6d28-4973-a58e-dd37e8a13e88
md"Please check [lib/CUDATutorial](../lib/CUDATutorial/kernel.jl)"

# ╔═╡ 6070842e-4117-4d26-9c75-6989c8b3e394
md"""# Appendix: The Navier-Stokes equation
Reference: [https://youtu.be/Ra7aQlenTb8](https://youtu.be/Ra7aQlenTb8)
"""

# ╔═╡ 2440375c-9284-4624-b6bc-dd41bcbd8b25
html"""
<iframe width="560" height="315" src="https://www.youtube.com/embed/Ra7aQlenTb8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
"""

# ╔═╡ c5786eac-1913-47e6-b4f5-949090bd2da9
md"""
The navier stokes equation describes the fluid dynamics, which contains the following two parts.

The first one describes the conservation of volume
```math
\nabla \underbrace{u}_{\text{velocity } u \in \mathbb{R}^d} = 0
```

The second one describes the dynamics
```math
\underbrace{\rho}_{\text{density}} \frac{du}{dt} = \underbrace{-\nabla p}_{\text{pressure}} + \underbrace{\mu \nabla^2 u}_{\text{viscosity (or friction)}} + \underbrace{f}_{\text{external force}}.
```

"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[compat]
BenchmarkTools = "~1.3.2"
CUDA = "~4.1.4"
PlutoUI = "~0.7.50"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0-rc3"
manifest_format = "2.0"
project_hash = "7d0204ea5973ad20c1acbad2acd500bb70fe7c0a"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "16b6dbc4cf7caee4e1e75c49485ec67b667098a0"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.3.1"

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"

    [deps.AbstractFFTs.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

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
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Atomix]]
deps = ["UnsafeAtomics"]
git-tree-sha1 = "c06a868224ecba914baa6942988e2f2aade419be"
uuid = "a9b6321e-bd34-4604-b9c9-b65b8de01458"
version = "0.1.0"

[[deps.BFloat16s]]
deps = ["LinearAlgebra", "Printf", "Random", "Test"]
git-tree-sha1 = "dbf84058d0a8cbbadee18d25cf606934b22d7c66"
uuid = "ab4f0b2a-ad5b-11e8-123f-65d77653426b"
version = "0.4.2"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "d9a9701b899b30332bbcb3e1679c41cce81fb0e8"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.2"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CUDA]]
deps = ["AbstractFFTs", "Adapt", "BFloat16s", "CEnum", "CUDA_Driver_jll", "CUDA_Runtime_Discovery", "CUDA_Runtime_jll", "CompilerSupportLibraries_jll", "ExprTools", "GPUArrays", "GPUCompiler", "KernelAbstractions", "LLVM", "LazyArtifacts", "Libdl", "LinearAlgebra", "Logging", "Preferences", "Printf", "Random", "Random123", "RandomNumbers", "Reexport", "Requires", "SparseArrays", "SpecialFunctions", "UnsafeAtomicsLLVM"]
git-tree-sha1 = "8547829ee0da896ce48a24b8d2f4bf929cf3e45e"
uuid = "052768ef-5323-5732-b1bb-66c8b64840ba"
version = "4.1.4"

[[deps.CUDA_Driver_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "498f45593f6ddc0adff64a9310bb6710e851781b"
uuid = "4ee394cb-3365-5eb0-8335-949819d2adfc"
version = "0.5.0+1"

[[deps.CUDA_Runtime_Discovery]]
deps = ["Libdl"]
git-tree-sha1 = "bcc4a23cbbd99c8535a5318455dcf0f2546ec536"
uuid = "1af6417a-86b4-443c-805f-a4643ffb695f"
version = "0.2.2"

[[deps.CUDA_Runtime_jll]]
deps = ["Artifacts", "CUDA_Driver_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "TOML"]
git-tree-sha1 = "81eed046f28a0cdd0dc1f61d00a49061b7cc9433"
uuid = "76a88914-d11a-5bdc-97e0-2f5a05c973a2"
version = "0.5.0+2"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.ExprTools]]
git-tree-sha1 = "c1d06d129da9f55715c6c212866f5b1bddc5fa00"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.9"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.GPUArrays]]
deps = ["Adapt", "GPUArraysCore", "LLVM", "LinearAlgebra", "Printf", "Random", "Reexport", "Serialization", "Statistics"]
git-tree-sha1 = "9ade6983c3dbbd492cf5729f865fe030d1541463"
uuid = "0c68f7d7-f131-5f86-a1c3-88cf8149b2d7"
version = "8.6.6"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "1cd7f0af1aa58abc02ea1d872953a97359cb87fa"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.4"

[[deps.GPUCompiler]]
deps = ["ExprTools", "InteractiveUtils", "LLVM", "Libdl", "Logging", "Scratch", "TimerOutputs", "UUIDs"]
git-tree-sha1 = "e9a9173cd77e16509cdf9c1663fda19b22a518b7"
uuid = "61eb1bfa-7361-4325-ad38-22787b887f55"
version = "0.19.3"

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

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.KernelAbstractions]]
deps = ["Adapt", "Atomix", "InteractiveUtils", "LinearAlgebra", "MacroTools", "PrecompileTools", "SparseArrays", "StaticArrays", "UUIDs", "UnsafeAtomics", "UnsafeAtomicsLLVM"]
git-tree-sha1 = "1e7e27a144936ed6f1b0a01dbc7b7f86afabeb6e"
uuid = "63c18a36-062a-441e-b654-da1e3ab1ce7c"
version = "0.9.3"

[[deps.LLVM]]
deps = ["CEnum", "LLVMExtra_jll", "Libdl", "Printf", "Unicode"]
git-tree-sha1 = "a8960cae30b42b66dd41808beb76490519f6f9e2"
uuid = "929cbde3-209d-540e-8aea-75f648917ca0"
version = "5.0.0"

[[deps.LLVMExtra_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "TOML"]
git-tree-sha1 = "09b7505cc0b1cee87e5d4a26eea61d2e1b0dcd35"
uuid = "dad2f222-ce93-54a1-a47d-0025e8a3acab"
version = "0.0.21+0"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

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
version = "2.28.2+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "478ac6c952fddd4399e71d4779797c538d0ff2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.8"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "5bb5129fdd62a2bbbe17c2756932259acf467386"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.50"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "2e47054ffe7d0a8872e977c0d09eb4b3d162ebde"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.0.2"

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

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Random123]]
deps = ["Random", "RandomNumbers"]
git-tree-sha1 = "552f30e847641591ba3f39fd1bed559b9deb0ef3"
uuid = "74087812-796a-5b5d-8853-05524746bad3"
version = "1.6.1"

[[deps.RandomNumbers]]
deps = ["Random", "Requires"]
git-tree-sha1 = "043da614cc7e95c703498a491e2c21f58a2b8111"
uuid = "e6cf234a-135c-5ec9-84dd-332b85af5143"
version = "1.5.3"

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

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

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

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "c262c8e978048c2b095be1672c9bee55b4619521"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.24"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "f548a9e9c490030e545f72074a41edfd0e5bcdd7"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.23"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnsafeAtomics]]
git-tree-sha1 = "6331ac3440856ea1988316b46045303bef658278"
uuid = "013be700-e6cd-48c3-b4a1-df204f14c38f"
version = "0.2.1"

[[deps.UnsafeAtomicsLLVM]]
deps = ["LLVM", "UnsafeAtomics"]
git-tree-sha1 = "ea37e6066bf194ab78f4e747f5245261f17a7175"
uuid = "d80eeb9a-aca5-4d75-85e5-170c8b632249"
version = "0.1.2"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.7.0+0"

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
# ╠═f2d7dc70-2de3-4411-ab1d-973980693f46
# ╠═695af2cf-7905-4282-a735-4e5f3e6e2879
# ╠═f26db3f9-04a0-4e72-93ee-219e4743b1d9
# ╟─0b956e8e-e5a1-11ed-2cfd-ddc0643b1144
# ╟─88f7b1b8-c60f-4969-997a-6f8b47d51e34
# ╟─050b3d36-6d01-4eb2-b5ea-6308225eced0
# ╟─6739234e-c3f4-42bb-a056-8c31e0913d10
# ╟─02154869-eefb-44e6-8b2c-9b471b1ba250
# ╟─3659db4f-d7f1-4e8b-9806-e5e58408912f
# ╟─7326ecb5-6ac6-41e1-a4e1-e8c3d2e4c5cd
# ╟─e4772a9c-ef82-4710-9459-c4652399867c
# ╟─788e09ee-072d-4192-86da-46cfb110aab7
# ╟─afcda842-6a4f-4898-aec2-f036f006cc81
# ╠═c6ff8e8f-270d-4cfe-b09e-b8ecba71d3b9
# ╟─ec84fd61-8e6f-4c95-ba30-44f23af04bcb
# ╠═075a4141-5860-4cf1-888d-23f9e090c48e
# ╠═57437cc1-d3b8-4fe0-a884-a3f373b5baac
# ╟─1fee5ca3-c7fa-4b92-96fc-f338e4190534
# ╠═58906955-9355-4029-bef2-1fe7d49a5ca7
# ╠═14e07e25-62bf-4bb2-8091-20a23d7944dc
# ╟─8819ab5f-6834-4fa4-932a-810428fdd8c8
# ╠═bf8970df-d3a6-4a73-9458-00b9e531d2c6
# ╠═2646178f-1d46-4d4c-9054-cceaa84cd3b3
# ╠═242c6d2f-8be8-4a78-8c17-407f1bc96bec
# ╟─09e1e603-caef-4ee9-959f-1154efaf1557
# ╠═5cb9f3f9-9244-4785-9b19-f04e19ee58d7
# ╠═ada9cb01-c2c7-4354-8581-d84c63b82b34
# ╠═f51579f8-b662-4050-bdbe-9ebcd6d6c172
# ╠═ded2a67f-f6c8-4f8a-b9df-325daf86442d
# ╟─6617d8ae-60cb-4257-9414-079b8964759d
# ╠═a3eb5495-c4f5-4b20-b045-86b75d8c8e58
# ╟─adaeb3b3-4632-44c5-baf8-6fc8777cde89
# ╟─cf9931db-ac03-445b-8b50-252d202ad5b8
# ╟─8a2dbc92-2f0d-4e73-914e-d78291f9fb39
# ╠═1fcad444-1c0f-4ee9-ba61-03a399674338
# ╠═7e002aa5-fc10-4583-bbae-6499d9cd48b3
# ╟─7e6abc2d-97ca-44d9-91b2-ae888e413be2
# ╠═d5005144-80ae-457a-aa2b-03971784059f
# ╠═0a4a816a-ec1a-45dc-8519-9cc92fb25051
# ╠═610521c2-d36f-4174-816f-82b36d052c94
# ╠═fc4e9b3b-c716-4b27-90cb-7f90fb762148
# ╠═0ea829bc-87f1-479d-b0ee-cd222afcb173
# ╟─c84dcaf6-7165-4473-aa0b-0cf15562f50d
# ╠═142d4bda-85b9-4eb3-adb7-0ad61c82d2f1
# ╠═90a4d05b-02d9-414b-b571-4680043edf36
# ╠═bb6ec433-d2e9-41c5-9a50-3617f666a455
# ╠═c45650c7-413a-4ef0-848d-9f4b3ca5055d
# ╟─e1f2b080-3bfe-43ce-b3e0-956441251578
# ╟─2f2de6d7-6d28-4973-a58e-dd37e8a13e88
# ╟─6070842e-4117-4d26-9c75-6989c8b3e394
# ╟─2440375c-9284-4624-b6bc-dd41bcbd8b25
# ╟─c5786eac-1913-47e6-b4f5-949090bd2da9
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
