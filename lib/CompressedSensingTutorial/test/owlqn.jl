using Test, CompressedSensingTutorial.L1Convex
using Random

@testset "original" begin
    Random.seed!(111)
    N = 100
    X = randn(N, 3)
    y = X * [2, -2, 0.0] .+ randn(N) .+ 0.1
    X = hcat(X, ones(N)) # add intercept term

    # convex function to minimize (here, MSE)
    # note that this function should not include L1 penalty, OWL-QN algorithm applies L1 penalty during gradient update step
    # parameters beta must be a 1D vector
    # in this implementation, all elements of beta are L1 regularized (e.g., including intercept parameter)
    function f(beta::Vector{Float64})
        diff = y - X * beta;
        sum(diff.^2.0) / size(y)[1]
    end

    # gradient function
    function ∇f(beta::Vector{Float64})
        -2 .* X' * (y - X * beta) / size(y)[1]
    end

    # initialize parameters
    beta = ones(size(X)[2])

    # optimization with λ = 0.2 regularization strength
    λ = 0.2
    M = OWLQN(typeof(beta); λ);

    for i in 1:100    
        beta = step!(M, f, ∇f, beta);
        
        mse = f(beta);
        nrm = sum(abs.(beta))
        loss = mse + λ * nrm
        
        print(string("Iteration: ", i, " Loss: ", loss, " MSE: ", mse, "\n"))
    end

    # OWL-QN
    print(string("OWL-QN L1-regularized solution: ", round.(beta, digits=3),"\n"))

    # OLS
    print(string("OLS solution: ", round.(inv(X' * X) * X' * y, digits=3),"\n"))

    @test isapprox(round.(beta, digits=3), round.(inv(X' * X) * X' * y, digits=3); atol=0.3)
end