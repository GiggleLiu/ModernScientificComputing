Back-Propagation

we have a data $x$

go through operations $f_1, f_2, f_3 \rightarrow L = f_3(f_2(f_1(x)))$

the gradient for $x$ is $\frac{\partial L}{\partial x} = \frac{\partial L}{\partial y_2}\cdot \frac{\partial y_2}{\partial y_1}\cdot \frac{\partial y_1}{\partial x}$

so we just remember the input and output of every function, for $y=f_i(x)$, we know $f_i'= g(x, y)$.

when $x\rightarrow \vec x$, $y\rightarrow \vec y$,

$\frac{\partial L}{\partial x} = \sum\limits_{y_2}\left(\frac{\partial L}{\partial y_2}\cdot\sum\limits_{\partial y_1}\left(\frac{\partial y_2}{\partial y_1}\cdot \frac{\partial y_1}{\partial x}\right)\right)$

Notice $\frac{\partial y_2}{\partial y_1}$ is a matrix, called Jacobian matrix.

e.g. y = Wx+b



Back-Propagation for RBM

$$E(x) = x^T\mathbf Wh + b^Th +x^Ta$$

$\frac{\partial E}{\partial W_{ij}}=x_ih_j$

