using SparseArrays

using LinearAlgebra

sp = sparse([3, 1, 1, 4, 5],[1, 2, 3, 5, 5],[0.799, 0.942, 0.848, 0.164, 0.637])

println(sp)

println(sp.colptr)

println(sp.rowval)

println(sp.nzval)

