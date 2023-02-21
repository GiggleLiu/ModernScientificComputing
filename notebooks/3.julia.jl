### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ 39479e02-fc99-4b27-ae04-b2ef94f24cf0
using Pkg, Luxor

# ╔═╡ cb5259ae-ce92-4197-8f51-bf6d9e371a25
try
	using PlutoLecturing
catch
	Pkg.develop(path="https://github.com/GiggleLiu/PlutoLecturing.jl.git")
	using PlutoLecturing
end

# ╔═╡ bd058399-1274-4a8d-bc49-a5999bd3a5ef
# for opening a shared library file (*.so), with zero run-time overhead
using Libdl

# ╔═╡ bd50a691-503a-4ab0-a836-ea380a1931ae
using BenchmarkTools

# ╔═╡ 0cbe52d2-6661-4712-b367-0f57c5e4e3c2
using PyCall

# ╔═╡ 640558dd-e6e0-4b84-9b93-c454ecf8acb9
using MethodAnalysis

# ╔═╡ fdcb76f5-479f-410a-bdaa-a95216ca9ec9
using TropicalNumbers

# ╔═╡ b40ecdbe-c062-4438-b165-5da3662b15b5
using Test

# ╔═╡ a82f898d-129d-4585-bca7-45814dcceeb9
TableOfContents(depth=2)

# ╔═╡ 785c7656-117e-47b5-8a6c-8d11d561ddf7
html"<button onclick=present()>Present</button>"

# ╔═╡ 0a884afd-49e5-41f3-b808-cc4c2dccf26a
html"""<h1>Announcement</h1>
<p>HKUST-GZ Zulip is online!</p>
<img src="https://zulip.hkust-gz.edu.cn/static/images/logo/zulip-org-logo.svg?version=0" width=200/>
<div style="font-size:40px;"><a href="https://zulip.hkust-gz.edu.cn">https://zulip.hkust-gz.edu.cn</a></div>

It is <strong>open source</strong>, <strong> self-hosted (5TB storage) </strong>, <strong>history kept & backuped</strong> and allows you to detect community and services.
"""

# ╔═╡ 6f4a9990-0b9b-4574-8e00-7d16a4b9f391
md"""
# An Introduction to the Julia programming language
"""

# ╔═╡ 9d84d2d5-ba4c-4004-8386-41492ec66674
md"""## A survey
What programming language do you use? Do you have any pain point about this language?
"""

# ╔═╡ dcee31b8-a384-4718-950e-d1c5a52df29e
md"# What is JuliaLang?"

# ╔═╡ f9037c77-a7af-4b16-85a5-5eb9c8b74bb9
md"""
## A modern, open-source, high performance programming lanaguage

JuliaLang was born in 2012 in MIT, now is maintained by Julia Computing Inc. located in Boston, US. Founders are Jeff Bezanson, Alan Edelman, Stefan Karpinski, Viral B. Shah.

JuliaLang is open-source, its code is maintained on [Github](https://github.com/JuliaLang/julia)(https://github.com/JuliaLang/julia) and it open source LICENSE is MIT.
Julia packages can be found on [JuliaHub](https://juliahub.com/ui/Packages), most of them are open-source.

It is designed for speed
![](https://julialang.org/assets/images/benchmarks.svg)
"""

# ╔═╡ 861ed080-c2ca-4766-a0a4-5fbb16688915
md"""## Reference
[arXiv:1209.5145](https://arxiv.org/abs/1209.5145)

**Julia: A Fast Dynamic Language for Technical Computing**
-- Jeff Bezanson, Stefan Karpinski, Viral B. Shah, Alan Edelman

 $(highlight("Dynamic")) languages have become popular for $(highlight("scientific computing")). They are generally considered highly productive, but lacking in performance. This paper presents Julia, a new dynamic language for technical computing, $(highlight("designed for performance")) from the beginning by adapting and extending modern programming language techniques. A design based on $(highlight("generic functions")) and a rich $(highlight("type")) system simultaneously enables an expressive programming model and successful $(highlight("type inference")), leading to good performance for a wide range of programs. This makes it possible for much of the Julia library to be written in Julia itself, while also incorporating best-of-breed C and Fortran libraries.

### Terms explained
* *dynamic programming language*: In computer science, a *dynamic programming language* is a class of high-level programming languages, which at runtime execute many common programming behaviours that static programming languages perform during compilation. These behaviors could include an extension of the program, by adding new code, by extending objects and definitions, or by modifying the type system.
* *type*: In a programming language, a *type* is a description of a set of values and a set of allowed operations on those values.
* *generic function*: In computer programming, a *generic function* is a function defined for polymorphism.
* *type inference*: *Type inference* refers to the automatic detection of the type of an expression in a formal language.
"""

# ╔═╡ 216b9efd-7a47-41e3-aeff-519fb934d781
md"# The two language problem"

# ╔═╡ 7acd68c6-af4e-4ba0-81d8-85b9a181c537
md"## Executing a C program"

# ╔═╡ f5e0e47c-4ab4-4d6b-941a-48ea2430a313
# A notebook utility to run code in a terminal style
with_terminal() do
	# display the file
	run(`cat clib/demo.c`)
end

# ╔═╡ 26a35e13-a033-40d5-b964-ee6bc7d874db
# compile to a shared library by piping C_code to gcc;
# (only works if you have gcc installed)
run(`gcc clib/demo.c -fPIC -O3 -msse3 -shared -o clib/demo.so`)

# ╔═╡ 8c15d3ec-aa68-4a27-8a17-b8a9f5e97149
with_terminal() do
	# list all files
	run(`ls clib`)
end

# ╔═╡ dc1178f2-fd17-4ca2-907a-267851cf2ea9
# @ccall is a julia macro
# a macro is a program for generating programs, just like the template in C++
# In Julia, we use `::` to specify the type of a variable
c_factorial(x) = Libdl.@ccall "clib/demo".c_factorial(x::Csize_t)::Int

# ╔═╡ 0a176011-0423-4971-b89a-2e8fb197d7b6
c_factorial(10)

# ╔═╡ 45ceeffe-9a3a-430f-9844-f5b3806dfb0c
c_factorial(1000)

# ╔═╡ 63fe0c9a-365c-4c9b-a26d-56faf24a5f85
@xbind benchmark_ccode CheckBox()

# ╔═╡ b460f115-2d18-4e0f-8732-0e8766c96888
if benchmark_ccode @benchmark c_factorial(1000) end

# ╔═╡ 3b840c20-cf23-4ccc-b6a9-f0fe34c10925
md"## Executing a Pyhton Program"

# ╔═╡ e7d36996-6a74-4183-aade-3f34b8fe4074
md"[learn more about calling C code in Julia](https://docs.julialang.org/en/v1/manual/calling-c-and-fortran-code/)"

# ╔═╡ 652f473f-3ab5-417f-8ab9-8f3fd9d4f754
md"Dynamic programming language does not require compiling"

# ╔═╡ dfd977be-12cb-4f68-9425-2c09cf69232a
# py"..." is a string literal, it is defined as a special macro: @py_str
py"""
def factorial(n):
	x = 1
	for i in range(1, n+1):
	    x = x * i
	return x
"""

# ╔═╡ 1c5ec173-7af1-4454-bbec-e8d8096b0490
py"factorial"(1000)

# ╔═╡ 50b5c202-ad20-47aa-b03f-08e45c8498e3
# `typemax` to get the maximum value
typemax(Int)

# ╔═╡ a9fb80ef-29e8-4dd9-9e37-ebb90f302e3e
md"🤔"

# ╔═╡ f225a5b5-d3ea-4c6f-8199-21ccfce0b003
@xbind benchmark_pycode CheckBox()

# ╔═╡ 0cca40d8-6c1a-469c-9b1e-d050e793a274
if benchmark_pycode @benchmark $(py"factorial")(1000) end

# ╔═╡ ee6182d7-52c2-4f8c-b74c-e50a2768587e
md"Dynamic typed language uses `Box(type, *data)` to represent an object."

# ╔═╡ 88b11d8a-c1e2-4d83-8c04-2543c0d141c7
md"Cache miss!"

# ╔═╡ 30e7724e-85dd-4167-85c0-185a7b527d3d
md"""## Two languages, e.g. Python & C/C++?
### From the maintainance's perspective
* Requires a build system and configuration files,
* Not easy to train new developers.

### There are many problems can not be vectorized
* Monte Carlo method and simulated annealing method,
* Generic Tensor Network method: the tensor elements has tropical algebra or finite field algebra,
* Branching and bound.

![](https://user-images.githubusercontent.com/6257240/200309092-6a138366-ac52-47e5-a010-47711612632b.png)
"""

# ╔═╡ d2054620-3178-4c7f-82cd-e12b039494a3
md"""
# Julia's solution
"""

# ╔═╡ f220b2bb-34ef-40be-8d81-6c2226569df3
md"## Julia compiling stages"

# ╔═╡ 59682a19-0e88-48bc-a747-b7d6d3ee7333
md"### 1. You computer gets a Julia program"

# ╔═╡ d2429055-58e9-4d84-894f-2e639723e078
function jlfactorial(n::Int)
	x = 1
	for i in 1:n
    	x = x * i
	end
	return x
end

# ╔═╡ bd4a5b95-0582-4b86-9403-7a49866af13b
md"Method instance is a compiled binary of a function for specific input types. When the function is written, the binary is not yet generated."

# ╔═╡ d4f68828-b4e3-4e99-9229-16432cf2afda
methodinstances(jlfactorial)

# ╔═╡ 42a3a248-5937-4496-b6d3-30387b240690
md"""
### 2. When calling a function, the Julia compiler infers types of variables on an intermediate Representation
"""

# ╔═╡ b1c9b8b2-c46b-4967-a233-4b4d35a52b90
mermaid"""
flowchart LR;
A("Call a Julia function") --> B{has method instance?}
B -- N --> N[infer types<br>& compile] --> C("binary")
C --> |execute| Z("result")
B -- Y --> C
"""

# ╔═╡ 4f5a8dfa-becb-44ab-aac5-ca3f48658053
with_terminal() do
	@code_warntype jlfactorial(10)
end

# ╔═╡ 96af110d-ac2d-410a-bf6b-b0f40c09b883
md"Sometimes, type can not be uniquely determined at the runtime."

# ╔═╡ f4667fb0-fd98-458e-bd3b-1c23d50209ed
with_terminal() do
	unstable(x) = x > 3 ? 1.0 : 3
	@code_warntype unstable(4)
end

# ╔═╡ 9c34819e-3ece-4d19-b90d-347a31875fb0
md"""
### 3. The typed program is then compiled to LLVM IR
$(html"<img src='https://upload.wikimedia.org/wikipedia/en/d/dd/LLVM_logo.png' width=200/>")
"""

# ╔═╡ 6529138b-b3f4-470a-af30-519608217688
md"""
LLVM is a set of compiler and toolchain technologies that can be used to develop a front end for any programming language and a back end for any instruction set architecture.
LLVM is the backend of multiple languages, including Julia, Rust, Swift and Kotlin.
"""

# ╔═╡ 4359a206-f4cf-4a83-87b6-3adf1c4afdfd
with_terminal() do 
	@code_llvm jlfactorial(10)
end

# ╔═╡ 95716242-94a5-45bf-8b6b-3ced2508d519
md"""
### 4. LLVM IR does some optimization, and then compiled to binary code.
"""

# ╔═╡ b79a755a-195b-4c9e-ae5f-b52f4a55f52c
with_terminal() do
	@code_native jlfactorial(10)
end

# ╔═╡ 40a91709-d217-48ab-90f1-0a5e02368da8
jlfactorial(1000)

# ╔═╡ 32039282-5981-4634-9442-8e02ce0d9c52
methodinstances(jlfactorial)

# ╔═╡ 8d726b29-6215-49b8-a93b-6966702ecc16
@xbind benchmark_jlcode CheckBox()

# ╔═╡ 6b6d4a14-f6cf-4cbe-87eb-7e5f6874fb2e
if benchmark_jlcode @benchmark jlfactorial(x) setup=(x=1000) end

# ╔═╡ ac46f30f-a86a-481d-af18-b0ea5129e949
md"""## The key ingredients of performance
* Rich **type** information, provided naturally by **multiple dispatch**;
* aggressive code specialization against **run-time** types;
* **JIT** compilation using the **LLVM** compiler framework.
"""

# ╔═╡ 41f7fa54-647a-4223-94c6-4801cfd3b2c0
md"""
## Should a method be owned by a type/class?
Implement function addition in Python.
```python
class X:
  def __init__(self, num):
    self.num = num

  def __add__(self, other_obj):
    return X(self.num+other_obj.num)

  def __radd__(self, other_obj):
    return X(other_obj.num + self.num)

  def __str__(self):
    return "X = " + str(self.num)

class Y:
  def __init__(self, num):
    self.num = num

  def __radd__(self, other_obj):
    return Y(self.num+other_obj.num)

  def __str__(self):
    return "Y = " + str(self.num)

print(X(3) + Y(5))


print(Y(3) + X(5))

```
"""

# ╔═╡ 85d3e8a3-502e-4423-95de-b4dd599035aa
# Julian style
struct X{T}
	num::T
end

# ╔═╡ 513b6cf8-de61-4245-8cdb-91ad1f1a485e
struct Y{T}
	num::T
end

# ╔═╡ 5295d636-51af-4c65-a9a8-e379cd52d52d
Base.:(+)(a::X, b::Y) = X(a.num + b.num)

# ╔═╡ fda8c5c5-35a1-4390-81b5-a2e3134e1f36
Base.:(+)(a::Y, b::X) = X(a.num + b.num)

# ╔═╡ aa03188b-752b-4d9d-bb76-2097f7a9f46b
Base.:(+)(a::X, b::X) = X(a.num + b.num)

# ╔═╡ 3142ef38-f0b6-4533-9404-5c71af7f4e47
Base.:(+)(a::Y, b::Y) = Y(a.num + b.num)

# ╔═╡ 49dfa81a-bbdc-4aeb-b752-750ea57ad069
md"""
If `C` wants to extend this method to a new type `Z`.
"""

# ╔═╡ c983ae19-3296-49b9-ac2b-717df2a6e068
md"""
```python
class Z:
  def __init__(self, num):
    self.num = num

  def __add__(self, other_obj):
    return Z(self.num+other_obj.num)

  def __radd__(self, other_obj):
    return Z(other_obj.num + self.num)

  def __str__(self):
    return "Z = " + str(self.num)

print(X(3) + Z(5))

print(Z(3) + X(5))
```
"""

# ╔═╡ c0a47030-301d-4911-9847-f5ffe557c2cd
struct Z{T}
	num::T
end

# ╔═╡ 93d5d096-0023-4ee4-abf4-7691d9cb5d7c
Base.:(+)(a::X, b::Z) = Z(a.num + b.num)

# ╔═╡ 725643b4-3be6-4d81-b028-16dfb3cd4961
Base.:(+)(a::Z, b::X) = Z(a.num + b.num)

# ╔═╡ c57c7aed-7338-49bc-ac9e-c240365b86de
Base.:(+)(a::Y, b::Z) = Z(a.num + b.num)

# ╔═╡ fb9d547d-d894-460b-8fbb-4f4f923710b1
Base.:(+)(a::Z, b::Y) = Z(a.num + b.num)

# ╔═╡ 2ded9376-c060-410c-bc14-0a5d28b217e5
Base.:(+)(a::Z, b::Z) = Z(a.num + b.num)

# ╔═╡ 0380f2f3-be04-4629-bd00-11f972d6bb9b
@drawsvg begin
	x0 = -50
	for i=1:4
		y0 = 40 * i - 100
		box(Point(x0, y0), 50, 40; action=:stroke)
		box(Point(x0+50, y0), 50, 40; action=:stroke)
		setcolor("#88CC66")
		circle(Point(x0+120, y0), 15; action=:fill)
		setcolor("black")
		text("type", Point(x0, y0); halign=:center, valign=:center)
		text("*data", Point(x0+50, y0); halign=:center, valign=:middle)
		text("data", Point(x0+120, y0); halign=:center, valign=:middle)
		arrow(Point(x0+50, y0-10), Point(x0+70, y0-30), Point(x0+90, y0-30), Point(x0+110, y0-10), :stroke)
	end
end 200 200

# ╔═╡ ab30507c-006b-4944-b175-3a00a228fc3a
X(3) + Y(5)

# ╔═╡ f75adcaf-34e1-40c9-abb3-5243f61a8037
Y(3) + X(5)

# ╔═╡ bb6bd575-690f-4165-84f7-3126eefc2ce4
X(3) + Z(5)

# ╔═╡ a6dba5a5-d27f-48fa-880a-cfa87de22a93
Z(3) + Y(5)

# ╔═╡ 2b3d5fa3-7b53-4dbb-bb80-586e98c082ec
md"""
## Julia function space is exponetially large!
Quiz: If a function $f$ has $k$ parameters, and the module has $t$ types, how many different functions can be generated?
```jula
f(x::T1, y::T2, z::T3...)
```

If it is an object-oriented language like Python？
```python
class T1:
    def f(self, y, z, ...):
        self.num = num

```
"""

# ╔═╡ 8c355756-0524-4ac4-92e3-a164605b53a5
md"""## Julia type system
"""

# ╔═╡ 7b5418cb-f30a-42b7-a2d4-9db9166ed5bf
md"""
* primitive type, e.g. Float64, Int32, UInt8, Bool,
* abstract type, a type for subtyping,
* concrete type, leaf nodes of a type system.
"""

# ╔═╡ 2435a0f0-b146-4c28-9f51-7ed2aa3a9f9f
md"""
## Example
"""

# ╔═╡ ccdebde5-5d7e-4395-9a47-e6c82ff7d72e
# the definition of an abstract type
abstract type A end

# ╔═╡ 992fd82a-a77e-42dd-a778-2eb38c4e82cd
# the definition of a concrete type
struct C <: A
	member1::Float64
	member2::Int
end

# ╔═╡ 8a1b06e6-c146-42db-ac79-b98bfe59e6d5
md"""
### Numbers
"""

# ╔═╡ dd37e58c-6687-4c3e-87fa-677117113065
PlutoLecturing.print_type_tree(Number)

# ╔═╡ cfdab8b5-e6b4-47b7-9e50-c2f6742ee35d
md"`<:` is the symbol for sybtyping， `A <: B` means A is a subtype of B。"

# ╔═╡ bfb02ae8-1725-4446-a8f6-8a398765785a
AbstractFloat <: Number

# ╔═╡ cfc426d8-95dc-4d1b-8655-5b260ac6eafd
md"`Any` is a parent type of any other type"

# ╔═╡ b83882d5-5c40-449d-b926-c87d191e504f
Number <: Any

# ╔═╡ 68f786f5-0f81-4185-8da6-8ac029831316
md"A type contains two parts: type name and type parameters"

# ╔═╡ e5a16795-bd1c-44f4-8676-2edb525cfa3a
# TypeName{type parameters...}
Complex{Float64}  # a commplex number with real and imaginary parts being Float64

# ╔═╡ 8d4c3a8a-a735-4924-a00b-a30ae8e206d0
fieldnames(Complex)

# ╔═╡ ec549f07-b8b1-4938-8e80-895d587c41a9
Base.isprimitivetype(Float64)

# ╔═╡ f2d766d4-030e-4f98-838b-12e7610a658f
Base.isabstracttype(AbstractFloat)

# ╔═╡ 05d70420-6b43-4877-b47a-558f95067a94
Base.isconcretetype(Complex{Float64})

# ╔═╡ 3e60f6c6-059a-4623-8684-b97f2864aff9
md"Quiz: Is complex number a concrete type?"

# ╔═╡ 835a120e-6495-40a1-81dc-9dc82dde33b3
Base.isconcretetype(Complex)

# ╔═╡ 7565059d-01cd-44bb-940b-b0bf4f42a366
Base.isconcretetype(Complex{Float64})

# ╔═╡ ee9a30fe-2dd8-41d0-930d-a69df76d6fb2
md"To represent a complex number with its real and imaginary parts being floating point numbers"

# ╔═╡ 0fb42584-110c-479b-afb4-22b7d7ffca96
Complex{<:AbstractFloat}

# ╔═╡ dfeff985-cd21-4171-b974-af4f8a159268
Complex{Float64} <: Complex{<:AbstractFloat}

# ╔═╡ 38e615e7-de6b-4d98-b643-c288ab2a636f
Complex{Float64} <: Complex{AbstractFloat}

# ╔═╡ 077c6e89-e2f5-44d2-b116-b2be5e1f8f1a
md"true or false？"

# ╔═╡ ebab5603-29a0-43c2-847d-858b31438180
isconcretetype(Complex{AbstractFloat})

# ╔═╡ f6b6ad42-ffe6-4550-b600-ed1f9f76c75b
md"They are different!"

# ╔═╡ db6a0eb0-f296-483c-8202-71ba41112e84
vany = Any[]

# ╔═╡ 5fe33249-e003-4f7a-b3ee-dcf377bf179a
vany isa Vector{Any}

# ╔═╡ 6f2cc362-e645-4f88-b6a9-d2133294416c
vany isa Vector{<:Any}

# ╔═╡ 1020a949-d3a0-46b2-9f67-a518a59c481d
push!(vany, "a")

# ╔═╡ 9b7c0da5-0f77-43c4-bcfa-541ab47c99df
vfloat64 = Float64[]

# ╔═╡ 1efcfa4a-7cb9-487b-a50d-752eebc3d796
vfloat64 isa Vector{<:Any}

# ╔═╡ 1ca44ba4-cdaa-4af8-896f-8f4ee3d28cd0
vfloat64 isa Vector{Any}

# ╔═╡ b48d3acd-79ca-430c-8856-90c1638325e4
push!(vfloat64, "a")

# ╔═╡ c9541faf-58e6-4e7f-b5d1-9dbdf88ec1ff
md"We use `Union` to represent the union of two types"

# ╔═╡ 3eb0b70e-8c24-4f4b-8a93-f578800cbf98
Union{AbstractFloat, Complex} <: Number

# ╔═╡ 75e320db-ab50-4bd3-9d7a-5b02b0612c80
Union{AbstractFloat, Complex} <: Real

# ╔═╡ e7dacddd-7122-4b85-b582-68c5c4d5e5c9
md"Make an alias for a type name"

# ╔═╡ fd4b6587-ae17-4bee-9e1b-e8f3f512304e
FloatAndComplex{T} = Union{T, Complex{T}} where T<:AbstractFloat

# ╔═╡ 77cbbe31-43a7-4f96-8138-fbaff26a3a01
md"## Defining functions"

# ╔═╡ 5f39a607-7154-4043-9c24-e0c93e89d97c
begin
	# fallback
	function roughly_equal(x::Number, y::Number)
		@info "(::Number, ::Number)"
		x ≈ y   # type with \approx<TAB>
	end
	function roughly_equal(x::AbstractFloat, y::Number)
		@info "(::AbstractFloat, ::Number)"
		-10 * eps(x) < x - y < 10 * eps(x)
	end
	function roughly_equal(x::Number, y::AbstractFloat)
		@info "(::Number, ::AbstractFloat)"
		-10 * eps(y) < x - y < 10 * eps(y)
	end
end

# ╔═╡ 7eb69246-261e-491b-9762-325c9e5563bd
# `methods` is different from `methodinstances` in MethodAnalysis. It returns method definitions rather than compiled binaries.
methods(roughly_equal)

# ╔═╡ cb81069a-6e39-42e3-ac4b-a90f0f062e1c
roughly_equal(3.0, 3)  # case 1

# ╔═╡ 68da59a5-0e50-4eb9-8f3c-774033309817
md"The most concrete one wins"

# ╔═╡ dbe03d81-ac8c-40cc-b5de-d64ced95b5eb
roughly_equal(3, 3)    # case 2

# ╔═╡ 5e1b9705-d086-4654-9af3-de8e2a1bfb67
roughly_equal(3.0, 3.0)

# ╔═╡ dea0f941-9e26-43bd-b846-066c2af579f9
md"""Exponential abstraction power brings the ambiguity error
```julia
function roughly_equal(x::AbstractFloat, y::AbstractFloat)
	@info "(::AbstractFloat, ::AbstractFloat)"
	-10 * eps(y) < x - y < 10 * eps(y)
end
```"""

# ╔═╡ 2484c94c-9bcc-4096-a138-7c9e4fefddf7
md"Quiz: how many `f` method instances do we have now?"

# ╔═╡ 3b620367-9d60-49d4-b274-10e510be354f
methodinstances(roughly_equal)

# ╔═╡ f35cb384-17c5-43f0-95c8-68a43fdc657e
md"Align the type parameters"

# ╔═╡ de071f25-4188-4066-a87c-9e6ee2b987e6
begin
	function lmul(x::Complex{T1}, y::AbstractArray{<:Complex{T2}}) where {T1<:Real, T2<:Real}
		@info "(::Complex{T1}, ::AbstractArray{<:Complex{T2}}) where {T1<:Real, T2<:Real}"
		x .* y
	end
	function lmul(x::Complex{T}, y::AbstractArray{<:Complex{T}}) where T<:Real
		@info "(::Complex{T}, ::AbstractArray{<:Complex{T}}) where T<:Real"
		x .* y
	end
end

# ╔═╡ 020744e9-e13f-4947-b339-e2c846f1b26c
lmul(3.0im, randn(ComplexF64, 3, 3))

# ╔═╡ 9c434355-bb49-42e5-b766-d8820dd2bf7a
lmul(3im, randn(ComplexF64, 3, 3))

# ╔═╡ 976795fe-2d86-432a-b053-7425958ff349
md"""
# Summary
* Julia's mutiple dispatch provides exponential abstraction power comparing with an object-oriented language.
* By carefully designed type system, we can program in an exponentially large function space.
"""

# ╔═╡ b379b6e0-0f20-43ab-aa1e-5fca3ccfb190
md"""
# Julia package development
"""

# ╔═╡ 60a6710d-103b-4276-8073-6b342cc4d084
md"The file structure of a package"

# ╔═╡ ef447d76-36d4-44cf-9d74-28cbe855c780
project_folder = dirname(dirname(pathof(TropicalNumbers)))

# ╔═╡ 597c8447-0e37-4839-a9c2-b0aa2ae2e394
mermaid"""
graph TD;
A["pkg> add Yao"] --> B["Update registries from GitHub"] --> C["Resolve version and generate Manifest.toml"] --> D["Download the package from GitHub"]
D --> E["Install and precompile"]
"""

# ╔═╡ 8492b727-b52d-482e-adac-5e16d82bdd71
print_dir_tree(project_folder)

# ╔═╡ 84d3a681-ff36-4df1-93f7-8f0fc231d38c
md"""
## Unit Test
"""

# ╔═╡ aab91fd6-4220-4deb-8786-3e2a97ac89d4
let
	function circ(x0, text, r)
		setcolor("#88CC66")
		circle(x0, 0, r; action=:fill)
		setcolor("black")
		Luxor.text(text, x0, 0; halign=:center, valign=:middle)
	end
	@drawsvg begin
		circ(-150, "Correctness", 40)
		circ(-25, "Speed", 30)
		circ(100, "Others", 20)
		fontsize(30)
		text(">", -87, 0; halign=:center, valign=:middle)
		text(">", 37, 0; halign=:center, valign=:middle)
	end 400 100
end

# ╔═╡ 370da282-140e-4a72-89f0-860d58f2a474
@test Tropical(3.0) + Tropical(2.0) == Tropical(3.0)

# ╔═╡ 1f04dec9-fb22-49f5-933a-37d07f059c90
@test_throws BoundsError [1,2][3]

# ╔═╡ 824ad79e-d39b-40c0-b58e-3596a2d730db
@test_broken 3 == 2

# ╔═╡ bd7a4133-1805-415b-8df6-1ae5863ec520
@testset "Tropical Number addition" begin
	@test Tropical(3.0) + Tropical(2.0) == Tropical(3.0)
	@test_throws BoundsError [1][2]
	@test_broken 3 == 2
end

# ╔═╡ 95a6f8b7-fbc8-400a-b3db-8dcee60a6c7c
@xbind run_test CheckBox()

# ╔═╡ b468100c-3508-456a-9c31-a1e1c28175b6
if run_test
	with_terminal() do
		Pkg.test("TropicalNumbers")
	end
end

# ╔═╡ e7330666-d05e-4dc5-91da-2375351d0c54
md"[Learn more](https://docs.julialang.org/en/v1/stdlib/Test/)"

# ╔═╡ b05835b0-f111-42e7-bf62-c20bb1fbbba0
md"""
## Version control and dependency resolving
"""

# ╔═╡ 043a14db-7a97-464d-94f5-fb690b869d18
md"`Yao` as an example"

# ╔═╡ 51090bfe-b5c6-4529-936f-d79babd44009
md"## PkgTemplates
"

# ╔═╡ 3907b528-0d42-4b8e-b16b-1e66a27d8eaf
md"""
## Case study: Happy Molecules
[https://github.com/CodingThrust/HappyMolecules.jl](https://github.com/CodingThrust/HappyMolecules.jl)
"""

# ╔═╡ dca6c9d8-0074-45bf-b840-d36c24855174
md"""
## A brief tour of Julia scientific computing ecosystem
"""

# ╔═╡ eabf205e-3d1c-4d42-907a-050207490995
md"### [SciML](https://github.com/SciML) ecosystem
Differential equation
[![](https://camo.githubusercontent.com/97bf407cc473d22b3d9ef63c861e8dba6dd3b4579728c342c49be86b48ea180e/687474703a2f2f7777772e73746f636861737469636c6966657374796c652e636f6d2f77702d636f6e74656e742f75706c6f6164732f323031392f30382f64655f736f6c7665725f736f6674776172655f636f6d70617273696f6e2d312e706e67)](https://camo.githubusercontent.com/97bf407cc473d22b3d9ef63c861e8dba6dd3b4579728c342c49be86b48ea180e/687474703a2f2f7777772e73746f636861737469636c6966657374796c652e636f6d2f77702d636f6e74656e742f75706c6f6164732f323031392f30382f64655f736f6c7665725f736f6674776172655f636f6d70617273696f6e2d312e706e67)
"

# ╔═╡ a72562cc-ea4e-4e01-9cb3-d84785dd5a92
md"""### [JuMP](https://github.com/jump-dev) ecosystem
Linear Programming, Mixed Integer Programming, Quadratic Programming 等。
![](https://user-images.githubusercontent.com/6257240/204845810-702108b0-e5db-4b5c-9378-0aa0896af6de.png)
"""

# ╔═╡ 237a3f56-9458-449d-92b0-3135bce85fb7
md"### [Yao](https://github.com/QuantumBFS) ecosystem
Quantum Computing
"

# ╔═╡ 565745ca-b000-4ec0-b53e-a5062abc4b1b
md"""
![](https://github.com/Roger-luo/quantum-benchmarks/raw/master/images/pcircuit.png)
"""

# ╔═╡ 19c6976f-3bf5-4485-bd55-3e6a0eee3580
md"""
More such ecosystems are [BioJulia](https://github.com/BioJulia),
[JuliaDynamics](https://github.com/JuliaDynamics),
[EcoJulia](https://github.com/EcoJulia),
[JuliaAstro](https://github.com/JuliaAstro),
[QuantEcon](https://github.com/QuantEcon).
"""

# ╔═╡ 804c81b6-61ea-4817-a062-0ac93406ba85
md"## High performance computing ecosystem"

# ╔═╡ bd728688-28e1-42fc-a316-53b41587e255
md"""
### [CUDA](https://github.com/JuliaGPU/CUDA.jl) ecosystem
CUDA programming in Julia.

![](https://juliagpu.org/assets/img/cuda-performance.png)
"""

# ╔═╡ 54142ab7-ad54-4844-8499-67a39d6a3007
md"""
### [LoopVectorization](https://github.com/JuliaSIMD/LoopVectorization.jl) ecosystem
Macro(s) for vectorizing loops (SIMD).
![](https://raw.githubusercontent.com/JuliaSIMD/LoopVectorization.jl/docsassets/docs/src/assets/bench_dot_v2.svg)

TropicalGEMM: A BLAS for tropical numbers.
![](https://github.com/TensorBFS/TropicalGEMM.jl/raw/master/benchmarks/benchmark-float64.png)
"""

# ╔═╡ ab2d522a-14ab-43b3-9eb0-0c4015e04679
md"# Live coding"

# ╔═╡ 930e39d2-80b9-4250-bdfe-477857b2f6ea
livecoding("https://raw.githubusercontent.com/GiggleLiu/notebooks/julia-tutorial/livecoding/1.basic/main.cast")

# ╔═╡ Cell order:
# ╠═39479e02-fc99-4b27-ae04-b2ef94f24cf0
# ╠═cb5259ae-ce92-4197-8f51-bf6d9e371a25
# ╠═a82f898d-129d-4585-bca7-45814dcceeb9
# ╟─785c7656-117e-47b5-8a6c-8d11d561ddf7
# ╟─0a884afd-49e5-41f3-b808-cc4c2dccf26a
# ╟─6f4a9990-0b9b-4574-8e00-7d16a4b9f391
# ╟─9d84d2d5-ba4c-4004-8386-41492ec66674
# ╟─dcee31b8-a384-4718-950e-d1c5a52df29e
# ╟─f9037c77-a7af-4b16-85a5-5eb9c8b74bb9
# ╟─861ed080-c2ca-4766-a0a4-5fbb16688915
# ╟─216b9efd-7a47-41e3-aeff-519fb934d781
# ╟─7acd68c6-af4e-4ba0-81d8-85b9a181c537
# ╠═f5e0e47c-4ab4-4d6b-941a-48ea2430a313
# ╠═26a35e13-a033-40d5-b964-ee6bc7d874db
# ╠═8c15d3ec-aa68-4a27-8a17-b8a9f5e97149
# ╠═bd058399-1274-4a8d-bc49-a5999bd3a5ef
# ╠═dc1178f2-fd17-4ca2-907a-267851cf2ea9
# ╠═0a176011-0423-4971-b89a-2e8fb197d7b6
# ╠═45ceeffe-9a3a-430f-9844-f5b3806dfb0c
# ╠═bd50a691-503a-4ab0-a836-ea380a1931ae
# ╟─63fe0c9a-365c-4c9b-a26d-56faf24a5f85
# ╠═b460f115-2d18-4e0f-8732-0e8766c96888
# ╟─3b840c20-cf23-4ccc-b6a9-f0fe34c10925
# ╟─e7d36996-6a74-4183-aade-3f34b8fe4074
# ╟─652f473f-3ab5-417f-8ab9-8f3fd9d4f754
# ╠═0cbe52d2-6661-4712-b367-0f57c5e4e3c2
# ╠═dfd977be-12cb-4f68-9425-2c09cf69232a
# ╠═1c5ec173-7af1-4454-bbec-e8d8096b0490
# ╠═50b5c202-ad20-47aa-b03f-08e45c8498e3
# ╟─a9fb80ef-29e8-4dd9-9e37-ebb90f302e3e
# ╟─f225a5b5-d3ea-4c6f-8199-21ccfce0b003
# ╠═0cca40d8-6c1a-469c-9b1e-d050e793a274
# ╟─ee6182d7-52c2-4f8c-b74c-e50a2768587e
# ╟─0380f2f3-be04-4629-bd00-11f972d6bb9b
# ╟─88b11d8a-c1e2-4d83-8c04-2543c0d141c7
# ╟─30e7724e-85dd-4167-85c0-185a7b527d3d
# ╟─d2054620-3178-4c7f-82cd-e12b039494a3
# ╟─f220b2bb-34ef-40be-8d81-6c2226569df3
# ╟─59682a19-0e88-48bc-a747-b7d6d3ee7333
# ╠═d2429055-58e9-4d84-894f-2e639723e078
# ╟─bd4a5b95-0582-4b86-9403-7a49866af13b
# ╠═640558dd-e6e0-4b84-9b93-c454ecf8acb9
# ╠═d4f68828-b4e3-4e99-9229-16432cf2afda
# ╟─42a3a248-5937-4496-b6d3-30387b240690
# ╟─b1c9b8b2-c46b-4967-a233-4b4d35a52b90
# ╠═4f5a8dfa-becb-44ab-aac5-ca3f48658053
# ╟─96af110d-ac2d-410a-bf6b-b0f40c09b883
# ╠═f4667fb0-fd98-458e-bd3b-1c23d50209ed
# ╟─9c34819e-3ece-4d19-b90d-347a31875fb0
# ╟─6529138b-b3f4-470a-af30-519608217688
# ╠═4359a206-f4cf-4a83-87b6-3adf1c4afdfd
# ╟─95716242-94a5-45bf-8b6b-3ced2508d519
# ╠═b79a755a-195b-4c9e-ae5f-b52f4a55f52c
# ╠═40a91709-d217-48ab-90f1-0a5e02368da8
# ╠═32039282-5981-4634-9442-8e02ce0d9c52
# ╟─8d726b29-6215-49b8-a93b-6966702ecc16
# ╠═6b6d4a14-f6cf-4cbe-87eb-7e5f6874fb2e
# ╟─ac46f30f-a86a-481d-af18-b0ea5129e949
# ╟─41f7fa54-647a-4223-94c6-4801cfd3b2c0
# ╠═85d3e8a3-502e-4423-95de-b4dd599035aa
# ╠═513b6cf8-de61-4245-8cdb-91ad1f1a485e
# ╠═5295d636-51af-4c65-a9a8-e379cd52d52d
# ╠═fda8c5c5-35a1-4390-81b5-a2e3134e1f36
# ╠═aa03188b-752b-4d9d-bb76-2097f7a9f46b
# ╠═3142ef38-f0b6-4533-9404-5c71af7f4e47
# ╟─49dfa81a-bbdc-4aeb-b752-750ea57ad069
# ╟─c983ae19-3296-49b9-ac2b-717df2a6e068
# ╠═c0a47030-301d-4911-9847-f5ffe557c2cd
# ╠═93d5d096-0023-4ee4-abf4-7691d9cb5d7c
# ╠═725643b4-3be6-4d81-b028-16dfb3cd4961
# ╠═c57c7aed-7338-49bc-ac9e-c240365b86de
# ╠═fb9d547d-d894-460b-8fbb-4f4f923710b1
# ╠═2ded9376-c060-410c-bc14-0a5d28b217e5
# ╠═ab30507c-006b-4944-b175-3a00a228fc3a
# ╠═f75adcaf-34e1-40c9-abb3-5243f61a8037
# ╠═bb6bd575-690f-4165-84f7-3126eefc2ce4
# ╠═a6dba5a5-d27f-48fa-880a-cfa87de22a93
# ╟─2b3d5fa3-7b53-4dbb-bb80-586e98c082ec
# ╟─8c355756-0524-4ac4-92e3-a164605b53a5
# ╟─7b5418cb-f30a-42b7-a2d4-9db9166ed5bf
# ╟─2435a0f0-b146-4c28-9f51-7ed2aa3a9f9f
# ╠═ccdebde5-5d7e-4395-9a47-e6c82ff7d72e
# ╠═992fd82a-a77e-42dd-a778-2eb38c4e82cd
# ╟─8a1b06e6-c146-42db-ac79-b98bfe59e6d5
# ╠═dd37e58c-6687-4c3e-87fa-677117113065
# ╟─cfdab8b5-e6b4-47b7-9e50-c2f6742ee35d
# ╠═bfb02ae8-1725-4446-a8f6-8a398765785a
# ╟─cfc426d8-95dc-4d1b-8655-5b260ac6eafd
# ╠═b83882d5-5c40-449d-b926-c87d191e504f
# ╟─68f786f5-0f81-4185-8da6-8ac029831316
# ╠═e5a16795-bd1c-44f4-8676-2edb525cfa3a
# ╠═8d4c3a8a-a735-4924-a00b-a30ae8e206d0
# ╠═ec549f07-b8b1-4938-8e80-895d587c41a9
# ╠═f2d766d4-030e-4f98-838b-12e7610a658f
# ╠═05d70420-6b43-4877-b47a-558f95067a94
# ╟─3e60f6c6-059a-4623-8684-b97f2864aff9
# ╠═835a120e-6495-40a1-81dc-9dc82dde33b3
# ╠═7565059d-01cd-44bb-940b-b0bf4f42a366
# ╟─ee9a30fe-2dd8-41d0-930d-a69df76d6fb2
# ╠═0fb42584-110c-479b-afb4-22b7d7ffca96
# ╠═dfeff985-cd21-4171-b974-af4f8a159268
# ╠═38e615e7-de6b-4d98-b643-c288ab2a636f
# ╠═077c6e89-e2f5-44d2-b116-b2be5e1f8f1a
# ╠═ebab5603-29a0-43c2-847d-858b31438180
# ╟─f6b6ad42-ffe6-4550-b600-ed1f9f76c75b
# ╠═db6a0eb0-f296-483c-8202-71ba41112e84
# ╠═5fe33249-e003-4f7a-b3ee-dcf377bf179a
# ╠═6f2cc362-e645-4f88-b6a9-d2133294416c
# ╠═1020a949-d3a0-46b2-9f67-a518a59c481d
# ╠═9b7c0da5-0f77-43c4-bcfa-541ab47c99df
# ╠═1efcfa4a-7cb9-487b-a50d-752eebc3d796
# ╠═1ca44ba4-cdaa-4af8-896f-8f4ee3d28cd0
# ╠═b48d3acd-79ca-430c-8856-90c1638325e4
# ╟─c9541faf-58e6-4e7f-b5d1-9dbdf88ec1ff
# ╠═3eb0b70e-8c24-4f4b-8a93-f578800cbf98
# ╠═75e320db-ab50-4bd3-9d7a-5b02b0612c80
# ╟─e7dacddd-7122-4b85-b582-68c5c4d5e5c9
# ╠═fd4b6587-ae17-4bee-9e1b-e8f3f512304e
# ╟─77cbbe31-43a7-4f96-8138-fbaff26a3a01
# ╠═5f39a607-7154-4043-9c24-e0c93e89d97c
# ╠═7eb69246-261e-491b-9762-325c9e5563bd
# ╠═cb81069a-6e39-42e3-ac4b-a90f0f062e1c
# ╟─68da59a5-0e50-4eb9-8f3c-774033309817
# ╠═dbe03d81-ac8c-40cc-b5de-d64ced95b5eb
# ╠═5e1b9705-d086-4654-9af3-de8e2a1bfb67
# ╟─dea0f941-9e26-43bd-b846-066c2af579f9
# ╟─2484c94c-9bcc-4096-a138-7c9e4fefddf7
# ╠═3b620367-9d60-49d4-b274-10e510be354f
# ╟─f35cb384-17c5-43f0-95c8-68a43fdc657e
# ╠═de071f25-4188-4066-a87c-9e6ee2b987e6
# ╠═020744e9-e13f-4947-b339-e2c846f1b26c
# ╠═9c434355-bb49-42e5-b766-d8820dd2bf7a
# ╟─976795fe-2d86-432a-b053-7425958ff349
# ╟─b379b6e0-0f20-43ab-aa1e-5fca3ccfb190
# ╠═fdcb76f5-479f-410a-bdaa-a95216ca9ec9
# ╟─60a6710d-103b-4276-8073-6b342cc4d084
# ╠═ef447d76-36d4-44cf-9d74-28cbe855c780
# ╟─597c8447-0e37-4839-a9c2-b0aa2ae2e394
# ╠═8492b727-b52d-482e-adac-5e16d82bdd71
# ╟─84d3a681-ff36-4df1-93f7-8f0fc231d38c
# ╠═b40ecdbe-c062-4438-b165-5da3662b15b5
# ╟─aab91fd6-4220-4deb-8786-3e2a97ac89d4
# ╠═370da282-140e-4a72-89f0-860d58f2a474
# ╠═1f04dec9-fb22-49f5-933a-37d07f059c90
# ╠═824ad79e-d39b-40c0-b58e-3596a2d730db
# ╠═bd7a4133-1805-415b-8df6-1ae5863ec520
# ╟─95a6f8b7-fbc8-400a-b3db-8dcee60a6c7c
# ╠═b468100c-3508-456a-9c31-a1e1c28175b6
# ╟─e7330666-d05e-4dc5-91da-2375351d0c54
# ╟─b05835b0-f111-42e7-bf62-c20bb1fbbba0
# ╟─043a14db-7a97-464d-94f5-fb690b869d18
# ╟─51090bfe-b5c6-4529-936f-d79babd44009
# ╟─3907b528-0d42-4b8e-b16b-1e66a27d8eaf
# ╟─dca6c9d8-0074-45bf-b840-d36c24855174
# ╟─eabf205e-3d1c-4d42-907a-050207490995
# ╟─a72562cc-ea4e-4e01-9cb3-d84785dd5a92
# ╟─237a3f56-9458-449d-92b0-3135bce85fb7
# ╟─565745ca-b000-4ec0-b53e-a5062abc4b1b
# ╟─19c6976f-3bf5-4485-bd55-3e6a0eee3580
# ╟─804c81b6-61ea-4817-a062-0ac93406ba85
# ╟─bd728688-28e1-42fc-a316-53b41587e255
# ╟─54142ab7-ad54-4844-8499-67a39d6a3007
# ╟─ab2d522a-14ab-43b3-9eb0-0c4015e04679
# ╟─930e39d2-80b9-4250-bdfe-477857b2f6ea
