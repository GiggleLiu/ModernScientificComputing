# 1

Notice that $||Ax-b||_2 = \sqrt{(Ax-b)^T(Ax-b)}$ 

$$
\frac{\partial L}{\partial x}
\\= \frac{\partial L}{\partial ||Ax-b||_2}\,\frac{\partial ||Ax-b||_2}{\partial Ax-b}\,\frac{\partial (Ax-b)}{\partial x} 
\\= 1 \times \frac{1}{2||Ax-b||_2}\times 2(Ax-b)^T \times A
\\= \frac{(Ax-b)^TA}{||Ax-b||_2}
$$

# 2

The video tells the condition when the compressed sensing can work or not.  

1. The first condition is incoherence. The condition is constraining the measurement matrix $C$ is incoherent with respect to $\Psi$, the basis. Or in other words, $C$ cannot be too parallel to $\Psi$. Sampling should be random instead of focusing on some columns of $\Psi$. 

2. Denoting the sparsity of the signal after Fourier transforamtion by $K$, and number of measurements by $P$, there should be constraints as,
   
   $$
   P \propto O(K\log(\frac{n}{K}))
   $$

Finally it should be noted that though the compressed sensing seems to reduce the space for storing pictures or something else, solving the optimization problem stated in the class for $x$ is in no way inexpensive. So compressed sensing may be used when measuring full resolution of the image is **really really expensive** or using it can **literally save lives** as the example of MRI of infants.
