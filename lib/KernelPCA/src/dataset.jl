module DataSets

using KernelPCA: Point
export quadratic, linear, curve, rings

function quadratic(n::Int; xspan=1, noise=0.1)
    xs = randn(n) .* xspan
    ys = xs .^ 2 .+ noise .* randn(n)
    return Point{2, Float64}[Point(x, y) for (x, y) in zip(xs, ys)]
end

function linear(n::Int; xspan=1, noise=0.1, offsety=0.0)
    xs = randn(n) .* xspan
    ys = xs .+ noise .* randn(n) .+ offsety
    return Point{2, Float64}[Point(x, y) for (x, y) in zip(xs, ys)]
end

function curve(n::Int; xspan=1, noise=0.1)
    xs = randn(n) .* xspan
    ys = (xs .- 1) .^ 2 .+ noise .* randn(n)
    return Point{2, Float64}[Point(x, y) for (x, y) in zip(xs, ys)]
end

function rings(n::Int; radius=1.0, width=0.1)
    vcat([let
            angles = rand(n) * 2π
            radis = radi .+ randn(n) * width
            [Point(r*cos(angle), r*sin(angle)) for (r, angle) in zip(radis, angles)]
        end for radi in radius]...)
end
end