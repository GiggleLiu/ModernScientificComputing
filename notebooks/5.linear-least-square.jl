### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 03d7776f-1ae1-4305-8638-caa82837166a
using PlutoUI

# ╔═╡ f375e09d-cfe2-4ca8-a2c1-32d11dd0b236
using Plots

# ╔═╡ 078d0638-7540-4ca4-bc11-b77b2c7f28c4
using LinearAlgebra

# ╔═╡ 24ace4f1-3801-4586-93cb-dcaecf1df9a3
using Test

# ╔═╡ c0992773-4324-4c22-a806-9ec7bd135a2f
using Luxor

# ╔═╡ c91e28af-d372-429b-b0c1-e6579b6230d4
TableOfContents()

# ╔═╡ 50272a9d-5040-413c-84f5-69ffe06b133a
html"""
<button onclick="present();"> present</button>
"""

# ╔═╡ 3bc7e1c5-4d06-4b2d-adbd-20935f8c54b2
ts = collect(0.0:0.5:10.0)

# ╔═╡ 69ea48d1-58c2-4e7d-a351-c4d96dcbed55
ys = [2.9, 2.7, 4.8, 5.3, 7.1, 7.6, 7.7, 7.6, 9.4, 9.0, 9.6, 10.0, 10.2, 9.7, 8.3, 8.4, 9.0, 8.3, 6.6, 6.7, 4.1]

# ╔═╡ 42fd3d15-40b6-4051-913b-293bd953028c
scatter(ts, ys; label="", xlabel="t", ylabel="y", ylim=(0, 10.5))

# ╔═╡ af03fa73-40ce-45f5-9f4f-d8c7809f7166
A2 = [ones(length(ts)) ts ts.^2]

# ╔═╡ c4b34c32-fc00-4a7c-8089-edd35c23bd65
A2

# ╔═╡ 7209792f-4944-4d06-9098-ae7ce1cea103
A2inv = pinv(A2)

# ╔═╡ d9a623cd-74fb-4404-8f62-30ed24a82ed7
x2 = pinv(A2) * ys

# ╔═╡ 72cb2367-c4bc-4ed1-b942-4144881e558f
norm(A2 * x2 - ys)^2

# ╔═╡ 0653d1cc-febe-4b97-9cea-ccf1ea5ef77c
let
	plt = scatter(ts, ys; xlabel="t", ylabel="y", ylim=(0, 10.5), label="data")
	tt = 0:0.1:10
	plot!(plt, tt, map(t->x2[1] + x2[2]*t + x2[3] * t^2, tt); label="fitted")
end

# ╔═╡ 3cfd45c5-4618-4b9a-a931-0b0cb7f12cf1
pinv(A2)

# ╔═╡ 78bd6ebd-a710-4cbb-a2a4-6ac663eb64d5
cond(A2)

# ╔═╡ 7e8d4ef5-6b3a-4588-8e1b-5a491860f9f9
opnorm(A2) * opnorm(pinv(A2))

# ╔═╡ 8e07091c-0b4b-490a-9cf7-dad94c3fa08a
maximum(svd(A2).S)/minimum(svd(A2).S)

# ╔═╡ f240e540-65a2-4f82-8006-a1d2a9955d1b
let
	p = 12345678
	q = 1
	p - sqrt(p^2 + q)
end

# ╔═╡ f4acf2cd-a183-4986-91f5-da6729759c84
let # more accurate
	p = 12345678
	q = 1
	q/(p + sqrt(p^2 + q))
end

# ╔═╡ 135c30d2-2168-4e88-82e3-673bbb4764d9
rectQ = Matrix(qr(A2).Q)

# ╔═╡ 573b545b-314a-4938-8ae8-1be006a918ae
qr(A2).R

# ╔═╡ 7d4d74ed-2de8-4b95-88c4-92d1398a7c4c
rectQ * qr(A2).R ≈ A2

# ╔═╡ 0322976d-d3a2-42ba-ab55-8d75796b0388
struct HouseholderMatrix{T} <: AbstractArray{T, 2}
	v::Vector{T}
	β::T
end

# ╔═╡ 525d5273-e10f-4669-afc4-7a527ff25acf
Base.size(A::HouseholderMatrix) = (length(A.v), length(A.v))

# ╔═╡ d9a7fbb0-243e-452c-ad23-ed116bf1849c
Base.size(A::HouseholderMatrix, i::Int) = i == 1 || i == 2 ? length(A.v) : 1

# ╔═╡ 9c9ea963-64db-437d-8509-d334b27b57d4
# some other methods to avoid ambiguity error

# ╔═╡ db6114bc-b253-4c7b-948c-1ad2036fd4b8
Base.inv(A::HouseholderMatrix) = A

# ╔═╡ 6c2555d4-5d84-42e0-8dd3-6e5781037a95
Base.adjoint(A::HouseholderMatrix) = A

# ╔═╡ 42812c21-229f-4e4a-b7ad-0d0317061776
inv(A2' * A2) * A2'

# ╔═╡ 5c3d483b-c1a4-4af9-b06f-f01b306d383b
A2' * A2

# ╔═╡ 4979c507-72c3-4cbb-8a7e-27cf4c9c4660
A2' * ys

# ╔═╡ 8782019c-f4b4-4b68-9d84-61aec009fe50
rectQ' * rectQ

# ╔═╡ 32258e09-1dd7-4954-be0f-98db3c2fb7ed
@testset "householder property" begin
	v = randn(3)
	β = 2/norm(v, 2)^2
	H = I - β * v * v'
	# symmetric
	@test H' ≈ H
	# reflexive
	@test H^2 ≈ I
	# orthogonal
	@test H' * H ≈ I
end

# ╔═╡ 64a46e12-ae2e-445f-b870-3389e15bcc5b
# the `mul!` interfaces can take two extra factors.
function left_mul!(B, A::HouseholderMatrix)
	B .-= (A.β .* A.v) * (A.v' * B)
	return B
end

# ╔═╡ 0c263746-b0a3-42df-a52b-9f9f51341db2
# the `mul!` interfaces can take two extra factors.
function right_mul!(A, B::HouseholderMatrix)
	A .= A .- (A * (B.β .* B.v)) * B.v'
	return A
end

# ╔═╡ 6e6b7827-86a1-4f20-801e-7d9c385d0d26
Base.getindex(A::HouseholderMatrix, i::Int, j::Int) = A.β * A.v[i] * conj(A.v[j])

# ╔═╡ db07252c-d1c1-46af-a16e-9a7d1e91ce4f
md"""# Review: Solving linear equations
Given $A\in \mathbb{R}^{n\times n}$ and $b \in \mathbb{R}^n$, find $x \in \mathbb{R}^n$ s.t.
```math
Ax = b
```

1. LU factorization with Gaussian Elimination (with Pivoting)
2. Sensitivity analysis: Condition number
2. Computing matrix inverse with Guass-Jordan Elimination
"""

# ╔═╡ 039e70f8-b8cf-11ed-311e-4d770652d6a9
md"# Linear Least Square Problem"

# ╔═╡ 1285a0ff-2290-49fb-bd16-74ebb155e6ff
md"## Data Fitting"

# ╔═╡ c12b4f4e-81d7-4b8a-8f77-b4e940199064
md"""
Given $m$ data points $(t_i, y_i)$, we wish to find the $n$-vector $x$ of parameters that gives the "best fit" to the data by the model function $f(t, x)$, with
```math
f: \mathbb{R}^{n+1} \rightarrow \mathbb{R}
```
```math
\min_x\sum_{i=1}^m (y_i - f(t_i, x))^2
```
"""

# ╔═╡ 19083b13-3b40-43ea-9535-975c2f1be8bb
md"## Example"

# ╔═╡ 26461708-def3-44b5-bb8f-4eb9f75c66d5
md"""
```math
f(x) = x_0 + x_1 t + x_2 t^2
```
"""

# ╔═╡ f0b7e196-80dd-4cd2-a8ce-3b99eee32580
md"""
```math
Ax = \left(\begin{matrix}
1 & t_1 & t_1^2\\
1 & t_2 & t_2^2\\
1 & t_3 & t_3^2\\
1 & t_4 & t_4^2\\
1 & t_5 & t_5^2\\
\vdots & \vdots & \vdots
\end{matrix}\right)
\left(\begin{matrix} x_1 \\ x_2 \\ x_3\end{matrix}\right) \approx
\left(\begin{matrix}y_1\\ y_2\\ y_3 \\ y_4 \\ y_5\\\vdots\end{matrix}\right) = b
```
"""

# ╔═╡ e4e444bf-0d07-4f6c-a104-ac0569928347
md"# Normal Equations"

# ╔═╡ 5124f2d6-37e3-4cf9-82df-eb50372271cb
md"The goal: minimize $\|Ax - b\|_2^2$"

# ╔═╡ dbd8e759-f5bf-4239-843f-2c394e7665c1
md"""
```math
A^T Ax = A^T b
```
"""

# ╔═╡ 58834440-1e0a-432b-9be2-41db98fa2742
md"## Pseudo-Inverse"

# ╔═╡ 81b6f4cb-a6c8-4a86-91f7-ac88646651f8
md"
```math
A^{+} = (A^T A)^{-1}A^T
```
```math
x = A^+ b
```
"

# ╔═╡ 291caf11-bacd-4171-8408-410b50f49183
md"Pseudoinverse"

# ╔═╡ 800b3257-0449-4d0d-8124-5b6ca7882902
md"The julia version"

# ╔═╡ e6435900-79be-46de-a7aa-7308df1e486a
md"## Example"

# ╔═╡ 6d7d33ff-1b2b-4f03-b4d4-a7f31dfd3b74
md"## The geometric interpretation"

# ╔═╡ 1684bff0-7ad0-4921-be48-a4bfdcbde81d
md"The residual is $b-Ax$"

# ╔═╡ eeb922e4-2e63-4d97-88c8-3951613695f5
md"""
```math
A^T(b - Ax) = 0
```
"""

# ╔═╡ a5034aeb-e74e-47ed-9d0a-4eb3d076dfbe
md"## Solving Normal Equations with Cholesky decomposition"

# ╔═╡ bb097284-3e30-489c-abac-f0c6b71edfd9
md"""
Step 1: Rectangular → Square
```math
A^TAx = A^T b
```

Step 2: Square → Triangular
```math
A^T A = LL^T
```

Step 3: Solve the triangular linear equation
"""

# ╔═╡ 0f6b8814-77a1-4b1f-8183-42bc6ea412e0
md"## Issue: The Condition-Squaring Effect"

# ╔═╡ 04acb542-dc1f-4c45-b6fd-62f387a81963
md"The conditioning of a square linear system $Ax = b$ depends only on the matrix, while the conditioning of a least squares problem $Ax \approx b$ depends on both $A$ and $b$."

# ╔═╡ 080677b7-cac7-4bbe-a4b0-71e18ca41b1b
md"""
```math
A = \left(\begin{matrix}1 & 1\\ \epsilon & 0 \\ 0 & \epsilon \end{matrix}\right)
```
"""

# ╔═╡ 5933200f-5aab-4937-b3df-9af1f81a5eaf
md"The definition of thin matrix condition number"

# ╔═╡ 68d9c2b1-bccf-48ec-9428-e0c65a1618ad
md"""
## The algorithm matters
"""

# ╔═╡ 96f7d3c9-fecc-4b5e-94ff-e8e9af74ce63
md"$x^2 - 2px - q$"

# ╔═╡ cb7a0e40-0d26-4330-abd0-cd730261b6b4
md"""
Algorithm 1:
```math
p - \sqrt{p^2 + q}
```
Algorithm 2:
```math
\frac{q}{p+\sqrt{p^2+q}}
```
"""

# ╔═╡ b0c7ed86-2127-46a6-9f98-547cdf591d23
md"# Orthogonal Transformations"

# ╔═╡ b84c4a00-37ea-453a-b69d-555ffcd8b358
md"""
```math
A = QR
```
```math
Rx = Q^{T}b
```
"""

# ╔═╡ 7b48e6ea-6fb7-44b5-9407-1fb38bf4f009
md"""
## Gist of QR factoriaztion by Householder reflection.
"""

# ╔═╡ 64be680f-3a97-4b92-b3fd-9c7a27bccb01
md"""
Let $H_k$ be an orthogonal matrix, i.e. $H_k^T H_k = I$
```math
H_n \ldots H_2H_1 A = R
```
```math
Q = H_1^{T} H_2 ^{T}\ldots H_n^{T}
```
"""

# ╔═╡ 6d519ffa-ea7e-4a95-a50f-f9421651cd20
md"""
## Review of Elimentary Elimination Matrix
```math
M_k = I_n  - \tau e_k^T
```
```math
\tau = \left(0, \ldots, 0, \tau_{k+1},\ldots,\tau_n\right)^T, ~~~ \tau_i = \frac{v_i}{v_k}.
```
Keys:
* Gaussian elimination is a recursive algorithm.
"""

# ╔═╡ a2832af2-c007-45d4-8fd7-210f85e3913e
md"""
## Householder reflection
Let $v \in \mathbb{R}^m$ be nonzero, An $m$-by-$m$ matrix $P$ of the form
```math
P = 1-\beta vv^T, ~~~\beta = \frac{2}{v^Tv}
```
is a Householder reflection.
"""

# ╔═╡ 2ee2e080-659d-4d85-9733-065efe6d4ce8
md"(the picture of householder reflection)"

# ╔═╡ 73bd9d1b-4890-48cf-8ecb-83dd6e8025ba
md"## Properties of Householder reflection"

# ╔═╡ 93c9f34c-ce1d-4940-8a24-1a5ce8aa7e01
md"Householder reflection is symmetric and orthogonal."

# ╔═╡ eb46cec9-5812-43aa-b192-2c84d5c5061e
md"## Project a vector to $e_1$"

# ╔═╡ d7c22484-3970-4c11-864c-a582d4034f7d
md"""
```math
P x = \beta e_1
```
```math
v = x \pm \|x\|_2 e_1
```
"""

# ╔═╡ f0dabeb6-2c30-4556-aeb8-03c51106f012
function householder_matrix(v::AbstractVector{T}) where T
	v = copy(v)
	v[1] -= norm(v, 2)
	return HouseholderMatrix(v, 2/norm(v, 2)^2)
end

# ╔═╡ a20de17c-33ca-4807-918f-3a58d641ed69
let
	A = Float64[1 2 2; 4 4 2; 4 6 4]
	hm = householder_matrix(view(A,:,1))
	hm * A
end

# ╔═╡ edecc73a-021f-4e0e-8d2e-dbafe537f0eb
md"## Triangular Least Squares Problems"

# ╔═╡ d9331fb3-8c04-4082-bdf5-0a1d09a65276
md"## QR Factoriaztion"

# ╔═╡ c10b85f2-be07-4fd4-a66c-50ac8e54fdb8
md"## Givens Rotations"

# ╔═╡ 2d41b937-1406-4db8-a453-f0d7ca042434
function draw_vectors(initial_vector, final_vector, angle)
	@drawsvg begin
		origin()
		circle(0, 0, 100, :stroke)
		setcolor("gray")
		a, b = initial_vector
		Luxor.arrow(Point(0, 0), Point(a, -b) * 100)
		setcolor("black")
		c, d = final_vector
		Luxor.arrow(Point(0, 0), Point(c, -d) * 100)
		Luxor.text("θ = $angle", 0, 50; valign=:center, halign=:center)
	end 600 400
end

# ╔═╡ 51e387ff-1619-4c3f-8e52-748c0bddd9cf
@bind angle Slider(0:0.03:2*3.14; show_value=true)

# ╔═╡ 925d3781-a469-4943-b951-1688d705cb97
md"""
```math
G = \left(\begin{matrix}
\cos\theta & -\sin\theta\\
\sin\theta & \cos\theta
\end{matrix}\right)
```
"""

# ╔═╡ bef1e66b-bf43-4e05-a286-693626c61ea6
rotation_matrix(angle) = [cos(angle) -sin(angle); sin(angle) cos(angle)]

# ╔═╡ 874cbe3e-516e-4f8c-8ad8-e781a5d4af0d
let
	initial_vector = [1.0, 0.0]
	final_vector = rotation_matrix(angle) * initial_vector
	@info final_vector
	draw_vectors(initial_vector, final_vector, angle)
end

# ╔═╡ 50bfec97-0cf8-4a6e-a0e1-13ee391dce69
md"""
## Eliminating the $y$ element
"""

# ╔═╡ 7ae46225-cbbb-4595-adbc-7fd679bf965f
atan(0.1, 0.5)

# ╔═╡ 385a17c7-2394-492a-8e89-0f402311f5c4
let
	initial_vector = randn(2)
	angle = atan(initial_vector[2], initial_vector[1])
	final_vector = rotation_matrix(-angle) * initial_vector
	draw_vectors(initial_vector, final_vector, -angle)
end

# ╔═╡ 06627dd0-f22d-4fe5-8050-d0a84cac12fe
md"""
```math
\left(
\begin{matrix}
1 & 0 & 0 & 0 & 0\\
0 & c & 0 & s & 0\\
0 & 0 & 1 & 0 & 0\\
0 & -s & 0 & c & 0\\
0 & 0 & 0 & 0 & 1
\end{matrix}
\right)
\left(
\begin{matrix}
a_1\\a_2\\a_3\\a_4\\a_5
\end{matrix}
\right)=
\left(
\begin{matrix}
a_1\\\alpha\\a_3\\0\\a_5
\end{matrix}
\right)
```
where $s = \sin(\theta)$ and $c = \cos(\theta)$.
"""

# ╔═╡ 963cb350-b9b5-4dbe-8b5f-63ce38440e86
md"## Givens QR Factorization"

# ╔═╡ 5d40252a-4dc3-420d-bd8d-d11abdb07c9b
struct GivensMatrix{T} <: AbstractArray{T, 2}
	c::T
	s::T
	i::Int
	j::Int
	n::Int
end

# ╔═╡ 64695822-e79c-4e34-912f-2179c674116d
Base.size(g::GivensMatrix) = (g.n, g.n)

# ╔═╡ 16ee76bf-3968-414b-aa0f-e82fbf3f7911
Base.size(g::GivensMatrix, i::Int) = i == 1 || i == 2 ? g.n : 1

# ╔═╡ d5812ce2-6333-4777-8016-7978af44a753
function elementary_elimination_matrix_1(A::AbstractMatrix{T}) where T
	n = size(A, 1)
	# create Elementary Elimination Matrices
	M = Matrix{Float64}(I, n, n)
	for i=2:n
		M[i, 1] =  -A[i, 1] ./ A[1, 1]
	end
	return M
end

# ╔═╡ 4e6a21ac-a27a-48a9-b714-6f66b24437c1
function lufact_naive_recur!(L, A::AbstractMatrix{T}) where T
	n = size(A, 1)
	if n == 1
		return L, A
	else
		# eliminate the first column
		m = elementary_elimination_matrix_1(A)
		L .= L * inv(m)
		A .= m * A
		# recurse
		lufact_naive_recur!(view(L, 2:n, 2:n), view(A, 2:n, 2:n))
	end
	return L, A
end

# ╔═╡ a10a2522-c4ea-4027-bbd3-3d0762341424
let
	A = [1 2 2; 4 4 2; 4 6 4]
	L = Matrix{Float64}(I, 3, 3)
	R = copy(A)
	lufact_naive_recur!(L, R)
	L * R ≈ A
end

# ╔═╡ b2e92d06-8731-491c-adbe-ec9f778247c1
function givens(A, i, j)
	x, y = A[i, 1], A[j, 1]
	norm = sqrt(x^2 + y^2)
	c = x/norm
	s = y/norm
	return GivensMatrix(c, s, i, j, size(A, 1))
end

# ╔═╡ d55be015-9a20-4efd-9be2-a5ecf9545400
function left_mul!(A::AbstractMatrix, givens::GivensMatrix)
	for col in 1:size(A, 2)
		vi, vj = A[givens.i, col], A[givens.j, col]
		A[givens.i, col] = vi * givens.c + vj * givens.s
		A[givens.j, col] = -vi * givens.s + vj * givens.c
	end
	return A
end

# ╔═╡ 92e842e9-42b8-45e6-937e-3d2049df9b09
function right_mul!(A::AbstractMatrix, givens::GivensMatrix)
	for row in 1:size(A, 1)
		vi, vj = A[row, givens.i], A[row, givens.j]
		A[row, givens.i] = vi * givens.c + vj * givens.s
		A[row, givens.j] = -vi * givens.s + vj * givens.c
	end
	return A
end

# ╔═╡ e6cd8de6-20c6-4d36-93ba-b1a9ed808fc2
function householder_qr!(Q::AbstractMatrix{T}, a::AbstractMatrix{T}) where T
	m, n = size(a)
	@assert size(Q, 2) == m
	if m == 1
		return Q, a
	else
		# apply householder matrix
		H = householder_matrix(view(a, :, 1))
		left_mul!(a, H)
		# update Q matrix
		right_mul!(Q, H')
		# recurse
		householder_qr!(view(Q, 1:m, 2:m), view(a, 2:m, 2:n))
	end
	return Q, a
end

# ╔═╡ 5ce1edef-5b0e-48ce-b269-855726cc5e15
@testset "householder QR" begin
	A = randn(3, 3)
	Q = Matrix{Float64}(I, 3, 3)
	R = copy(A)
	householder_qr!(Q, R)
	@info R
	@test Q * R ≈ A
	@test Q' * Q ≈ I
end

# ╔═╡ 296749ef-7973-4ac9-8632-825fccbd3476
let
	A = randn(3, 3)
	g = givens(A, 2, 3)
	left_mul!(copy(A), g)
end

# ╔═╡ f3c5297d-c371-41af-988b-595fb47ac4d7
function givens_qr!(Q::AbstractMatrix, A::AbstractMatrix)
	m, n = size(A)
	if m == 1
		return Q, A
	else
		for k = m:-1:2
			g = givens(A, k-1, k)
			left_mul!(A, g)
			right_mul!(Q, g)
		end
		givens_qr!(view(Q, :, 2:m), view(A, 2:m, 2:n))
		return Q, A
	end
end

# ╔═╡ bfca07d3-6479-4835-8b10-314facfcfea1
@testset "givens QR" begin
	n = 3
	A = randn(n, n)
	R = copy(A)
	Q, R = givens_qr!(Matrix{Float64}(I, n, n), R)
	@test Q * R ≈ A
	@test Q * Q' ≈ I
	@info R
end

# ╔═╡ 0a753edc-4507-46e8-ab0f-fcdd5f3fa21f
md"## Gram-Schmidt Orthogonalization"

# ╔═╡ 8bcdaf5f-6e69-471e-9fca-063ece7f563a
md"""
```math
q_k = \left(a_k - \sum_{i=1}^{k-1} r_{ik}q_i\right)/r_{kk}
```
"""

# ╔═╡ e4a1cb08-1e6c-45b1-9937-12b13bba1645
md"## Algorithm: Classical Gram-Schmidt Orthogonalization"

# ╔═╡ c32925a7-28ca-4c23-9ab8-43db8e0dc0c3
function classical_gram_schmidt(A::AbstractMatrix{T}) where T
	m, n = size(A)
	Q = zeros(T, m, n)
	R = zeros(T, n, n)
	R[1, 1] = norm(view(A, :, 1))
	Q[:, 1] .= view(A, :, 1) ./ R[1, 1]
	for k = 2:n
		Q[:, k] .= view(A, :, k)
		# project z to span(A[:, 1:k-1])⊥
		for j = 1:k-1
			R[j, k] = view(Q, :, j)' * view(A, :, k)
			Q[:, k] .-= view(Q, :, j) .* R[j, k]
		end
		# normalize the k-th column
		R[k, k] = norm(view(Q, :, k))
		Q[:, k] ./= R[k, k]
	end
	return Q, R
end

# ╔═╡ a7a4c219-d4dd-4491-90f9-824924124ff2
@testset "classical GS" begin
	n = 10
	A = randn(n, n)
	Q, R = classical_gram_schmidt(A)
	@test Q * R ≈ A
	@test Q * Q' ≈ I
	@info R
end

# ╔═╡ 21f0d7df-396e-47cc-beb8-0fa13fd8bc40
md"## Algorithm: Modified Gram-Schmidt Orthogonalization"

# ╔═╡ bd12051d-f8ad-4055-8461-b1495ca95ce6
function modified_gram_schmidt!(A::AbstractMatrix{T}) where T
	m, n = size(A)
	Q = zeros(T, m, n)
	R = zeros(T, n, n)
	for k = 1:n
		R[k, k] = norm(view(A, :, k))
		Q[:, k] .= view(A, :, k) ./ R[k, k]
		for j = k+1:n
			R[k, j] = view(Q, :, k)' * view(A, :, j)
			A[:, j] .-= view(Q, :, k) .* R[k, j]
		end
	end
	return Q, R
end

# ╔═╡ 8d4e7395-f05b-45dd-b762-da4cd1f40b29
@testset "modified GS" begin
	n = 10
	A = randn(n, n)
	Q, R = modified_gram_schmidt!(copy(A))
	@test Q * R ≈ A
	@test Q * Q' ≈ I
	@info R
end

# ╔═╡ cbab862d-f6f1-4238-b007-f1341455a85f
let
	n = 100
	A = randn(n, n)
	Q1, R1 = classical_gram_schmidt(A)
	Q2, R2 = modified_gram_schmidt!(copy(A))
	@info norm(Q1' * Q1 - I)
	@info norm(Q2' * Q2 - I)
end

# ╔═╡ c806e238-5f84-4cab-8e13-d9a15d4ee2b0
md"# Eigenvalue/Singular value decomposition problem"

# ╔═╡ 21d4d322-3af7-4ab2-90a4-b465f009167b
md"""
```math
Ax = \lambda x
```
"""

# ╔═╡ 36e59b38-07a5-43ea-9b73-599f6b78b938
md"## Power method"

# ╔═╡ e5998180-d4e9-4e9d-a965-b02d92c3a188
matsize = 10

# ╔═╡ 836f7624-e0b9-4ee3-9f11-a9b148af4266
A10 = randn(matsize, matsize); A10 += A10'

# ╔═╡ c84c3f0b-8b82-4710-bf27-7667506ef357
eigen(A10).values

# ╔═╡ deaaf582-3387-41b1-83ba-8290aa84236d
vmax = eigen(A10).vectors[:,end]

# ╔═╡ 1625ece0-5a1c-416f-b716-68c1f9f9478d
let
	x = normalize!(randn(matsize))
	for i=1:20
		x = A10 * x
		normalize!(x)
	end
	1-abs2(x' * vmax)
end

# ╔═╡ 5787c430-d48b-43b8-97e4-e95b1d66f578
md"""
## Rayleigh Quotient Iteration
"""

# ╔═╡ 0e874ac9-c3cb-4d65-8424-d425b6ff4748
let
	x = normalize!(randn(matsize))
	U = eigen(A10).vectors
	for k=1:5
		sigma = x' * A10 * x
		y = (A10 - sigma * I) \ x
		x = normalize!(y)
	end
	(x' * U)'
end

# ╔═╡ 537f7520-4e65-4d9f-8905-697d957f2772
md"## Symmetric QR decomposition"

# ╔═╡ ca22eba8-be14-40b1-b8fe-ead89b323952
function householder_trid!(Q, a)
	m, n = size(a)
	@assert m==n && size(Q, 2) == n
	if m == 2
		return Q, a
	else
		# apply householder matrix
		H = householder_matrix(view(a, 2:n, 1))
		left_mul!(view(a, 2:n, :), H)
		right_mul!(view(a, :, 2:n), H')
		# update Q matrix
		right_mul!(view(Q, :, 2:n), H')
		# recurse
		householder_trid!(view(Q, :, 2:n), view(a, 2:m, 2:n))
	end
	return Q, a
end

# ╔═╡ a5c83d11-580e-4066-9bec-9ed8202e4e46
@testset "householder tridiagonal" begin
	n = 5
	a = randn(n, n)
	a = a + a'
	Q = Matrix{Float64}(I, n, n)
	Q, T = householder_trid!(Q, copy(a))
	@test Q * T * Q' ≈ a
end

# ╔═╡ d8fb96fb-bc78-4072-afe9-8427fac0f6ac
md"""## The SVD algorithm
```math
A = U S V^T
```
1. Form $C = A^T A$,
2. Use the symmetric QR algorithm to compute $V_1^T C V_1 = {\rm diag}(\sigma_i^2)$,
3. Apply QR with column pivoting to $AV_1$ obtaining $U^T(AV_1)\Pi = R$.
"""

# ╔═╡ ac65b656-8ab5-4866-b011-25711260f110
md"""
# Assignments
### 1. Review
Suppose that you are computing the QR factorization of the matrix
```math
A = \left(\begin{matrix}
1 & 1 & 1\\
1 & 2 & 4\\
1 & 3 & 9\\
1 & 4 & 16
\end{matrix}\right)
```
by Householder transformations.

* Problems:
    1. How many Householder transformations are required?
    2. What does the first column of A become as a result of applying the first Householder transformation?
    3. What does the first column of A become as a result of applying the first Householder transformation?
    4. How many Givens rotations would be required to computing the QR factoriazation of A?
### 2. Coding
Computing the QR decomposition of a symmetric triangular matrix with Givens rotation. Try to minimize the computing time and estimate the number of FLOPS.

For example, if the input matrix size is $T \in \mathbb{R}^{5\times 5}$
```math
T = \left(\begin{matrix}
t_{11} & t_{12} & 0 & 0 & 0\\
t_{21} & t_{22} & t_{23} & 0 & 0\\
0 & t_{32} & t_{33} & t_{34} & 0\\
0 & 0 & t_{43} & t_{44} & t_{45}\\
0 & 0 & 0 & t_{54} & t_{55}
\end{matrix}\right)
```
where $t_{ij} = t_{ji}$.

In your algorithm, you should first apply Givens rotation on row 1 and 2.
```math
G(t_{11}, t_{21}) T = \left(\begin{matrix}
t_{11}' & t_{12}' & t_{13}' & 0 & 0\\
0 & t_{22}' & t_{23}' & 0 & 0\\
0 & t_{32} & t_{33} & t_{34} & 0\\
0 & 0 & t_{43} & t_{44} & t_{45}\\
0 & 0 & 0 & t_{54} & t_{55}
\end{matrix}\right)
```
Then apply $G(t_{22}', t_{32})$ et al.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Luxor = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[compat]
Luxor = "~3.7.0"
Plots = "~1.38.6"
PlutoUI = "~0.7.50"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "cd3df8ab6206c1807bf1a96f1c03d728b167c474"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "d0b3f8b4ad16cb0a2988c6788646a5e6a17b6b1b"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.0.5"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c6d890a52d2c4d55d326439580c3b8d0875a77d9"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.7"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "485193efd2176b88e6622a39a246f8c5b600e74e"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.6"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "9c209fb7536406834aa938fb149964b985de6c83"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.1"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random", "SnoopPrecompile"]
git-tree-sha1 = "aa3edc8f8dea6cbfa176ee12f7c2fc82f0608ed3"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.20.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "61fdd77467a5c3ad071ef8277ac6bd6af7dd4c04"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.6.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "e8119c1a33d267e16108be441a287a6981ba1630"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.14.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "7be5f99f7d15578798f338f5433b6c432ea8037b"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "660b2ea2ec2b010bb02823c6d0ff6afd9bdc5c16"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.71.7"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "d5e1fd17ac7f3aa4c5287a61ee28d4f8b8e98873"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.71.7+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "37e4657cd56b11abe3d10cd4a1ec5fbdb4180263"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.7.4"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.Juno]]
deps = ["Base64", "Logging", "Media", "Profile"]
git-tree-sha1 = "07cb43290a840908a771552911a6274bc6c072c7"
uuid = "e5e0dc1b-0480-54bc-9374-aad01c23163d"
version = "0.8.4"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "2422f47b34d4b127720a18f86fa7b1aa2e141f29"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.18"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Librsvg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pango_jll", "Pkg", "gdk_pixbuf_jll"]
git-tree-sha1 = "ae0923dab7324e6bc980834f709c4cd83dd797ed"
uuid = "925c91fb-5dd6-59dd-8e8c-345e74382d89"
version = "2.54.5+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "0a1b7c2863e44523180fdb3146534e265a91870b"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.23"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "cedb76b37bc5a6c702ade66be44f831fa23c681e"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.0"

[[deps.Luxor]]
deps = ["Base64", "Cairo", "Colors", "Dates", "FFMPEG", "FileIO", "Juno", "LaTeXStrings", "Random", "Requires", "Rsvg", "SnoopPrecompile"]
git-tree-sha1 = "909a67c53fddd216d5e986d804b26b1e3c82d66d"
uuid = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
version = "3.7.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Media]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "75a54abd10709c01f1b86b84ec225d26e840ed58"
uuid = "e89f7d12-3494-54d1-8411-f7d8b9ae1f27"
version = "0.5.0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "6503b77492fd7fcb9379bf73cd31035670e3c509"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.3.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9ff31d101d987eb9d66bd8b176ac7c277beccd09"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.20+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.40.0+0"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "84a314e3926ba9ec66ac097e3635e270986b0f10"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.50.9+0"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "6f4fbcd1ad45905a5dee3f4256fabb49aa2110c6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.7"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "c95373e73290cf50a8a22c3375e4625ded5c5280"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.4"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SnoopPrecompile", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "da1d3fb7183e38603fcdd2061c47979d91202c97"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.38.6"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "5bb5129fdd62a2bbbe17c2756932259acf467386"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.50"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "261dddd3b862bd2c940cf6ca4d1c8fe593e457c8"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.3"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase", "SnoopPrecompile"]
git-tree-sha1 = "e974477be88cb5e3040009f3767611bc6357846f"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.11"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rsvg]]
deps = ["Cairo", "Glib_jll", "Librsvg_jll"]
git-tree-sha1 = "3d3dc66eb46568fb3a5259034bfc752a0eb0c686"
uuid = "c4c386cf-5103-5370-be45-f3a111cca3b8"
version = "1.0.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "f94f779c94e58bf9ea243e77a37e16d9de9126bd"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "ef28127915f4229c971eb43f3fc075dd3fe91880"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.2.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "94f38103c984f89cf77c402f2a68dbd870f8165f"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.11"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "ed8d92d9774b077c53e1da50fd81a36af3744c1c"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "93c41695bc1c08c46c5899f4fe06d6ead504bb73"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.3+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c6edfe154ad7b313c01aceca188c05c835c67360"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.4+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.gdk_pixbuf_jll]]
deps = ["Artifacts", "Glib_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Xorg_libX11_jll", "libpng_jll"]
git-tree-sha1 = "e9190f9fb03f9c3b15b9fb0c380b0d57a3c8ea39"
uuid = "da03df04-f53b-5353-a52f-6a8b0620ced0"
version = "2.42.8+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╠═03d7776f-1ae1-4305-8638-caa82837166a
# ╟─c91e28af-d372-429b-b0c1-e6579b6230d4
# ╟─50272a9d-5040-413c-84f5-69ffe06b133a
# ╟─db07252c-d1c1-46af-a16e-9a7d1e91ce4f
# ╟─039e70f8-b8cf-11ed-311e-4d770652d6a9
# ╟─1285a0ff-2290-49fb-bd16-74ebb155e6ff
# ╟─c12b4f4e-81d7-4b8a-8f77-b4e940199064
# ╟─19083b13-3b40-43ea-9535-975c2f1be8bb
# ╠═3bc7e1c5-4d06-4b2d-adbd-20935f8c54b2
# ╠═69ea48d1-58c2-4e7d-a351-c4d96dcbed55
# ╠═f375e09d-cfe2-4ca8-a2c1-32d11dd0b236
# ╠═42fd3d15-40b6-4051-913b-293bd953028c
# ╟─26461708-def3-44b5-bb8f-4eb9f75c66d5
# ╟─f0b7e196-80dd-4cd2-a8ce-3b99eee32580
# ╠═af03fa73-40ce-45f5-9f4f-d8c7809f7166
# ╟─e4e444bf-0d07-4f6c-a104-ac0569928347
# ╟─5124f2d6-37e3-4cf9-82df-eb50372271cb
# ╟─dbd8e759-f5bf-4239-843f-2c394e7665c1
# ╟─58834440-1e0a-432b-9be2-41db98fa2742
# ╟─81b6f4cb-a6c8-4a86-91f7-ac88646651f8
# ╠═c4b34c32-fc00-4a7c-8089-edd35c23bd65
# ╟─291caf11-bacd-4171-8408-410b50f49183
# ╠═42812c21-229f-4e4a-b7ad-0d0317061776
# ╟─800b3257-0449-4d0d-8124-5b6ca7882902
# ╠═7209792f-4944-4d06-9098-ae7ce1cea103
# ╟─e6435900-79be-46de-a7aa-7308df1e486a
# ╠═5c3d483b-c1a4-4af9-b06f-f01b306d383b
# ╠═4979c507-72c3-4cbb-8a7e-27cf4c9c4660
# ╠═d9a623cd-74fb-4404-8f62-30ed24a82ed7
# ╠═078d0638-7540-4ca4-bc11-b77b2c7f28c4
# ╠═72cb2367-c4bc-4ed1-b942-4144881e558f
# ╠═0653d1cc-febe-4b97-9cea-ccf1ea5ef77c
# ╟─6d7d33ff-1b2b-4f03-b4d4-a7f31dfd3b74
# ╟─1684bff0-7ad0-4921-be48-a4bfdcbde81d
# ╟─eeb922e4-2e63-4d97-88c8-3951613695f5
# ╟─a5034aeb-e74e-47ed-9d0a-4eb3d076dfbe
# ╟─bb097284-3e30-489c-abac-f0c6b71edfd9
# ╟─0f6b8814-77a1-4b1f-8183-42bc6ea412e0
# ╟─04acb542-dc1f-4c45-b6fd-62f387a81963
# ╟─080677b7-cac7-4bbe-a4b0-71e18ca41b1b
# ╠═3cfd45c5-4618-4b9a-a931-0b0cb7f12cf1
# ╠═78bd6ebd-a710-4cbb-a2a4-6ac663eb64d5
# ╟─5933200f-5aab-4937-b3df-9af1f81a5eaf
# ╠═7e8d4ef5-6b3a-4588-8e1b-5a491860f9f9
# ╠═8e07091c-0b4b-490a-9cf7-dad94c3fa08a
# ╟─68d9c2b1-bccf-48ec-9428-e0c65a1618ad
# ╟─96f7d3c9-fecc-4b5e-94ff-e8e9af74ce63
# ╟─cb7a0e40-0d26-4330-abd0-cd730261b6b4
# ╠═f240e540-65a2-4f82-8006-a1d2a9955d1b
# ╠═f4acf2cd-a183-4986-91f5-da6729759c84
# ╟─b0c7ed86-2127-46a6-9f98-547cdf591d23
# ╟─b84c4a00-37ea-453a-b69d-555ffcd8b358
# ╠═135c30d2-2168-4e88-82e3-673bbb4764d9
# ╠═8782019c-f4b4-4b68-9d84-61aec009fe50
# ╠═573b545b-314a-4938-8ae8-1be006a918ae
# ╠═7d4d74ed-2de8-4b95-88c4-92d1398a7c4c
# ╟─7b48e6ea-6fb7-44b5-9407-1fb38bf4f009
# ╟─64be680f-3a97-4b92-b3fd-9c7a27bccb01
# ╟─6d519ffa-ea7e-4a95-a50f-f9421651cd20
# ╠═d5812ce2-6333-4777-8016-7978af44a753
# ╠═4e6a21ac-a27a-48a9-b714-6f66b24437c1
# ╠═a10a2522-c4ea-4027-bbd3-3d0762341424
# ╟─a2832af2-c007-45d4-8fd7-210f85e3913e
# ╟─2ee2e080-659d-4d85-9733-065efe6d4ce8
# ╟─73bd9d1b-4890-48cf-8ecb-83dd6e8025ba
# ╟─93c9f34c-ce1d-4940-8a24-1a5ce8aa7e01
# ╠═24ace4f1-3801-4586-93cb-dcaecf1df9a3
# ╠═32258e09-1dd7-4954-be0f-98db3c2fb7ed
# ╠═0322976d-d3a2-42ba-ab55-8d75796b0388
# ╠═525d5273-e10f-4669-afc4-7a527ff25acf
# ╠═d9a7fbb0-243e-452c-ad23-ed116bf1849c
# ╠═64a46e12-ae2e-445f-b870-3389e15bcc5b
# ╠═0c263746-b0a3-42df-a52b-9f9f51341db2
# ╠═9c9ea963-64db-437d-8509-d334b27b57d4
# ╠═db6114bc-b253-4c7b-948c-1ad2036fd4b8
# ╠═6c2555d4-5d84-42e0-8dd3-6e5781037a95
# ╠═6e6b7827-86a1-4f20-801e-7d9c385d0d26
# ╟─eb46cec9-5812-43aa-b192-2c84d5c5061e
# ╟─d7c22484-3970-4c11-864c-a582d4034f7d
# ╠═f0dabeb6-2c30-4556-aeb8-03c51106f012
# ╠═a20de17c-33ca-4807-918f-3a58d641ed69
# ╟─edecc73a-021f-4e0e-8d2e-dbafe537f0eb
# ╟─d9331fb3-8c04-4082-bdf5-0a1d09a65276
# ╠═e6cd8de6-20c6-4d36-93ba-b1a9ed808fc2
# ╠═5ce1edef-5b0e-48ce-b269-855726cc5e15
# ╟─c10b85f2-be07-4fd4-a66c-50ac8e54fdb8
# ╠═c0992773-4324-4c22-a806-9ec7bd135a2f
# ╠═2d41b937-1406-4db8-a453-f0d7ca042434
# ╠═51e387ff-1619-4c3f-8e52-748c0bddd9cf
# ╟─925d3781-a469-4943-b951-1688d705cb97
# ╠═bef1e66b-bf43-4e05-a286-693626c61ea6
# ╠═874cbe3e-516e-4f8c-8ad8-e781a5d4af0d
# ╟─50bfec97-0cf8-4a6e-a0e1-13ee391dce69
# ╠═7ae46225-cbbb-4595-adbc-7fd679bf965f
# ╠═385a17c7-2394-492a-8e89-0f402311f5c4
# ╟─06627dd0-f22d-4fe5-8050-d0a84cac12fe
# ╟─963cb350-b9b5-4dbe-8b5f-63ce38440e86
# ╠═5d40252a-4dc3-420d-bd8d-d11abdb07c9b
# ╠═64695822-e79c-4e34-912f-2179c674116d
# ╠═16ee76bf-3968-414b-aa0f-e82fbf3f7911
# ╠═b2e92d06-8731-491c-adbe-ec9f778247c1
# ╠═d55be015-9a20-4efd-9be2-a5ecf9545400
# ╠═92e842e9-42b8-45e6-937e-3d2049df9b09
# ╠═296749ef-7973-4ac9-8632-825fccbd3476
# ╠═f3c5297d-c371-41af-988b-595fb47ac4d7
# ╠═bfca07d3-6479-4835-8b10-314facfcfea1
# ╟─0a753edc-4507-46e8-ab0f-fcdd5f3fa21f
# ╟─8bcdaf5f-6e69-471e-9fca-063ece7f563a
# ╟─e4a1cb08-1e6c-45b1-9937-12b13bba1645
# ╠═c32925a7-28ca-4c23-9ab8-43db8e0dc0c3
# ╠═a7a4c219-d4dd-4491-90f9-824924124ff2
# ╟─21f0d7df-396e-47cc-beb8-0fa13fd8bc40
# ╠═bd12051d-f8ad-4055-8461-b1495ca95ce6
# ╠═8d4e7395-f05b-45dd-b762-da4cd1f40b29
# ╠═cbab862d-f6f1-4238-b007-f1341455a85f
# ╟─c806e238-5f84-4cab-8e13-d9a15d4ee2b0
# ╟─21d4d322-3af7-4ab2-90a4-b465f009167b
# ╟─36e59b38-07a5-43ea-9b73-599f6b78b938
# ╠═e5998180-d4e9-4e9d-a965-b02d92c3a188
# ╠═836f7624-e0b9-4ee3-9f11-a9b148af4266
# ╠═c84c3f0b-8b82-4710-bf27-7667506ef357
# ╠═deaaf582-3387-41b1-83ba-8290aa84236d
# ╠═1625ece0-5a1c-416f-b716-68c1f9f9478d
# ╟─5787c430-d48b-43b8-97e4-e95b1d66f578
# ╠═0e874ac9-c3cb-4d65-8424-d425b6ff4748
# ╟─537f7520-4e65-4d9f-8905-697d957f2772
# ╠═ca22eba8-be14-40b1-b8fe-ead89b323952
# ╠═a5c83d11-580e-4066-9bec-9ed8202e4e46
# ╟─d8fb96fb-bc78-4072-afe9-8427fac0f6ac
# ╟─ac65b656-8ab5-4866-b011-25711260f110
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
