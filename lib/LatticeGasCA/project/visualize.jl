using WGLMakie
using LatticeGasCA

function make_video(lg::AbstractLatticeGas; filename::String="lattice-gas.mp4", nframes::Int=120)
    lattice_data = Observable(LatticeGasCA.density(lg))
    fig, axis, plt = Makie.heatmap(lattice_data)

    Makie.record(fig, filename, 1:nframes) do frame
        notify.((lattice_data,))
        lattice_data[] = LatticeGasCA.density(update!(lg))
    end
end


hpp = hpp_center_square(200, 200, 0.01);
make_video(hpp)