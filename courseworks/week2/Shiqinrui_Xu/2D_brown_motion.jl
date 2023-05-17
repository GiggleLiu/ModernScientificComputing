using Random, Plots

function simulate_brownian_motion_2d(n_steps)
    # Set initial position to the origin
    pos = [0.0, 0.0]
    
    # Initialize an array to store the particle trajectory
    traj = zeros(n_steps+1, 2)
    traj[1, :] = pos
    
    # Set the standard deviation of the step size
    step_size = 0.1
    
    # Loop over the specified number of steps
    for i in 1:n_steps
        # Generate a random step in x and y directions
        dx, dy = step_size * randn(2)
        
        # Update the position
        pos[1] += dx
        pos[2] += dy
        
        # Store the new position in the trajectory array
        traj[i+1, :] = pos
    end
    
    return traj
end

# Simulate Brownian motion for 10000 steps
traj = simulate_brownian_motion_2d(10000)

# Plot the trajectory
plot(traj[:, 1], traj[:, 2], xlabel="X", ylabel="Y", title="2D Brownian Motion", legend=false)

# Save the plot as a PNG file
savefig("result.png")