using Random

# 0001 denotes a site having one particle, and the particle moving right
# 0101 denotes a site having two particles, one move to the left and another move to the right.
for (k, DIRECTION) in enumerate([:right, :up, :left, :down])
    @eval $DIRECTION(x::T) where T<:Integer = x & (one(T) << $(k-1))
end

function update!(output, lattice)
    for j=1:ny, i=1:nx
        state = left(lattice[i+1, j]) + right(lattice[i-1, j]) + down(lattice[i, j+1]) + up(lattice[i, j-1])
        if state == 0b0101       # right left
            state = 0b1010
        elseif state == 0b1010   # up down
            state = 0b0101
        end
    end
end

function init_lattice(nx, ny, density)
    lattice = sum(d-> rand(nx, ny) .< density .* (1<<d), 0:2)
    # add a square
    ssize = rount(Int, nx*0.15)
    l = round(Int, 0.5*(nx - ssize))
    lattice[l+1:l+ssize, l+1:l+ssize] .= 15
    return lattice
end

function run(nx, ny, density; niters::Int=1000)
    lattice = init_lattice(nx, ny, density)
    cache = copy(lattice)
    for i = 1:niters
        cache .= update.(lattice)
        lattice, cache = cache, lattice
    end
end

run(128, 128, 0.5)