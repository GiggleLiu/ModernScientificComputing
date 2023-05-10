using CUDA
using BenchmarkTools
using LinearAlgebra

n = 2000
cua = CUDA.randn(n, n)
cub = CUDA.randn(n, n)
cuc = CUDA.zeros(n, n)
@time CUDA.@sync mul!(cuc, cua, cub);
a = Array(cua)
b = Array(cub)
c = zeros(n, n)
@time mul!(c, a, b);

Array(cuc) ≈ c

# this function is copied from lecture 9
function poor_besselj(ν::Int, z::T; atol=eps(T)) where T
    k = 0
    s = (z/2)^ν / factorial(ν)
    out = s
    while abs(s) > atol
        k += 1
        s *= (-1) / k / (k+ν) * (z/2)^2
        out += s
    end
    out
end
factorial(n) = n == 1 ? 1 : factorial(n-1)*n
x = CuArray(randn(10000))
@benchmark CUDA.@sync poor_besselj.(1, $x)
@benchmark poor_besselj.(1, $(Array(x)))

############ Printing
function print_kernel()
    # this is how to get the "id" for the current thread
    i = (blockIdx().x-1) * blockDim().x + threadIdx().x
    @cuprintf "My id is %ld\n" Int(i)
    # must return nothing
    return
end
# launch a CUDA kernel on multiple threads and blocks
CUDA.@sync @cuda threads=2 blocks=2 print_kernel()

############ Indexing an CuArray
function one2n_kernel(A)
    i = (blockIdx().x-1) * blockDim().x + threadIdx().x
    # we can use if-else to avoid bound error
    @inbounds if i <= length(A)
        A[i] = i
    end
    return
end
A = CUDA.zeros(2000)
@cuda blocks=2 threads=1024 one2n_kernel(A)
Array(A)

############ Debugging
function dynamic_kernel(A)
	i = (blockIdx().x-1) * blockDim().x + threadIdx().x
	# we can use if-else to avoid bound error
	@inbounds if i <= length(A)
		A[i:i+1] = randn(2)  # error: dynamic allocation
	end
	return
end
# launch a CUDA kernel
@device_code_warntype @cuda blocks=2 threads=1024 dynamic_kernel(A)