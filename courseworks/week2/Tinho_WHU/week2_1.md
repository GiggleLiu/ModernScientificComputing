|                            | is concrete | is primitive | is abstract | is bits type | is mutable |
| -------------------------- | ----------- | ------------ | ----------- | ------------ |:---------- |
| ComplexF64                 | 1           | 0            | 0           | 1            | 1          |
| Complex{AbstractFloat}     | 1           | 0            | 0           | 0            | 1          |
| Complex{<:AbstractFloat}   | 0           | 0            | 0           | 0            | 0          |
| AbstractFloat              | 0           | 0            | 1           | 0            | 0          |
| Union{Float64, ComplexF64} | 0           | 0            | 0           | 0            | 0          |
| Int32                      | 1           | 1            | 0           | 1            | 1          |
| Matrix{Float32}            | 1           | 0            | 0           | 0            | 1          |
| Base.RefValue              | 0           | 0            | 0           | 0            | 0          |

1 for yes, 0 for no
