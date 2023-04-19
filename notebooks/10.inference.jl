### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ a3d30219-6fbe-46a3-b304-4963eaf5ecf1
using PlutoUI

# ╔═╡ b14bc8c7-8a5d-4518-8561-2328fa61ce86
using LuxorGraphPlot, Luxor

# ╔═╡ 759ab9af-b11e-491e-b646-0497ca33f7ae
using LinearAlgebra

# ╔═╡ f699d333-bafd-4ad6-9a9c-8e08c5230891
using OMEinsum

# ╔═╡ dffe3a4c-1043-4320-bf10-f3c023459c31
TableOfContents()

# ╔═╡ efb30222-db9c-11ed-168b-1f3cb30fc22c
md"
# The backward rule of matrix multiplication
"

# ╔═╡ bd65ae8a-580e-4684-a902-8d7643268831
md"""
Let $\mathcal{T}$ be a stack, and $x \rightarrow \mathcal{T}$ and $x\leftarrow \mathcal{T}$ be the operation of pushing and poping an element from this stack.
Given $A \in R^{l\times m}$ and $B\in R^{m\times n}$, the forward pass computation of matrix multiplication is
```math
\begin{align}
&C = A B\\
&A \rightarrow \mathcal{T}\\
&B \rightarrow \mathcal{T}\\
&\ldots
\end{align}
```

Let the adjoint of $x$ be $\overline{x} = \frac{\partial \mathcal{L}}{\partial x}$, where $\mathcal{L}$ is a real loss as the final output.
The backward pass computes
```math
\begin{align}
&\ldots\\
&B \leftarrow \mathcal{T}\\
&\overline{A} = \overline{C}B\\
&A \leftarrow \mathcal{T}\\
&\overline{B} = A\overline{C}
\end{align}
```

The rules to compute $\overline{A}$ and $\overline{B}$ are called the backward rules for matrix multiplication. They are crucial for rule based automatic differentiation.
"""

# ╔═╡ fc2d50c3-9f25-410c-807e-6fb3bc4c4956
md"""
## Deriving the backward rules

Let us introduce a small perturbation $\delta A$ on $A$ and $\delta B$ on $B$,

```math
\delta C = \delta A B + A \delta B
```

```math
\delta \mathcal{L} = {\rm tr}(\delta C^T \overline{C}) = 
{\rm tr}(\delta A^T \overline{A}) + {\rm tr}(\delta B^T \overline{B})
```



"""

# ╔═╡ d1490cf0-1dc0-466e-bec8-a17420713cf2
md"""
It is easy to see
```math
\delta L = {\rm tr}((\delta A B)^T \overline C) + {\rm tr}((A \delta B)^T \overline C) = 
{\rm tr}(\delta A^T \overline{A}) + {\rm tr}(\delta B^T \overline{B})
```
We have the backward rules for matrix multiplication as
```math
\begin{align}
&\overline{A} = \overline{C}B^T\\
&\overline{B} = A^T\overline{C}
\end{align}
```

"""

# ╔═╡ 84a58161-9986-497b-b13b-0cc9c2127b09
md"# The backward rule of eigen decomposition
Ref: [https://arxiv.org/abs/1710.08717](https://arxiv.org/abs/1710.08717)

Given a symmetric matrix $A$, the eigen decomposition is

```math
A = UEU^\dagger
```

We have

```math
\overline{A} = U\left[\overline{E} + \frac{1}{2}\left(\overline{U}^\dagger U \circ F + h.c.\right)\right]U^\dagger
```

Where $F_{ij}=(E_j- E_i)^{-1}$.

If $E$ is continuous, we define the density $\rho(E) = \sum\limits_k \delta(E-E_k)=-\frac{1}{\pi}\int_k \Im[G^r(E, k)] $ (check sign!). Where $G^r(E, k) = \frac{1}{E-E_k+i\delta}$.

We have
```math
\overline{A} = U\left[\overline{E} + \frac{1}{2}\left(\overline{U}^\dagger U \circ \Re [G(E_i, E_j)] + h.c.\right)\right]U^\dagger
```
"

# ╔═╡ 35e527f3-2285-4ecb-83ec-2e69678f872c
md"""
# Tensors and tensor decomposition
"""

# ╔═╡ fc9711e8-01d5-4175-97ba-c9169c659eb7
md"Ref: Golub, Section 12"

# ╔═╡ 6f36475d-e36d-4bd3-9b95-a271b48e6e54
md"""
## Tensor contraction
"""

# ╔═╡ b625f965-57eb-43f5-bbdf-aae9e33ed846
md"""
We use the `einsum` function to compute the tensor contraction.
"""

# ╔═╡ 83ca9284-10c6-448e-8e79-bacbf3868c5d
md"""
### The diagramatic representation
"""

# ╔═╡ 05fe25bb-8f49-413b-815d-71071d7dd48d
md"## Higher order SVD"

# ╔═╡ 1d9b7f81-260c-402f-9c83-4580d20def16
md"""
Quiz: How do you use matrix singular value decomposition (or principle componnt analysis) in your own research?
"""

# ╔═╡ 05eeacb2-b459-4545-9fbb-a01ca148538e
md"### Tucker decomposition"

# ╔═╡ 27ce5bd7-689f-4e83-a817-89ef45dc7ef4
md"""
Suppose $A \in R^{n_1\times n_2\times n_3}$ and assume that $r \leq {\rm rank}(A)$with inequality in at least one component. Prompted by the optimality properties of the matrix SVD, let us consider the following optimization problem:
```math
\min_{X} \| A - X \|_F
```
such that 
```math
X_{lmn} = \sum_{j_1=j_2=j_3=1}^{r_1, r_2, r_3} S_{j_1j_2j_3} (U_1)_{lj_1}(U_2)_{mj_2}(U_3)_{nj_3}.
```

We refer to this as the Tucker approximation problem.

"""

# ╔═╡ 52435495-a591-4d52-afc9-57e7670b6d7a
md"""
The pseudocode for Tucker decomposition algorithm:
```math
\begin{align}
&\texttt{Repeat:}\\
&~~~~\texttt{for} ~~k = l,\ldots,d\\
&~~~~~~~~\text{Compute the SVD}\\
&~~~~~~~~~~~~A(k) (U_d \otimes \ldots \otimes U_{k+1} \otimes U_{k-1} \otimes \ldots \otimes U_1) = \tilde{U}_k\Sigma_kV_k^T\\
&~~~~~~~~U_k = \tilde{U}_k(:,1:r_k)\\
&~~~~\texttt{end}
\end{align}
```
"""

# ╔═╡ 8489fec0-14eb-4016-a1aa-a7f26915f71d
function tucker_movefirst(X::AbstractArray{T, N}, Us, k::Int) where {N, T}
	Ak = X
	for i=1:N
		# move i-th dimension to the first
		if i!=1
			pm = collect(1:N)
			pm[1], pm[i] = pm[i], pm[1]
			Ak = permutedims(Ak, pm)
		end
		if i != k
			# multiply Uk on the i-th dimension
			remain = size(Ak)[2:end]
			Ak = Us[i]' * reshape(Ak, size(Ak, 1), :)
			Ak = reshape(Ak, size(Ak, 1), remain...)
		end
	end
	A_ = permutedims(Ak, (2:N..., 1))
	return permutedims(A_, (k, setdiff(1:N, k)...))
end

# ╔═╡ a9d1c805-699c-4cf2-942d-7a8f62dd3ffd
function tucker_project(X::AbstractArray{T, N}, Us; inverse=false) where {N, T}
	Ak = X
	for i=1:N
		# move i-th dimension to the first
		if i!=1
			pm = collect(1:N)
			pm[1], pm[i] = pm[i], pm[1]
			Ak = permutedims(Ak, pm)
		end
		remain = size(Ak)[2:end]
		Ak = (inverse ? Us[i] : Us[i]') * reshape(Ak, size(Ak, 1), :)
		Ak = reshape(Ak, size(Ak, 1), remain...)
	end
	return permutedims(Ak, (2:N..., 1))
end

# ╔═╡ ab719f60-edaf-418d-b1fa-2561232aa5b6
function tucker_decomp(X::AbstractArray{T,N}, rs::Vector{Int}; nrepeat::Int) where {T, N}
	# the first sweep, to generate U_k
	Us = [Matrix{T}(I, size(X, i), size(X, i)) for i=1:N]
	Ak = X
	for n=1:nrepeat
		for i=1:N
			Ak = tucker_movefirst(X, Us, i)
			ret = svd(reshape(Ak, size(Ak, 1), :))
			Us[i] = ret.U[:,1:rs[i]]
		end
		Ak = permutedims(Ak, (2:N..., 1))
		dist = norm(tucker_project(tucker_project(X, Us), Us; inverse=true) .- X)
		@info "The Frobenius norm distance is: $dist"
	end
	return tucker_project(X, Us), Us
end

# ╔═╡ 979dd7d1-efba-4701-be48-75764e5c19b7
X = randn(20, 10, 15);

# ╔═╡ a83dfc4c-84b1-437f-bf93-4fe984abe1bb
Cor, Us = tucker_decomp(X, [4, 5, 6]; nrepeat=10)

# ╔═╡ 9e6ab8c9-d9f5-42cc-b597-07c851a5fee3
md"Quiz: compare the size of storage before/after the tucker decomposition."

# ╔═╡ 09daec34-d618-4863-a80f-7362eee5de88
md"""
### CP decomposition
"""

# ╔═╡ ec1a731e-4b03-40ad-8297-3927a9847dd8
md"""
Given $X \in R^{n_1 \times n_2\times n_3}$ and an integer $r$, we consider the problem
```math
\min_X \|A - X\|
```
such that 
```math
X_{lmn} = \sum_{j=1}^{r}\lambda_j F_{lj} G_{mj} H_{nj}
```
where $F\in R^{n_1\times r}$, $G\in R^{n_2\times r}$, and $H\in R^{n_3\times r}$. This is an example of the CP approximation problem. We assume that the columns of $F$, $G$, and $H$ have unit 2-norm.
"""

# ╔═╡ 8f9fa210-b4dd-4d1a-9b52-917b29cd1ca4
md"""
```math
\begin{align}
&\texttt{Repeat:}\\
&~~~~\texttt{for}~~k= l:d\\ 
&~~~~~~~~\text{Minimize }\| A_{(k)} - \tilde{F}^{(k)} (F^{(d)} \odot \ldots\odot F^{(k+ l)} \odot F^{(k-1)} \odot \ldots \odot F^{(1)})\|_F\\
&~~~~~~~~~~~~\text{ with respect to }\tilde{F}(k).\\
&~~~~~~~~\texttt{for}~~j = l:r\\
&~~~~~~~~~~~~\lambda_j = \|\tilde{F}_{(k)}( :,j)\|\\
&~~~~~~~~~~~~F^{(k)}(:,j) = \tilde{F}_k ( :,j)/\lambda_j\\
&~~~~~~~~\texttt{end}\\
&~~~~\texttt{end}
\end{align}
```
"""

# ╔═╡ bea57d0a-3422-4c55-ad74-12b959608c41
md"""
# Tensor contraction
"""

# ╔═╡ f497c2b8-6504-4f0e-96ba-e20a842ce67c
md"""
The `einsum` notation.
* The `einsum` notation for matrix multiplication $C_{ik} := A_{ij}B_{jk}$ is `"ij,jk->ik"`.
* The `einsum` notation for element-wise multiplication is `i,i->i`.
* Guess, what are
    * `ii->`
    * `ii->i`
    * `i->ii`
    * `,,->`
    * `ijb,jkb->ikb`
    * `ij,ik,il->jkl`
"""

# ╔═╡ ea60d05d-1967-4726-a0f2-f67225b13edc
ein"ij, jk -> ik"([1 2; 3 4], [5 6; 7 8])

# ╔═╡ 0c0c0555-e2d5-47f1-877a-57a39f1b7b8b
md"""
## The backward rule of tensor contraction
"""

# ╔═╡ e3ba7d5a-d891-428f-934c-46652b336b9c
md"""
The backward rule for matrix multiplication is
* `C = ein"ij,jk->ik"(A, B)`
    * `̄A = ein"ik,jk->ij"(̄C, B)`
    * `̄B = ein"ik,jk->ij"(A, ̄C)`
* `v = ein"ii->i"(A)`
    * `̄A = ein"?"(̄v)`
"""

# ╔═╡ 3c5eec46-6482-4969-a3d7-3e9dc4429069
md"""
# Probability graph
"""

# ╔═╡ e5002708-2970-4792-b4d0-ee9763fad80e
md"""
| **Random variable**  | **Meaning**                     |
|        :---:         | :---                            |
|        A         | Recent trip to Asia             |
|        T         | Patient has tuberculosis        |
|        S         | Patient is a smoker             |
|        L         | Patient has lung cancer         |
|        B         | Patient has bronchitis          |
|        E         | Patient hast T and/or L |
|        X         | Chest X-Ray is positive         |
|        D         | Patient has dyspnoea            |
"""

# ╔═╡ a2df3466-432f-495c-8c07-89b0456c6bea
let
	r = 20
	W = 200
	vars = [
		("A", 0.0, 0.0), ("S", 0.75, 0.0),
		("T", 0.0, 0.3), ("L", 0.5, 0.3), ("B", 1.0, 0.3), 
		("E", 0.25, 0.6), ("X", 0.0, 0.9), ("D", 0.75, 0.9)]
	@drawsvg begin
		origin(200, 0)
		nodes = []
		for (t, x, y) in vars
			push!(nodes, node(circle, Point(x*W+0.15W, y*W+0.15W), r, :stroke))
		end
		for (k, node) in enumerate(nodes)
			LuxorGraphPlot.draw_vertex(node, stroke_color="black",
				fill_color="white", line_width=2, line_style="solid")
			LuxorGraphPlot.draw_text(node.loc, vars[k][1]; fontsize=14, color="black", fontface="")
		end
		for (i, j) in [(1, 3), (2, 4), (2, 5), (3, 6), (4, 6), (5, 8), (6, 7), (6, 8)]
			LuxorGraphPlot.draw_edge(nodes[i], nodes[j], color="black", line_width=2, line_style="solid", arrow=true)
		end
	end 600 W*1.3
end

# ╔═╡ 5c8a16ff-f53d-421f-a4b3-fc47d1504635
md"""
A probabilistic graphical model (PGM) illustrates the mathematical modeling of reasoning in the presence of uncertainty. Bayesian networks (above) and Markov random fields are popular types of PGMs. Consider the
Bayesian network shown in the figure above known as the *ASIA network*. It is a simplified example from the context of medical
diagnosis that describes the probabilistic relationships between different
random variables corresponding to possible diseases, symptoms, risk factors and
test results. It consists of a graph ``G = (V,\mathcal{E})`` and a
probability distribution ``P(V)`` where ``G`` is a directed acyclic graph,
``V`` is the set of variables and ``\mathcal{E}`` is the set of edges
connecting the variables. We assume all variables to be discrete (0 or 1). Each variable ``v \in V`` is quantified with a *conditional probability distribution* ``P(v \mid
pa(v))`` where ``pa(v)`` are the parents of ``v``. These conditional
probability distributions together with the graph ``G`` induce a *joint
probability distribution* over ``P(V)``, given by
```math
P(V) = \prod_{v\in V} P(v \mid pa(v)).
```
"""

# ╔═╡ 98c38f79-e5cb-4b94-9c42-689839471c10
md"""
## The tensor network
"""

# ╔═╡ 678d9e48-ca0e-4718-b7c0-ea406978e116
md"A tensor network in physics is also known as the **factor graph** in machine learning, and the **sum-product network** in mathematics."

# ╔═╡ 0540043f-f9a1-4aaa-a189-ad3ff97919a0
md"""
A tensor network is a multi-linear map from a collection of labelled tensors $\mathcal{T}$ to an output tensor.
It is formally defined as follows.

**Definition:**
    A tensor network is a multi-linear map specified by a triple of $\mathcal{N} = (\Lambda, \mathcal{T}, \boldsymbol{\sigma}_o)$,
    where $\Lambda$ is a set of symbols (or labels),
    $\mathcal{T} = \{T^{(1)}_{\boldsymbol{\sigma}_1}, T^{(2)}_{\boldsymbol{\sigma}_2}, \ldots, T^{(M)}_{\boldsymbol{\sigma}_M}\}$ is a set of tensors as the inputs,
    and $\boldsymbol{\sigma}_o$ is a string of symbols labelling the output tensor.
    Each $T^{(k)}_{\boldsymbol{\sigma_k}} \in \mathcal{T}$ is labelled by a string $\boldsymbol{\sigma}_k \in \Lambda^{r \left(T^{(k)} \right)}$, where $r \left(T^{(k)} \right)$ is the rank of $T^{(k)}$.
    The multi-linear map or the **contraction** on this triple is
```math
\begin{equation}
	O_{\boldsymbol{\sigma}_o} = \sum_{\Lambda \setminus \sigma_o} \prod_{k=1}^{M} T^{(k)}_{\boldsymbol{\sigma_k}},
\end{equation}
```
where the summation runs over all possible configurations over the set of symbols absent in the output tensor.
\end{definition}
For example, the matrix multiplication can be specified as a tensor network
```math
\begin{equation}
\mathcal{N}_{\rm matmul} = \left(\{i,j,k\}, \{A_{ij}, B_{jk}\}, ik\right),
\end{equation}
```
where $A_{ij}$ and $B_{jk}$ are input matrices (two-dimensional tensors), and $(i,k)$ are labels associated to the output.
The contraction is defined as $O_{ik} = \sum_j A_{ij}B_{jk}$, where the subscripts are for tensor indexing, and the tensor dimensions with the same label must have the same size.
The graphical representation of a tensor network is an open hypergraph that having open hyperedges, where an input tensor is mapped to a vertex and a label is mapped to a hyperedge that can connect an arbitrary number of vertices, while the labels appearing in the output tensor are mapped to open hyperedges.
"""

# ╔═╡ 13ce0667-ae64-4268-80bc-13c71bc96743
md"""
## The partition function
[https://uaicompetition.github.io/uci-2022/competition-entry/tasks/](https://uaicompetition.github.io/uci-2022/competition-entry/tasks/)
"""

# ╔═╡ 7bf73c91-fd84-4bca-be2a-4e5521d957fb
md"""
## The optimal contraction of a tensor network
"""

# ╔═╡ 95b6d81a-c6dd-4488-86ac-e1b9911b8b05
eincode = ein"at,ex,sb,sl,tle,ebd,a,s,t,l,b,e,x,d->"

# ╔═╡ e3ce6bdd-60ae-4ade-9956-7911d9787e3d
optimized_eincode = optimize_code(eincode, uniformsize(eincode, 2), TreeSA())

# ╔═╡ 20cd0336-9493-43df-9ca6-02645eac929f
contraction_complexity(optimized_eincode, uniformsize(optimized_eincode, 2))

# ╔═╡ 7083a4ed-77d9-48bb-a97c-034dad5fa287
function contract(ancillas...)
	# 0 -> NO
	# 1 -> YES
	AT = [0.98 0.02; 0.95 0.05]
	EX = [0.99 0.01; 0.02 0.98]
	SB = [0.96 0.04; 0.88 0.12]
	SL = [0.99 0.01; 0.92 0.08]
	TLE = zeros(2, 2, 2)
	TLE[1,:,:] .= [1.0 0.0; 0.0 1.0]
	TLE[2,:,:] .= [0.0 1.0; 0.0 1.0]
	EBD = zeros(2, 2, 2)
	EBD[1,:,:] .= [0.8 0.2; 0.3 0.7]
	EBD[2,:,:] .= [0.2 0.8; 0.05 0.95]
	return optimized_eincode(AT, EX, SB, SL, TLE, EBD, ancillas...)[]
end

# ╔═╡ 66db0b4f-f1b5-4174-9045-1e4af2fd1422
md"""
## The backward rule for factor graph contraction
"""

# ╔═╡ 72445647-b14d-4133-9980-d55ae6bb19ea
contract([0.0, 1.0], [1.0, 0.0], [1.0, 1.0], # A, S, T
		[0.0, 1.0], [1.0, 1.0], # L, B
		[1.0, 1.0], # E
		[1.0, 1.0], [1.0, 1.0] # X, D
		)

# ╔═╡ 2a9f6028-63a2-4719-affd-8327150c40ad
md"""
| **Random variable**  | **Meaning**                     |
|        :---:         | :---                            |
|        A         | Recent trip to Asia             |
|        T         | Patient has tuberculosis        |
|        S         | Patient is a smoker             |
|        L         | Patient has lung cancer         |
|        B         | Patient has bronchitis          |
|        E         | Patient hast T and/or L |
|        X         | Chest X-Ray is positive         |
|        D         | Patient has dyspnoea            |
"""

# ╔═╡ 336ee05e-94eb-4b7f-9b5b-4f86c9253bc4
md"""
# Homework
1. What is the einsum notation for outer product of two vectors?
2. What does the einsum notation `"jk,kl,lm,mj->"` stands for?
2. The tensor network `"abc,cde,efg,ghi,ijk,klm,mno->abdfhjlno"` is known as matrix product state in physics or tensor train in mathematics. Please
    1. Draw a diagramatic representation for it.
    2. If we contract it with another tensor network `"pbq,qdr,rfs,sht,tju,ulv,vnw->pbdfhjlnw"`, i.e., computing `abc,cde,efg,ghi,ijk,klm,mno,pbq,qdr,rfs,sht,tju,ulv,vnw->apow`. What is the optimal contraction order in the diagram, and estimate the contraction complexity (degree of freedoms have the same size $n$).
    3. Using `OMEinsum` (check the section "Probability graph") to obtain a contraction order and compare it with your answer.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Luxor = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
LuxorGraphPlot = "1f49bdf2-22a7-4bc4-978b-948dc219fbbc"
OMEinsum = "ebe7aa44-baf0-506c-a96f-8464559b3922"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Luxor = "~3.7.0"
LuxorGraphPlot = "~0.2.0"
OMEinsum = "~0.7.4"
PlutoUI = "~0.7.50"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "7819d7f5f54ce432adf36d516ed4607a2f0c4ad8"

[[deps.AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "16b6dbc4cf7caee4e1e75c49485ec67b667098a0"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.3.1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.AbstractTrees]]
git-tree-sha1 = "faa260e4cb5aba097a73fab382dd4b5819d8ec8c"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.4"

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

[[deps.Atomix]]
deps = ["UnsafeAtomics"]
git-tree-sha1 = "c06a868224ecba914baa6942988e2f2aade419be"
uuid = "a9b6321e-bd34-4604-b9c9-b65b8de01458"
version = "0.1.0"

[[deps.BFloat16s]]
deps = ["LinearAlgebra", "Printf", "Random", "Test"]
git-tree-sha1 = "dbf84058d0a8cbbadee18d25cf606934b22d7c66"
uuid = "ab4f0b2a-ad5b-11e8-123f-65d77653426b"
version = "0.4.2"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BatchedRoutines]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "441db9f0399bcfb4eeb8b891a6b03f7acc5dc731"
uuid = "a9ab73d0-e05c-5df1-8fde-d6a4645b8d8e"
version = "0.2.2"

[[deps.BetterExp]]
git-tree-sha1 = "dd3448f3d5b2664db7eceeec5f744535ce6e759b"
uuid = "7cffe744-45fd-4178-b173-cf893948b8b7"
version = "0.1.0"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CUDA]]
deps = ["AbstractFFTs", "Adapt", "BFloat16s", "CEnum", "CUDA_Driver_jll", "CUDA_Runtime_Discovery", "CUDA_Runtime_jll", "CompilerSupportLibraries_jll", "ExprTools", "GPUArrays", "GPUCompiler", "KernelAbstractions", "LLVM", "LazyArtifacts", "Libdl", "LinearAlgebra", "Logging", "Preferences", "Printf", "Random", "Random123", "RandomNumbers", "Reexport", "Requires", "SparseArrays", "SpecialFunctions", "UnsafeAtomicsLLVM"]
git-tree-sha1 = "8547829ee0da896ce48a24b8d2f4bf929cf3e45e"
uuid = "052768ef-5323-5732-b1bb-66c8b64840ba"
version = "4.1.4"

[[deps.CUDA_Driver_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "498f45593f6ddc0adff64a9310bb6710e851781b"
uuid = "4ee394cb-3365-5eb0-8335-949819d2adfc"
version = "0.5.0+1"

[[deps.CUDA_Runtime_Discovery]]
deps = ["Libdl"]
git-tree-sha1 = "bcc4a23cbbd99c8535a5318455dcf0f2546ec536"
uuid = "1af6417a-86b4-443c-805f-a4643ffb695f"
version = "0.2.2"

[[deps.CUDA_Runtime_jll]]
deps = ["Artifacts", "CUDA_Driver_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "TOML"]
git-tree-sha1 = "81eed046f28a0cdd0dc1f61d00a49061b7cc9433"
uuid = "76a88914-d11a-5bdc-97e0-2f5a05c973a2"
version = "0.5.0+2"

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

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "7a60c856b9fa189eb34f5f8a6f6b5529b7942957"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.6.1"

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

[[deps.ExprTools]]
git-tree-sha1 = "c1d06d129da9f55715c6c212866f5b1bddc5fa00"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.9"

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

[[deps.GPUArrays]]
deps = ["Adapt", "GPUArraysCore", "LLVM", "LinearAlgebra", "Printf", "Random", "Reexport", "Serialization", "Statistics"]
git-tree-sha1 = "9ade6983c3dbbd492cf5729f865fe030d1541463"
uuid = "0c68f7d7-f131-5f86-a1c3-88cf8149b2d7"
version = "8.6.6"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "1cd7f0af1aa58abc02ea1d872953a97359cb87fa"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.4"

[[deps.GPUCompiler]]
deps = ["ExprTools", "InteractiveUtils", "LLVM", "Libdl", "Logging", "Scratch", "TimerOutputs", "UUIDs"]
git-tree-sha1 = "237360a9f4c26f61d2151c65c34f887810c7bd7b"
uuid = "61eb1bfa-7361-4325-ad38-22787b887f55"
version = "0.19.1"

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

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "1cf1d7dcb4bc32d7b4a5add4232db3750c27ecb4"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.8.0"

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

[[deps.Inflate]]
git-tree-sha1 = "5cd07aab533df5170988219191dfad0519391428"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.3"

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

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

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

[[deps.KernelAbstractions]]
deps = ["Adapt", "Atomix", "InteractiveUtils", "LinearAlgebra", "MacroTools", "SnoopPrecompile", "SparseArrays", "StaticArrays", "UUIDs", "UnsafeAtomics", "UnsafeAtomicsLLVM"]
git-tree-sha1 = "976231af02176082fb266a9f96a59da51fcacf20"
uuid = "63c18a36-062a-441e-b654-da1e3ab1ce7c"
version = "0.9.2"

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

[[deps.LLVM]]
deps = ["CEnum", "LLVMExtra_jll", "Libdl", "Printf", "Unicode"]
git-tree-sha1 = "a8960cae30b42b66dd41808beb76490519f6f9e2"
uuid = "929cbde3-209d-540e-8aea-75f648917ca0"
version = "5.0.0"

[[deps.LLVMExtra_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "TOML"]
git-tree-sha1 = "09b7505cc0b1cee87e5d4a26eea61d2e1b0dcd35"
uuid = "dad2f222-ce93-54a1-a47d-0025e8a3acab"
version = "0.0.21+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

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

[[deps.Luxor]]
deps = ["Base64", "Cairo", "Colors", "Dates", "FFMPEG", "FileIO", "Juno", "LaTeXStrings", "Random", "Requires", "Rsvg", "SnoopPrecompile"]
git-tree-sha1 = "909a67c53fddd216d5e986d804b26b1e3c82d66d"
uuid = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
version = "3.7.0"

[[deps.LuxorGraphPlot]]
deps = ["Graphs", "LinearAlgebra", "Luxor"]
git-tree-sha1 = "25b388309ae6733813055fcc836d5cdd5a14b5b7"
uuid = "1f49bdf2-22a7-4bc4-978b-948dc219fbbc"
version = "0.2.0"

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

[[deps.Media]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "75a54abd10709c01f1b86b84ec225d26e840ed58"
uuid = "e89f7d12-3494-54d1-8411-f7d8b9ae1f27"
version = "0.5.0"

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

[[deps.OMEinsum]]
deps = ["AbstractTrees", "BatchedRoutines", "CUDA", "ChainRulesCore", "Combinatorics", "LinearAlgebra", "MacroTools", "OMEinsumContractionOrders", "Requires", "Test", "TupleTools"]
git-tree-sha1 = "5cf996994702927752c533f724dca098eb727a0a"
uuid = "ebe7aa44-baf0-506c-a96f-8464559b3922"
version = "0.7.4"

[[deps.OMEinsumContractionOrders]]
deps = ["AbstractTrees", "BetterExp", "JSON", "Requires", "SparseArrays", "Suppressor"]
git-tree-sha1 = "0d4fbd4f2d368bf104671187dcd716a2fac533e0"
uuid = "6f22d1fd-8eed-4bb7-9776-e7d684900715"
version = "0.8.1"

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
git-tree-sha1 = "d321bf2de576bf25ec4d3e4360faca399afca282"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.0"

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
git-tree-sha1 = "478ac6c952fddd4399e71d4779797c538d0ff2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.8"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

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

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Random123]]
deps = ["Random", "RandomNumbers"]
git-tree-sha1 = "7a1a306b72cfa60634f03a911405f4e64d1b718b"
uuid = "74087812-796a-5b5d-8853-05524746bad3"
version = "1.6.0"

[[deps.RandomNumbers]]
deps = ["Random", "Requires"]
git-tree-sha1 = "043da614cc7e95c703498a491e2c21f58a2b8111"
uuid = "e6cf234a-135c-5ec9-84dd-332b85af5143"
version = "1.5.3"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

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
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

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

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "ef28127915f4229c971eb43f3fc075dd3fe91880"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.2.0"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "63e84b7fdf5021026d0f17f76af7c57772313d99"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.21"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.Suppressor]]
git-tree-sha1 = "c6ed566db2fe3931292865b966d6d140b7ef32a9"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.1"

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

[[deps.TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "f2fd3f288dfc6f507b0c3a2eb3bac009251e548b"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.22"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.TupleTools]]
git-tree-sha1 = "3c712976c47707ff893cf6ba4354aa14db1d8938"
uuid = "9d95972d-f1c8-5527-a6e0-b4b365fa01f6"
version = "1.3.0"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnsafeAtomics]]
git-tree-sha1 = "6331ac3440856ea1988316b46045303bef658278"
uuid = "013be700-e6cd-48c3-b4a1-df204f14c38f"
version = "0.2.1"

[[deps.UnsafeAtomicsLLVM]]
deps = ["LLVM", "UnsafeAtomics"]
git-tree-sha1 = "ea37e6066bf194ab78f4e747f5245261f17a7175"
uuid = "d80eeb9a-aca5-4d75-85e5-170c8b632249"
version = "0.1.2"

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
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

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
"""

# ╔═╡ Cell order:
# ╠═a3d30219-6fbe-46a3-b304-4963eaf5ecf1
# ╠═dffe3a4c-1043-4320-bf10-f3c023459c31
# ╠═b14bc8c7-8a5d-4518-8561-2328fa61ce86
# ╟─efb30222-db9c-11ed-168b-1f3cb30fc22c
# ╟─bd65ae8a-580e-4684-a902-8d7643268831
# ╟─fc2d50c3-9f25-410c-807e-6fb3bc4c4956
# ╟─d1490cf0-1dc0-466e-bec8-a17420713cf2
# ╟─84a58161-9986-497b-b13b-0cc9c2127b09
# ╟─35e527f3-2285-4ecb-83ec-2e69678f872c
# ╟─fc9711e8-01d5-4175-97ba-c9169c659eb7
# ╟─6f36475d-e36d-4bd3-9b95-a271b48e6e54
# ╟─b625f965-57eb-43f5-bbdf-aae9e33ed846
# ╟─83ca9284-10c6-448e-8e79-bacbf3868c5d
# ╟─05fe25bb-8f49-413b-815d-71071d7dd48d
# ╟─1d9b7f81-260c-402f-9c83-4580d20def16
# ╟─05eeacb2-b459-4545-9fbb-a01ca148538e
# ╟─27ce5bd7-689f-4e83-a817-89ef45dc7ef4
# ╟─52435495-a591-4d52-afc9-57e7670b6d7a
# ╠═759ab9af-b11e-491e-b646-0497ca33f7ae
# ╠═ab719f60-edaf-418d-b1fa-2561232aa5b6
# ╠═8489fec0-14eb-4016-a1aa-a7f26915f71d
# ╠═a9d1c805-699c-4cf2-942d-7a8f62dd3ffd
# ╠═979dd7d1-efba-4701-be48-75764e5c19b7
# ╠═a83dfc4c-84b1-437f-bf93-4fe984abe1bb
# ╟─9e6ab8c9-d9f5-42cc-b597-07c851a5fee3
# ╟─09daec34-d618-4863-a80f-7362eee5de88
# ╟─ec1a731e-4b03-40ad-8297-3927a9847dd8
# ╟─8f9fa210-b4dd-4d1a-9b52-917b29cd1ca4
# ╟─bea57d0a-3422-4c55-ad74-12b959608c41
# ╟─f497c2b8-6504-4f0e-96ba-e20a842ce67c
# ╠═f699d333-bafd-4ad6-9a9c-8e08c5230891
# ╠═ea60d05d-1967-4726-a0f2-f67225b13edc
# ╟─0c0c0555-e2d5-47f1-877a-57a39f1b7b8b
# ╟─e3ba7d5a-d891-428f-934c-46652b336b9c
# ╟─3c5eec46-6482-4969-a3d7-3e9dc4429069
# ╟─e5002708-2970-4792-b4d0-ee9763fad80e
# ╟─a2df3466-432f-495c-8c07-89b0456c6bea
# ╟─5c8a16ff-f53d-421f-a4b3-fc47d1504635
# ╟─98c38f79-e5cb-4b94-9c42-689839471c10
# ╟─678d9e48-ca0e-4718-b7c0-ea406978e116
# ╟─0540043f-f9a1-4aaa-a189-ad3ff97919a0
# ╟─13ce0667-ae64-4268-80bc-13c71bc96743
# ╟─7bf73c91-fd84-4bca-be2a-4e5521d957fb
# ╠═95b6d81a-c6dd-4488-86ac-e1b9911b8b05
# ╠═e3ce6bdd-60ae-4ade-9956-7911d9787e3d
# ╠═20cd0336-9493-43df-9ca6-02645eac929f
# ╠═7083a4ed-77d9-48bb-a97c-034dad5fa287
# ╟─66db0b4f-f1b5-4174-9045-1e4af2fd1422
# ╠═72445647-b14d-4133-9980-d55ae6bb19ea
# ╟─2a9f6028-63a2-4719-affd-8327150c40ad
# ╟─336ee05e-94eb-4b7f-9b5b-4f86c9253bc4
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
