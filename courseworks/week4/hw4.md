# 1. Review

Q1

3 Householder transformations are required

 Q2

 $v=[1,1,1,1]$

$|| v || = 2$

$u=[1;1;1;1]-2\times[1;0;0;0]=[-1;1;1;1] $

$u = \frac{u}{||u||}=\frac{u}{2}$

$H1 = I - 2\times u \times u^T$

$H1 \cdot v = [2;0;0;0]$

Q3

The second householder transfomation only affect the element below the diagnol, so it should still be $[2;0;0;0]$

Q4

6 Givens transformations are required.

# 2. Coding

I write the code based on the version as shown in the class. The major change is,

1. Givens rotation do not start from the last row,but the first and second row, since elements  in lower suddiaganol is zero

2. Givens rotation only acts on the first three columns instead of all columns,since elements in upper subdiagnol is zero

While the modification of H in each iteration is not changed.

The FLOPS can be computed as followed,

$compute_A = 3 \times 6 \times n \approx 18n$

$compute_H \approx \sum_{k=1}^{n} 6\times k^2 = (2n+1)(n+1)n  = 2n^3+3n^2 + n$

$FLOPS = compute_A + compute_H \approx 2n^3+ 3n^2 + 19n$
