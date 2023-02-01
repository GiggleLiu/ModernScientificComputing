struct Mod{T}
	value::T
	modulus::T
end

@inline function Base.:(+)(x::Mod{T}, y::Mod{T}) where {T}
	@assert x.modulus == y.modulus
	N = x.modulus
    t = widen(x.value) + widen(y.value)
    return Mod{T}(mod(t, N), N)
end

@inline function Base.:(*)(x::Mod{T}, y::Mod{T}) where {T}
	@assert x.modulus == y.modulus
	N = x.modulus
	q = widemul(x.value, y.value)         # multipy with added precision
	return Mod{T}(mod(q, N), N) # return with proper type
end

function big_integer_solve(f, ::Type{TI}, max_iter::Int=100) where TI
    N = typemax(TI)
    local res, respre, prodp
    for k = 1:max_iter
	    N = prevprime(N-TI(1))
        rk = f(N)
        if max_iter==1
            return BigInt(rk.value)  # needs test
        end
        if k != 1
            res, prodp = CRT_improve(respre, prodp, rk.value, rk.modulus)
        	respre == res && return res  # converged
            respre = res
        else  # k=1
            respre = BigInt(rk.value)
            prodp = BigInt(rk.modulus)
        end
    end
    @warn "result is potentially inconsistent."
    return res
end

function CRT_improve(val::BigInt, prodp::BigInt, remainder, p)
    M = prodp * p
    t1, t2 = invmod(p, prodp), invmod(prodp, p)
    mod(val * t1 * p + remainder * t2 * prodp, M), M
end
