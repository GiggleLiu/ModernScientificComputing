### A Pluto.jl notebook ###
# v0.19.19

using Markdown
using InteractiveUtils

# ╔═╡ 129914e6-66cb-4ab9-a29e-8e317c0c9bc3
using PlutoUI

# ╔═╡ ab3525e4-c4bb-11ed-2c7e-ab007b9c9196
using FFTW

# ╔═╡ 869f12fb-3ddb-4962-9243-9e0ce1f43e1d
md"""
### Fourier transformation

Given a function $f(x)$, the Fourier transformation is defined as

```math
F(u) = \int_{-\infty}^{\infty} e^{-2\pi iux} f(x) dx.
```

Its inverse process, or the inverse Fourier transformation is defined as

```math
f(x) = \int_{-\infty}^{\infty} e^{2\pi iux} F(u) dk
```
"""

# ╔═╡ efbde06c-c892-4d49-8c48-ae21d1bbe8da
function fourier_transform(f, start, stop, step, u::Real)
	sum(x->exp(2π*im*u*x) * f(x), start:step:stop) * step
end

# ╔═╡ fefc8147-856f-49a5-ab74-e70c2391a8d2
#using Plots

# ╔═╡ ec26f119-f213-47d1-8f03-0aecb6deec3e
let
	k = -10:0.1:10
	#y = fourier_transform.(x->cos(π * x), -10, 10, 0.1, k)
	plot(x, y)
end

# ╔═╡ 2a166f85-8940-439c-b27e-3e2beb6ba691
md"""
## The FFT matrix
"""

# ╔═╡ 1bd59263-1bc5-4f32-96f2-1bab54a96a92
function fft!(x::AbstractVector{T}) where T
    N = length(x)
    @inbounds if N <= 1
        return x
    elseif N == 2
        t =  x[2]
        oi = x[1]
        x[1]     = oi + t
        x[2]     = oi - t
        return x
    end
 
    # divide
    odd  = x[1:2:N]
    even = x[2:2:N]
 
    # conquer
    fft!(odd)
    fft!(even)
 
    # combine
    @inbounds for i=1:N÷2
       t = exp(T(-2im*π*(i-1)/N)) * even[i]
       oi = odd[i]
       x[i]     = oi + t
       x[i+N÷2] = oi - t
    end
    return x
end

# ╔═╡ 27435099-9c2d-4fec-9315-a9aef1855fd7
fft!()

# ╔═╡ 0796609b-286f-48a3-bd2d-faffd6b3073d
md"""
## Two dimensional Fourier transformation
```math
F(u, v) = \int_{-\infty}^{\infty}dy\int_{-\infty}^\infty e^{-2\pi i(ux+vy)} f(x, y) dx.
```
"""

# ╔═╡ 8c3f3fe1-d98f-4bf7-9da4-a717cd0f9f35
md"""
The fastest Fourier transformation.
"""

# ╔═╡ 0bc227c1-c890-4d9c-895c-f2d4b5dacdd1
fft

# ╔═╡ Cell order:
# ╠═129914e6-66cb-4ab9-a29e-8e317c0c9bc3
# ╟─869f12fb-3ddb-4962-9243-9e0ce1f43e1d
# ╠═efbde06c-c892-4d49-8c48-ae21d1bbe8da
# ╠═fefc8147-856f-49a5-ab74-e70c2391a8d2
# ╠═ec26f119-f213-47d1-8f03-0aecb6deec3e
# ╠═2a166f85-8940-439c-b27e-3e2beb6ba691
# ╠═1bd59263-1bc5-4f32-96f2-1bab54a96a92
# ╠═27435099-9c2d-4fec-9315-a9aef1855fd7
# ╟─0796609b-286f-48a3-bd2d-faffd6b3073d
# ╟─8c3f3fe1-d98f-4bf7-9da4-a717cd0f9f35
# ╠═ab3525e4-c4bb-11ed-2c7e-ab007b9c9196
# ╠═0bc227c1-c890-4d9c-895c-f2d4b5dacdd1
