"""
    ImageSamples{T, IT<:AbstractVector{CartesianIndex{2}}, VT<:AbstractVector{T}}
    ImageSamples(size, indices, values)

A set of pixels sampled from the image.
"""
struct ImageSamples{T, IT<:AbstractVector{CartesianIndex{2}}, VT<:AbstractVector{T}}
    size::Tuple{Int, Int}
    indices::IT
    values::VT
end

"""
    sample_image_pixels(img::AbstractMatrix, probability::Real)

Sample a set of image pixels from the input image (a matrix).
Returns a [`ImageSamples`](@ref) instance.

### Arguments
* `img` is the input image, usually in the form a floating point matrix.
* `probability` is the probability include a pixel in to the sample.
"""
function sample_image_pixels(img::AbstractMatrix, probability::Real)
	k = round(Int, length(img) * probability)
	indices = StatsBase.sample(CartesianIndices(img), k, replace=false) # random sample of indices
	values = img[indices]
    return ImageSamples(size(img), indices, values)
end

function objective_dct(x, samples::ImageSamples; C=0.0)
    # constraint A*x = sample_values, minimize norm(x, 1)
    Ax_b = idct(x)[samples.indices] .- samples.values
    loss = norm(Ax_b, 2)
    if !iszero(C)
        loss += C .* norm(x, 1)
    end
    return loss
end

function gradient_dct!(g, x, samples::ImageSamples; C=0.0)
    # gradient is 2 * (A' * A x - A' * sample_values) + sign(x)
    Ax_b = idct(x)[samples.indices] .- samples.values
    padded = zero_padded(samples, Ax_b)
    if !iszero(C)
        g .= 2 .* dct(padded) .+ C .* sign.(x)
    else
        g .= 2 .* dct(padded)
    end
    return g
end
gradient_dct(x, samples::ImageSamples; C=0.0) = gradient_dct!(zero(x), x, samples; C)

# zero pad the sample to target size
function zero_padded(samples::ImageSamples{T}, values::AbstractVector{T}=samples.values) where T
    x = similar(values, samples.size...)
    fill!(x, zero(T))
    x[samples.indices] .= values
    return x
end

raw"""
    sensing_image(samples::ImageSamples; C) -> AbstractMatrix

Taking a sample of pixels from a gray scale image, and returns the original image by minimizing the following loss function w.r.t. variables ``x``
```math
\|A x - b\|_2 + C\|x\|_1,
```
where ``A`` is the sampled rows of the 2D DCT matrix, ``x`` is the image in the momentum space.
``b`` is the sampled pixel values, and ``C`` is a hyper-parameter explained bellow.

### Arguments
* `samples` is an [`ImageSamples`](@ref) instance.

### Keyword arguments
* `img0` is the initial guess of the image, default value is a random matrix.
* `C = 0.2` is the factor to reduce the l₁ norm of the image in momentum space.
* `iterations = 100` is the number of iterations to optimize.
* `g_tol = 1e-5` is the value below which the gradient norm will trigger a program break condition.
* `show_trace = false` is the switch to print optimization information.
* `optimizer = :OWLQN` is the optimizer, it should be one of :OWLQN and :LBFGS.
"""
function sensing_image(samples::ImageSamples;
            img0 = StatsBase.rand!(similar(samples.values, samples.size...)),
            C::Real=0.2,
            iterations::Int=100,
            g_tol::Real=1e-5,
            show_trace::Bool=false,
            optimizer::Symbol = :OWLQN,
            linesearch = L1Convex.SimpleLinesearch()
        )
    # initial vector
    x0 = dct(img0)
    # objective function
    if optimizer == :LBFGS
        f = x->objective_dct(x, samples; C)
        g! = (g, x)->gradient_dct!(g, x, samples; C)
        optres = optimize(f, g!, x0,
            LBFGS(; linesearch),
            Optim.Options(; g_tol,
                        iterations,
                        show_trace)
        )
        return idct(optres.minimizer)
    elseif optimizer == :OWLQN
        f = x -> objective_dct(x, samples; C=0.0)
        g = x -> gradient_dct(x, samples; C=0.0)
        opt = L1Convex.OWLQN(typeof(x0); λ=C, m=10, linesearch)
        for i = 1:iterations
            x0 = L1Convex.step!(opt, f, g, x0)
            if show_trace
                @info "Iteration: $i, f(x): $(f(x0)), l1-norm: $(norm(x0, 1)), loss = $(f(x0) + C*norm(x0, 1))"
            end
            norm(opt.Δg) < g_tol && return idct(x0)
        end
        return idct(x0)
    else
        error("Unknown optimizer: $optimizer")
    end
end