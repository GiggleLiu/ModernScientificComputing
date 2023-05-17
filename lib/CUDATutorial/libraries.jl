import SparseArrays, FFTW, LinearAlgebra, Random
using CUDA; CUDA.allowscalar(false)
using Test

@testset "CUSOLVER" begin
    A = randn(10, 10)
    v = randn(10)
    # operations
    @test Array(CuArray(A) \ CuArray(v)) ≈ A \ Array(v)
end

@testset "CUSPARSE" begin
    Random.seed!(2)
    # initialize a CUDA sparse array
    A = SparseArrays.sprand(10, 10, 0.2)
    cuA = CUSPARSE.CuSparseMatrixCSC(A)

    @show SparseArrays.nnz(cuA)

    # operations
    v = randn(10)
    cuv = CuArray(v)
    # matrix vector
    @test Array(cuA * cuv) ≈ A * v

    # matrix matrix
    @test Array(cuA * cuA) ≈ A * A

    # gaussian eliminatjion
    cuA += Diagonal(CUDA.randn(10))
    A = Array(cuA)
    @show CuArray(LinearAlgebra.UpperTriangular(cuA) \ cuv)
    @test Array(LinearAlgebra.UpperTriangular(cuA) \ cuv) ≈ LinearAlgebra.UpperTriangular(A) \ v
end

@testset "CUFFT" begin
    v = randn(10)
    @test Array(CUFFT.fft(CuArray(v))) ≈ FFTW.fft(v)

    # 2D fft
    A = randn(10, 10)
    @test Array(CUFFT.fft(CuArray(A))) ≈ FFTW.fft(A)
end
