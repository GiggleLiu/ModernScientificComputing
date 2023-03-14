### A Pluto.jl notebook ###
# v0.19.19

using Markdown
using InteractiveUtils

# ╔═╡ cb5259ae-ce92-4197-8f51-bf6d9e371a25
# ╠═╡ show_logs = false
begin
	using Luxor
	using AbstractTrees, PlutoUI, Reexport
	include("../lib/PlutoLecturing/src/PlutoLecturing.jl")
	using .PlutoLecturing
	PlutoLecturing.presentmode()
	TableOfContents(depth=2)
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

 $(PlutoLecturing.highlight("Dynamic")) languages have become popular for $(PlutoLecturing.highlight("scientific computing")). They are generally considered highly productive, but lacking in performance. This paper presents Julia, a new dynamic language for technical computing, $(PlutoLecturing.highlight("designed for performance")) from the beginning by adapting and extending modern programming language techniques. A design based on $(PlutoLecturing.highlight("generic functions")) and a rich $(PlutoLecturing.highlight("type")) system simultaneously enables an expressive programming model and successful $(PlutoLecturing.highlight("type inference")), leading to good performance for a wide range of programs. This makes it possible for much of the Julia library to be written in Julia itself, while also incorporating best-of-breed C and Fortran libraries.

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
* *Multiple dispatch* is a feature of some programming languages in which a function or method can be dynamically dispatched based on the $(PlutoLecturing.highlight("run-time")) type.
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
PlutoLecturing.print_dir_tree(project_folder)

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
md"""
# Homework

Submit by making a **pull request** to the course github repository (the `courseworks/week2` folder).

##### 1. Fill the following form
|    | is concrete |  is primitive | is abstract | is bits type | is mutable|
| --- | --- | --- | --- | --- | --- |
| ComplexF64 |
| Complex{AbstractFloat} |
| Complex{<:AbstractFloat} |
| AbstractFloat |
| Union{Float64, ComplexF64} |
| Int32 |
| Matrix{Float32} |
| Base.RefValue |

Task: Fill the form in a markdown file and include it in your pull request.

Hint: [how to create a table in markdown](https://www.markdownguide.org/extended-syntax/).

##### 2. Coding

Choose one: (a), (b) or (c).

**(a - Easy).** Task: Bellow you will find a live coding. Open an Julia REPL and type what the live coding types. Submit the `~/.julia/logs/repl_history.jl` file (only the related portion) as a proof of work.


**(b - Hard).** Two dimensional brownian motion
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

Task: Simulate 2D brownian motion for 10000 steps, and include the code in your pull request. Please include the following content in the pull request description:
* the benchmark result
* a plot of the particle trajectory,

Hint: you can make a plot with [`Plots`](https://github.com/JuliaPlots/Plots.jl) or [`Makie`](https://docs.makie.org/stable/).

**(c - Harder).** The `3x+1` problem

> Suppose we start with a positive integer, and if it is odd then multiply it by 3 and add 1, and if it is even, divide it by 2. Then repeat this process as long as you can. Do you eventually reach the integer 1, no matter what you started with?

For instance, starting with 5, it is odd, so we apply 3x+1. We get 16, which is even, so we divide by 2. We get 8, and then 4, and then 2, and then 1. So yes, in this case, we eventually end up at 1.

Task: Verifier this hypothesis for all positive integers of Int32 type, and include your code with test in your pull request.

Hint: [how to write tests](https://docs.julialang.org/en/v1/stdlib/Test/).
"""

# ╔═╡ ab2d522a-14ab-43b3-9eb0-0c4015e04679
md"# Live coding"

# ╔═╡ d5121deb-1873-446a-b66a-bf65ef992ea6
md"This script is for Julia code training"

# ╔═╡ 930e39d2-80b9-4250-bdfe-477857b2f6ea
PlutoLecturing.livecoding("https://raw.githubusercontent.com/GiggleLiu/notebooks/julia-tutorial/livecoding/1.basic/main.cast")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractTrees = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
Libdl = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
Luxor = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
MethodAnalysis = "85b6ec6f-f7df-4429-9514-a64bcd9ee824"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
Reexport = "189a3867-3050-52da-a836-e630ba90ab69"
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
TropicalNumbers = "b3a74e9c-7526-4576-a4eb-79c0d4c32334"

[compat]
AbstractTrees = "~0.4.4"
BenchmarkTools = "~1.3.2"
Luxor = "~3.7.0"
MethodAnalysis = "~0.4.11"
Plots = "~1.38.7"
PlutoUI = "~0.7.50"
PyCall = "~1.95.1"
Reexport = "~1.2.2"
TropicalNumbers = "~0.5.5"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0-beta3"
manifest_format = "2.0"
project_hash = "b49854d646c35eb33b13f15ecd6a5f9e3ef56dd9"

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

[[deps.Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "d0b3f8b4ad16cb0a2988c6788646a5e6a17b6b1b"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.0.5"

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

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "e32a90da027ca45d84678b826fffd3110bb3fc90"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.8.0"

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

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "7be5f99f7d15578798f338f5433b6c432ea8037b"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.0"

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

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

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

[[deps.Juno]]
deps = ["Base64", "Logging", "Media", "Profile"]
git-tree-sha1 = "07cb43290a840908a771552911a6274bc6c072c7"
uuid = "e5e0dc1b-0480-54bc-9374-aad01c23163d"
version = "0.8.4"

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

[[deps.Librsvg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pango_jll", "Pkg", "gdk_pixbuf_jll"]
git-tree-sha1 = "ae0923dab7324e6bc980834f709c4cd83dd797ed"
uuid = "925c91fb-5dd6-59dd-8e8c-345e74382d89"
version = "2.54.5+0"

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

[[deps.Luxor]]
deps = ["Base64", "Cairo", "Colors", "Dates", "FFMPEG", "FileIO", "Juno", "LaTeXStrings", "Random", "Requires", "Rsvg", "SnoopPrecompile"]
git-tree-sha1 = "909a67c53fddd216d5e986d804b26b1e3c82d66d"
uuid = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
version = "3.7.0"

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

[[deps.Media]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "75a54abd10709c01f1b86b84ec225d26e840ed58"
uuid = "e89f7d12-3494-54d1-8411-f7d8b9ae1f27"
version = "0.5.0"

[[deps.MethodAnalysis]]
deps = ["AbstractTrees"]
git-tree-sha1 = "69d5c89c5d3af15e73d0cdb7482411c156e3f810"
uuid = "85b6ec6f-f7df-4429-9514-a64bcd9ee824"
version = "0.4.11"

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

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "84a314e3926ba9ec66ac097e3635e270986b0f10"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.50.9+0"

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

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "62f417f6ad727987c755549e9cd88c46578da562"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.95.1"

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

[[deps.Rsvg]]
deps = ["Cairo", "Glib_jll", "Librsvg_jll"]
git-tree-sha1 = "3d3dc66eb46568fb3a5259034bfc752a0eb0c686"
uuid = "c4c386cf-5103-5370-be45-f3a111cca3b8"
version = "1.0.0"

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

[[deps.TropicalNumbers]]
git-tree-sha1 = "bfafb870d4a18d84d2ade80cf857440ab3d0a2df"
uuid = "b3a74e9c-7526-4576-a4eb-79c0d4c32334"
version = "0.5.5"

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

[[deps.VersionParsing]]
git-tree-sha1 = "58d6e80b4ee071f5efd07fda82cb9fbe17200868"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.3.0"

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

[[deps.gdk_pixbuf_jll]]
deps = ["Artifacts", "Glib_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Xorg_libX11_jll", "libpng_jll"]
git-tree-sha1 = "e9190f9fb03f9c3b15b9fb0c380b0d57a3c8ea39"
uuid = "da03df04-f53b-5353-a52f-6a8b0620ced0"
version = "2.42.8+0"

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
# ╟─cb5259ae-ce92-4197-8f51-bf6d9e371a25
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
# ╟─d5121deb-1873-446a-b66a-bf65ef992ea6
# ╟─930e39d2-80b9-4250-bdfe-477857b2f6ea
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
