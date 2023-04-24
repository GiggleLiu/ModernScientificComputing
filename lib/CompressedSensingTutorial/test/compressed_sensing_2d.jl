using CompressedSensingTutorial
using CompressedSensingTutorial: objective_dct, gradient_dct!, gradient_dct
using Test
using Images, FiniteDifferences, FFTW, Optim
using Random

@testset "waterfall gradient test" begin
    Random.seed!(3)
	C = 0.1
    sample_probability = 0.1
    img = Float64.(Gray.(Images.load(joinpath(@__DIR__, "waterfall.jpeg"))))
    samples = sample_image_pixels(img, sample_probability)

	x0 = rand(size(img)...)
    # the gradient obtained with the finite difference method
	g1 = FiniteDifferences.central_fdm(5, 1)(x->objective_dct((y=copy(x0); y[1]=x; y), samples; C), x0[1])
	g2 = FiniteDifferences.central_fdm(5, 1)(x->objective_dct((y=copy(x0); y[2]=x; y), samples; C), x0[2])
    # the gradient obtained with the manual gradient
	gobj = gradient_dct(x0, samples; C)
    @test isapprox(g1, gobj[1]; rtol=1e-2)
    @test isapprox(g2, gobj[2]; rtol=1e-2)
end

@testset "optimization LBFGS" begin
    Random.seed!(3)
    # compressed sensing optimization
    C = 0.01
    sample_probability = 0.1
    img = Float64.(Gray.(Images.load(joinpath(@__DIR__, "waterfall.jpeg"))))
    samples = sample_image_pixels(img, sample_probability)
	optres = optimize(
                    x->objective_dct(x, samples; C),
                    (g, x)->gradient_dct!(g, x, samples; C),
                    rand(Float64, size(img)...),
                    LBFGS(),
                    Optim.Options(g_tol = 1e-5,
                             iterations = 100,
                             store_trace = false,
                             show_trace = true))
    restored_img = FFTW.idct(optres.minimizer)
    @test norm(restored_img[samples.indices] - img[samples.indices]) <= 5
    @test norm(optres.minimizer, 1) <= 30000
    display(Gray.(FFTW.idct(optres.minimizer)))
    display(Gray.(optres.minimizer))
end