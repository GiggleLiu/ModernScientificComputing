
# mode: julia
	true isa Bool
# time: 2023-03-08 22:47:53 CST
# mode: julia
	sizeof(Bool)
# time: 2023-03-08 22:48:19 CST
# mode: julia
	!true
# time: 2023-03-08 22:48:46 CST
# mode: julia
	true && false
# time: 2023-03-08 22:49:09 CST
# mode: julia
	true || false
# time: 2023-03-08 22:49:25 CST
# mode: julia
	true ⊻ false
# time: 2023-03-08 22:49:36 CST
# mode: julia
	true ⊻  false
# time: 2023-03-08 22:50:03 CST
# mode: julia
	3 isa Int
# time: 2023-03-08 22:52:17 CST
# mode: julia
	0*3 isa UInt8
# time: 2023-03-08 22:53:17 CST
# mode: julia
	bitstring(3)
# time: 2023-03-08 22:55:17 CST
# mode: julia
	bitstring(0x3)
# time: 2023-03-08 22:55:30 CST
# mode: julia
	sizeof(3)
# time: 2023-03-08 22:55:40 CST
# mode: julia
	sizeof(0x3)
# time: 2023-03-08 22:55:48 CST
# mode: julia
	7 % 3
# time: 2023-03-08 22:55:55 CST
# mode: julia
	7 / 3
# time: 2023-03-08 22:56:05 CST
# mode: julia
	7 ÷ 3
# time: 2023-03-08 22:56:22 CST
# mode: julia
	7 << 1
# time: 2023-03-08 22:56:29 CST
# mode: julia
	7 >> 1
# time: 2023-03-08 22:56:38 CST
# mode: julia
	 7 | 1
# time: 2023-03-08 22:56:46 CST
# mode: julia
	7 & 1
# time: 2023-03-08 22:56:53 CST
# mode: julia
	7 ⊻ 1
# time: 2023-03-08 22:57:01 CST
# mode: julia
	3.2 isa Float64
# time: 2023-03-08 22:57:09 CST
# mode: julia
	3.2f2 isa Float32
# time: 2023-03-08 22:57:20 CST
# mode: julia
	3.2 + 3im isa ComplexF64
# time: 2023-03-08 22:57:34 CST
# mode: julia
	typeof(π)
# time: 2023-03-08 22:57:48 CST
# mode: julia
	typeof(ℯ)
# time: 2023-03-08 22:58:05 CST
# mode: julia
	3.0 ^ 3
# time: 2023-03-08 22:58:15 CST
# mode: julia
	"3.0" isa String
# time: 2023-03-08 22:58:51 CST
# mode: julia
	(1, "3.0") isa Tuple
# time: 2023-03-08 22:58:58 CST
# mode: julia
	(1, "3.0")[1]
# time: 2023-03-08 22:59:05 CST
# mode: julia
	(3.0=>"3.0") isa Pair
# time: 2023-03-08 22:59:14 CST
# mode: julia
	(3.0=>"3.0").first
# time: 2023-03-08 22:59:20 CST
# mode: julia
	(3.0=>"3.0").second
# time: 2023-03-08 22:59:29 CST
# mode: julia
	[2, 3.0] isa Vector
# time: 2023-03-08 22:59:48 CST
# mode: julia
	1:10 isa UnitRange
# time: 2023-03-08 22:59:59 CST
# mode: julia
	length(1:10)
# time: 2023-03-08 23:00:05 CST
# mode: julia
	1:2:10 isa StepRange
# time: 2023-03-08 23:00:22 CST
# mode: julia
	d = Dict(3.0=>"three", 4.0=>"four")
# time: 2023-03-08 23:00:22 CST
# mode: julia
	Dict{Float64, String} with 2 entries:
# time: 2023-03-08 23:00:22 CST
# mode: julia
	  4.0 => "four"
# time: 2023-03-08 23:01:21 CST
# mode: julia
	d = Dict(3.0=>"three", 4.0=>"four")
# time: 2023-03-08 23:01:37 CST
# mode: julia
	d isa Dict
# time: 2023-03-08 23:01:48 CST
# mode: julia
	keys(d)
# time: 2023-03-08 23:01:55 CST
# mode: julia
	values(d)
# time: 2023-03-08 23:02:04 CST
# mode: julia
	d[3.0]
# time: 2023-03-08 23:02:11 CST
# mode: julia
	get(d, 3.0, "not exist")
# time: 2023-03-08 23:02:27 CST
# mode: julia
	get(d, 5.0, "not exist")
# time: 2023-03-08 23:02:44 CST
# mode: julia
	haskey(d, 3.0)
# time: 2023-03-08 23:02:59 CST
# mode: julia
	UInt64(3) isa UInt64
# time: 2023-03-08 23:03:06 CST
# mode: julia
	Float32(3) isa Float32
# time: 2023-03-08 23:03:43 CST
# mode: julia
	[(1, "3.0")...]
# time: 2023-03-08 23:03:57 CST
# mode: julia
	([1, 3.0]...,)
# time: 2023-03-08 23:04:27 CST
# mode: julia
	((3.0=>"3.0")...,)
# time: 2023-03-08 23:04:35 CST
# mode: julia
	(1:2:10...,)
# time: 2023-03-08 23:04:47 CST
# mode: julia
	[1:2:10...]
# time: 2023-03-08 23:05:05 CST
# mode: julia
	[Dict(3.0=>"three", 4.0=>"four")...]
# time: 2023-03-08 23:05:12 CST
# mode: julia
	collect(1:2:10)
# time: 2023-03-08 23:05:20 CST
# mode: julia
	typemin(Int)
# time: 2023-03-08 23:05:27 CST
# mode: julia
	typemax(Int)
# time: 2023-03-08 23:05:42 CST
# mode: julia
	typemax(UInt64)
# time: 2023-03-08 23:05:54 CST
# mode: julia
	 typemin(Float64)
# time: 2023-03-08 23:06:02 CST
# mode: julia
	typemax(Float64)
# time: 2023-03-08 23:06:08 CST
# mode: julia
	zero(Float64)
# time: 2023-03-08 23:06:16 CST
# mode: julia
	one(Float64)
# time: 2023-03-08 23:06:24 CST
# mode: julia
	0.0 * Inf
# time: 2023-03-08 23:06:32 CST
# mode: julia
	Inf == Inf
# time: 2023-03-08 23:06:43 CST
# mode: julia
	NaN == NaN
# time: 2023-03-08 23:06:53 CST
# mode: julia
	eps(Float32)
# time: 2023-03-08 23:07:03 CST
# mode: julia
	eps(Float64)
# time: 2023-03-08 23:07:12 CST
# mode: julia
	1.0 == nextfloat(1.0)
# time: 2023-03-08 23:07:29 CST
# mode: julia
	 1.0 ≈ nextfloat(1.0)
# time: 2023-03-08 23:08:27 CST
# mode: julia
	let
	 x = 1                                                                  
	           for i=1:100  # iterates over 1, 2, ..., 100                            
	               x *= i                                                             
	           end                                                                    
	           x   
	       end
# time: 2023-03-08 23:08:40 CST
# mode: julia
	let                                                                        
	           x = BigInt(1)                                                          
	           for i=1:100                                                            
	               x *= i                                                             
	           end                                                                    
	           x                                                                      
	       end
# time: 2023-03-08 23:09:07 CST
# mode: julia
	a = 0; a += 1; a+=2; a
# time: 2023-03-08 23:09:35 CST
# mode: julia
	begin
	a = 0                                                                  
	           a += 1                                                                 
	           a+=2                                                                   
	           a                                                                      
	       end
# time: 2023-03-08 23:10:14 CST
# mode: julia
	for i in 1:3
	println(i)                                                             
	       end
# time: 2023-03-08 23:10:29 CST
# mode: julia
	for i = 1:3                                                                
	           println(i)                                                             
	       end
# time: 2023-03-08 23:12:09 CST
# mode: julia
	let
	for i = 1:3
	    j = i==1
	    end
	    j
	end
# time: 2023-03-08 23:13:41 CST
# mode: julia
	let                                                                        
	           x = BigInt(1)                                                          
	           for i=1:100                                                            
	               x *= i                                                             
	           end                                                                    
	           x                                                                      
	       end
# time: 2023-03-08 23:14:28 CST
# mode: julia
	let
	local j
	    for i=1:3
	        j=i==1?1:j+1
# time: 2023-03-08 23:14:50 CST
# mode: julia
	let
	local j
	    for i=1:3
	        j=i==1 ?  1:j+1
# time: 2023-03-08 23:17:03 CST
# mode: julia
	let
	     local j
	    for i=1:3
	        j = i==1 ? 1 : j + 1 
	    end
	    j
	end
# time: 2023-03-08 23:17:21 CST
# mode: julia
	global_j = 0
# time: 2023-03-08 23:18:04 CST
# mode: julia
	let                                                                        
	           local j   
	           for i = 1:3                                                            
	               j = i==1 ? 1 : j + 1                                               
	           end                                                                    
	           j                                                                      
	       end
# time: 2023-03-08 23:18:55 CST
# mode: julia
	let                                                                        
	           for i=1:5                                                              
	               global_j += 1  
	           end                                                                    
	       end
# time: 2023-03-08 23:19:34 CST
# mode: julia
	let                                                                        
	           for i=1:5                                                              
	               global global_j += 1                              
	           end                                                                    
	       end
# time: 2023-03-08 23:19:57 CST
# mode: julia
	using Primes
# time: 2023-03-08 23:20:32 CST
# mode: julia
	for i=1:typemax(Int8)                                                      
	           if isprime(i)                                                          
	               println(i)                                                         
	           end                                                                    
	       end
# time: 2023-03-08 23:22:28 CST
# mode: pkg
	registry add
# time: 2023-03-08 23:23:37 CST
# mode: julia
	using Primes
# time: 2023-03-08 23:23:53 CST
# mode: julia
	for i=1:typemax(Int8)                                                      
	           if isprime(i)                                                          
	               println(i)                                                         
	           end                                                                    
	       end
# time: 2023-03-08 23:25:03 CST
# mode: julia
	ints = Int8(1):typemax(Int8)
# time: 2023-03-08 23:25:33 CST
# mode: julia
	boolean_mask = isprime.(ints)
# time: 2023-03-08 23:26:03 CST
# mode: julia
	 ints[boolean_mask]
# time: 2023-03-08 23:26:30 CST
# mode: julia
	[x for x in Int8(1):typemax(Int8) if isprime(x)]
# time: 2023-03-08 23:26:49 CST
# mode: julia
	filter(isprime, Int8(1):typemax(Int8))
# time: 2023-03-08 23:27:12 CST
# mode: julia
	 @doc filter
# time: 2023-03-08 23:27:54 CST
# mode: julia
	function compare(x,y)                                                      
	           if x < y                                                               
	               relation = "less than"                                             
	           elseif x == y                                                          
	               relation = "equal to"                                              
	           else                                                                   
	               relation = "larger than to"                                        
	           end                                                                    
	           println("$x is $relation $(y).")                
	       end
# time: 2023-03-08 23:28:07 CST
# mode: julia
	 compare(3, 4)
# time: 2023-03-08 23:29:05 CST
# mode: julia
	try                                                                        
	           x = [1]                                                                
	           x[0]   
	       catch e                                                                    
	           @info "get error $e"  
	           throw(e)                                                               
	       finally                                                                    
	           println("I will be executed anyway ;D")                                
	       end
# time: 2023-03-08 23:29:29 CST
# mode: shell
	cd
# time: 2023-03-08 23:29:49 CST
# mode: shell
	cd /.julia
# time: 2023-03-08 23:30:09 CST
# mode: shell
	ls
# time: 2023-03-08 23:30:12 CST
# mode: shell
	cd
# time: 2023-03-08 23:30:29 CST
# mode: shell
	cd ~
# time: 2023-03-08 23:30:45 CST
# mode: shell
	cd .julia
# time: 2023-03-08 23:30:47 CST
# mode: shell
	ls
# time: 2023-03-08 23:30:55 CST
# mode: shell
	cd logs/
# time: 2023-03-08 23:30:57 CST
# mode: shell
	ls
# time: 2023-03-08 23:32:37 CST
# mode: shell
	cp repl_history.jl ~/home/yanyu
# time: 2023-03-08 23:33:20 CST
# mode: shell
	cp repl_history.jl ~
