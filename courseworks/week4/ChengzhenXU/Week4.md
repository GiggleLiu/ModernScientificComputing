
# 1. Review
Suppose that you are computing the QR factorization of the matrix
$$
A = \left(\begin{matrix}
1 & 1 & 1\\
1 & 2 & 4\\
1 & 3 & 9\\
1 & 4 & 16
\end{matrix}\right)
$$
by Householder transformations.

* Problems:
    1. How many Householder transformations are required?
    2. What does the first column of A become as a result of applying the first Householder transformation?
    3. What does the first column of A become as a result of applying the second Householder transformation?
    4. How many Givens rotations would be required to computing the QR factoriazation of A?
--------

Answer:

1. 4
2.  $[2,0,0,0]^T$
 Solution:
 $x=[1,1,1,1]^{T}$,$||x||_{2}=2$,$u=\frac{x-2e_{1}}{||x-2e_{1}||}=\frac{[-1,1,1,1]^{T}}{2}$
 $H=I-2uu^{T}=[1/2,1/2,1/2,1/2;1/2,1/2,-1/2,-1/2;1/2,-1/2,1/2,-1/2;1/2,-1/2,-1/2,1/2]$
 $Hx=[2,0,0,0]$
 
 3. no change: $[2,0,0,0]^T$
4. 6 
(1,1,1,1) - 4 -> x3 rotations
3 -> x2 rotations
2 -> x1 rotations

 

--------


# 2. Coding
Computing the QR decomposition of a symmetric triangular matrix with Givens rotation. Try to minimize the computing time and estimate the number of FLOPS.

For example, if the input matrix size is $T \in \mathbb{R}^{5\times 5}$
$$
T = \left(\begin{matrix}
t_{11} & t_{12} & 0 & 0 & 0\\
t_{21} & t_{22} & t_{23} & 0 & 0\\
0 & t_{32} & t_{33} & t_{34} & 0\\
0 & 0 & t_{43} & t_{44} & t_{45}\\
0 & 0 & 0 & t_{54} & t_{55}
\end{matrix}\right)
$$
where $t_{ij} = t_{ji}$.

In your algorithm, you should first apply Givens rotation on row 1 and 2.
$$
G(t_{11}, t_{21}) T = \left(\begin{matrix}
t_{11}' & t_{12}' & t_{13}' & 0 & 0\\
0 & t_{22}' & t_{23}' & 0 & 0\\
0 & t_{32} & t_{33} & t_{34} & 0\\
0 & 0 & t_{43} & t_{44} & t_{45}\\
0 & 0 & 0 & t_{54} & t_{55}
\end{matrix}\right)
$$
Then apply $G(t_{22}', t_{32})$ et al.

```julia
julia> using LinearAlgebra

julia> function Givens_rotation(A)
           n = size(A, 1)
           Q = Matrix{eltype(A)}(I, n, n)
           R = copy(A)
           @inbounds for i = 1:n - 1
               t_ii = R[i, i]
               t_ji = R[i + 1, i]

julia> function Givens_rotation(A)
           n = size(A, 1)
           Q = Matrix{eltype(A)}(I, n, n)
           R = copy(A)
           @inbounds for i = 1:n - 1
               t_ii = R[i, i]
               t_ji = R[i + 1, i]

               r = sqrt(t_ii^2 + t_ji^2)
               c = t_ii / r
               s = t_ji / r


               @inbounds for j in i: min(i+2, n)
                   A_1 = R[i, j]
                   A_2 = R[i + 1, j]
                   R[i, j] = c * A_1 + s * A_2
                   R[i + 1, j] = - s * A_1 + c * A_2
               end
               
               @inbounds for j in 1:min(i+2, n)
                   Q_1 = Q[j, i]
                   Q_2 = Q[j, i + 1]
                   Q[j, i] = c * Q_1 + s * Q_2
                   Q[j, i + 1] = - s * Q_1 + c * Q_2
               end
           end

           return Q, R
       end
Givens_rotation (generic function with 1 method)

```

```julia
julia> using Random

julia> function rand_A(n)
           A = Matrix(Tridiagonal(rand(n, n)))
           return A
       end
rand_A (generic function with 1 method)

     
```

```julia
julia> A = rand_A(10)
10×10 Matrix{Float64}:
 0.459031  0.458173  0.0       0.0        0.0       0.0       0.0       0.0       0.0       0.0
 0.79199   0.053323  0.185336  0.0        0.0       0.0       0.0       0.0       0.0       0.0
 0.0       0.625427  0.335567  0.62635    0.0       0.0       0.0       0.0       0.0       0.0
 0.0       0.0       0.491207  0.287621   0.913701  0.0       0.0       0.0       0.0       0.0
 0.0       0.0       0.0       0.0403055  0.202875  0.55084   0.0       0.0       0.0       0.0
 0.0       0.0       0.0       0.0        0.449293  0.270039  0.692233  0.0       0.0       0.0
 0.0       0.0       0.0       0.0        0.0       0.352802  0.957748  0.767389  0.0       0.0
 0.0       0.0       0.0       0.0        0.0       0.0       0.527814  0.114603  0.391994  0.0
 0.0       0.0       0.0       0.0        0.0       0.0       0.0       0.56045   0.30838   0.467869
 0.0       0.0       0.0       0.0        0.0       0.0       0.0       0.0       0.300491  0.319353

```

```julia

julia> Q, R = Givens_rotation(A)
([0.5014533548632641 0.44022820651696015 … 0.04224009491271324 -0.03127174178142073; 0.8651846813810201 -0.255152357426159 … -0.024481983742375833 0.01812482371241293; … ; 0.0 0.0 … 0.20342198757063149 -0.1506000372659568; 0.0 0.0 … 0.5950159970357025 0.8037138565880326], [0.9154002337649394 0.2758865986315152 … 0.0 0.0; 0.0 0.7265066099034211 … 0.0 0.0; … ; 0.0 0.0 … 0.5050130245218265 0.2851948376945359; 0.0 0.0 … 0.0 0.18620701324061456])

```

```julia
julia> Q
10×10 Matrix{Float64}:
 0.501453   0.440228  -0.338641  -0.641512   0.0942155   0.0892877  -0.0934244  -0.0137498    0.0422401  -0.0312717
 0.865185  -0.255152   0.196273   0.371815  -0.0546065  -0.0517504   0.0541479   0.00796926  -0.024482    0.0181248
 0.0        0.86087    0.231346   0.438256  -0.0643643  -0.0609978   0.0638239   0.00939332  -0.0288568   0.0213636
 0.0        0.0        0.890662  -0.439682   0.0645738   0.0611964  -0.0640316  -0.00942389   0.0289507  -0.0214332
 0.0        0.0        0.0        0.254611   0.539425    0.511212   -0.534896   -0.0787236    0.241843   -0.179045
 0.0        0.0        0.0        0.0        0.829969   -0.355286    0.371746    0.054712    -0.168078    0.124434
 0.0        0.0        0.0        0.0        0.0         0.770921    0.55061     0.0810364   -0.248948    0.184304
 0.0        0.0        0.0        0.0        0.0         0.0         0.502679   -0.2188       0.672166   -0.497627
 0.0        0.0        0.0        0.0        0.0         0.0         0.0         0.967439     0.203422   -0.1506
 0.0        0.0        0.0        0.0        0.0         0.0         0.0         0.0          0.595016    0.803714

```

```julia

julia> using Test

julia> @testset "Givens Rotation" begin
               for i in 1:100
                       n = rand(1:100)
                       A = rand_A(n)
                       Q, R = Givens_rotation(A)
                       @test Q * R ≈ A
               end
       end
Test Summary:   | Pass  Total  Time
Givens Rotation |  100    100  0.0s
Test.DefaultTestSet("Givens Rotation", Any[], 100, false, false, true, 1.684340332803973e9, 1.684340332819115e9)
```
Credits to Xuanzhao Gao