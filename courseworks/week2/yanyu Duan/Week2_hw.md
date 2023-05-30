## Fill the following form
|                            | is concrete | is primitive | is abstract | is bits | is mutable |
|----------------------------|-------------|--------------|-------------|---------|------------|
| ComplexF64                 | T           | F            | F           | T       | F          |
| Complex{AbstractFloat}     | T           | F            | F           | F       | F          |
| Complex{<:AbstractFloat}   | F           | F            | F           | F       | F          |
| AbstractFloat              | F           | F            | T           | F       | F          |
| Union{Float64, ComplexF64} | F           | F            | F           | F       | F          |
| Int32                      | T           | T            | F           | T       | F          |
| Matrix{Float32}            | T           | F            | F           | F       | T          |
| Base.RefValue              | F           | F            | F           | F       | T          |

T means true and F means false.
