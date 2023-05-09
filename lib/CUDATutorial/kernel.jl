using CUDA

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
A = CUDA.zeros(2000)
# launch a CUDA kernel
@device_code_warntype @cuda blocks=2 threads=1024 dynamic_kernel(A)