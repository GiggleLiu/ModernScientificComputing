using Plots
using LinearAlgebra
using SparseArrays
using Test
using FFTW

# generating the signal

N = 5000
brain_signal = sin.(LinRange(0, 1000, N) ./ 10) .+ rand(N)
plot1 = plot(brain_signal)
display(plot1)

# plot the wavelet
function ricker(x, a)
	A = 8/π/sqrt(3a)
	return A * (1 - (x/a)^2) * exp(-x^2/a^2/2)
end


x = -10:0.01:10
y = ricker.(x, 0.6)
plot2 = plot(x, y)
display(plot2)


function wavelet_transformation(signal::AbstractVector{T}, fw) where T
    n_signal = length(signal)
    n_fw = length(fw)
    
    # Zero pad the signal and the filter wavelet to the next power of two
    n_padded = nextpow(2, n_signal + n_fw - 1)
    padded_signal = [signal; zeros(n_padded - n_signal)]
    padded_fw = [fw; zeros(n_padded - n_fw)]

    # Perform FFT on both the signal and the filter wavelet
    fft_signal = fft(padded_signal)
    fft_fw = fft(padded_fw)

    # Multiply the FFTs element-wise
    fft_product = fft_signal .* fft_fw

    # Perform the inverse FFT to get the resulting wavelet transformation
    resulting_vector = real(ifft(fft_product))[1:n_signal + n_fw - 1]

    return resulting_vector
end


# the width parameter `a` in the Ricker wavelet is 1..500
widths = 1:N÷10
res = []
for (j, a) in enumerate(widths)
	fw = ricker.(-1000:1000, a)   # the descretized wavelet of width `a`
	res_a = wavelet_transformation(brain_signal, fw)
	push!(res, res_a)
end
plot3 = heatmap(hcat(res...); ylabel="time", xlabel="widths")
display(plot3)
