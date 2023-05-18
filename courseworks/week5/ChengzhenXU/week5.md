# 1. Review

```julia
julia> using SparseArrays

julia> m = 5
5

julia> n = 5
5

julia> rowindices = [3, 1, 1, 4, 5]
5-element Vector{Int64}:
 3
 1
 1
 4
 5

julia> colindices = [1, 2, 3, 3, 4]
5-element Vector{Int64}:
 1
 2
 3
 3
 4

julia> data = [0.799, 0.942, 0.848, 0.164, 0.637]
5-element Vector{Float64}:
 0.799
 0.942
 0.848
 0.164
 0.637

julia> sp = sparse(rowindices, colindices, data, m, n)
5×5 SparseMatrixCSC{Float64, Int64} with 5 stored entries:
  ⋅     0.942  0.848   ⋅      ⋅ 
  ⋅      ⋅      ⋅      ⋅      ⋅ 
 0.799   ⋅      ⋅      ⋅      ⋅ 
  ⋅      ⋅     0.164   ⋅      ⋅ 
  ⋅      ⋅      ⋅     0.637   ⋅ 

julia> println(sp.colptr)
[1, 2, 3, 5, 6, 6]

julia> println(sp.rowval)
[3, 1, 1, 4, 5]

julia> println(sp.nzval)
[0.799, 0.942, 0.848, 0.164, 0.637]
```


# 2. Coding(1)
```julia
julia> function my_spv(sp, v)
           @assert sp.n == size(v, 1)
           n = sp.n
           m = sp.m
           spv = zeros(Float64, m)
           sp_val = sp.nzval
           sp_row = sp.rowval
           for i in 1:n
               for j in nzrange(sp, i)
                   k = sp_row[j]
                   spv[k] += sp_val[j] * v[i]
               end
           end
           return spv
       end
my_spv (generic function with 1 method)

```


```julia
julia> using SparseArrays, Test

julia> @testset "sparse matrix - vector multiplication" begin
               for k = 1:100
                       m, n = rand(1:100, 2)
                       density = rand()
                       sp = sprand(m, n, density)
                       v = randn(n)
               @test Matrix(sp) * v ≈ my_spv(sp, v)
               end
       end
Test Summary:                         | Pass  Total  Time
sparse matrix - vector multiplication |  100    100  0.0s
Test.DefaultTestSet("sparse matrix - vector multiplication", Any[], 100, false, false, true, 1.684339191866241e9, 1.684339191870808e9)
```

Credits to Xuanzhao Gao