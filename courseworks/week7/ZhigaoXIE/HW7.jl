using Optim
using ForwardDiff
using Plots
using LinearAlgebra

function loss_function(x, edges)
    n = size(x, 2)
    loss = 0.0
    for (u, v) in edges
        if norm(x[:, u] - x[:, v]) > 1.0
            loss += norm(x[:, u] - x[:, v]) - 1.0
        end
    end
    for u in 1:n
        for v in (u + 1):n
            if (u, v) ∉ edges && norm(x[:, u] - x[:, v]) < 1.0
                loss += 1.0 - norm(x[:, u] - x[:, v])
            end
        end
    end
    return loss
end

function unit_disk_embedding(edges, n)
    # Assign each vertex with a random coordinate
    x0 = rand(2, n)
    res = optimize(x -> loss_function(x, edges), x0, BFGS(), autodiff=:forward)

    # Extract the optimal coordinates from the optimizer result
    x_opt = res.minimizer

    # Plot the resulting graph
    plot()
    scatter!(x_opt[1, :], x_opt[2, :], markersize=6)
    for (u, v) in edges
        plot!([x_opt[1, u], x_opt[1, v]], [x_opt[2, u], x_opt[2, v]], linewidth=2)
    end
    xlims!(-2, 4)
    ylims!(-1, 4)
    xticks!(-2:0.5:4)
    yticks!(-1:0.5:4)
    xlabel!("x")
    ylabel!("y")
    return x_opt
end

# Define the graph
n = 10
edges = [
    (1, 2), (1, 3),
    (2, 3), (2, 4), (2, 5), (2, 6),
    (3, 5), (3, 6), (3, 7),
    (4, 5), (4, 8),
    (5, 6), (5, 8), (5, 9),
    (6, 7), (6, 8), (6, 9),
    (7, 9), (8, 9), (8, 10), (9, 10)
]

# Generate the unit-disk embedding and plot the resulting graph
x_opt = unit_disk_embedding(edges, n)
savefig("unit_disk_embedding.png")

