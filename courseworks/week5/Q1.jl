using SparseArrays

using LinearAlgebra
begin
sp = sparse([3, 1, 1, 4, 5],[1, 2, 3, 3, 5],[0.799, 0.942, 0.848, 0.164, 0.637])

println(Matrix(sp))
print("sp.colptr = ")
println( sp.colptr)
print("sp.rowval = ")
println(sp.rowval)
print("sp.nzval = ")
println(sp.nzval)
end

#julia "e:\HKUSTgz\courses\Julia\week5\tempCodeRunnerFile.jl"
#[0.0 0.942 0.848 0.0 0.0; 0.0 0.0 0.0 0.0 0.0; 0.799 0.0 0.0 0.0 0.0; 0.0 0.0 0.164 0.0 0.0; 0.0 0.0 0.0 0.0 0.637]
#sp.colptr = [1, 2, 3, 5, 5, 6]
#sp.rowval = [3, 1, 1, 4, 5]
#sp.nzval = [0.799, 0.942, 0.848, 0.164, 0.637]
