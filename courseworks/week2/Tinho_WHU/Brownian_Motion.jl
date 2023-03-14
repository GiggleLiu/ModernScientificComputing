using BenchmarkTools
using Plots

function simulate_brownian_motion(n::Int64)
    x = 0.0
    y = 0.0
    x_positions = [x]
    y_positions = [y]

    for i in 1:n
        dx = randn()
        dy = randn()
        x += dx
        y += dy
        push!(x_positions, x)
        push!(y_positions, y)
    end

    return x_positions, y_positions
end

n_steps = 100
x_positions, y_positions = simulate_brownian_motion(n_steps)

plot(x_positions, y_positions, xlabel="x", ylabel="y", legend=false,title="2D simulation of Brownian Motion")

@benchmark simulate_brownian_motion($n_steps)