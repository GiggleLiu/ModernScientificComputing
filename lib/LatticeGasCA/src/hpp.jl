abstract type AbstractLatticeGas end
# 0001 denotes a site having one particle, and the particle moving right
# 0101 denotes a site having two particles, one move to the left and another move to the right.
for (k, DIRECTION) in enumerate([:right, :up, :left, :down])
    @eval $DIRECTION(x::T) where T<:Integer = x & (one(T) << $(k-1))
end

# Hardy–Pomeau–Pazzis (HPP) model
struct HPPLatticeGas{T<:Integer, MT<:AbstractMatrix{T}} <: AbstractLatticeGas
    lattice::MT
    cache::MT
end
HPPLatticeGas(lattice::AbstractMatrix) = HPPLatticeGas(lattice, similar(lattice))
density(lg::HPPLatticeGas) = count_ones.(lg.lattice)
Base.show(io::IO, hpp::HPPLatticeGas) = print(io, UnicodePlots.heatmap(Array(density(hpp)); width=size(hpp.lattice, 2), height=size(hpp.lattice, 1)))
Base.show(io::IO, ::MIME"text/plain", hpp::HPPLatticeGas) = Base.show(io, hpp)
Base.copy(hpp::HPPLatticeGas) = HPPLatticeGas(copy(hpp.lattice), copy(hpp.cache))
Base.:(==)(hpp::HPPLatticeGas, hpp2::HPPLatticeGas) = hpp.lattice == hpp2.lattice

#         top   (j=ny)
# left (i=1)    right (i=nx)
#        bottom (j=1)
function update!(lg::HPPLatticeGas{T}) where T
    nx, ny = size(lg.lattice)
    @inbounds for j=1:ny, i=1:nx
        state = (i == nx ? zero(T) : left(lg.lattice[i+1, j])) +
            (i == 1 ? zero(T) : right(lg.lattice[i-1, j])) + 
            (j == ny ? zero(T) : down(lg.lattice[i, j+1])) +
            (j == 1 ? zero(T) : up(lg.lattice[i, j-1]))
        newstate = hpp_state_transfer_rule(state, i, j, nx, ny)
        lg.cache[i, j] = newstate
    end
    copyto!(lg.lattice, lg.cache)
    return lg
end

function hpp_state_transfer_rule(state::T, i, j, nx, ny) where T
    if state == 0b0101       # right left
        # right-left collision
        state = T(0b1010)
    elseif state == 0b1010   # up down
        # up-down collision
        state = T(0b0101)
    else
        # rebound rule
        if i == 1 && !iszero(left(state))
            state += right(T(-1)) - left(T(-1))
        elseif i == nx && !iszero(right(state))
            state += left(T(-1)) - right(T(-1))
        end
        if j == 1 && !iszero(down(state))
            state += up(T(-1)) - down(T(-1))
        elseif j == ny && !iszero(up(state))
            state += down(T(-1)) - up(T(-1))
        end
    end
    return state
end


function hpp_center_square(nx, ny, density)
    lattice = sum(d-> (rand(nx, ny) .< density) .* (1<<d), 0:3)
    # add a square
    nmin = min(nx, ny)
    ssize = round(Int, nmin*0.15)
    l = round(Int, 0.5*(nmin - ssize))
    lattice[l+1:l+ssize, l+1:l+ssize] .= 15
    return HPPLatticeGas(lattice)
end

function hpp_singledot()
    nx, ny = 20, 20
    points = [(5, 5, 15)]
    lattice = zeros(Int, nx, ny)
    # add a square
    for (i, j, v) in points
        lattice[i, j] = v
    end
    return HPPLatticeGas(lattice)
end

"""
    simulate(lg::AbstractLatticeGas, niters::Int; verbose::Bool=false)

Simulate a lattice gas model `lg` for `niters` steps.
"""
function simulate(lg::AbstractLatticeGas, niters::Int; verbose::Bool=false)
    lg = copy(lg)
    verbose && println(lg)
    for _ = 1:niters
        update!(lg)
        verbose && (println(lg); sleep(0.2))
    end
    return lg
end