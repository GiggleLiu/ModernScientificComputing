# Assignments
1. Get the relative condition number of division operation $a/b$.

2. Classify each of the following matrices as well-conditioned or ill-conditioned:
```math
(a). ~~\left(\begin{matrix}10^{10} & 0\\ 0 & 10^{-10}\end{matrix}\right)
```
```math
(b). ~~\left(\begin{matrix}10^{10} & 0\\ 0 & 10^{10}\end{matrix}\right)
```
```math
(c). ~~\left(\begin{matrix}10^{-10} & 0\\ 0 & 10^{-10}\end{matrix}\right)
```
```math
(d). ~~\left(\begin{matrix}1 & 2\\ 2 & 4\end{matrix}\right)
```
3. Implement the Gauss-Jordan elimination algorithm to compute matrix inverse. In the following example, we first create an augmented matrix $(A | I)$. Then we apply the Gauss-Jordan elimination matrices on the left. The final result is stored in the augmented matrix as $(I, A^{-1})$.
![](https://user-images.githubusercontent.com/6257240/222182865-c2a1aa28-946a-4acb-8df8-f5d7da93c3ee.png)

Task: Please implement a function `gauss_jordan` that computes the inverse for a matrix at any size. Please also include the following test in your submission.
```julia
@testset "Gauss Jordan" begin
	n = 10
	A = randn(n, n)
	@test gauss_jordan(A) * A ≈ Matrix{Float64}(I, n, n)
end