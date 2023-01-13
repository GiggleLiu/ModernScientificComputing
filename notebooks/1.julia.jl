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

# ╔═╡ b8d442b2-8b3d-11ed-2ac7-1f0fbfa7836d
using BenchmarkTools

# ╔═╡ f9bc5799-195d-41ae-ba89-0cb1cf22e603
using PlutoUI

# ╔═╡ 54777de2-a602-4236-9b53-980bf4ce193f
include("shared.jl")

# ╔═╡ 01c33da1-b98d-42dc-8725-4afb8ae6f44f
present()

# ╔═╡ 5c5f6214-61c5-4532-ac05-85a43e5639cc
md"""
# About this course
## Scientific computing
> Scientific computing is the collection of tools, techniques and theories required to solve on a computer the mathematical models of problems in science and engineering.
>
> -- Gene H. Golub and James M. Ortega
"""

# ╔═╡ c51b55d2-c899-421f-a633-1daa4168c6d5
md"## Textbook"

# ╔═╡ d59dce7b-5fed-45ba-9f9f-f4b93cf4b89f
leftright(md"""
$(LocalResource("images/textbook.jpg"))
""", md"""
#### Chapters
1. Scientific Computing
2. Systems of linear equations
3. Linear least squares
4. Eigenvalue problems
5. Nonlinear equations
6. Optimization
7. Interpolation
8. $(del("Numerical integration and differentiation"))
9. $(del("Initial value problems for ordinary differential equations"))
10. $(del("Boundary value problems for ordinary differential equations"))
11. $(del("Partial differential equations"))
12. Fast fourier transform
13. Random numbers and stochastic simulation
"""; width=660, left=0.4)

# ╔═╡ af0db2a7-41ca-4baf-89f3-4a416a062382
md"""
## This course (Slightly more than the textbook)
1. Modern toolkits
    - Computer architecture
    - An operating system: Linux
    - A programming language: Julia
    - Four types of parallel computing schemes
        - Single instruction and multiple data (SIMD)
        - Multithreading
        - Message passing interface (MPI)
        - CUDA programming
2. Old mathematical modeling and algorithms
3. State of the art problems
    - probabilistic modeling
    - sparsity detection (in dataset)
    - computational hard problems
"""

# ╔═╡ ce633741-5a25-4eda-a0f4-9050be226255
md"""
## Grading
1. 70% by course assignment
2. 30% by final presentation
## $(highlight("Our communication channel!"))
(Zulip link to be added)
## My email
Jinguo Liu

[jinguoliu@hkust-gz.edu.cn](mailto:jinguoliu@hkust-gz.edu.cn)
"""

# ╔═╡ f36e7b45-193e-4028-aae5-352711b8406d
md"# Lecture 1: Understanding our computer"

# ╔═╡ 684c162a-cd72-4675-aa47-3969cf1768ee
md"""
![Computer arch, Power suppl, CPU, Registers, Caches, Main memory, GPU]()
"""

# ╔═╡ e95e9fa0-42e7-43ea-8571-37fbb6043948
md"""
```bash
(base) ➜  ~ lscpu
Architecture:            x86_64
  CPU op-mode(s):        32-bit, 64-bit
  Address sizes:         39 bits physical, 48 bits virtual
  Byte Order:            Little Endian
CPU(s):                  8
  On-line CPU(s) list:   0-7
Vendor ID:               GenuineIntel
  Model name:            Intel(R) Core(TM) i7-10510U CPU @ 1.80GHz
    CPU family:          6
    Model:               142
    Thread(s) per core:  2
    Core(s) per socket:  4
    Socket(s):           1
    Stepping:            12
    CPU max MHz:         4900.0000
    CPU min MHz:         400.0000
    BogoMIPS:            4599.93
    Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat 
                         pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx p
                         dpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good n
                         opl xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 mo
                         nitor ds_cpl vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1
                          sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c 
                         rdrand lahf_lm abm 3dnowprefetch cpuid_fault epb invpcid_single ss
                         bd ibrs ibpb stibp ibrs_enhanced tpr_shadow vnmi flexpriority ept 
                         vpid ept_ad fsgsbase tsc_adjust sgx bmi1 avx2 smep bmi2 erms invpc
                         id mpx rdseed adx smap clflushopt intel_pt xsaveopt xsavec xgetbv1
                          xsaves dtherm ida arat pln pts hwp hwp_notify hwp_act_window hwp_
                         epp md_clear flush_l1d arch_capabilities
Virtualization features: 
  Virtualization:        VT-x
Caches (sum of all):     
  L1d:                   128 KiB (4 instances)
  L1i:                   128 KiB (4 instances)
  L2:                    1 MiB (4 instances)
  L3:                    8 MiB (1 instance)
NUMA:                    
  NUMA node(s):          1
  NUMA node0 CPU(s):     0-7
Vulnerabilities:         
  Itlb multihit:         KVM: Mitigation: VMX disabled
  L1tf:                  Not affected
  Mds:                   Not affected
  Meltdown:              Not affected
  Mmio stale data:       Mitigation; Clear CPU buffers; SMT vulnerable
  Retbleed:              Mitigation; Enhanced IBRS
  Spec store bypass:     Mitigation; Speculative Store Bypass disabled via prctl and seccom
                         p
  Spectre v1:            Mitigation; usercopy/swapgs barriers and __user pointer sanitizati
                         on
  Spectre v2:            Mitigation; Enhanced IBRS, IBPB conditional, RSB filling, PBRSB-eI
                         BRS SW sequence
  Srbds:                 Mitigation; Microcode
  Tsx async abort:       Not affected
```
"""

# ╔═╡ 0b157313-555b-40a5-aca0-68b17ecd7b86
md"# Primitive Data Types
"

# ╔═╡ 57b3426a-1dc7-44ca-9368-78cb322c259b
md"## Caches"

# ╔═╡ 61094c96-832f-44a4-892a-688187434472
# cache friendly
function f1!(x)
	@inbounds for i=1:length(x)
        x[i] = rand(1:length(x))
   	end
	return x
end

# ╔═╡ d9ad5708-db25-407d-b382-c3dc8fb1003c
# cache unfriendly
function f2!(x)
	@inbounds for i=1:length(x)
        x[i] = x[rand(1:length(x))]
   	end
	return x
end

# ╔═╡ 97f9d064-a0ff-4593-bbab-5cf224965b25
x = zeros(Int, 10000);

# ╔═╡ c7157d70-3cdd-4b75-b86b-ea9b1cacbeb0
md""" $(@bind run_bm1 CheckBox()) Run Benchmarks"""

# ╔═╡ d0c151cb-55a7-4d89-99d5-416eb00cf251
run_bm1 && @benchmark f1!($x)

# ╔═╡ 71cc7d7e-d034-4d33-85a5-3b540c702515
run_bm1 && @benchmark f2!($x)

# ╔═╡ 60d0ebd1-276b-4a7b-958f-44c035dc6d86
md""" $(@bind run_bm2 CheckBox()) Run Benchmarks"""

# ╔═╡ 5f7edd45-01bd-4af4-b25e-5827c5ae580d
xlarge = zeros(Int, 10000000);

# ╔═╡ 749af321-0b3c-43b1-82ac-effc93475e10
run_bm2 && @benchmark f1!($xlarge)

# ╔═╡ f6904206-5935-4002-b914-f058ecfe3a43
run_bm2 && @benchmark f2!($xlarge)

# ╔═╡ ea04c76e-df32-4bfe-a40c-6cd9a9c9a21a
md"""## Pluto notebook using guide:
### How to play this notebook?
1. Clone this Github repo to your local host.
```bash
git clone https://github.com/GiggleLiu/ModernScientificComputing.git
```

### Controls

* Use $(kbd("Ctrl")) + $(kbd("Alt")) + $(kbd("P")) to toggle the presentation mode.
* Use $(kbd("Ctrl")) + $(kbd("→")) / $(kbd("←")) to play the previous/next slide.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
BenchmarkTools = "~1.3.2"
PlutoUI = "~0.7.49"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0-beta2"
manifest_format = "2.0"
project_hash = "0da5d17056461ac0abf65ae8365452a13a39bc03"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

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

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

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

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

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
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+0"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "6466e524967496866901a78fca3f2e9ea445a559"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eadad7b14cf046de6eb41f13c9275e5aa2711ab6"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.49"

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

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

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

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "ac00576f90d8a259f2c9d823e91d1de3fd44d348"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.2.0+0"

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
# ╠═54777de2-a602-4236-9b53-980bf4ce193f
# ╠═01c33da1-b98d-42dc-8725-4afb8ae6f44f
# ╟─5c5f6214-61c5-4532-ac05-85a43e5639cc
# ╟─c51b55d2-c899-421f-a633-1daa4168c6d5
# ╟─d59dce7b-5fed-45ba-9f9f-f4b93cf4b89f
# ╟─af0db2a7-41ca-4baf-89f3-4a416a062382
# ╟─ce633741-5a25-4eda-a0f4-9050be226255
# ╟─f36e7b45-193e-4028-aae5-352711b8406d
# ╠═684c162a-cd72-4675-aa47-3969cf1768ee
# ╟─e95e9fa0-42e7-43ea-8571-37fbb6043948
# ╟─0b157313-555b-40a5-aca0-68b17ecd7b86
# ╟─57b3426a-1dc7-44ca-9368-78cb322c259b
# ╠═61094c96-832f-44a4-892a-688187434472
# ╠═d9ad5708-db25-407d-b382-c3dc8fb1003c
# ╠═97f9d064-a0ff-4593-bbab-5cf224965b25
# ╠═b8d442b2-8b3d-11ed-2ac7-1f0fbfa7836d
# ╟─c7157d70-3cdd-4b75-b86b-ea9b1cacbeb0
# ╠═d0c151cb-55a7-4d89-99d5-416eb00cf251
# ╠═71cc7d7e-d034-4d33-85a5-3b540c702515
# ╟─60d0ebd1-276b-4a7b-958f-44c035dc6d86
# ╠═5f7edd45-01bd-4af4-b25e-5827c5ae580d
# ╠═749af321-0b3c-43b1-82ac-effc93475e10
# ╠═f6904206-5935-4002-b914-f058ecfe3a43
# ╟─ea04c76e-df32-4bfe-a40c-6cd9a9c9a21a
# ╠═f9bc5799-195d-41ae-ba89-0cb1cf22e603
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
