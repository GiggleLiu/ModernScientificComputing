using CUDA
using CUDA.GPUArrays: gpu_call, @cartesianidx

export cpu

function update!(lg::HPPLatticeGas{ET, <:CuArray{ET}}) where ET
    @inline function kernel(ctx, lattice::AbstractArray{T}, cache) where T
        i, j = (@cartesianidx lattice).I
        nx, ny = size(lattice)
        @inbounds state = (i == nx ? zero(T) : left(lattice[i+1, j])) +
            (i == 1 ? zero(T) : right(lattice[i-1, j])) + 
            (j == ny ? zero(T) : down(lattice[i, j+1])) +
            (j == 1 ? zero(T) : up(lattice[i, j-1]))
        newstate = hpp_state_transfer_rule(state, i, j, nx, ny)
        @inbounds cache[i, j] = newstate
        return
    end
    gpu_call(kernel, lg.lattice, lg.cache)
    CUDA.synchronize()
    copyto!(lg.lattice, lg.cache)
    return lg
end

function CUDA.cu(lg::HPPLatticeGas)
    HPPLatticeGas(CuArray(lg.lattice), CuArray(lg.cache))
end

function cpu(lg::HPPLatticeGas)
    HPPLatticeGas(Array(lg.lattice), Array(lg.cache))
end