1. Get the relative condition number of division operation $a/b$.

$$
\begin{aligned}
f(x) &=a/x\\
\delta f &= [f(x+\delta x)-f(x)]\\
& =\frac{a}{x+\delta x}-\frac{a}{x}\\
& = -\frac{a\delta x }{(x+\delta x)x}\\
cond(x) &=\underset{\delta \rightarrow 0}{lim}\underset{||\delta x||\leq\delta}{sup}(\frac{||\frac{a\delta x }{(x+\delta x)x}||}{||\frac{a}{x}||}/\frac{||\delta x||}{||x||})\\
&= 1

\end{aligned}

$$



2. Classify each of the following matrices as well-conditioned or ill-conditioned:
$$
(a). ~~\left(\begin{matrix}10^{10} & 0\\ 0 & 10^{-10}\end{matrix}\right)
$$
$$
A=~~\left(\begin{matrix}10^{10} & 0\\ 0 & 10^{-10}\end{matrix}\right)\\
~~\\
A^{-1}=~~\left(\begin{matrix}10^{-10} & 0\\ 0 & 10^{10}\end{matrix}\right)\\
~~\\
||A||=\underset{x\neq0}{\max}\frac{||\left(\begin{matrix}10^{10} & 0\\ 0 & 10^{-10}\end{matrix}\right)\left(\begin{matrix} x_{1} \\ x_{2}\end{matrix}\right)||}{||\left(\begin{matrix} x_{1} \\ x_{2}\end{matrix}\right)||}
~~\\
cond_{1}(A)=10^{10}*10^{10}>>1
$$
As a result, A here is ill-conditioned.



$$
(b). ~~\left(\begin{matrix}10^{10} & 0\\ 0 & 10^{10}\end{matrix}\right)
$$

$$
B=~~\left(\begin{matrix}10^{10} & 0\\ 0 & 10^{10}\end{matrix}\right)\\
~~\\
B^{-1}= ~~\left(\begin{matrix}10^{-10} & 0\\ 0 & 10^{-10}\end{matrix}\right)\\
~~\\
cond_{1}(B)=||B||_{1}\cdot||B^{-1}||_{1}=10^{10}\cdot 10^{-10}=1

$$
As a result, B here is well-conditioned.

$$
(c). ~~\left(\begin{matrix}10^{-10} & 0\\ 0 & 10^{-10}\end{matrix}\right)
$$
$$
C=~~\left(\begin{matrix}10^{-10} & 0\\ 0 & 10^{-10}\end{matrix}\right)
$$
The same reason for the condition state of B, C is well-conditioned as well.
$$
(d). ~~\left(\begin{matrix}1 & 2\\ 2 & 4\end{matrix}\right)
$$


$$
D= ~~\left(\begin{matrix}1 & 2\\ 2 & 4\end{matrix}\right)
$$
D is singular, so its condition number is infinite. So, it is ill-conditioned.


3. Implement the Gauss-Jordan elimination algorithm to compute matrix inverse. In the following example, we first create an augmented matrix $(A | I)$. Then we apply the Gauss-Jordan elimination matrices on the left. The final result is stored in the augmented matrix as $(I, A^{-1})$.
![](https://user-images.githubusercontent.com/6257240/222182865-c2a1aa28-946a-4acb-8df8-f5d7da93c3ee.png)

Task: Please implement a function `gauss_jordan` that computes the inverse for a matrix at any size. Please also include the following test in your submission.
```julia
@testset "Gauss Jordan" begin
	n = 10
	A = randn(n, n)
	@test gauss_jordan(A) * A ≈ Matrix{Float64}(I, n, n)
end
```

code: 

```julia
julia> using LinearAlgebra

julia> using BenchmarkTools

julia> function Gauss_Jordan(M::AbstractMatrix{T}) where T <: Number
           m,n = size(M)
           @assert m == n
           MI = hcat(M,Matrix{eltype(M)}(I,m,m))
           return _Gauss_Jordan_helper!(MI)
       end
Gauss_Jordan (generic function with 1 method)

julia> function _Gauss_Jordan_helper!(MI_partial::AbstractMatrix{T}) where T <: Number
           m,n = size(MI_partial)
           fct = 0.0
           if n == m
               return MI_partial
           else
               cur_idx = 2 * m - n + 1
               fct = MI_partial[cur_idx,1]

               @inbounds for j in 1:n
                   MI_partial[cur_idx,j] /= fct
               end

               @inbounds for i in 1:m
                   if i != cur_idx
                       fct = MI_partial[i,1]
                       @inbounds for j in 1:n
                           MI_partial[i,j] -= fct * MI_partial[cur_idx,j]
                       end
                   end
               end
               return _Gauss_Jordan_helper!(view(MI_partial,:,2:n))
           end

       end
_Gauss_Jordan_helper! (generic function with 1 method)

julia> using Test

julia> @testset "Gauss Jordan" begin
               n = 10
               T = randn(n, n)
               @test Gauss_Jordan(T) * T ≈ Matrix{Float64}(I, n, n)
       end
Test Summary: | Pass  Total  Time
Gauss Jordan  |    1      1  0.7s
Test.DefaultTestSet("Gauss Jordan", Any[], 1, false, false, true, 1.684339958479303e9, 1.684339959164809e9)
```



Credits to  Yusheng Zhao

