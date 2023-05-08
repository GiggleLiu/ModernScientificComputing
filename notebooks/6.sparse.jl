### A Pluto.jl notebook ###
# v0.19.19

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

# ╔═╡ 4b6307f7-af43-4990-a5c4-5be2b6b11364
using PlutoUI

# ╔═╡ e548acb6-bf53-11ed-1988-7325c1e2b481
using LinearAlgebra, SparseArrays

# ╔═╡ 0c8bf832-0cf8-4b56-b064-1dd177aceae8
using KrylovKit

# ╔═╡ 5b764297-3d06-4899-a8ae-f4378427a6e5
using Graphs  # for generating sparse matrices

# ╔═╡ 8d0d3889-14c0-4e2e-b710-8830e2dab827
TableOfContents()

# ╔═╡ 2add4589-251b-47d0-a800-f0db7f204b61
html"""<button onclick="present()">present</button>"""

# ╔═╡ 83886259-6371-4a02-aedf-b84b413bc229
some_random_matrix = reshape(1:25, 5, 5)

# ╔═╡ 4f1e505c-170b-436f-a8ba-ef61c1d8943e
struct COOMatrix{T} <: AbstractArray{T, 2}   # Julia does not have a COO data type
	rowval::Vector{Int}   # row indices
	colval::Vector{Int}   # column indices
	nzval::Vector{T}  	  # values
	m::Int 				  # number of rows
	n::Int   			  # number of columns
end

# ╔═╡ a205f6d4-8ecd-4103-9904-505c4ecc7b72
Base.size(coo::COOMatrix{T}) where T = (coo.m, coo.n)

# ╔═╡ 78e46965-d581-4f1b-9b53-283441526571
function Base.getindex(coo::COOMatrix{T}, i::Integer, j::Integer) where T
	v = zero(T)
	for (i2, j2, v2) in zip(coo.rowval, coo.colval, coo.nzval)
		if i == i2 && j == j2
			v += v2  # accumulate the value, since repeated indices are allowed.
		end
	end
	return v
end

# ╔═╡ 4990344c-81e8-48cf-93c0-fa1460e0470b
md"# Overview
1. Sparse matrix representation.
    * COOrdinate (COO) format
    * Compressed Sparse Column/Row (CSC/CSR) format
2. Solving the dominant eigenvalue problem.
    * Symmetric Lanczos process
    * Anoldi process
"

# ╔═╡ 49a32422-2415-487e-b3be-28a0436bb552
md"# Sparse Matrices"

# ╔═╡ 4e017416-db9b-43b9-8fd5-657e9810e075
md"Recall that the elementary elimination matrix in Gaussian elimination has the following form."

# ╔═╡ 893f30df-9984-41e3-8353-c23d22730dcc
md"""
```math
M_k = \left(\begin{matrix}

1 & \ldots & 0 & 0 & 0 & \ldots & 0\\
\vdots & \ddots & \vdots & \vdots & \vdots & \ddots & \vdots\\
0 & \ldots & 1 & 0 & 0 & \ldots & 0\\
0 & \ldots & 0 & 1 & 0 & \ldots & 0\\
0 & \ldots & 0 & -m_{k+1} & 1 & \ldots & 0\\
\vdots & \ddots & \vdots & \vdots & \vdots & \ddots & \vdots\\
0 & \ldots & 0 & -m_{n} & 0 & \ldots & 1\\

\end{matrix}\right)
```
where $m_i = a_i/a_k$.
"""

# ╔═╡ 5cca8d2a-7b49-4fcd-bf84-748cb0d66eb0
md"The following cell is copied from notebook: `4.linearequation.jl`"

# ╔═╡ 50b753dc-7033-447b-9480-2e7e0a052f78
md"""
This representation requires storing $n^2$ elements, which is very memory inefficient since it has only $2n-k$ nonzero elements.
"""

# ╔═╡ cf51c362-3a4a-4f60-9123-2693b60e00fd
md"Let $A\in\mathbb{R}^{m\times n}$ be a sparse matrix, and ${\rm nnz}(A) \ll mn$ be the number of nonzero elements in $A$. Is there a universal matrix type that stores such sparse matrices efficiently?."

# ╔═╡ 78da9988-7cc0-4be7-9b8b-89e0029971d7
md"The answer is yes."

# ╔═╡ 6210e3be-fcd3-4682-9f45-8c8d1af9f99c
md"""
## COOrdinate (COO) format
"""

# ╔═╡ 30eb61aa-b03c-4bb7-8491-c6e411a378fe
md"""
The coordinate format means storing nonzero matrix elements into triples
```math
\begin{align}
&(i_1, j_1, v_1)\\
&(i_2, j_2, v_2)\\
&\vdots\\
&(i_k, j_k, v_k)
\end{align}
```

Quiz: How many bytes are required to store the matrix `demo_matrix` in the COO format?
"""

# ╔═╡ 3b1537ea-6176-4996-acd0-05071187f95c
md"We need to implement the [`AbstractArray` interfaces](https://docs.julialang.org/en/v1/manual/interfaces/#man-interface-array)."

# ╔═╡ 3b72536e-c005-4224-ba9d-b157f1c38310
Base.size(coo::COOMatrix{T}, i::Int) where T = getindex((coo.m, coo.n), i)

# ╔═╡ f19a3128-c0a5-4529-b839-1e97fb969483
function elementary_elimination_matrix(A::AbstractMatrix{T}, k::Int) where T
	n = size(A, 1)
	@assert size(A, 2) == n
	# create Elementary Elimination Matrices
	M = Matrix{Float64}(I, n, n)
	for i=k+1:n
		M[i, k] =  -A[i, k] ./ A[k, k]
	end
	return M
end

# ╔═╡ 64ac1cc6-6463-44f8-be88-54f9f52fc12b
demo_matrix = elementary_elimination_matrix(some_random_matrix, 3)

# ╔═╡ 33c4367d-2475-4cf5-8ac4-7ecd81642bbf
md"""
## Indexing a COO matrix
"""

# ╔═╡ 6a3e1a35-762a-4e1e-a706-310e21e618b3
md"Element indexing requires $O({\rm nnz}(A))$ time."

# ╔═╡ 8b6801b4-0ece-4484-a48f-f9435a868bc1
coo_matrix = COOMatrix([1, 2, 3, 4, 5, 4, 5], [1, 2, 3, 4, 5, 3, 3], [1, 1, 1, 1, 1, demo_matrix[4,3], demo_matrix[5, 3]], 5, 5)

# ╔═╡ 6f54c341-383a-4969-95d3-9e347862ddd2
# uncomment to show the result
sizeof(coo_matrix)

# ╔═╡ 0ea729be-40b2-41ab-991a-c87c8a79fbdf
md"""
## Multiplying two COO matrices
"""

# ╔═╡ 1365d99c-4baa-4f04-b5e3-a05fbb3a42c1
md"In the following example, we compute `coo_matrix * coo_matrix`."

# ╔═╡ cd21ceec-3ebd-459b-b28c-8942a885d4b6
function Base.:(*)(A::COOMatrix{T1}, B::COOMatrix{T2}) where {T1, T2}
	@assert size(A, 2) == size(B, 1)
	rowval = Int[]
	colval = Int[]
	nzval = promote_type(T1, T2)[]
	for (i, j, v) in zip(A.rowval, A.colval, A.nzval)
		for (i2, j2, v2) in zip(B.rowval, B.colval, B.nzval)
			if j == i2
				push!(rowval, i)
				push!(colval, j2)
				push!(nzval, v * v2)
			end
		end
	end
	return COOMatrix(rowval, colval, nzval, size(A, 1), size(B, 2))
end

# ╔═╡ 2e7b7227-e3c8-4235-aeea-610508e25432
coo_matrix * coo_matrix

# ╔═╡ 09fff797-5ee7-442c-90de-fb2eae4ede7c
demo_matrix ^ 2

# ╔═╡ 90193207-5ace-4987-94f5-747690777ab3
md"""
Yep!
"""

# ╔═╡ 3b43ee31-eb5a-4e62-81ba-6196e1ad8420
md"""
* Quiz 1: What is the time complexity of COO matrix `setindex!` (`A[i, j] += v`)?
* Quiz 2: What is the time complexity of COO matrix multiplication?
"""

# ╔═╡ 86dc94e1-726a-40c5-87fd-6f5ab43774da
md"""
## Compressed Sparse Column (CSC) format
"""

# ╔═╡ c5eb77b7-f1e6-45fc-88ef-cf4edf331223
md"""
A CSC format sparse matrix can be constructed with the `SparseArrays.sparse` function
"""

# ╔═╡ 39c9b4c3-469d-45dd-ab89-523c48764480
csc_matrix = sparse(coo_matrix.rowval, coo_matrix.colval, coo_matrix.nzval)

# ╔═╡ eff3b121-edaa-4dcd-b3f3-fbdfb061713d
md"It contains 5 fields"

# ╔═╡ 3133cc77-6647-45c5-b693-5eaa1b9528bc
fieldnames(csc_matrix |> typeof)

# ╔═╡ 04531119-a926-4e9e-9f4f-b0cfc655f637
md"""
The `m`, `n`, `rowval` and `nzval` have the same meaning as those in the COO format.
`colptr` is a integer vector of size $n+1$, the element of which points to the elements in `rowval` and `nzval`. Given a matrix $A \in \mathbb{R}^{m\times n}$ in the CSC format, the $j$-th column of $A$ is defined as
`A[rowval[colptr[j]:colptr[j+1]-1], j] := nzval[colptr[j]:colptr[j+1]-1]`
"""

# ╔═╡ 242a2046-fae4-4a45-9792-2ac06deb08a3
csc_matrix[:, 3]

# ╔═╡ 009dd53d-402f-44a4-9dec-087887ab74eb
md"The row indices of nonzero elements in the 3rd column."

# ╔═╡ a59bda82-78cd-44e3-ad23-f3a887a33ad7
rows3 = csc_matrix.rowval[csc_matrix.colptr[3]:csc_matrix.colptr[4]-1]

# ╔═╡ bb4a7db3-c437-4247-8ba5-8f752960f8eb
# or equivalently in Julia, we can use `nzrange`
csc_matrix.rowval[nzrange(csc_matrix, 3)]

# ╔═╡ 4cffe4df-c28a-4004-afc1-1652020d0aa7
md"The values of nonzero elements in the 3rd column."

# ╔═╡ e4b610d0-5247-4c6b-8f06-733504f8ebae
csc_matrix.nzval[csc_matrix.colptr[3]:csc_matrix.colptr[4]-1]

# ╔═╡ cb869bad-b17c-446e-860f-600e1054668d
md"""
## Indexing a CSC matrix
"""

# ╔═╡ a4ff9546-3dc4-463e-84b3-73303ced838d
md"""
The number of operations required to index an element in the $j$-th column of a CSC matrix is linear to the nonzero elements in the $j$-th column.
"""

# ╔═╡ 2a590b74-3ed1-44bf-87bc-c703a237211b
# I do not want to overwrite `Base.getindex`
function my_getindex(A::SparseMatrixCSC{T}, i::Int, j::Int) where T
	for k in nzrange(A, j)
		if A.rowval[k] == i
			return A.nzval[k]
		end
	end
	return zero(T)
end

# ╔═╡ 9296e387-fc25-495c-9299-564d7d512e72
my_getindex(csc_matrix, 4, 3)

# ╔═╡ 97d9d866-20bd-490f-b0e1-a722a3dedf29
md"""
## Multiplying two CSC matrices
"""

# ╔═╡ 27ebe6eb-5b47-400a-8e30-2dccafdaab24
md"""
Multiplying two CSC matrices is much faster than multiplying two COO matrices.
"""

# ╔═╡ 778b3d09-1b76-4ad0-bdd7-8cbd06918519
function my_matmul(A::SparseMatrixCSC{T1}, B::SparseMatrixCSC{T2}) where {T1, T2}
	T = promote_type(T1, T2)
	@assert size(A, 2) == size(B, 1)
	rowval, colval, nzval = Int[], Int[], T[]
	for j2 in 1:size(B, 2)  # enumerate the columns of B
		for k2 in nzrange(B, j2)  # enumerate the rows of B
			v2 = B.nzval[k2]
			for k1 in nzrange(A, B.rowval[k2])  # enumerate the rows of A
				push!(rowval, A.rowval[k1])
				push!(colval, j2)
				push!(nzval, A.nzval[k1] * v2)
			end
		end
	end
	return sparse(rowval, colval, nzval, size(A, 1), size(B, 2))
end

# ╔═╡ fa3f8189-85eb-4943-8347-83aa6572c2fe
my_matmul(csc_matrix, csc_matrix)

# ╔═╡ e8234fbd-61a8-4ff8-9d18-b974267fb062
csc_matrix^2

# ╔═╡ d7f295c4-ce02-46d0-9f14-5ec3d4f25ab3
md"""
Quiz: What is the time complexity of CSC matrix `setindex!` (`A[i, j] = v`)?
"""

# ╔═╡ fffdf566-3d54-4cbe-8543-bc88bd669f4c
md"# Large sparse eigenvalue problem"

# ╔═╡ f14621f1-a002-46c5-b0c0-15d008ab382c
md"""
## Dominant eigenvalue problem
"""

# ╔═╡ 3b75625c-2d92-4499-9662-ee1c7a173c30
md"One can use the power method to compute dominant eigenvalues (one having the largest absolute value) of a matrix."

# ╔═╡ 1981eb8f-e93b-44cb-b81d-6f8c7ed13ec1
function power_method(A::AbstractMatrix{T}, n::Int) where T
	n = size(A, 2)
	x = normalize!(randn(n))
	for i=1:n
		x = A * x
		normalize!(x)
	end
	return x' * A * x', x
end

# ╔═╡ ec049390-f8fa-42d8-8e63-45af08b058d3
md"""
Since computing matrix-vector multiplication of CSC sparse matrix is fast, the power method is a convenient method to obtain the largest eigen value of a sparse matrix.
"""

# ╔═╡ a51ddacf-7e9f-4ab5-be9b-f2ed4e9952aa
md"The rate of convergence is dedicated by $|\lambda_2/\lambda_1|^k$."

# ╔═╡ cefb596e-2df5-44a3-bd6f-062e7ebdc0ed
md"""
By inverting the sign, $A\rightarrow -A$, we can use the same method to obtain the smallest eigenvalue.
"""

# ╔═╡ 50717c84-e8cf-4e19-b344-7d50b0b290ff
md"## The symmetric Lanczos process"

# ╔═╡ 339df51a-7623-405a-a590-adc337edc0be
md"""
Let $A \in \mathbb{R}^{n \times n}$ be a large symmetric sparse matrix, the Lanczos process can be used to obtain its largest/smallest eigenvalue, with faster convergence speed comparing with the power method.
"""

# ╔═╡ 014be843-e2d3-42c8-bbc9-bd66bbb7df93
md"""
## The Krylov subspace
"""

# ╔═╡ 2a548303-adb7-4189-bb82-2095f920a996
md"""
A Krylov subspace of size $k$ with initial vector $q_1$ is defined by
```math
\mathcal{K}(A, q_1, k) = {\rm span}\{q_1, Aq_1, A^2q_1, \ldots, A^{k-1}q_1\}
```
"""

# ╔═╡ b9c1e68a-634f-42e0-aa13-e84b4feb2a3a
md"""
The Julia package `KrylovKit.jl` contains many Krylov space based algorithms.

`KrylovKit.jl` accepts general functions or callable objects as linear maps, and general Julia
objects with vector like behavior (as defined in the docs) as vectors.

The high level interface of KrylovKit is provided by the following functions:
*   `linsolve`: solve linear systems
*   `eigsolve`: find a few eigenvalues and corresponding eigenvectors
*   `geneigsolve`: find a few generalized eigenvalues and corresponding vectors
*   `svdsolve`: find a few singular values and corresponding left and right singular vectors
*   `exponentiate`: apply the exponential of a linear map to a vector
*   `expintegrator`: [exponential integrator](https://en.wikipedia.org/wiki/Exponential_integrator)
    for a linear non-homogeneous ODE, computes a linear combination of the `ϕⱼ` functions which generalize `ϕ₀(z) = exp(z)`.

"""

# ╔═╡ 8dc7e127-187e-48e5-9ed5-d7ecf196a40e
md"""
## Projecting a sparse matrix into a subspace
Given $Q\in \mathbb{R}^{n\times k}$ and $Q^T Q = I$, the following statement is always true.
```math
\lambda_1(Q^T_k A Q_k) \leq \lambda_1(A),
```
where $\lambda_1(A)$ is the largest eigenvalue of $A \in \mathbb{R}^{n\times n}$.
"""

# ╔═╡ 89bc81e9-e1ce-459f-bd28-511b534a14fc
md"""
## Lanczos Tridiagonalization

In the Lanczos tridiagonalizaiton process, we want to find a orthogonal matrix $Q^T$ such that
```math
Q^T A Q = T
```
where $T$ is a tridiagonal matrix
```math
T = \left(\begin{matrix}
\alpha_1 & \beta_1 & 0 & \ldots & 0\\
\beta_1 & \alpha_2 & \beta_2 & \ldots & 0\\
0 & \beta_2 & \alpha_3 & \ldots & 0\\
\vdots & \vdots & \vdots & \ddots & \vdots\\
0 & 0 & 0 & \beta_{k-1} & \alpha_k
\end{matrix}\right),
```
 $Q = [q_1 | q_2 | \ldots | q_n],$ and ${\rm span}(\{q_1, q_2, \ldots, q_k\}) = \mathcal{K}(A, q_1, k)$.
"""

# ╔═╡ 03cb1b92-ba98-4065-8761-1a108f6cabfb
md"We have $Aq_k = \beta_{k-1}q_{k-1} + \alpha_k q_k + \beta_k q_{k+1}$, or equivalently in the recursive style
```math
q_{k+1} = (Aq_k - \beta_{k-1}q_{k-1} - \alpha_k q_k)/\beta_k.
```
"

# ╔═╡ a2d79593-fd1f-46ea-afe2-578f75e084cf
md"""
By multiplying $q_k^T$ on the left, we have
```math
\alpha_k  = q_k^T A q_k.
```
Since $q_{k+1}$ is normalized, we have
```math
\beta_k = \|Aq_k - \beta_{k-1}q_{k-1} - \alpha_k q_k\|_2
```
"""

# ╔═╡ 0ada2d40-1052-42f1-9577-3d6e590efca4
md"""
If at any moment, $\beta_k = 0$, the interation stops due to convergence of a subspace. We have the following reducible form
```math
T(\beta_2 = 0) = \left(\begin{array}{cc|ccc}
\alpha_1 & \beta_1 & 0 & \ldots & 0\\
\beta_1 & \alpha_2 & 0 & \ldots & 0\\
\hline
0 & 0 & \alpha_3 & \ldots & 0\\
\vdots & \vdots & \vdots & \ddots & \vdots\\
0 & 0 & 0 & \beta_{k-1} & \alpha_k
\end{array}\right),
```
"""

# ╔═╡ 0906b965-f760-4f67-9ddc-498aeb99c3b8
md"## A naive implementation"

# ╔═╡ 166d4ddc-5e58-4210-a389-997c1ea82de2
function lanczos(A, q1::AbstractVector{T}; abstol, maxiter) where T
	# normalize the input vector
	q1 = normalize(q1)
	# the first iteration
	q = [q1]
	Aq1 = A * q1
	α = [q1' * Aq1]
	rk = Aq1 .- α[1] .* q1
	β = [norm(rk)]
	for k = 2:min(length(q1), maxiter)
		# the k-th orthonormal vector in Q
		push!(q, rk ./ β[k-1])
		Aqk = A * q[k]
		# compute the diagonal element as αₖ = qₖᵀ A qₖ
		push!(α, q[k]' * Aqk)
		rk = Aqk .- α[k] .* q[k] .- β[k-1] * q[k-1]
		# compute the off-diagonal element as βₖ = |rₖ|
		nrk = norm(rk)
		# break if βₖ is smaller than abstol or the maximum number of iteration is reached
		if abs(nrk) < abstol || k == length(q1)
			break
		end
		push!(β, nrk)
	end
	# returns T and Q
	return SymTridiagonal(α, β), hcat(q...)
end

# ╔═╡ 37a68538-2fee-45e2-a1c4-653107f1e0de
md"""
## Example: using dominant eigensolver to study the spectral graph theory
"""

# ╔═╡ f75a35cd-d334-4741-8477-7555aec38e92
md"""
Laplacian matrix
Given a simple graph $G$ with $n$ vertices $v_{1},\ldots ,v_{n}$, its Laplacian matrix $L_{n\times n}$ is defined element-wise as

```math
L_{i,j}:={\begin{cases}\deg(v_{i})&{\mbox{if}}\ i=j\\-1&{\mbox{if}}\ i\neq j\ {\mbox{and}}\ v_{i}{\mbox{ is adjacent to }}v_{j}\\0&{\mbox{otherwise}},\end{cases}}
```
or equivalently by the matrix $L=D-A$, where $D$ is the degree matrix and A is the adjacency matrix of the graph. Since $G$ is a simple graph, $A$ only contains 1s or 0s and its diagonal elements are all 0s.
"""

# ╔═╡ cab1420b-fdf1-42d7-95fd-f37ef416bf49
md"""Theorem: The number of connected components in the graph is the dimension of the nullspace of the Laplacian and the algebraic multiplicity of the 0 eigenvalue.
"""

# ╔═╡ 294e1dea-4f2f-4731-9327-b1c04c82d2db
graphsize = 10

# ╔═╡ 273f9cbd-1885-4834-921d-60130c34c028
md"One can use the `Graphs.laplacian_matrix(graph)` to generate a laplacian matrix (CSC formated) of a graph."

# ╔═╡ 3b299d74-e209-4c1e-a831-fce40c4f43f4
lmat = laplacian_matrix(random_regular_graph(graphsize, 3))

# ╔═╡ 1b403168-63b7-4850-8d49-20869d00f71b
tri, Q = lanczos(lmat, randn(graphsize); abstol=1e-8, maxiter=100)

# ╔═╡ e11c71bb-a079-4748-9598-e6c49dfce7a7
eigen(tri).values

# ╔═╡ 95e3a70a-0c2a-4c87-a7c6-963b607c63ad
Q' * Q

# ╔═╡ 2a5118ab-c616-4b85-8ea5-737cd319f835
@bind graph_size Slider(10:2:200; show_value=true, default=10)

# ╔═╡ 05411446-466b-4c6c-bb8a-0caebb516770
let
	graph = random_regular_graph(graph_size, 3)
	A = laplacian_matrix(graph)
	q1 = randn(graph_size)
	tr, Q = lanczos(-A, q1; abstol=1e-8, maxiter=100)
	# using function `KrylovKit.eigsolve`
	@info "KrylovKit.eigsolve: " eigsolve(A, q1, 2, :SR)
	@info Q' * Q
	# diagonalize the triangular matrix obtained with our naive implementation
	@info "Naive approach: " eigen(-tr).values
end;

# ╔═╡ 4c0f9641-f723-4880-9346-ba7899390d52
md"""NOTE: with larger `graph_size`, you should see some "ghost" eigenvalues """

# ╔═╡ e68e3e51-2084-45bf-a8d0-42e4f22d0aea
md"""
## Reorthogonalization
"""

# ╔═╡ 64ed8383-a449-4278-9cd9-ad317ce13574
md"""
Let $r_0, \ldots, r_{k-1} \in \mathbb{R}_n$ be given and suppose that Householder matrices $H_0, \ldots, H_{k-1}$ have been computed such that $(H_0\ldots H_{k- 1})^T [r_0\mid\ldots\mid r_{k-1}]$ is upper triangular. Let $[q_1 \mid \ldots \mid q_k ]$ denote the first $k$ columns of the Householderproduct $(H_0 \ldots H_{k-1})$.
Then $q_k^T q_l = \delta_{kl}$ (machine precision).
"""

# ╔═╡ 75d297f9-892e-44c4-80a4-1e1beb5d7d9c
md"**The following 4 cells are copied from notebook: 5.linear-least-square.jl**"

# ╔═╡ 191f0c0a-fb45-402e-9fdc-f3427c70bf25
struct HouseholderMatrix{T} <: AbstractArray{T, 2}
	v::Vector{T}
	β::T
end

# ╔═╡ af4d73c4-2f8e-4aaa-aa40-3be0ded47323
# the `mul!` interfaces can take two extra factors.
function left_mul!(B, A::HouseholderMatrix)
	B .-= (A.β .* A.v) * (A.v' * B)
	return B
end

# ╔═╡ 571936d4-3ce6-48e8-be5d-7dbc73e2d3d4
# the `mul!` interfaces can take two extra factors.
function right_mul!(A, B::HouseholderMatrix)
	A .= A .- (A * (B.β .* B.v)) * B.v'
	return A
end

# ╔═╡ 84408a62-5062-41fd-8f49-2ace02d7d685
function householder_matrix(v::AbstractVector{T}) where T
	v = copy(v)
	v[1] -= norm(v, 2)
	return HouseholderMatrix(v, 2/norm(v, 2)^2)
end

# ╔═╡ 5e6a089b-e61b-4945-b8dc-1e069d8f0d92
md"The Lanczos algorithm with complete orthogonalization."

# ╔═╡ 91ab0a42-1a2f-4944-98f5-bda041fa9ff1
function lanczos_reorthogonalize(A, q1::AbstractVector{T}; abstol, maxiter) where T
	n = length(q1)
	# normalize the input vector
	q1 = normalize(q1)
	# the first iteration
	q = [q1]
	Aq1 = A * q1
	α = [q1' * Aq1]
	rk = Aq1 .- α[1] .* q1
	β = [norm(rk)]
	householders = [householder_matrix(q1)]
	for k = 2:min(n, maxiter)
		# reorthogonalize rk: 1. compute the k-th householder matrix
		for j = 1:k-1
			left_mul!(view(rk, j:n), householders[j])
		end
		push!(householders, householder_matrix(view(rk, k:n)))
		# reorthogonalize rk: 2. compute the k-th orthonormal vector in Q
		qk = zeros(T, n); qk[k] = 1  # qₖ = H₁H₂…Hₖeₖ
		for j = k:-1:1
			left_mul!(view(qk, j:n), householders[j])
		end
		push!(q, qk)
		Aqk = A * q[k]
		# compute the diagonal element as αₖ = qₖᵀ A qₖ
		push!(α, q[k]' * Aqk)
		rk = Aqk .- α[k] .* q[k] .- β[k-1] * q[k-1]
		# compute the off-diagonal element as βₖ = |rₖ|
		nrk = norm(rk)
		# break if βₖ is smaller than abstol or the maximum number of iteration is reached
		if abs(nrk) < abstol || k == n
			break
		end
		push!(β, nrk)
	end
	return SymTridiagonal(α, β), hcat(q...)
end

# ╔═╡ 06d4453f-ea4e-4e5f-9aea-72a84cd56e99
let
	n = 1000
	graph = random_regular_graph(n, 3)
	A = laplacian_matrix(graph)
	q1 = randn(n)
	tr, Q = lanczos_reorthogonalize(A, q1; abstol=1e-5, maxiter=100)
	@info eigsolve(A, q1, 2, :SR)
	eigen(tr)
end

# ╔═╡ bb65395e-4d11-439d-9dba-e25c7048df9f
md"""
## Notes on Lanczos
1. In practise, we do not store all $q$ vectors to save space.
2. Blocking technique is required if we want to compute multiple eigenvectors or a degenerate eigenvector.
2. Restarting technique can be used to improve the solution.
"""

# ╔═╡ d6487a34-1c62-4879-a92a-7fcfb7080d85
md"""
## The Arnoldi Process
"""

# ╔═╡ d0776be5-6a56-41c2-981c-e992ec8afdc5
md"""If $A$ is not symmetric, then the orthogonal tridiagonalization $Q^T A Q = T$ does not exist in general. The Arnoldi approach involves the column by column generation of an orthogonal $Q$ such that $Q^TAQ = H$ is a Hessenberg matrix.
```math
H = \left(\begin{matrix}
h_{11} & h_{12} & h_{13} & \ldots & h_{1k}\\
h_{21} & h_{22} & h_{23} & \ldots & h_{2k}\\
0 & h_{32} & h_{33} & \ldots & h_{3k}\\
\vdots & \vdots & \vdots & \ddots & \vdots\\
0 & 0 & 0 & \ldots & h_{kk}
\end{matrix}\right)
```

That is, $h_{ij} = 0$ for $i>j+1$.
"""

# ╔═╡ 71ebaf5b-5f20-4f73-b530-3ae1aea071f2
function arnoldi_iteration(A::AbstractMatrix{T}, x0::AbstractVector{T}; maxiter) where T
	h = Vector{T}[]
	q = [normalize(x0)]
	n = length(x0)
	@assert size(A) == (n, n)
	for k = 1:min(maxiter, n)
		u = A * q[k]    # generate next vector
		hk = zeros(T, k+1)
		for j = 1:k # subtract from new vector its components in all preceding vectors
			hk[j] = q[j]' * u
			u = u - hk[j] * q[j]
		end
		hkk = norm(u)
		hk[k+1] = hkk
		push!(h, hk)
		if abs(hkk) < 1e-8 || k >=n # stop if matrix is reducible
			break
		else
			push!(q, u ./ hkk)
		end
	end

	# construct `h`
	kmax = length(h)
	H = zeros(T, kmax, kmax)
	for k = 1:length(h)
		if k == kmax
			H[1:k, k] .= h[k][1:k]
		else
			H[1:k+1, k] .= h[k]
		end
	end
	return H, hcat(q...)
end

# ╔═╡ 68e61322-1f14-4098-ab3b-6349aaab669a
let
	n = 10
	A = randn(n, n)
	q1 = randn(n)
	h, q = arnoldi_iteration(A, q1; maxiter=100)

	# using function `KrylovKit.eigsolve`
	@info "KrylovKit.eigsolve: " eigsolve(A, q1, 2, :LR)
	# diagonalize the triangular matrix obtained with our naive implementation
	@info "Naive approach: " eigen(h).values
end;

# ╔═╡ b0b1e888-98d9-405c-8b01-a3b4f8cae1dd
md"# Assignment"

# ╔═╡ 1fd7a9d3-1f63-407b-b44c-1bd198351039
md"""
#### 1. Review
I forgot to copy the definitions of `rowindices`, `colindices` and `data` in the following code. Can you help me figure out what are their possible values?
```julia
julia> sp = sparse(rowindices, colindices, data);

julia> sp.colptr
6-element Vector{Int64}:
 1
 2
 3
 5
 6
 6

julia> sp.rowval
5-element Vector{Int64}:
 3
 1
 1
 4
 5

julia> sp.nzval
5-element Vector{Float64}:
 0.799
 0.942
 0.848
 0.164
 0.637

julia> sp.m
5

julia> sp.n
5
```
"""

# ╔═╡ dabdee6d-0c64-4dc7-9c09-15d388a32387
md"""
#### 2. Coding (Choose one of the following two problems):
1. (easy) Implement CSC format sparse matrix-vector multiplication as function `my_spv`. Please include the following test code into your project.
```julia
using SparseArrays, Test

@testset "sparse matrix - vector multiplication" begin
	for k = 1:100
		m, n = rand(1:100, 2)
		density = rand()
		sp = sprand(m, n, density)
		v = randn(n)
        @test Matrix(sp) * v ≈ my_spv(sp, v)
	end
end
```

2. (hard) The restarting in Lanczos is a technique technique to reduce memory. Suppose we wish to calculate the largest eigenvalue of $A$. If $q_1 \in \mathbb{R}^{n}$ is a given normalized vector, then it can be refined as follows:

Step 1. Generate $q_2,\ldots,q_s \in \mathbb{R}^{n}$ via the block Lanczos algorithm.

Step 2. Form $T_s = [ q_1 \mid \ldots \mid q_s]^TA [ q_1 \mid \ldots \mid q_s]$, an s-by-s matrix.

Step 3. Compute an orthogonal matrix $U = [ u_1 \mid \ldots\mid u_s]$ such that $U^T T_s U = {\rm diag}(\theta_1, \ldots, \theta_s)$ with $\theta_1\geq \ldots \geq\theta_s$·

Step 4. Set $q_1^{({\rm new})} = [q_1 \mid \ldots \mid q_s]u_1$.

Please implement a Lanczos tridiagonalization process with restarting as a Julia function. You submission should include that function as well as a test. 
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Graphs = "86223c79-3864-5bf0-83f7-82e725a168b6"
KrylovKit = "0b1a1467-8014-51b9-945f-bf0ae24f4b77"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[compat]
Graphs = "~1.8.0"
KrylovKit = "~0.6.0"
PlutoUI = "~0.7.50"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "2810da36ff5c96af693608e9e35c2889d5a7d14b"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "cc37d689f599e8df4f464b2fa3870ff7db7492ef"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.6.1"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c6d890a52d2c4d55d326439580c3b8d0875a77d9"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.7"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "61fdd77467a5c3ad071ef8277ac6bd6af7dd4c04"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.6.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "1cd7f0af1aa58abc02ea1d872953a97359cb87fa"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.4"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "1cf1d7dcb4bc32d7b4a5add4232db3750c27ecb4"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.8.0"

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

[[deps.Inflate]]
git-tree-sha1 = "5cd07aab533df5170988219191dfad0519391428"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.KrylovKit]]
deps = ["ChainRulesCore", "GPUArraysCore", "LinearAlgebra", "Printf"]
git-tree-sha1 = "1a5e1d9941c783b0119897d29f2eb665d876ecf3"
uuid = "0b1a1467-8014-51b9-945f-bf0ae24f4b77"
version = "0.6.0"

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

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

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

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "6f4fbcd1ad45905a5dee3f4256fabb49aa2110c6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.7"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

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

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "2d7d9e1ddadc8407ffd460e24218e37ef52dd9a3"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.16"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

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

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╠═4b6307f7-af43-4990-a5c4-5be2b6b11364
# ╟─8d0d3889-14c0-4e2e-b710-8830e2dab827
# ╟─2add4589-251b-47d0-a800-f0db7f204b61
# ╟─4990344c-81e8-48cf-93c0-fa1460e0470b
# ╟─49a32422-2415-487e-b3be-28a0436bb552
# ╠═e548acb6-bf53-11ed-1988-7325c1e2b481
# ╟─4e017416-db9b-43b9-8fd5-657e9810e075
# ╟─893f30df-9984-41e3-8353-c23d22730dcc
# ╟─5cca8d2a-7b49-4fcd-bf84-748cb0d66eb0
# ╠═f19a3128-c0a5-4529-b839-1e97fb969483
# ╠═83886259-6371-4a02-aedf-b84b413bc229
# ╠═64ac1cc6-6463-44f8-be88-54f9f52fc12b
# ╟─50b753dc-7033-447b-9480-2e7e0a052f78
# ╟─cf51c362-3a4a-4f60-9123-2693b60e00fd
# ╟─78da9988-7cc0-4be7-9b8b-89e0029971d7
# ╟─6210e3be-fcd3-4682-9f45-8c8d1af9f99c
# ╟─30eb61aa-b03c-4bb7-8491-c6e411a378fe
# ╠═4f1e505c-170b-436f-a8ba-ef61c1d8943e
# ╟─3b1537ea-6176-4996-acd0-05071187f95c
# ╠═a205f6d4-8ecd-4103-9904-505c4ecc7b72
# ╠═3b72536e-c005-4224-ba9d-b157f1c38310
# ╟─33c4367d-2475-4cf5-8ac4-7ecd81642bbf
# ╟─6a3e1a35-762a-4e1e-a706-310e21e618b3
# ╠═78e46965-d581-4f1b-9b53-283441526571
# ╠═8b6801b4-0ece-4484-a48f-f9435a868bc1
# ╠═6f54c341-383a-4969-95d3-9e347862ddd2
# ╟─0ea729be-40b2-41ab-991a-c87c8a79fbdf
# ╟─1365d99c-4baa-4f04-b5e3-a05fbb3a42c1
# ╠═cd21ceec-3ebd-459b-b28c-8942a885d4b6
# ╠═2e7b7227-e3c8-4235-aeea-610508e25432
# ╠═09fff797-5ee7-442c-90de-fb2eae4ede7c
# ╟─90193207-5ace-4987-94f5-747690777ab3
# ╟─3b43ee31-eb5a-4e62-81ba-6196e1ad8420
# ╟─86dc94e1-726a-40c5-87fd-6f5ab43774da
# ╟─c5eb77b7-f1e6-45fc-88ef-cf4edf331223
# ╠═39c9b4c3-469d-45dd-ab89-523c48764480
# ╟─eff3b121-edaa-4dcd-b3f3-fbdfb061713d
# ╠═3133cc77-6647-45c5-b693-5eaa1b9528bc
# ╟─04531119-a926-4e9e-9f4f-b0cfc655f637
# ╠═242a2046-fae4-4a45-9792-2ac06deb08a3
# ╟─009dd53d-402f-44a4-9dec-087887ab74eb
# ╠═a59bda82-78cd-44e3-ad23-f3a887a33ad7
# ╠═bb4a7db3-c437-4247-8ba5-8f752960f8eb
# ╟─4cffe4df-c28a-4004-afc1-1652020d0aa7
# ╠═e4b610d0-5247-4c6b-8f06-733504f8ebae
# ╟─cb869bad-b17c-446e-860f-600e1054668d
# ╟─a4ff9546-3dc4-463e-84b3-73303ced838d
# ╠═2a590b74-3ed1-44bf-87bc-c703a237211b
# ╠═9296e387-fc25-495c-9299-564d7d512e72
# ╟─97d9d866-20bd-490f-b0e1-a722a3dedf29
# ╟─27ebe6eb-5b47-400a-8e30-2dccafdaab24
# ╠═778b3d09-1b76-4ad0-bdd7-8cbd06918519
# ╠═fa3f8189-85eb-4943-8347-83aa6572c2fe
# ╠═e8234fbd-61a8-4ff8-9d18-b974267fb062
# ╟─d7f295c4-ce02-46d0-9f14-5ec3d4f25ab3
# ╟─fffdf566-3d54-4cbe-8543-bc88bd669f4c
# ╟─f14621f1-a002-46c5-b0c0-15d008ab382c
# ╟─3b75625c-2d92-4499-9662-ee1c7a173c30
# ╠═1981eb8f-e93b-44cb-b81d-6f8c7ed13ec1
# ╟─ec049390-f8fa-42d8-8e63-45af08b058d3
# ╟─a51ddacf-7e9f-4ab5-be9b-f2ed4e9952aa
# ╟─cefb596e-2df5-44a3-bd6f-062e7ebdc0ed
# ╟─50717c84-e8cf-4e19-b344-7d50b0b290ff
# ╟─339df51a-7623-405a-a590-adc337edc0be
# ╟─014be843-e2d3-42c8-bbc9-bd66bbb7df93
# ╟─2a548303-adb7-4189-bb82-2095f920a996
# ╟─b9c1e68a-634f-42e0-aa13-e84b4feb2a3a
# ╠═0c8bf832-0cf8-4b56-b064-1dd177aceae8
# ╟─8dc7e127-187e-48e5-9ed5-d7ecf196a40e
# ╟─89bc81e9-e1ce-459f-bd28-511b534a14fc
# ╟─03cb1b92-ba98-4065-8761-1a108f6cabfb
# ╟─a2d79593-fd1f-46ea-afe2-578f75e084cf
# ╟─0ada2d40-1052-42f1-9577-3d6e590efca4
# ╟─0906b965-f760-4f67-9ddc-498aeb99c3b8
# ╠═166d4ddc-5e58-4210-a389-997c1ea82de2
# ╟─37a68538-2fee-45e2-a1c4-653107f1e0de
# ╟─f75a35cd-d334-4741-8477-7555aec38e92
# ╟─cab1420b-fdf1-42d7-95fd-f37ef416bf49
# ╠═5b764297-3d06-4899-a8ae-f4378427a6e5
# ╠═294e1dea-4f2f-4731-9327-b1c04c82d2db
# ╟─273f9cbd-1885-4834-921d-60130c34c028
# ╠═3b299d74-e209-4c1e-a831-fce40c4f43f4
# ╠═1b403168-63b7-4850-8d49-20869d00f71b
# ╠═e11c71bb-a079-4748-9598-e6c49dfce7a7
# ╠═95e3a70a-0c2a-4c87-a7c6-963b607c63ad
# ╠═2a5118ab-c616-4b85-8ea5-737cd319f835
# ╠═05411446-466b-4c6c-bb8a-0caebb516770
# ╟─4c0f9641-f723-4880-9346-ba7899390d52
# ╟─e68e3e51-2084-45bf-a8d0-42e4f22d0aea
# ╟─64ed8383-a449-4278-9cd9-ad317ce13574
# ╟─75d297f9-892e-44c4-80a4-1e1beb5d7d9c
# ╠═191f0c0a-fb45-402e-9fdc-f3427c70bf25
# ╠═af4d73c4-2f8e-4aaa-aa40-3be0ded47323
# ╠═571936d4-3ce6-48e8-be5d-7dbc73e2d3d4
# ╠═84408a62-5062-41fd-8f49-2ace02d7d685
# ╟─5e6a089b-e61b-4945-b8dc-1e069d8f0d92
# ╠═91ab0a42-1a2f-4944-98f5-bda041fa9ff1
# ╠═06d4453f-ea4e-4e5f-9aea-72a84cd56e99
# ╟─bb65395e-4d11-439d-9dba-e25c7048df9f
# ╟─d6487a34-1c62-4879-a92a-7fcfb7080d85
# ╟─d0776be5-6a56-41c2-981c-e992ec8afdc5
# ╠═71ebaf5b-5f20-4f73-b530-3ae1aea071f2
# ╠═68e61322-1f14-4098-ab3b-6349aaab669a
# ╟─b0b1e888-98d9-405c-8b01-a3b4f8cae1dd
# ╟─1fd7a9d3-1f63-407b-b44c-1bd198351039
# ╟─dabdee6d-0c64-4dc7-9c09-15d388a32387
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
