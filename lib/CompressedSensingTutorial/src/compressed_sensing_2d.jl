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
    return Ax_b' * Ax_b .+ C .* norm(x, 1)
end

function gradient_dct!(g, x, samples::ImageSamples; C=0.0)
    # gradient is 2 * (A' * A x - A' * sample_values) + sign(x)
    Ax_b = idct(x)[samples.indices] .- samples.values
    padded = zero_padded(samples, Ax_b)
    g .= 2 .* dct(padded) .+ C .* sign.(x)
    return g
end
gradient_dct(x, samples::ImageSamples; C=0.0) = gradient_dct!(zero(x), x, samples; C)

# zero pad the sample to target size
function zero_padded(samples::ImageSamples{T}, values::AbstractVector{T}) where T
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
* `C` is the factor to reduce the l₁ norm of the image in momentum space.
"""
function sensing_image(samples::ImageSamples; C)
    optres = optimize(
        x->objective_f(x, samples.indices, samples.values; C),
        (g, x)->objective_g!(g, x, samples.indices, samples.values; C),
        rand(Float64, samples.size...),
        LBFGS(),
        Optim.Options(g_tol = 1e-5,
                    iterations = 200,
                    store_trace = false,
                    show_trace = true)
    )
    return idct(optres)
end