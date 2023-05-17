# time: 2023-02-15 20:13:21 CST
# mode: julia
	]dev OMEinsum
# time: 2023-02-15 20:13:28 CST
# mode: julia
	dev OMEinsum
# time: 2023-02-15 20:20:21 CST
# mode: julia
	dev
# time: 2023-02-15 20:21:49 CST
# mode: julia
	exit
# time: 2023-02-15 20:24:50 CST
# mode: julia
	using Pkg; Pkg.add("Revise")
# time: 2023-02-15 20:38:57 CST
# mode: julia
	versioninfo()
# time: 2023-02-15 20:44:29 CST
# mode: julia
	add Pluto
# time: 2023-02-15 20:44:40 CST
# mode: julia
	pkg> add Pluto
# time: 2023-02-15 20:45:02 CST
# mode: julia
	pkg
# time: 2023-02-15 20:48:20 CST
# mode: julia
	dev OMEinsum
# time: 2023-02-15 20:48:36 CST
# mode: julia
	]dev OMEinsum
# time: 2023-02-15 20:50:54 CST
# mode: julia
	using Pkg; Pkg.add("Revise")
# time: 2023-02-15 20:51:28 CST
# mode: julia
	date
# time: 2023-02-15 20:52:16 CST
# mode: pkg
	st
# time: 2023-02-15 20:52:30 CST
# mode: pkg
	?
# time: 2023-02-15 20:52:51 CST
# mode: pkg
	add Pluto
# time: 2023-02-15 21:28:21 CST
# mode: pkg
	dev OMEINSUM
# time: 2023-02-15 21:28:54 CST
# mode: pkg
	dev OMEinsum
# time: 2023-02-15 21:33:10 CST
# mode: julia
	--project
# time: 2023-02-15 21:33:30 CST
# mode: pkg
	test
# time: 2023-02-15 21:41:05 CST
# mode: pkg
	]
# time: 2023-02-22 16:05:23 CST
# mode: julia
	BigInt(10)^1000
# time: 2023-02-22 16:07:23 CST
# mode: julia
	vsh
# time: 2023-02-22 16:13:28 CST
# mode: julia
	Complex{Float64}
# time: 2023-02-22 16:14:15 CST
# mode: julia
	dump(Complex)
# time: 2023-02-22 16:16:23 CST
# mode: julia
	lslsl
# time: 2023-02-22 16:16:26 CST
# mode: julia
	dadad
# time: 2023-02-22 16:18:46 CST
# mode: julia
	dump(Array)
# time: 2023-02-22 16:19:08 CST
# mode: julia
	Matrix
# time: 2023-02-22 16:19:20 CST
# mode: julia
	Matrix{Float64}
# time: 2023-02-22 16:30:12 CST
# mode: julia
	collect(Any, 1:2:2000)
# time: 2023-02-22 16:30:24 CST
# mode: julia
	collect(Any, 1:2:20000)
# time: 2023-03-05 10:46:48 CST
# mode: julia
	a = 10
# time: 2023-03-05 10:46:56 CST
# mode: julia
	println(a)
# time: 2023-03-05 10:47:09 CST
# mode: help
	println
# time: 2023-03-05 10:47:28 CST
# mode: julia
	println
# time: 2023-03-05 10:47:48 CST
# mode: julia
	println(io, "Hello", ',', " world.")
# time: 2023-03-05 10:48:12 CST
# mode: shell
	ls
# time: 2023-03-05 10:48:56 CST
# mode: pkg
	using pkg
# time: 2023-03-05 10:49:30 CST
# mode: julia
	ls
# time: 2023-03-05 10:50:14 CST
# mode: julia
	Pkg.install
# time: 2023-03-05 10:50:16 CST
# mode: julia
	Pkg.installed
# time: 2023-03-05 10:50:21 CST
# mode: julia
	Pkg.installed()
# time: 2023-03-05 10:50:37 CST
# mode: julia
	Pkg.undate()
# time: 2023-03-05 10:50:47 CST
# mode: julia
	pkg.installed
# time: 2023-03-05 10:50:48 CST
# mode: julia
	pkg.installed()
# time: 2023-03-05 14:49:13 CST
# mode: julia
	a = [1,2,3,4]
# time: 2023-03-05 14:52:36 CST
# mode: julia
	aa = (1:2:5)
# time: 2023-03-05 14:52:42 CST
# mode: julia
	aa.start
# time: 2023-03-05 14:52:46 CST
# mode: julia
	aa.step
# time: 2023-03-05 14:52:50 CST
# mode: julia
	aa.stop
# time: 2023-03-05 14:52:57 CST
# mode: julia
	first(aa)
# time: 2023-03-05 14:53:09 CST
# mode: julia
	Int8[3,4,5]
# time: 2023-03-05 14:54:00 CST
# mode: julia
	["one","two","three"]
# time: 2023-03-06 20:16:01 CST
# mode: julia
	function back_substitution!(l::AbstractMatrix, b::AbstractVector)
	        n = length(b)
	        @assert size(l) == (n, n) "size mismatch"
	        x = zero(b)
	        # loop over columns
	        for j = 1:n
	                # stop if matrix is singular
	                if iszero(l[j, j])
	                        error("The lower triangular matrix is singular!")
	                end
	                # compute solution component
	                x[j] = b[j] / l[j, j]
	                for i = j+1:n
	                        # update right hand side
	                        b[i] = b[i] - l[i, j] * x[j]
	                end
	        end
	        return x
	end
# time: 2023-03-06 20:16:11 CST
# mode: julia
	l = tril(randn(4, 4))
# time: 2023-03-06 20:18:00 CST
# mode: julia
	l=[1.3964     0.0        0.0        0.0;-1.0634    -1.20152    0.0        0.0;0.274699   0.842341   0.281033   0.0;-0.427873   0.0701839  1.0647    -0.328598]
# time: 2023-03-06 20:18:08 CST
# mode: julia
	b = randn(4)
# time: 2023-03-06 20:18:17 CST
# mode: julia
	back_substitution!(l, copy(b))
# time: 2023-03-06 20:18:29 CST
# mode: julia
	LowerTriangular(l) \ b
# time: 2023-03-06 20:19:34 CST
# mode: julia
	let
	        X, Y = 0:0.1:5, 0:0.1:5
	        heatmap(X, Y, sin.(X .+ Y'))
	end
# time: 2023-03-06 20:24:37 CST
# mode: julia
	clear
# time: 2023-03-06 20:24:53 CST
# mode: shell
	clear
# time: 2023-03-06 20:26:02 CST
# mode: julia
	Base.isconcretetype(Complex{AbstractFloat})
# time: 2023-03-06 20:26:27 CST
# mode: julia
	Base.isconcretetype()
# time: 2023-03-06 20:26:35 CST
# mode: julia
	Base.isconcretetype(Complex{<:AbstractFloat}        )
# time: 2023-03-06 20:27:29 CST
# mode: julia
	Base.isconcretetype(Complex{<:AbstractFloat})
# time: 2023-03-06 20:27:41 CST
# mode: julia
	Base.isconcretetype(AbstractFloat)
# time: 2023-03-06 20:27:58 CST
# mode: julia
	Base.isconcretetype(Union{Float64, ComplexF64})
# time: 2023-03-06 20:28:19 CST
# mode: julia
	Base.isconcretetype(Int32)
# time: 2023-03-06 20:28:59 CST
# mode: julia
	Base.isconcretetype(Matrix{Float32})
# time: 2023-03-06 20:29:20 CST
# mode: julia
	Base.isconcretetype(Base.RefValue)
# time: 2023-03-06 20:47:04 CST
# mode: julia
	ture isa Bool
# time: 2023-03-06 20:47:27 CST
# mode: julia
	true isa Bool
# time: 2023-03-06 20:47:43 CST
# mode: julia
	sizeof(Bool)
# time: 2023-03-06 20:47:55 CST
# mode: julia
	!true
# time: 2023-03-06 20:48:09 CST
# mode: julia
	true&&false
# time: 2023-03-06 20:48:16 CST
# mode: julia
	true||false
# time: 2023-03-06 20:50:09 CST
# mode: julia
	ture >= flase
# time: 2023-03-06 20:50:16 CST
# mode: julia
	true >= flase
# time: 2023-03-06 20:50:25 CST
# mode: julia
	true >= false
# time: 2023-03-06 20:50:40 CST
# mode: julia
	3 isa Int
# time: 2023-03-06 20:50:53 CST
# mode: julia
	0x3 isa UInt8
# time: 2023-03-06 20:51:01 CST
# mode: julia
	bistring(3)
# time: 2023-03-06 20:51:21 CST
# mode: julia
	bitstring(8)
# time: 2023-03-06 20:51:32 CST
# mode: julia
	bitstring(0x3)
# time: 2023-03-06 20:51:41 CST
# mode: julia
	sizeof(3)
# time: 2023-03-06 20:51:51 CST
# mode: julia
	sizeof(0x3)
# time: 2023-03-06 20:51:58 CST
# mode: julia
	7%3
# time: 2023-03-06 20:52:03 CST
# mode: julia
	3/3
# time: 2023-03-06 20:52:06 CST
# mode: julia
	7、3
# time: 2023-03-06 20:52:10 CST
# mode: julia
	7/3
# time: 2023-03-06 20:52:37 CST
# mode: julia
	7 ÷ 3
# time: 2023-03-06 20:52:48 CST
# mode: julia
	7<<3
# time: 2023-03-06 20:52:52 CST
# mode: julia
	7<<1
# time: 2023-03-06 20:53:05 CST
# mode: julia
	7>>1
# time: 2023-03-06 20:53:16 CST
# mode: julia
	7|1
# time: 2023-03-06 20:53:20 CST
# mode: julia
	7&1
# time: 2023-03-06 20:53:54 CST
# mode: julia
	7 ⊻ 1
# time: 2023-03-06 20:54:04 CST
# mode: julia
	3.2 isa Float64
# time: 2023-03-06 20:54:19 CST
# mode: julia
	3.2e2 isa Float64
# time: 2023-03-06 20:54:27 CST
# mode: julia
	3.2f2 isa Float32
# time: 2023-03-06 20:54:43 CST
# mode: julia
	3.2 + 3im isa ComplexF64
# time: 2023-03-06 20:55:05 CST
# mode: julia
	typeof(\pi)
# time: 2023-03-06 20:55:09 CST
# mode: julia
	typeof(π)
# time: 2023-03-06 20:55:19 CST
# mode: julia
	typeof(\euler)
# time: 2023-03-06 20:55:23 CST
# mode: julia
	typeof(ℯ)
# time: 2023-03-06 20:55:38 CST
# mode: julia
	3.0^3
# time: 2023-03-06 20:55:59 CST
# mode: julia
	"3.0" isa String
# time: 2023-03-06 20:56:12 CST
# mode: julia
	(1, "3.0") ias tuple
# time: 2023-03-06 20:56:17 CST
# mode: julia
	(1, "3.0") isa tuple
# time: 2023-03-06 20:56:23 CST
# mode: julia
	(1, "3.0") isa Tuple
# time: 2023-03-06 20:56:35 CST
# mode: julia
	(1, "3.0")[1] isa Tuple
# time: 2023-03-06 20:57:03 CST
# mode: julia
	(3.0=>"3.0") isa Pair
# time: 2023-03-06 20:57:17 CST
# mode: julia
	(3.0=>"3.0").first
# time: 2023-03-06 20:57:28 CST
# mode: julia
	(3.0=>"3.0").second
# time: 2023-03-06 20:57:40 CST
# mode: julia
	[2,3.0] isa Vector
# time: 2023-03-06 20:57:50 CST
# mode: julia
	1:10 isa UnitRange
# time: 2023-03-06 20:57:56 CST
# mode: julia
	length(1:10)
# time: 2023-03-06 20:58:07 CST
# mode: julia
	1:2:10 isa StepRange
# time: 2023-03-06 20:58:53 CST
# mode: julia
	d = Dict(3.0=>"three", 4.0=>"four")
# time: 2023-03-06 20:59:00 CST
# mode: julia
	d isa Dict
# time: 2023-03-06 20:59:09 CST
# mode: julia
	keys(d)
# time: 2023-03-06 20:59:17 CST
# mode: julia
	values(d)
# time: 2023-03-06 20:59:25 CST
# mode: julia
	d[3.0]
# time: 2023-03-06 20:59:44 CST
# mode: julia
	get(d, 3.0,'not exist')
# time: 2023-03-06 21:00:04 CST
# mode: julia
	get(d, 3.0,"not exist")
# time: 2023-03-06 21:00:17 CST
# mode: julia
	get(d, 5.0,"not exist")
# time: 2023-03-06 21:00:40 CST
# mode: julia
	haskey(d,3.0)
# time: 2023-03-06 21:01:08 CST
# mode: julia
	UInt64(3) isa UInt64
# time: 2023-03-06 21:01:40 CST
# mode: julia
	Float32(3) isa Float32
# time: 2023-03-06 21:02:14 CST
# mode: julia
	[(1,"3.0")...]
# time: 2023-03-06 21:02:24 CST
# mode: julia
	[(1,"3.0")...,]
# time: 2023-03-06 21:02:42 CST
# mode: julia
	
	(1,"3.0")...,
# time: 2023-03-06 21:03:01 CST
# mode: julia
	([1,"3.0"]...,)
# time: 2023-03-06 21:03:23 CST
# mode: julia
	((3.0=>"3.0")...,)
# time: 2023-03-06 21:03:43 CST
# mode: julia
	(1:2:10...,)
# time: 2023-03-06 21:04:14 CST
# mode: julia
	[1:2:10...]
# time: 2023-03-06 21:05:15 CST
# mode: julia
	[Dict(3.0=>"three",4.0=>"four")]
# time: 2023-03-06 21:05:19 CST
# mode: julia
	[Dict(3.0=>"three",4.0=>"four")...,]
# time: 2023-03-06 21:05:43 CST
# mode: julia
	collect(1:2:10)
# time: 2023-03-06 21:05:50 CST
# mode: julia
	tyemin(Int)
# time: 2023-03-06 21:05:55 CST
# mode: julia
	typemin(Int)
# time: 2023-03-06 21:06:02 CST
# mode: julia
	typemax(Int)
# time: 2023-03-06 21:06:11 CST
# mode: julia
	typemax(UInt64)
# time: 2023-03-06 21:06:15 CST
# mode: julia
	typemIN(UInt64)
# time: 2023-03-06 21:06:20 CST
# mode: julia
	typemin(UInt64)
# time: 2023-03-06 21:06:50 CST
# mode: julia
	typemin(Float64)
# time: 2023-03-06 21:06:54 CST
# mode: julia
	typemax(Float64)
# time: 2023-03-06 21:07:02 CST
# mode: julia
	zero(Float64)
# time: 2023-03-06 21:07:11 CST
# mode: julia
	one(Float64)
# time: 2023-03-06 21:07:29 CST
# mode: julia
	0.0 * Inf
# time: 2023-03-06 21:07:36 CST
# mode: julia
	Inf == Inf
# time: 2023-03-06 21:07:45 CST
# mode: julia
	NaN == NaN
# time: 2023-03-06 21:07:54 CST
# mode: julia
	eps(Float32)
# time: 2023-03-06 21:08:06 CST
# mode: julia
	eps(Float64)
# time: 2023-03-06 21:08:16 CST
# mode: julia
	1.0 == nextfloat(1.0)
# time: 2023-03-06 21:08:34 CST
# mode: julia
	1.0 ≈ nextfloat(1.0)
# time: 2023-03-06 21:09:28 CST
# mode: julia
	let 
	x = 1
	for i = 1:100
	    x *= i
	    end
	x    
	end
# time: 2023-03-06 21:10:14 CST
# mode: julia
	let 
	    x = BigInt(1)
	    for i = 1:100
	        x *= 1
	        end
	        x
	        end
# time: 2023-03-06 21:10:57 CST
# mode: julia
	a = 0; a += 1; a +=2; a
# time: 2023-03-06 21:11:23 CST
# mode: julia
	begin
	    a = 0
	    a += 1
	    a += 2
	    end
# time: 2023-03-06 21:11:50 CST
# mode: julia
	for i in 1:3
	println(1)
	end
# time: 2023-03-06 21:12:00 CST
# mode: julia
	for i in 1:3
	println(i)
	end
# time: 2023-03-06 21:13:42 CST
# mode: julia
	let 
	for i = 1:3
	    j = i==1 ? 1 : j+1
	    end
	    j
	    end
# time: 2023-03-06 21:14:30 CST
# mode: julia
	let local j
	for i = 1:3
	    j = i==1 ? 1 : j+1
	    end
	    j
	    end
# time: 2023-03-06 21:15:03 CST
# mode: julia
	let 
	local j
	 for i = 1:3 
	 j = i==1 ? 1:j
# time: 2023-03-06 21:15:06 CST
# mode: julia
	let 
	local j
	 for i = 1:3 
	 j = i==1 ? 1:j+1
# time: 2023-03-06 21:15:44 CST
# mode: julia
	let 
	local j
	for i = 1:3
	j = i==1 ? 1:j + 1
# time: 2023-03-06 21:16:37 CST
# mode: julia
	let
	local j
	for i = 1:3
	    j = i ==1 ? 1 : j+1
	    end
	    j
	    end
# time: 2023-03-06 21:17:00 CST
# mode: julia
	global_j = 0
# time: 2023-03-06 21:17:03 CST
# mode: julia
	let
	local j
	for i = 1:3
	    j = i ==1 ? 1 : j+1
	    end
	    j
	    end
# time: 2023-03-06 21:17:24 CST
# mode: julia
	global_j = 0
# time: 2023-03-06 21:18:08 CST
# mode: julia
	let 
	for i = 1:3
	    j = i == 1 ? 1 : j+1
	    end
	    j
	    end
# time: 2023-03-06 21:18:50 CST
# mode: julia
	let
	for i = 1:5
	    global global_j += 1
	    end
	    end
# time: 2023-03-06 21:19:10 CST
# mode: julia
	global_j
# time: 2023-03-06 21:19:36 CST
# mode: julia
	using Primes
# time: 2023-03-06 21:24:28 CST
# mode: julia
	for i=1:typemax(Int8)
	if isprime(i)
	    print(i)
	    end
	    end
# time: 2023-03-06 21:24:41 CST
# mode: julia
	for i=1:typemax(Int8)
	if isprime(i)
	    println(i)
	    end
	    end
# time: 2023-03-06 21:25:56 CST
# mode: julia
	let i=Int8(0)
	whlie i< typemax(Int8)
# time: 2023-03-06 21:26:08 CST
# mode: julia
	let i=Int8(0)
	whlie i < typemax(Int8)
# time: 2023-03-06 21:27:22 CST
# mode: julia
	let i=Int(8)
	while i < typemax(Int8)
	i += Int8(1)
	if isprime(i)
	    println(i)
	    end
	end
	end
# time: 2023-03-06 21:28:07 CST
# mode: julia
	ints = Int8(1):typemax(Int8)
# time: 2023-03-06 21:29:15 CST
# mode: julia
	boolean_mask = isprime.(ints)
# time: 2023-03-06 21:31:19 CST
# mode: julia
	ints[boolean_mask]
# time: 2023-03-06 21:32:13 CST
# mode: julia
	[x for x in Int8(1):typemax(Int8) if isprime(x)]
# time: 2023-03-06 21:33:16 CST
# mode: julia
	filter(isprime, Int8(1):typemax(Int8))
# time: 2023-03-06 21:33:43 CST
# mode: julia
	@doc filter
# time: 2023-03-06 21:35:43 CST
# mode: julia
	function compare(x,y)
	    if x<y
	        relation = "less than"
	    elseif x==y
	        relation = "equal to"
	    else 
	        relatioin = "larger than to"
	    end
	    println("$x is $relation $y.")
	    end
# time: 2023-03-06 21:35:57 CST
# mode: julia
	compare(3,4)
# time: 2023-03-06 21:37:34 CST
# mode: julia
	try 
	x = [1]
	x[0]
	catch e
	    throw(e)
	finally
	    println("I will be exectued anyway ;D")
	end
# time: 2023-03-06 21:38:24 CST
# mode: shell
	vi ~/.julia/logs/repl_history.jl
# time: 2023-03-06 21:38:50 CST
# mode: shell
	sz ~/.julia/logs/repl_history.jl
