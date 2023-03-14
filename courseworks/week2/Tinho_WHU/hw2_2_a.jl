# time: 2023-02-26 18:11:20 CST
# mode: julia
	# boolean variables
# time: 2023-02-26 18:11:33 CST
# mode: julia
	true isa Bool
# time: 2023-02-26 18:12:09 CST
# mode: julia
	# size in bytes sizeof(Bool)
# time: 2023-02-26 18:12:21 CST
# mode: julia
	sizeof(Bool)
# time: 2023-02-26 18:12:29 CST
# mode: julia
	# Not
# time: 2023-02-26 18:12:38 CST
# mode: julia
	!true
# time: 2023-02-26 18:13:43 CST
# mode: julia
	# And
# time: 2023-02-26 18:13:48 CST
# mode: julia
	true
# time: 2023-02-26 18:14:04 CST
# mode: julia
	true && false
# time: 2023-02-26 18:14:18 CST
# mode: julia
	 # or
# time: 2023-02-26 18:14:29 CST
# mode: julia
	true || false
# time: 2023-02-26 18:15:10 CST
# mode: julia
	# xor: type ⊻
# time: 2023-02-26 18:15:30 CST
# mode: julia
	true ⊻ false
# time: 2023-02-26 18:16:31 CST
# mode: julia
	3 isa int
# time: 2023-02-26 18:16:44 CST
# mode: julia
	3 isa Int
# time: 2023-02-26 18:17:37 CST
# mode: julia
	0*3 isa UInt
# time: 2023-02-26 18:17:53 CST
# mode: julia
	0*3 isa UInt8
# time: 2023-02-26 18:18:09 CST
# mode: julia
	0×3 isa UInt8
# time: 2023-02-26 18:18:48 CST
# mode: julia
	0x3 isa UInt8
# time: 2023-02-26 18:19:43 CST
# mode: julia
	bitstring(3)
# time: 2023-02-26 18:20:12 CST
# mode: julia
	bitstring(0x3)
# time: 2023-02-26 18:20:33 CST
# mode: julia
	sizeof(3)
# time: 2023-02-26 18:20:47 CST
# mode: julia
	7 % 3
# time: 2023-02-26 18:21:22 CST
# mode: julia
	7 ÷ 3
# time: 2023-02-26 18:21:37 CST
# mode: julia
	7 << 1
# time: 2023-02-26 18:22:27 CST
# mode: julia
	7 >> 1
# time: 2023-02-26 18:22:40 CST
# mode: julia
	7 | 1
# time: 2023-02-26 18:23:03 CST
# mode: julia
	7 & 1
# time: 2023-02-26 18:23:31 CST
# mode: julia
	 7 ⊻ 1
# time: 2023-02-26 18:23:51 CST
# mode: julia
	3.2 isa Float54
# time: 2023-02-26 18:23:55 CST
# mode: julia
	3.2 isa Float64
# time: 2023-02-26 18:24:27 CST
# mode: julia
	3.2e2 isa Float64
# time: 2023-02-26 18:24:39 CST
# mode: julia
	3.2f2 isa Float32
# time: 2023-02-26 18:25:12 CST
# mode: julia
	  3.2 + 3im isa ComplexF64
# time: 2023-02-26 18:25:46 CST
# mode: julia
	typeof(π)
# time: 2023-02-26 18:26:01 CST
# mode: julia
	typeof(ℯ)
# time: 2023-02-26 18:26:22 CST
# mode: julia
	3.0 ^ 3
# time: 2023-02-26 18:26:45 CST
# mode: julia
	 "3.0" isa String
# time: 2023-02-26 18:27:13 CST
# mode: julia
	(1,"3.0") isa tuple
# time: 2023-02-26 18:27:20 CST
# mode: julia
	(1,"3.0") isa Tuple
# time: 2023-02-26 18:27:44 CST
# mode: julia
	(1,"3.0"){1}
# time: 2023-02-26 18:27:53 CST
# mode: julia
	(1,"3.0")[1]
# time: 2023-02-26 18:28:30 CST
# mode: julia
	 (3.0=>"3.0") isa Pair
# time: 2023-02-26 18:29:08 CST
# mode: julia
	 (3.0=>"3.0").First
# time: 2023-02-26 18:29:12 CST
# mode: julia
	 (3.0=>"3.0").first
# time: 2023-02-26 18:29:28 CST
# mode: julia
	 (3.0=>"3.0").second
# time: 2023-02-26 18:29:51 CST
# mode: julia
	[2 3.0] isa vector
# time: 2023-02-26 18:29:57 CST
# mode: julia
	[2 3.0] isa Vector
# time: 2023-02-26 18:30:11 CST
# mode: julia
	[2,3.0] isa Vector
# time: 2023-02-26 18:30:36 CST
# mode: julia
	1:10 isa UnitRange
# time: 2023-02-26 18:30:51 CST
# mode: julia
	 length(1:10)
# time: 2023-02-26 18:31:13 CST
# mode: julia
	 1:2:10 isa StepRange
# time: 2023-02-26 18:32:09 CST
# mode: julia
	 d = Dict(3.0=>"Three",4.0=>"Four")
# time: 2023-02-26 18:32:35 CST
# mode: julia
	d isa Dict
# time: 2023-02-26 18:32:49 CST
# mode: julia
	keys(d)
# time: 2023-02-26 18:33:01 CST
# mode: julia
	values(d)
# time: 2023-02-26 18:33:13 CST
# mode: julia
	d[3.0]
# time: 2023-02-26 18:33:56 CST
# mode: julia
	get(d,3.0,"not exist")
# time: 2023-02-26 18:34:20 CST
# mode: julia
	get(d,4.0,"not exist")
# time: 2023-02-26 18:34:24 CST
# mode: julia
	get(d,5.0,"not exist")
# time: 2023-02-26 18:35:04 CST
# mode: julia
	haskey(d,3.0)
# time: 2023-02-26 18:38:49 CST
# mode: julia
	UInt64(3) isa Uint
# time: 2023-02-26 18:38:59 CST
# mode: julia
	UInt64(3) isa UInt64
# time: 2023-02-26 18:39:28 CST
# mode: julia
	 Float32(3) isa Float32
# time: 2023-02-26 18:40:23 CST
# mode: julia
	[(1,"3.0")...]
# time: 2023-02-26 18:41:03 CST
# mode: julia
	 ([1,"3.0"])
# time: 2023-02-26 18:41:07 CST
# mode: julia
	 ([1,"3.0"]...)
# time: 2023-02-26 18:41:24 CST
# mode: julia
	 ([1,"3.0"]...,)
# time: 2023-02-26 18:42:13 CST
# mode: julia
	((3.0=>"3.0"...,))
# time: 2023-02-26 18:42:23 CST
# mode: julia
	((3.0=>"3.0")...,)
# time: 2023-02-26 18:43:58 CST
# mode: julia
	(1:2:10...,)
# time: 2023-02-26 18:44:19 CST
# mode: julia
	[1:2:10...]
# time: 2023-02-26 19:04:30 CST
# mode: julia
	true isa Bool
# time: 2023-02-26 19:04:44 CST
# mode: julia
	sizeof(Bool)
# time: 2023-02-26 19:05:07 CST
# mode: julia
	!true
# time: 2023-02-26 19:05:26 CST
# mode: julia
	true
# time: 2023-02-26 19:05:37 CST
# mode: julia
	true && false
# time: 2023-02-26 19:05:49 CST
# mode: julia
	true || false
# time: 2023-02-26 19:06:05 CST
# mode: julia
	true ⊻ false
# time: 2023-02-26 19:06:16 CST
# mode: julia
	3 isa int
# time: 2023-02-26 19:06:33 CST
# mode: julia
	3 isa Int
# time: 2023-02-26 19:06:51 CST
# mode: julia
	0×3 isa UInt8
# time: 2023-02-26 19:07:02 CST
# mode: julia
	0x3 isa UInt8
# time: 2023-02-26 19:07:10 CST
# mode: julia
	bitstring(3)
# time: 2023-02-26 19:07:17 CST
# mode: julia
	bitstring(0x3)
# time: 2023-02-26 19:07:29 CST
# mode: julia
	sizeof(3)
# time: 2023-02-26 19:07:37 CST
# mode: julia
	7 % 3
# time: 2023-02-26 19:07:47 CST
# mode: julia
	7 ÷ 3
# time: 2023-02-26 19:08:01 CST
# mode: julia
	7 << 1
# time: 2023-02-26 19:08:08 CST
# mode: julia
	7 >> 1
# time: 2023-02-26 19:08:16 CST
# mode: julia
	7 | 1
# time: 2023-02-26 19:08:49 CST
# mode: julia
	7 & 1
# time: 2023-02-26 19:08:56 CST
# mode: julia
	7 ⊻ 1
# time: 2023-02-26 19:09:12 CST
# mode: julia
	3.2 isa Float64
# time: 2023-02-26 19:09:22 CST
# mode: julia
	3.2e2 isa Float64
# time: 2023-02-26 19:09:38 CST
# mode: julia
	3.2f2 isa Float32
# time: 2023-02-26 19:09:52 CST
# mode: julia
	3.2 + 3im isa ComplexF64
# time: 2023-02-26 19:10:01 CST
# mode: julia
	typeof(π)
# time: 2023-02-26 19:10:10 CST
# mode: julia
	typeof(ℯ)
# time: 2023-02-26 19:10:18 CST
# mode: julia
	3.0 ^ 3
# time: 2023-02-26 19:10:31 CST
# mode: julia
	"3.0" isa String
# time: 2023-02-26 19:10:40 CST
# mode: julia
	(1,"3.0") isa Tuple
# time: 2023-02-26 19:10:54 CST
# mode: julia
	(1,"3.0")[1]
# time: 2023-02-26 19:11:03 CST
# mode: julia
	(3.0=>"3.0") isa Pair
# time: 2023-02-26 19:11:13 CST
# mode: julia
	(3.0=>"3.0").First
# time: 2023-02-26 19:11:22 CST
# mode: julia
	(3.0=>"3.0").first
# time: 2023-02-26 19:11:29 CST
# mode: julia
	(3.0=>"3.0").second
# time: 2023-02-26 19:11:39 CST
# mode: julia
	[2 3.0] isa vector
# time: 2023-02-26 19:11:47 CST
# mode: julia
	[2 3.0] isa Vector
# time: 2023-02-26 19:11:55 CST
# mode: julia
	[2,3.0] isa Vector
# time: 2023-02-26 19:12:04 CST
# mode: julia
	1:10 isa UnitRange
# time: 2023-02-26 19:12:10 CST
# mode: julia
	length(1:10)
# time: 2023-02-26 19:12:21 CST
# mode: julia
	1:2:10 isa StepRange
# time: 2023-02-26 19:12:35 CST
# mode: julia
	d = Dict(3.0=>"Three",4.0=>"Four")
# time: 2023-02-26 19:12:49 CST
# mode: julia
	d isa Dict
# time: 2023-02-26 19:13:00 CST
# mode: julia
	keys(d)
# time: 2023-02-26 19:13:09 CST
# mode: julia
	values(d)
# time: 2023-02-26 19:13:17 CST
# mode: julia
	d[3.0]
# time: 2023-02-26 19:13:24 CST
# mode: julia
	get(d,3.0,"not exist")
# time: 2023-02-26 19:13:31 CST
# mode: julia
	get(d,4.0,"not exist")
# time: 2023-02-26 19:13:41 CST
# mode: julia
	get(d,5.0,"not exist")
# time: 2023-02-26 19:13:49 CST
# mode: julia
	haskey(d,3.0)
# time: 2023-02-26 19:13:56 CST
# mode: julia
	UInt64(3) isa Uint
# time: 2023-02-26 19:14:04 CST
# mode: julia
	UInt64(3) isa UInt64
# time: 2023-02-26 19:14:11 CST
# mode: julia
	Float32(3) isa Float32
# time: 2023-02-26 19:14:22 CST
# mode: julia
	[(1,"3.0")...]
# time: 2023-02-26 19:14:37 CST
# mode: julia
	([1,"3.0"])
# time: 2023-02-26 19:14:55 CST
# mode: julia
	([1,"3.0"]...,)
# time: 2023-02-26 19:15:09 CST
# mode: julia
	((3.0=>"3.0")...,)
# time: 2023-02-26 19:15:18 CST
# mode: julia
	(1:2:10...,)
# time: 2023-02-26 19:15:28 CST
# mode: julia
	[1:2:10...]
# time: 2023-02-26 19:15:38 CST
# mode: julia
	[Dict(3=>"three",4=>"four")...]
# time: 2023-02-26 19:15:50 CST
# mode: julia
	collect(1:2:10)
# time: 2023-02-26 19:15:58 CST
# mode: julia
	typemin(Int)
# time: 2023-02-26 19:16:06 CST
# mode: julia
	typemax(Int)
# time: 2023-02-26 19:16:16 CST
# mode: julia
	typemin(UInt64)
# time: 2023-02-26 19:16:52 CST
# mode: julia
	typemax(UInt64)
# time: 2023-02-26 19:17:04 CST
# mode: julia
	typemin(Float64)
# time: 2023-02-26 19:17:20 CST
# mode: julia
	typemax(Float64)
# time: 2023-02-26 19:17:43 CST
# mode: julia
	zero(Float64)
# time: 2023-02-26 19:18:00 CST
# mode: julia
	one(Float64)
# time: 2023-02-26 19:18:23 CST
# mode: julia
	0.0 * Inf
# time: 2023-02-26 19:18:41 CST
# mode: julia
	Inf == Inf
# time: 2023-02-26 19:18:55 CST
# mode: julia
	NaN ==NaN
# time: 2023-02-26 19:19:19 CST
# mode: julia
	exp(Float32)
# time: 2023-02-26 19:19:30 CST
# mode: julia
	eps(Float32)
# time: 2023-02-26 19:19:32 CST
# mode: julia
	eps(Float64)
# time: 2023-02-26 19:19:55 CST
# mode: julia
	1.0 == nextfloat(1.0)
# time: 2023-02-26 19:20:30 CST
# mode: julia
	1.0 ≈ nextfloat(1.0)
# time: 2023-02-26 19:23:03 CST
# mode: julia
	let
	    x = 1                                                                  
	        for i=1:100                            
	               x *= i                                                                  end                                                                    
	x
# time: 2023-02-26 19:24:41 CST
# mode: julia
	let
	    x =1
	    for i = 1:100
	        x*=i
	    end
	    x
	end
# time: 2023-02-26 19:25:25 CST
# mode: julia
	let                                                                        
	    x = BigInt(1)                                                          
	    for i=1:100                                                            
	        x *= i                                                             
	    end                                                                    
	    x                                                                      
	end
# time: 2023-02-26 19:26:04 CST
# mode: julia
	a = 0; a+= 1; a+=2;a
# time: 2023-02-26 19:26:48 CST
# mode: julia
	begin                   
	    a = 0                                                             
	    a += 1                                                             
	    a+=2                                                               
	    a                                                                  
	end
# time: 2023-02-26 19:28:18 CST
# mode: julia
	for i in 1:3
	    println(i)
	end
# time: 2023-02-26 19:29:06 CST
# mode: julia
	for i= 1:3
	    println(i)
	end
# time: 2023-02-26 19:30:07 CST
# mode: julia
	let                      
	    for i = 1:3             
	        j = i==1 ? 1 : j + 1             
	    end                                                                    
	    j                   
	end
# time: 2023-02-26 19:32:26 CST
# mode: julia
	let
	    local j
	    for i = 1:3
	        j= i== 1 ? 1 : j + 1
	    end
	    j
	end
# time: 2023-02-26 19:32:46 CST
# mode: julia
	global_j = 0
# time: 2023-02-26 19:34:00 CST
# mode: julia
	let
	    for i = 1:5
	        global_j += 1
	    end
	end
# time: 2023-02-26 19:34:39 CST
# mode: julia
	let
	    for i = 1:5
	        global global_j += 1
	    end
	end
# time: 2023-02-26 19:35:04 CST
# mode: julia
	global_j
# time: 2023-02-26 19:36:12 CST
# mode: julia
	using Primes
# time: 2023-02-26 19:37:24 CST
# mode: pkg
	Pkg.add("Primes")
# time: 2023-02-26 19:37:37 CST
# mode: pkg
	add("Primes")
# time: 2023-02-26 19:37:56 CST
# mode: julia
	import Pkg; Pkg.add("Primes")
# time: 2023-02-26 19:38:17 CST
# mode: julia
	using Primes
# time: 2023-02-26 19:39:04 CST
# mode: julia
	for i=1:typemax(Int8)                                                   
	    if isprime(i)                                                         
	        println(i)                                                    
	    end                                                              
	end
# time: 2023-02-26 19:40:09 CST
# mode: julia
	let i=Int8(0)                                                     
	    while i < typemax(Int8)                                           
	        i += Int8(1)                                                    
	        if isprime(i)                                                  
	            println(i)                                                 
	        end                                                             
	    end                                                                 
	end
# time: 2023-02-26 19:40:44 CST
# mode: julia
	ints = Int8(1):typemax(Int8)
# time: 2023-02-26 19:41:08 CST
# mode: julia
	boolean_mask = isprime.(ints)
# time: 2023-02-26 19:41:40 CST
# mode: julia
	Ints[boolean_mask]
# time: 2023-02-26 19:41:45 CST
# mode: julia
	ints[boolean_mask]
# time: 2023-02-26 19:42:20 CST
# mode: julia
	[x for x in Int8(1):typemax(Int8) if isprime(x)]
# time: 2023-02-26 19:42:50 CST
# mode: julia
	@ doc filter
# time: 2023-02-26 19:42:54 CST
# mode: julia
	@doc filter
# time: 2023-02-26 19:44:05 CST
# mode: julia
	function compare(x,y)                                                   
	    if x<y                                                          
	        relation = "less than"                                             
	    elseif x==y                                                          
	        relation = "equal to"                                              
	    else                                                                   
	        relation = "larger than to"                                        
	    end                                                                    
	    println("$x is $relation $(y).")             
	end
# time: 2023-02-26 19:44:23 CST
# mode: julia
	compare (generic function with 1 method)
# time: 2023-02-26 19:44:48 CST
# mode: julia
	function compare(x,y)                                                   
	    if x<y                                                          
	        relation = "less than"                                             
	    elseif x==y                                                          
	        relation = "equal to"                                              
	    else                                                                   
	        relation = "larger than to"                                        
	    end                                                                    
	    println("$x is $relation $(y).")             
	end
# time: 2023-02-26 19:45:12 CST
# mode: julia
	compare(3, 4)
# time: 2023-02-26 19:46:19 CST
# mode: julia
	try                                                              
	    x= [1]                                                                
	    x[0]                                      
	catch e                                                                  
	    @info "get error $e"        
	    throw(e)                                                      
	finally                                                              
	    println("I will be executed anyway :D")                           
	end
