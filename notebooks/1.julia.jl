### A Pluto.jl notebook ###
# v0.19.22

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
using Pkg, Revise

# ╔═╡ 41ff9fda-a597-420b-93a9-b281d42acfb1
Pkg.develop(path="https://github.com/GiggleLiu/PlutoMustache.jl.git")

# ╔═╡ a319ad61-9b51-412b-a186-797150a579ab
using PlutoMustache

# ╔═╡ ed7b56a6-d9cb-4045-979f-3aa618a6b6d4
using Plots

# ╔═╡ 8776764c-4483-476b-bfff-a3e779431a68
using Random

# ╔═╡ b8d442b2-8b3d-11ed-2ac7-1f0fbfa7836d
using BenchmarkTools

# ╔═╡ 01c33da1-b98d-42dc-8725-4afb8ae6f44f
presentmode()

# ╔═╡ 5c5f6214-61c5-4532-ac05-85a43e5639cc
md"""
# About this course
## What is scientific computing?
"""

# ╔═╡ 0fe286ff-1359-4eb4-ab6c-28b231f9d56e
leftright(netimage("https://upload.wikimedia.org/wikipedia/commons/c/ce/Genegolub.jpg"), md"""
Scientific computing is the collection of tools, techniques and theories required to solve $(highlight("on a computer")) the $(highlight("mathematical models")) of problems in $(highlight("science and engineering")).

-- Gene H. Golub and James M. Ortega
"""; left=0.3)

# ╔═╡ c51b55d2-c899-421f-a633-1daa4168c6d5
md"## Textbook"

# ╔═╡ d59dce7b-5fed-45ba-9f9f-f4b93cf4b89f
leftright(md"""
$(localimage("images/textbook.jpg"))
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
    - Understanding our computing devices
    - An introduction to modern toolkit
        - Linux operating system
        - Vim, SSH and Git
    - A programming language: Julia
2. Mathematical modeling and algorithms
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
md"# Lecture 1: Understanding our computer (40min)"

# ╔═╡ 72924c3a-0bbe-4d74-b2a9-60b250db4ec2
blackboard("What is inside a computer?")

# ╔═╡ 163016e4-9133-4c61-a7ac-82e41e6db234
md"## Get hardware information (Linux)"

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

# ╔═╡ 16dc1e93-9f16-4299-9e8e-59dff16b6fd9
md"## Estimating the computing power of your devices (20min)"

# ╔═╡ 37e9697d-e2ed-4fa4-882b-5cd77586d719


# ╔═╡ 7e036714-ab4c-4546-89f2-dbf422868ffc
md"""
### Example 1
"""

# ╔═╡ 9acd075f-bd77-41da-8455-e54063cbc8b4
function axpy!(a::Real, x::AbstractVector, y::AbstractVector)
	@assert length(x) == length(y) "the input size of x and y mismatch, got $(length(x)) and $(length(y))"
	@inbounds for i=1:length(x)
		y[i] += a * x[i]
	end
	return y
end

# ╔═╡ d381fcf1-3b53-49fa-a5af-1a242c83d05c
function roll_axpy!(a::Real, x::AbstractVector, y::AbstractVector, indices::AbstractVector{Int})
	@assert length(x) == length(y) == length(indices) "the input size of x and y mismatch, got $(length(x)), $(length(y)) and $(length(indices))"
	@inbounds for i in indices
		y[i] += a * x[i]
	end
	return y
end

# ╔═╡ 85d0bce1-ca15-4a86-821f-87d3ec0b715c
md" $(@bind timing1 CheckBox()) Show times (binded to `timing1`)"

# ╔═╡ f5edd248-eb04-41d1-b435-21aa77b010b7
timing1 && let
	ns = 2 .^ (1:26)
	times = Float64[]
	for n in ns
		x = randn(Float64, n)
		y = randn(Float64, n)
		tn = @elapsed axpy!(2.0, x, y)
		push!(times, tn/n)
	end
	plot(ns, times; ylabel="time/n/s", label="axpy!", ylim=(0, 1e-8))
end

# ╔═╡ 7fa987b4-3d97-40e0-b4e0-fd4c5759c48b
md" $(@bind timing2 CheckBox()) Show times (binded to `timing2`)"

# ╔═╡ 5245a31a-62c3-422d-8d04-d2bdf496cbcc
timing2 && let
	ns = 2 .^ (1:26)
	times = Float64[]
	for n in ns
		x = randn(Float64, n)
		y = randn(Float64, n)
		indices = Random.shuffle(1:n)
		tn = @elapsed roll_axpy!(2.0, x, y, indices)
		push!(times, tn/n)
	end
	plot(ns, times; ylabel="time/n/s", label="axpy!", ylim=(0, 1e-7))
end

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
# ╠═╡ disabled = true
#=╠═╡
x = zeros(Int, 10000);
  ╠═╡ =#

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

# ╔═╡ 9306f25a-f4f5-4b19-973d-76845a746510
md"## Compiling a program"

# ╔═╡ 0b157313-555b-40a5-aca0-68b17ecd7b86
md"# Primitive Data Types
"

# ╔═╡ 2e61df85-2246-4153-b8b0-174c7fc7ec8c
md"""## Numbers
Is floating point number type a field?
"""

# ╔═╡ ab90a643-8648-400f-a1ef-90b946c76471
md"## Homework
* speed of light
* ssh to the server and check the computing power
* get julia installed
"

# ╔═╡ a029e179-9c01-40f9-a23c-a5dd672740cb
md"""
#### Rules:
1. Collaboration is allowed, but you should credit your collaborator.
"""

# ╔═╡ a1ff2e4c-2416-4cb1-9df7-8e2437558287
md"# Resources"

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

# ╔═╡ Cell order:
# ╠═84c14a09-2c9e-4919-bfb1-cdf4d5a61776
# ╠═41ff9fda-a597-420b-93a9-b281d42acfb1
# ╠═a319ad61-9b51-412b-a186-797150a579ab
# ╠═01c33da1-b98d-42dc-8725-4afb8ae6f44f
# ╟─5c5f6214-61c5-4532-ac05-85a43e5639cc
# ╟─0fe286ff-1359-4eb4-ab6c-28b231f9d56e
# ╟─c51b55d2-c899-421f-a633-1daa4168c6d5
# ╟─d59dce7b-5fed-45ba-9f9f-f4b93cf4b89f
# ╟─af0db2a7-41ca-4baf-89f3-4a416a062382
# ╟─ce633741-5a25-4eda-a0f4-9050be226255
# ╟─f36e7b45-193e-4028-aae5-352711b8406d
# ╟─72924c3a-0bbe-4d74-b2a9-60b250db4ec2
# ╟─163016e4-9133-4c61-a7ac-82e41e6db234
# ╟─f5ad618c-0a00-475f-b05d-97deba0faaef
# ╠═d5c2f523-80dd-40df-bf11-dd58cd493606
# ╟─d6dca51b-978e-456e-b7c0-b658d894101d
# ╠═c0aa6f21-47d5-4f03-8b9b-a8df5c18a1b8
# ╟─2c92ab20-c105-4623-83c2-239462d59707
# ╠═96c87a95-ca76-4cf5-8920-8d1f014ba47b
# ╟─16dc1e93-9f16-4299-9e8e-59dff16b6fd9
# ╠═37e9697d-e2ed-4fa4-882b-5cd77586d719
# ╟─7e036714-ab4c-4546-89f2-dbf422868ffc
# ╠═9acd075f-bd77-41da-8455-e54063cbc8b4
# ╠═d381fcf1-3b53-49fa-a5af-1a242c83d05c
# ╠═ed7b56a6-d9cb-4045-979f-3aa618a6b6d4
# ╟─85d0bce1-ca15-4a86-821f-87d3ec0b715c
# ╠═f5edd248-eb04-41d1-b435-21aa77b010b7
# ╟─7fa987b4-3d97-40e0-b4e0-fd4c5759c48b
# ╠═8776764c-4483-476b-bfff-a3e779431a68
# ╠═5245a31a-62c3-422d-8d04-d2bdf496cbcc
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
# ╟─9306f25a-f4f5-4b19-973d-76845a746510
# ╟─0b157313-555b-40a5-aca0-68b17ecd7b86
# ╟─2e61df85-2246-4153-b8b0-174c7fc7ec8c
# ╟─ab90a643-8648-400f-a1ef-90b946c76471
# ╟─a029e179-9c01-40f9-a23c-a5dd672740cb
# ╟─a1ff2e4c-2416-4cb1-9df7-8e2437558287
# ╟─ea04c76e-df32-4bfe-a40c-6cd9a9c9a21a
