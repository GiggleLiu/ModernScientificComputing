module LatticeGasCA

import UnicodePlots

export hpp_center_square, hpp_singledot, HPPLatticeGas, simulate, update!, AbstractLatticeGas, density

include("hpp.jl")
include("cuda.jl")

# using Requires
# function __init__()
#     @require CUDA="052768ef-5323-5732-b1bb-66c8b64840ba" include("cuda.jl")
# end

end
