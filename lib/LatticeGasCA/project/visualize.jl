using GLMakie
using LatticeGasCA

function make_video(lg::AbstractLatticeGas; filename::String="lattice-gas.mp4", nframes::Int=120)
    lattice_data = Observable(density(lg))
    fig, axis, plt = heatmap(lattice_data)

    record(fig, filename, 1:nframes) do frame
        notify.((lattice_data,))
        lattice_data[] = density(update!(lg))
    end
end