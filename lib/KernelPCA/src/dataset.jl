module DataSets

using KernelPCA: Point
export quadratic

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


end