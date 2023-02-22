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
using MethodAnalysis  # a package to analyse functions

# ╔═╡ 98ae699e-a3ea-4e94-9d23-8976de049431
using Plots

# ╔═╡ fdcb76f5-479f-410a-bdaa-a95216ca9ec9
using TropicalNumbers

# ╔═╡ b40ecdbe-c062-4438-b165-5da3662b15b5
using Test

# ╔═╡ a82f898d-129d-4585-bca7-45814dcceeb9
TableOfContents(depth=2)

# ╔═╡ b9b3ba05-eab9-487d-8f27-72059b8a848c
presentmode()

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
[![](https://julialang.org/assets/images/benchmarks.svg)](https://julialang.org/assets/images/benchmarks.svg)
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

# ╔═╡ 940b21b3-b56a-423d-aace-90858d0064ea
md"#### C code is typed."

# ╔═╡ f5e0e47c-4ab4-4d6b-941a-48ea2430a313
# A notebook utility to run code in a terminal style
with_terminal() do
	# display the file
	run(`cat clib/demo.c`)
end

# ╔═╡ c9debe3b-fe96-4b87-9dd3-5b16499ac109
md"#### C code needs to be compiled"

# ╔═╡ 26a35e13-a033-40d5-b964-ee6bc7d874db
# compile to a shared library by piping C_code to gcc;
# (only works if you have gcc installed)
run(`gcc clib/demo.c -fPIC -O3 -msse3 -shared -o clib/demo.so`)

# ╔═╡ 8c15d3ec-aa68-4a27-8a17-b8a9f5e97149
with_terminal() do
	# list all files
	run(`ls clib`)
end

# ╔═╡ 715b7cee-d818-48fe-abfe-e6707a843ad4
md"#### One can use `Libdl` package to open a shared library"

# ╔═╡ dc1178f2-fd17-4ca2-907a-267851cf2ea9
# @ccall is a julia macro
# a macro is a program for generating programs, just like the template in C++
# In Julia, we use `::` to specify the type of a variable
c_factorial(x) = Libdl.@ccall "clib/demo".c_factorial(x::Csize_t)::Int

# ╔═╡ 578deb27-cb28-46e9-be6c-22a6f938fe8e
md"#### Typed code may overflow, but is fast!"

# ╔═╡ 0a176011-0423-4971-b89a-2e8fb197d7b6
c_factorial(10)

# ╔═╡ 45ceeffe-9a3a-430f-9844-f5b3806dfb0c
c_factorial(1000)

# ╔═╡ 63fe0c9a-365c-4c9b-a26d-56faf24a5f85
@xbind benchmark_ccode CheckBox()

# ╔═╡ b460f115-2d18-4e0f-8732-0e8766c96888
if benchmark_ccode @benchmark c_factorial(1000) end

# ╔═╡ e7d36996-6a74-4183-aade-3f34b8fe4074
md"[learn more about calling C code in Julia](https://docs.julialang.org/en/v1/manual/calling-c-and-fortran-code/)"

# ╔═╡ 28382c69-e63d-4b2a-851d-b05f5779b2b1
md"Discussion: not all type specifications are nessesary."

# ╔═╡ 3b840c20-cf23-4ccc-b6a9-f0fe34c10925
md"## Executing a Pyhton Program"

# ╔═╡ 652f473f-3ab5-417f-8ab9-8f3fd9d4f754
md"#### Dynamic programming language does not require compiling"

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
#py"factorial"(1000)

# ╔═╡ 3807f507-3dc2-4a1f-965f-be3599d5f067
md"#### Dynamic typed language is more flexible, but slow!"

# ╔═╡ 50b5c202-ad20-47aa-b03f-08e45c8498e3
# `typemax` to get the maximum value
typemax(Int)

# ╔═╡ a9fb80ef-29e8-4dd9-9e37-ebb90f302e3e
md"🤔"

# ╔═╡ f225a5b5-d3ea-4c6f-8199-21ccfce0b003
@xbind benchmark_pycode CheckBox()

# ╔═╡ 0cca40d8-6c1a-469c-9b1e-d050e793a274
if benchmark_pycode @benchmark $(py"factorial")(1000) end

# ╔═╡ 923943b9-da11-4fe4-bf32-39971dcf0cdc
md"#### The reason why dynamic typed language is slow is related to caching."

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

# ╔═╡ 1b4095a0-f0ec-4794-83fe-8b7b1f3cf1d8
md"NOTE: I should open a Julia REPL now!"

# ╔═╡ 59682a19-0e88-48bc-a747-b7d6d3ee7333
md"### 1. You computer gets a Julia program"

# ╔═╡ d2429055-58e9-4d84-894f-2e639723e078
function jlfactorial(n)
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
### 2. When calling a function, the Julia compiler infers types of variables on an intermediate representation (IR)
"""

# ╔═╡ b1c9b8b2-c46b-4967-a233-4b4d35a52b90
mermaid"""
flowchart LR;
A("Call a Julia function") --> B{has method instance?}
B -- N --> N[infer types<br>& compile] --> C("binary")
C --> |execute| Z("result")
B -- Y --> C
"""

# ╔═╡ b5628e93-973a-4532-9014-d54ddbbee050
md"#### One can use `@code_warntype` or `@code_typed` to show this intermediate representation."

# ╔═╡ 4f5a8dfa-becb-44ab-aac5-ca3f48658053
with_terminal() do
	@code_warntype jlfactorial(10)  # or @code_typed without warning
end

# ╔═╡ 96af110d-ac2d-410a-bf6b-b0f40c09b883
md"""
`::` means type assertion in Julia.

#### Sometimes, type can not be uniquely determined at the runtime. This is called "type unstable"."""

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

# ╔═╡ a8480903-b05c-456d-accc-e9b7cfde4591
md"#### Aftering calling a function, a method instance will be generated."

# ╔═╡ 40a91709-d217-48ab-90f1-0a5e02368da8
jlfactorial(1000)

# ╔═╡ 32039282-5981-4634-9442-8e02ce0d9c52
methodinstances(jlfactorial)

# ╔═╡ ecb05073-3e34-42da-9a4f-bfd517474956
md"#### A new method will be generatd whenever there is a new type as the input."

# ╔═╡ b751784a-85bf-4758-905e-2bfb69d92c2b
jlfactorial(UInt32(10))

# ╔═╡ 53234cb9-8d50-4e50-be69-31aab56a1a53
methodinstances(jlfactorial)

# ╔═╡ 7ea178cf-3470-4cf0-9bea-44ee516a8633
md"#### Dynamically generating method instances is also called Just-in-time compiling (JIT), the secret why Julia is fast!"

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

# ╔═╡ 8c355756-0524-4ac4-92e3-a164605b53a5
md"""# Julia's type system
"""

# ╔═╡ 7b5418cb-f30a-42b7-a2d4-9db9166ed5bf
md"""
1. Abstract types, which may have declared subtypes and supertypes (a subtype relation is declared using the notation Sub <: Super) 
2. Composite types (similar to C structs), which have named fields and declared supertypes 
3. Bits types, whose values are represented as bit strings, and which have declared supertypes 
4. Tuples, immutable ordered collections of values 
5. Union types, abstract types constructed from other types via set union
"""

# ╔═╡ 8a1b06e6-c146-42db-ac79-b98bfe59e6d5
md"""
## Numbers
"""

# ╔═╡ e170eeea-0e8d-4932-aaea-fe306537a189
md"#### Type hierachy in Julia is a tree (without multiple inheritance)"

# ╔═╡ dd37e58c-6687-4c3e-87fa-677117113065
PlutoLecturing.print_type_tree(Number)

# ╔═╡ 82975999-1fb9-4638-9218-5751d28bd420
subtypes(Number)

# ╔═╡ 663946a8-7c04-431e-954b-79c43cca73a3
supertype(Float64)

# ╔═╡ bfb02ae8-1725-4446-a8f6-8a398765785a
AbstractFloat <: Real

# ╔═╡ 3131a388-702d-4e79-960a-225650ca396b
md"#### Abstract types does not have fields, while composite types have"

# ╔═╡ f2d766d4-030e-4f98-838b-12e7610a658f
Base.isabstracttype(Number)

# ╔═╡ 05d70420-6b43-4877-b47a-558f95067a94
# concrete type is more strict than composit
Base.isconcretetype(Complex{Float64})

# ╔═╡ 9e09ebdf-02ee-45c5-b242-c0bafc7f4426
fieldnames(Number)

# ╔═╡ 8d4c3a8a-a735-4924-a00b-a30ae8e206d0
fieldnames(Complex)

# ╔═╡ 1357484e-06e5-4536-9a8e-972e2fb84c8c
md"#### We have only finite primitive types on a machine, they are those supported natively by computer instruction."

# ╔═╡ ec549f07-b8b1-4938-8e80-895d587c41a9
Base.isprimitivetype(Float64)

# ╔═╡ cfc426d8-95dc-4d1b-8655-5b260ac6eafd
md"#### `Any` is a super type of any other type"

# ╔═╡ b83882d5-5c40-449d-b926-c87d191e504f
Number <: Any

# ╔═╡ 68f786f5-0f81-4185-8da6-8ac029831316
md"#### A type contains two parts: type name and type parameters"

# ╔═╡ e5a16795-bd1c-44f4-8676-2edb525cfa3a
# TypeName{type parameters...}
Complex{Float64}  # a commplex number with real and imaginary parts being Float64

# ╔═╡ c2e6de83-80f2-45a2-83a7-ba330df9bde1
md"#### ComplexF64 is a bits type, it has fixed size."

# ╔═╡ 0330f4a2-fbed-432c-8357-d7b6664ca983
isbitstype(Complex{Float64})

# ╔═╡ 702de85e-143f-4594-96c4-9745867f7b77
sizeof(Complex{Float32})

# ╔═╡ 686fb408-819a-424c-ad24-47e7604fad34
sizeof(Complex{Float64})

# ╔═╡ 45dadca0-ee12-490d-b7a5-124d7b2123a8
md"But `Complex{BigFloat}` is not"

# ╔═╡ 99a7acc6-1d9e-4efb-a0e4-98abfcf238cc
sizeof(Complex{BigFloat})

# ╔═╡ 0ae65cc6-a560-4e94-97c5-7f2f78c7a8c2
isbitstype(Complex{BigFloat})

# ╔═╡ 167fdd9b-cca3-4c9d-bd95-cb17055fd6aa
md"The size of Complex{BigFloat} is not true! It returns the pointer size!"

# ╔═╡ f0a6bafc-25d0-4e75-b8de-91794c45f9bc
md"#### A type can be neither abstract nor concrete."

# ╔═╡ ee9a30fe-2dd8-41d0-930d-a69df76d6fb2
md"To represent a complex number with its real and imaginary parts being floating point numbers"

# ╔═╡ 0fb42584-110c-479b-afb4-22b7d7ffca96
Complex{<:AbstractFloat}

# ╔═╡ dfeff985-cd21-4171-b974-af4f8a159268
Complex{Float64} <: Complex{<:AbstractFloat}

# ╔═╡ 9c88ca66-43e1-436f-b2ea-58d0e3a844a2
Base.isabstracttype(Complex{<:AbstractFloat})

# ╔═╡ ce9b4b44-c486-4db2-a222-4b322b1c5aa0
Base.isconcretetype(Complex{<:AbstractFloat})

# ╔═╡ c9541faf-58e6-4e7f-b5d1-9dbdf88ec1ff
md"#### We use `Union` to represent the union of two types"

# ╔═╡ 3eb0b70e-8c24-4f4b-8a93-f578800cbf98
Union{AbstractFloat, Complex} <: Number

# ╔═╡ 75e320db-ab50-4bd3-9d7a-5b02b0612c80
Union{AbstractFloat, Complex} <: Real

# ╔═╡ 98d415e8-80fd-487c-b1c3-d561ae254967
md"NOTE: it is similar to multiple inheritance, but `Union` can not have subtype!"

# ╔═╡ e7dacddd-7122-4b85-b582-68c5c4d5e5c9
md"#### You can make an alias for a type name if you think it is too long"

# ╔═╡ fd4b6587-ae17-4bee-9e1b-e8f3f512304e
FloatAndComplex{T} = Union{T, Complex{T}} where T<:AbstractFloat

# ╔═╡ 8eb05a38-63ba-4660-a034-20cbf38101be
md"## Case study: Vector element type and speed"

# ╔═╡ fce7d595-2787-4aae-a2cf-867586c64a1a
md"#### Any type vector is flexible. You can add any element into it."

# ╔═╡ db6a0eb0-f296-483c-8202-71ba41112e84
vany = Any[]  # same as vany = []

# ╔═╡ 5fe33249-e003-4f7a-b3ee-dcf377bf179a
typeof(vany)

# ╔═╡ 1020a949-d3a0-46b2-9f67-a518a59c481d
push!(vany, "a")

# ╔═╡ 3964d728-5e17-4200-b2ec-9a010657cfa4
push!(vany, 1)

# ╔═╡ b9adf808-11cc-484d-862b-1e624aebe8a2
md"#### Fixed typed vector is more restrictive."

# ╔═╡ 9b7c0da5-0f77-43c4-bcfa-541ab47c99df
vfloat64 = Float64[]

# ╔═╡ 1efcfa4a-7cb9-487b-a50d-752eebc3d796
vfloat64 |> typeof

# ╔═╡ b48d3acd-79ca-430c-8856-90c1638325e4
push!(vfloat64, "a")

# ╔═╡ a4158324-82ef-4d09-8fd7-59867d301c14
md"#### But type stable vectors are faster!"

# ╔═╡ 08a86fcb-da29-407b-9914-73379c703b86
@xbind run_any_benchmark CheckBox()

# ╔═╡ 26a8f8bb-de04-459e-b4e4-8e01b14328a7
@xbind run_float_benchmark CheckBox()

# ╔═╡ 897abf5d-e9c8-446a-b2fc-64d43c7025b1
md"# Multiple dispatch"

# ╔═╡ ccdebde5-5d7e-4395-9a47-e6c82ff7d72e
# the definition of an abstract type
# L is the number of legs
abstract type AbstractAnimal{L} end

# ╔═╡ 992fd82a-a77e-42dd-a778-2eb38c4e82cd
# the definition of a concrete type
struct Dog <: AbstractAnimal{4}
	color::String
end

# ╔═╡ cfdab8b5-e6b4-47b7-9e50-c2f6742ee35d
md"`<:` is the symbol for sybtyping， `A <: B` means A is a subtype of B."

# ╔═╡ bac1adb2-6952-4d52-bdac-dd6a0879b770
struct Cat <: AbstractAnimal{4}
	color::String
end

# ╔═╡ 0b13e7f8-c101-4dec-9904-1ebc3231b3d6
struct Cock <: AbstractAnimal{2}
	gender::Bool
end

# ╔═╡ 86169c92-0891-4516-8c5d-ebcfcee128dc
struct Human{FT <: Real} <: AbstractAnimal{2}
	height::FT
	function Human(height::T) where T <: Real
		if height <= 0 || height > 300
			error("The tall of a Human being must be in range 0~300, got $(height)")
		end
		return new{T}(height)
	end
end

# ╔═╡ 94fcbc31-ede2-416a-a6ba-0e149c25e53d
md"#### One can implement the same function on different types"

# ╔═╡ cdf0c539-8791-404a-a65d-9dd095b667cf
md"The most general one as the fall back method"

# ╔═╡ bb2445b8-35b5-4ae2-a688-308c7fafc497
fight(a::AbstractAnimal, b::AbstractAnimal) = "draw"

# ╔═╡ d785d6bf-5c2e-4796-b7f9-52488bde6354
md"#### The most concrete method is called"

# ╔═╡ e6fc61d7-b163-481c-8a47-7697a24af1a8
fight(dog::Dog, cat::Cat) = "win"

# ╔═╡ 73dc694f-23c2-4816-9c72-65336e89c1c2
fight(hum::Human, a::AbstractAnimal) = "win"

# ╔═╡ a703d5b9-0123-4a93-878b-2f9ca6791601
fight(hum::Human, a::Union{Dog, Cat}) = "loss"

# ╔═╡ 8d9c18f2-a82d-4f80-aea2-7bf2b899d229
md"#### Be careful about the ambiguity error!"

# ╔═╡ a95c6a36-95df-487c-b98f-42431033930e
fight(hum::AbstractAnimal, a::Human) = "loss"

# ╔═╡ 0946c055-4b0c-4058-b073-15b9963dbacc
md"The combination of two types."

# ╔═╡ 4bed73a0-8ac6-40fc-8ece-58ed51092e6f
@xbind define_human_fight CheckBox()

# ╔═╡ ee7ae309-121e-424d-aa71-b020d4048595
if define_human_fight
	fight(hum::Human{T}, hum2::Human{T}) where T<:Real = hum.height > hum2.height ? "win" : "loss"
end

# ╔═╡ 03a3098e-4031-4acc-8521-d2abac148dcb
fight(Cock(true), Cat("red"))

# ╔═╡ 3ca1d598-aefb-4d80-b8ff-8c5d0ec359cf
fight(Dog("blue"), Cat("white"))

# ╔═╡ c9e88a31-e7af-4884-a2a3-ccd147225f2f
fight(Human(180), Cat("white"))

# ╔═╡ 8e87ab3f-68b1-421a-b204-74ee71a3ab41
fight(Human(170), Human(180))

# ╔═╡ 4edcdfaf-d61d-4a9a-9a7d-93dd2b429a64
md"Quiz: How many method instances are generated for fight so far?"

# ╔═╡ a7086af5-2687-4c87-b894-988618317c7c
methodinstances(fight)

# ╔═╡ ec835542-32fe-4c74-ae7c-4f96972ae83f
md"#### A final comment: do not abuse the type system, otherwise the main memory might explode for generating too many functions."

# ╔═╡ 727e7b18-ca58-41dd-92a1-4635333e6a49
@xbind run_dynamic_benchmark CheckBox()

# ╔═╡ 4786a882-37d1-492f-ba5d-60129bdc554d
md"""#### A "zero" cost implementation"""

# ╔═╡ 6085b373-d41d-4cdd-8503-1d653504c865
Val(3.0) # just a type

# ╔═╡ 9da91c4d-a1bd-41f9-8715-d9043b06860c
f(::Val{1}) = Val(1)

# ╔═╡ 482876d6-25ea-44ce-a278-571f5a04a7b8
f(::Val{2}) = Val(1)

# ╔═╡ d10a5fb2-6b59-4b8e-965f-943f2301af88
@xbind run_static_benchmark CheckBox()

# ╔═╡ 02956688-53b9-4dba-905f-bac3b49a3327
md"However, this violates the [Performance Tips](https://docs.julialang.org/en/v1/manual/performance-tips/), since it transfers the run-time to compile time."

# ╔═╡ 41f7fa54-647a-4223-94c6-4801cfd3b2c0
md"""
## Multiple dispatch is more powerful than object-oriented programming!
Implement addition in Python.
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

# ╔═╡ 60a4cd54-da72-469b-986d-da7126990046
md"Implement addition in Julia"

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

# ╔═╡ 8380403f-f0f1-4d5a-b82d-96550d9ef69b
md"#### Multiple dispatch is easier to extend!"

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
		Luxor.text("type", Point(x0, y0); halign=:center, valign=:center)
		Luxor.text("*data", Point(x0+50, y0); halign=:center, valign=:middle)
		Luxor.text("data", Point(x0+120, y0); halign=:center, valign=:middle)
		Luxor.arrow(Point(x0+50, y0-10), Point(x0+70, y0-30), Point(x0+90, y0-30), Point(x0+110, y0-10), :stroke)
	end
end 200 200

# ╔═╡ a252de65-257b-422d-a612-5e85a30ea0c9
if run_any_benchmark
	let biganyv = collect(Any, 1:2:20000)
		@benchmark for i=1:length($biganyv)
			$biganyv[i] += 1
		end
	end
end

# ╔═╡ 8fe44a3b-7c42-4f93-87b0-6b2110d453f7
if run_float_benchmark
	let bigfloatv = collect(Float64, 1:2:20000)
		@benchmark for i=1:length($bigfloatv)
			$bigfloatv[i] += 1
		end
	end
end

# ╔═╡ e2dca383-c4ad-4f8a-b203-8de982cbcc4f
# NOTE: this is not the best way of implementing fibonacci sequencing
fib(x::Int) = x <= 2 ? 1 : fib(x-1) + fib(x-2)

# ╔═╡ f1fc72f8-a153-4e93-9e7e-04fe60162ddc
if run_dynamic_benchmark @benchmark fib(20) end

# ╔═╡ 46c46c26-f80a-45dd-b343-c6d88fa645e8
addup(::Val{x}, ::Val{y}) where {x, y} = Val(x + y)

# ╔═╡ a7763a0c-998e-4830-a403-9885f98bf070
f(::Val{x}) where x = addup(f(Val(x-1)), f(Val(x-2)))

# ╔═╡ 9d0b0d38-eecc-4a0d-bbcb-e26701bf4d65
if run_static_benchmark @benchmark f(Val(20)) end

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
### Julia function space is exponetially large!
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

# ╔═╡ 976795fe-2d86-432a-b053-7425958ff349
md"""
## Summary
* *Multiple dispatch* is a feature of some programming languages in which a function or method can be dynamically dispatched based on the $(highlight("run-time")) type.
* Julia's mutiple dispatch provides exponential abstraction power comparing with an object-oriented language.
* By carefully designed type system, we can program in an exponentially large function space.
"""

# ╔═╡ 28f4a4eb-5bf6-4583-8bb7-34d387a6e0db
md"# Tuple, Array and broadcasting"

# ╔═╡ c4749999-1bd3-4469-866e-c003b9cd49e3
md"#### Tuple has fixed memory layout, but array does not."

# ╔═╡ 3bab5aca-cdfe-4d84-91d8-156431e833e0
tp = (1, 2.0, 'c')

# ╔═╡ c0e930a8-8108-4b19-ba7e-0391c966196b
typeof(tp)

# ╔═╡ f283055d-f7a4-45d3-bec0-01ef90ef8aee
isbitstype(typeof(tp))

# ╔═╡ 15c8e8ec-ab01-49f2-9817-4aa9b42a8235
arr = [1, 2.0, 'c']

# ╔═╡ 8ef5f133-258d-483d-8384-7f7a2f67bdb4
typeof(arr)

# ╔═╡ cdf08e5b-255c-4e50-ae20-3a3361e14fa2
isbitstype(typeof(arr))

# ╔═╡ 954a31c4-55f2-4100-b6d2-43e2fffa6e2c
md"#### Boardcasting"

# ╔═╡ 0bab2c7e-5cc5-4af6-82b2-83760b426678
x = 0:0.1:π

# ╔═╡ 12ea25da-ece4-4392-bf93-62ddb416ed81
y = sin.(x)

# ╔═╡ 83576464-4fc9-4a5f-85f9-35ec33dd76fc
plot(x, y; label="sin")

# ╔═╡ 0127d9bf-a7e1-4bea-a3f2-c34ad2b8b7f6
mesh = (1:100)'

# ╔═╡ 2c580195-390f-4591-92d7-c19c6690cd02
let
	X, Y = 0:0.1:5, 0:0.1:5
	heatmap(X, Y, sin.(X .+ Y'))
end

# ╔═╡ cec2de4a-038a-4fdd-bcd1-9bf0210eca3e
md"#### Broadcasting is fast (loop fusing)!"

# ╔═╡ c851dbae-ed16-4d65-85c4-34397c06aa77
@xbind benchmark_broadcast CheckBox()

# ╔═╡ e9b3fd20-9976-4a55-a725-056bc1092a72
if benchmark_broadcast @benchmark $x .+ $y .+ $x .+ $y end

# ╔═╡ fc903462-a935-440a-986d-ee29de561042
if benchmark_broadcast @benchmark $x + $y + $x + $y end

# ╔═╡ 57dfdc17-7bb2-48ff-9b9a-47ba51301eac
md"#### Broadcasting over non-concrete element types may be type unstable."

# ╔═╡ 2dd79aa9-9c04-41ac-a001-f6ed651a9540
eltype(arr)

# ╔═╡ 31b314c4-894a-414f-a779-9191ba7c9af2
arr .+ 1

# ╔═╡ 6bdec7da-2955-43ec-a31d-2e55a8c15bac
with_terminal() do
	@code_warntype (+).(arr, 1)
end

# ╔═╡ 5c84b09c-8552-49fe-bf74-61d06be28de5
eltype(tp)

# ╔═╡ 01a0395d-5381-4bf9-8fdc-1b3615535a47
with_terminal() do
	@code_warntype (+).(tp, 1)
end

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
		Luxor.text(">", -87, 0; halign=:center, valign=:middle)
		Luxor.text(">", 37, 0; halign=:center, valign=:middle)
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

# ╔═╡ 3907b528-0d42-4b8e-b16b-1e66a27d8eaf
md"""
## Case study: Create a package like HappyMolecules
With `PkgTemplates`.

[https://github.com/CodingThrust/HappyMolecules.jl](https://github.com/CodingThrust/HappyMolecules.jl)
"""

# ╔═╡ 8f378774-ee4f-4778-b677-147209254164
md"
# Homework
##### 0. Fill the following form
|    | is concrete |  is primitive | is abstract | is bits type | is super type |
| --- | --- | --- | --- | --- | --- |
| ComplexF64 |
| Complex{AbstractFloat} |
| Complex{<:AbstractFloat} |
| AbstractFloat |
| Union{Float64, ComplexF64} |
| Int32 |
| Array{Float32, 2} |
| Matrix{Float32} |

##### 1. Implement the two dimensional brownian motion
 Brownian motion in two dimension is composed of cumulated sumummation of a sequence of normally distributed random displacements, that is Brownian motion can be simulated by successive adding terms of random normal distribute numbernamely:
```math
\begin{align}
& \mathbf x(t=0) \sim N(\mathbf{0}, \mathbf{I})\\
& \mathbf x(t=1) \sim \mathbf x(t=0) + N(\mathbf{0}, \mathbf{I})\\
& \mathbf x(t=2) \sim \mathbf x(t=1) + N(\mathbf{0}, \mathbf{I})\\
&\ldots
\end{align}
```
where $N(\mathbf \mu, \mathbf{\Sigma})$ is a [multivariate normal distribution](https://en.wikipedia.org/wiki/Multivariate_normal_distribution).

Task: Implement the algorithm and plot the path in a two dimensional space.

Hint: you can make a plot with [`Makie`](https://docs.makie.org/stable/).

##### 2. Solve the `3x+1` problem?

The 3x+1 problem asks the following:
> Suppose we start with a positive integer, and if it is odd then multiply it by 3 and add 1, and if it is even, divide it by 2. Then repeat this process as long as you can. Do you eventually reach the integer 1, no matter what you started with?

For instance, starting with 5, it is odd, so we apply 3x+1. We get 16, which is even, so we divide by 2. We get 8, and then 4, and then 2, and then 1. So yes, in this case, we eventually end up at 1.

Task: Verify this hypothesis to some big number.
"

# ╔═╡ ab2d522a-14ab-43b3-9eb0-0c4015e04679
md"# Live coding"

# ╔═╡ 930e39d2-80b9-4250-bdfe-477857b2f6ea
livecoding("https://raw.githubusercontent.com/GiggleLiu/notebooks/julia-tutorial/livecoding/1.basic/main.cast")

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

# ╔═╡ Cell order:
# ╠═39479e02-fc99-4b27-ae04-b2ef94f24cf0
# ╠═cb5259ae-ce92-4197-8f51-bf6d9e371a25
# ╠═a82f898d-129d-4585-bca7-45814dcceeb9
# ╟─b9b3ba05-eab9-487d-8f27-72059b8a848c
# ╟─785c7656-117e-47b5-8a6c-8d11d561ddf7
# ╟─0a884afd-49e5-41f3-b808-cc4c2dccf26a
# ╟─6f4a9990-0b9b-4574-8e00-7d16a4b9f391
# ╟─9d84d2d5-ba4c-4004-8386-41492ec66674
# ╟─dcee31b8-a384-4718-950e-d1c5a52df29e
# ╟─f9037c77-a7af-4b16-85a5-5eb9c8b74bb9
# ╟─861ed080-c2ca-4766-a0a4-5fbb16688915
# ╟─216b9efd-7a47-41e3-aeff-519fb934d781
# ╟─7acd68c6-af4e-4ba0-81d8-85b9a181c537
# ╟─940b21b3-b56a-423d-aace-90858d0064ea
# ╠═f5e0e47c-4ab4-4d6b-941a-48ea2430a313
# ╟─c9debe3b-fe96-4b87-9dd3-5b16499ac109
# ╠═26a35e13-a033-40d5-b964-ee6bc7d874db
# ╠═8c15d3ec-aa68-4a27-8a17-b8a9f5e97149
# ╟─715b7cee-d818-48fe-abfe-e6707a843ad4
# ╠═bd058399-1274-4a8d-bc49-a5999bd3a5ef
# ╠═dc1178f2-fd17-4ca2-907a-267851cf2ea9
# ╟─578deb27-cb28-46e9-be6c-22a6f938fe8e
# ╠═0a176011-0423-4971-b89a-2e8fb197d7b6
# ╠═45ceeffe-9a3a-430f-9844-f5b3806dfb0c
# ╠═bd50a691-503a-4ab0-a836-ea380a1931ae
# ╟─63fe0c9a-365c-4c9b-a26d-56faf24a5f85
# ╠═b460f115-2d18-4e0f-8732-0e8766c96888
# ╟─e7d36996-6a74-4183-aade-3f34b8fe4074
# ╟─28382c69-e63d-4b2a-851d-b05f5779b2b1
# ╟─3b840c20-cf23-4ccc-b6a9-f0fe34c10925
# ╟─652f473f-3ab5-417f-8ab9-8f3fd9d4f754
# ╠═0cbe52d2-6661-4712-b367-0f57c5e4e3c2
# ╠═dfd977be-12cb-4f68-9425-2c09cf69232a
# ╠═1c5ec173-7af1-4454-bbec-e8d8096b0490
# ╟─3807f507-3dc2-4a1f-965f-be3599d5f067
# ╠═50b5c202-ad20-47aa-b03f-08e45c8498e3
# ╟─a9fb80ef-29e8-4dd9-9e37-ebb90f302e3e
# ╟─f225a5b5-d3ea-4c6f-8199-21ccfce0b003
# ╠═0cca40d8-6c1a-469c-9b1e-d050e793a274
# ╟─923943b9-da11-4fe4-bf32-39971dcf0cdc
# ╟─ee6182d7-52c2-4f8c-b74c-e50a2768587e
# ╟─0380f2f3-be04-4629-bd00-11f972d6bb9b
# ╟─88b11d8a-c1e2-4d83-8c04-2543c0d141c7
# ╟─30e7724e-85dd-4167-85c0-185a7b527d3d
# ╟─d2054620-3178-4c7f-82cd-e12b039494a3
# ╟─f220b2bb-34ef-40be-8d81-6c2226569df3
# ╟─1b4095a0-f0ec-4794-83fe-8b7b1f3cf1d8
# ╟─59682a19-0e88-48bc-a747-b7d6d3ee7333
# ╠═d2429055-58e9-4d84-894f-2e639723e078
# ╟─bd4a5b95-0582-4b86-9403-7a49866af13b
# ╠═640558dd-e6e0-4b84-9b93-c454ecf8acb9
# ╠═d4f68828-b4e3-4e99-9229-16432cf2afda
# ╟─42a3a248-5937-4496-b6d3-30387b240690
# ╟─b1c9b8b2-c46b-4967-a233-4b4d35a52b90
# ╟─b5628e93-973a-4532-9014-d54ddbbee050
# ╠═4f5a8dfa-becb-44ab-aac5-ca3f48658053
# ╟─96af110d-ac2d-410a-bf6b-b0f40c09b883
# ╠═f4667fb0-fd98-458e-bd3b-1c23d50209ed
# ╟─9c34819e-3ece-4d19-b90d-347a31875fb0
# ╟─6529138b-b3f4-470a-af30-519608217688
# ╠═4359a206-f4cf-4a83-87b6-3adf1c4afdfd
# ╟─95716242-94a5-45bf-8b6b-3ced2508d519
# ╠═b79a755a-195b-4c9e-ae5f-b52f4a55f52c
# ╟─a8480903-b05c-456d-accc-e9b7cfde4591
# ╠═40a91709-d217-48ab-90f1-0a5e02368da8
# ╠═32039282-5981-4634-9442-8e02ce0d9c52
# ╟─ecb05073-3e34-42da-9a4f-bfd517474956
# ╠═b751784a-85bf-4758-905e-2bfb69d92c2b
# ╠═53234cb9-8d50-4e50-be69-31aab56a1a53
# ╟─7ea178cf-3470-4cf0-9bea-44ee516a8633
# ╟─8d726b29-6215-49b8-a93b-6966702ecc16
# ╠═6b6d4a14-f6cf-4cbe-87eb-7e5f6874fb2e
# ╟─ac46f30f-a86a-481d-af18-b0ea5129e949
# ╟─8c355756-0524-4ac4-92e3-a164605b53a5
# ╟─7b5418cb-f30a-42b7-a2d4-9db9166ed5bf
# ╟─8a1b06e6-c146-42db-ac79-b98bfe59e6d5
# ╟─e170eeea-0e8d-4932-aaea-fe306537a189
# ╠═dd37e58c-6687-4c3e-87fa-677117113065
# ╠═82975999-1fb9-4638-9218-5751d28bd420
# ╠═663946a8-7c04-431e-954b-79c43cca73a3
# ╠═bfb02ae8-1725-4446-a8f6-8a398765785a
# ╟─3131a388-702d-4e79-960a-225650ca396b
# ╠═f2d766d4-030e-4f98-838b-12e7610a658f
# ╠═05d70420-6b43-4877-b47a-558f95067a94
# ╠═9e09ebdf-02ee-45c5-b242-c0bafc7f4426
# ╠═8d4c3a8a-a735-4924-a00b-a30ae8e206d0
# ╟─1357484e-06e5-4536-9a8e-972e2fb84c8c
# ╠═ec549f07-b8b1-4938-8e80-895d587c41a9
# ╟─cfc426d8-95dc-4d1b-8655-5b260ac6eafd
# ╠═b83882d5-5c40-449d-b926-c87d191e504f
# ╟─68f786f5-0f81-4185-8da6-8ac029831316
# ╠═e5a16795-bd1c-44f4-8676-2edb525cfa3a
# ╟─c2e6de83-80f2-45a2-83a7-ba330df9bde1
# ╠═0330f4a2-fbed-432c-8357-d7b6664ca983
# ╠═702de85e-143f-4594-96c4-9745867f7b77
# ╠═686fb408-819a-424c-ad24-47e7604fad34
# ╟─45dadca0-ee12-490d-b7a5-124d7b2123a8
# ╠═99a7acc6-1d9e-4efb-a0e4-98abfcf238cc
# ╠═0ae65cc6-a560-4e94-97c5-7f2f78c7a8c2
# ╟─167fdd9b-cca3-4c9d-bd95-cb17055fd6aa
# ╟─f0a6bafc-25d0-4e75-b8de-91794c45f9bc
# ╟─ee9a30fe-2dd8-41d0-930d-a69df76d6fb2
# ╠═0fb42584-110c-479b-afb4-22b7d7ffca96
# ╠═dfeff985-cd21-4171-b974-af4f8a159268
# ╠═9c88ca66-43e1-436f-b2ea-58d0e3a844a2
# ╠═ce9b4b44-c486-4db2-a222-4b322b1c5aa0
# ╟─c9541faf-58e6-4e7f-b5d1-9dbdf88ec1ff
# ╠═3eb0b70e-8c24-4f4b-8a93-f578800cbf98
# ╠═75e320db-ab50-4bd3-9d7a-5b02b0612c80
# ╟─98d415e8-80fd-487c-b1c3-d561ae254967
# ╟─e7dacddd-7122-4b85-b582-68c5c4d5e5c9
# ╠═fd4b6587-ae17-4bee-9e1b-e8f3f512304e
# ╟─8eb05a38-63ba-4660-a034-20cbf38101be
# ╟─fce7d595-2787-4aae-a2cf-867586c64a1a
# ╠═db6a0eb0-f296-483c-8202-71ba41112e84
# ╠═5fe33249-e003-4f7a-b3ee-dcf377bf179a
# ╠═1020a949-d3a0-46b2-9f67-a518a59c481d
# ╠═3964d728-5e17-4200-b2ec-9a010657cfa4
# ╟─b9adf808-11cc-484d-862b-1e624aebe8a2
# ╠═9b7c0da5-0f77-43c4-bcfa-541ab47c99df
# ╠═1efcfa4a-7cb9-487b-a50d-752eebc3d796
# ╠═b48d3acd-79ca-430c-8856-90c1638325e4
# ╟─a4158324-82ef-4d09-8fd7-59867d301c14
# ╟─08a86fcb-da29-407b-9914-73379c703b86
# ╠═a252de65-257b-422d-a612-5e85a30ea0c9
# ╟─26a8f8bb-de04-459e-b4e4-8e01b14328a7
# ╠═8fe44a3b-7c42-4f93-87b0-6b2110d453f7
# ╟─897abf5d-e9c8-446a-b2fc-64d43c7025b1
# ╠═ccdebde5-5d7e-4395-9a47-e6c82ff7d72e
# ╠═992fd82a-a77e-42dd-a778-2eb38c4e82cd
# ╟─cfdab8b5-e6b4-47b7-9e50-c2f6742ee35d
# ╠═bac1adb2-6952-4d52-bdac-dd6a0879b770
# ╠═0b13e7f8-c101-4dec-9904-1ebc3231b3d6
# ╠═86169c92-0891-4516-8c5d-ebcfcee128dc
# ╟─94fcbc31-ede2-416a-a6ba-0e149c25e53d
# ╟─cdf0c539-8791-404a-a65d-9dd095b667cf
# ╠═bb2445b8-35b5-4ae2-a688-308c7fafc497
# ╠═03a3098e-4031-4acc-8521-d2abac148dcb
# ╟─d785d6bf-5c2e-4796-b7f9-52488bde6354
# ╠═e6fc61d7-b163-481c-8a47-7697a24af1a8
# ╠═3ca1d598-aefb-4d80-b8ff-8c5d0ec359cf
# ╠═73dc694f-23c2-4816-9c72-65336e89c1c2
# ╠═a703d5b9-0123-4a93-878b-2f9ca6791601
# ╠═c9e88a31-e7af-4884-a2a3-ccd147225f2f
# ╟─8d9c18f2-a82d-4f80-aea2-7bf2b899d229
# ╠═a95c6a36-95df-487c-b98f-42431033930e
# ╟─0946c055-4b0c-4058-b073-15b9963dbacc
# ╠═8e87ab3f-68b1-421a-b204-74ee71a3ab41
# ╟─4bed73a0-8ac6-40fc-8ece-58ed51092e6f
# ╠═ee7ae309-121e-424d-aa71-b020d4048595
# ╟─4edcdfaf-d61d-4a9a-9a7d-93dd2b429a64
# ╠═a7086af5-2687-4c87-b894-988618317c7c
# ╟─ec835542-32fe-4c74-ae7c-4f96972ae83f
# ╠═e2dca383-c4ad-4f8a-b203-8de982cbcc4f
# ╟─727e7b18-ca58-41dd-92a1-4635333e6a49
# ╠═f1fc72f8-a153-4e93-9e7e-04fe60162ddc
# ╟─4786a882-37d1-492f-ba5d-60129bdc554d
# ╠═6085b373-d41d-4cdd-8503-1d653504c865
# ╠═46c46c26-f80a-45dd-b343-c6d88fa645e8
# ╠═a7763a0c-998e-4830-a403-9885f98bf070
# ╠═9da91c4d-a1bd-41f9-8715-d9043b06860c
# ╠═482876d6-25ea-44ce-a278-571f5a04a7b8
# ╠═d10a5fb2-6b59-4b8e-965f-943f2301af88
# ╠═9d0b0d38-eecc-4a0d-bbcb-e26701bf4d65
# ╟─02956688-53b9-4dba-905f-bac3b49a3327
# ╟─41f7fa54-647a-4223-94c6-4801cfd3b2c0
# ╟─60a4cd54-da72-469b-986d-da7126990046
# ╠═85d3e8a3-502e-4423-95de-b4dd599035aa
# ╠═513b6cf8-de61-4245-8cdb-91ad1f1a485e
# ╠═5295d636-51af-4c65-a9a8-e379cd52d52d
# ╠═fda8c5c5-35a1-4390-81b5-a2e3134e1f36
# ╠═aa03188b-752b-4d9d-bb76-2097f7a9f46b
# ╠═3142ef38-f0b6-4533-9404-5c71af7f4e47
# ╟─8380403f-f0f1-4d5a-b82d-96550d9ef69b
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
# ╟─976795fe-2d86-432a-b053-7425958ff349
# ╟─28f4a4eb-5bf6-4583-8bb7-34d387a6e0db
# ╟─c4749999-1bd3-4469-866e-c003b9cd49e3
# ╠═3bab5aca-cdfe-4d84-91d8-156431e833e0
# ╠═c0e930a8-8108-4b19-ba7e-0391c966196b
# ╠═f283055d-f7a4-45d3-bec0-01ef90ef8aee
# ╠═15c8e8ec-ab01-49f2-9817-4aa9b42a8235
# ╠═8ef5f133-258d-483d-8384-7f7a2f67bdb4
# ╠═cdf08e5b-255c-4e50-ae20-3a3361e14fa2
# ╟─954a31c4-55f2-4100-b6d2-43e2fffa6e2c
# ╠═0bab2c7e-5cc5-4af6-82b2-83760b426678
# ╠═12ea25da-ece4-4392-bf93-62ddb416ed81
# ╠═98ae699e-a3ea-4e94-9d23-8976de049431
# ╠═83576464-4fc9-4a5f-85f9-35ec33dd76fc
# ╠═0127d9bf-a7e1-4bea-a3f2-c34ad2b8b7f6
# ╠═2c580195-390f-4591-92d7-c19c6690cd02
# ╟─cec2de4a-038a-4fdd-bcd1-9bf0210eca3e
# ╟─c851dbae-ed16-4d65-85c4-34397c06aa77
# ╠═e9b3fd20-9976-4a55-a725-056bc1092a72
# ╠═fc903462-a935-440a-986d-ee29de561042
# ╟─57dfdc17-7bb2-48ff-9b9a-47ba51301eac
# ╠═2dd79aa9-9c04-41ac-a001-f6ed651a9540
# ╠═31b314c4-894a-414f-a779-9191ba7c9af2
# ╠═6bdec7da-2955-43ec-a31d-2e55a8c15bac
# ╠═5c84b09c-8552-49fe-bf74-61d06be28de5
# ╠═01a0395d-5381-4bf9-8fdc-1b3615535a47
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
# ╟─3907b528-0d42-4b8e-b16b-1e66a27d8eaf
# ╟─8f378774-ee4f-4778-b677-147209254164
# ╟─ab2d522a-14ab-43b3-9eb0-0c4015e04679
# ╟─930e39d2-80b9-4250-bdfe-477857b2f6ea
# ╟─dca6c9d8-0074-45bf-b840-d36c24855174
# ╟─eabf205e-3d1c-4d42-907a-050207490995
# ╟─a72562cc-ea4e-4e01-9cb3-d84785dd5a92
# ╟─237a3f56-9458-449d-92b0-3135bce85fb7
# ╟─565745ca-b000-4ec0-b53e-a5062abc4b1b
# ╟─19c6976f-3bf5-4485-bd55-3e6a0eee3580
# ╟─804c81b6-61ea-4817-a062-0ac93406ba85
# ╟─bd728688-28e1-42fc-a316-53b41587e255
# ╟─54142ab7-ad54-4844-8499-67a39d6a3007
