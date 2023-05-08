# Modern Scientific Computing (AMAT 5315)

(Work in progress!!!)

# *PART 1: Computing*
### Week 1: Understanding our computing devices
* [Lecture notes](https://giggleliu.github.io/ModernScientificComputing/msc/1.devices/)
* Pluto notebook [[html](https://giggleliu.github.io/ModernScientificComputing/notebooks/1.understanding-our-computing-devices/), [pdf](notebooks/1.understanding-our-computing-devices.pdf), [source](notebooks/1.understanding-our-computing-devices.jl)]

### Week 2: Linux and Git (Hands on)
* [Lecture notes](https://giggleliu.github.io/ModernScientificComputing/msc/2.1.opensource/)
* [Cheat sheet](https://giggleliu.github.io/ModernScientificComputing/msc/2.2.cheatsheets/)

### Week 3: The Julia programming language
* We use [arXiv:1209.5145](https://arxiv.org/abs/1209.5145) as the reference.
* Pluto notebook [[html](https://giggleliu.github.io/ModernScientificComputing/notebooks/3.julia/), [pdf](notebooks/3.julia.pdf), [source](notebooks/3.julia.jl)]

# *PART 2: Mathematical modeling*
This part does not contain any lecture note.
Please check the following book as a reference.
> Heath M T. Scientific computing: an introductory survey, revised second edition[M]. Society for Industrial and Applied Mathematics, 2018.

### Week 4: Systems of linear equations
* Pluto notebook [[html](https://giggleliu.github.io/ModernScientificComputing/notebooks/4.linearequation/), [pdf](notebooks/4.linearequation.pdf), [source](notebooks/4.linearequation.jl)]

### Week 5: Linear least square problem and QR decomposition
* Pluto notebook [[html](https://giggleliu.github.io/ModernScientificComputing/notebooks/5.linear-least-square/), [pdf](notebooks/5.linear-least-square.pdf), [source](notebooks/5.linear-least-square.jl)]

### Week 6: Eigenvalue problems and sparse matrices
* Pluto notebook [[html](https://giggleliu.github.io/ModernScientificComputing/notebooks/6.sparse/), [pdf](notebooks/6.sparse.pdf), [source](notebooks/6.sparse.jl)]

### Week 7: Fast Fourier transform
* Pluto notebook [[html](https://giggleliu.github.io/ModernScientificComputing/notebooks/7.fft/), [pdf](notebooks/7.fft.pdf), [source](notebooks/7.fft.jl)]

### Week 8: Nonlinear equations and optimization
* Pluto notebook [[html](https://giggleliu.github.io/ModernScientificComputing/notebooks/8.optimization/), [pdf](notebooks/8.optimization.pdf), [source](notebooks/8.optimization.jl)]

### Week 9: Automatic differentiation
* Pluto notebook [[html](https://giggleliu.github.io/ModernScientificComputing/notebooks/9.autodiff/), [pdf](notebooks/9.autodiff.pdf), [source](notebooks/9.autodiff.jl)]

# *PART 3: Scientific applications*
### Week 10: Probabilistic modeling
* Pluto notebook [[html](https://giggleliu.github.io/ModernScientificComputing/notebooks/10.inference/), [pdf](notebooks/10.inference.pdf), [source](notebooks/10.inference.jl)]

### Week 11: Sparsity detection
* Pluto notebook [[html](https://giggleliu.github.io/ModernScientificComputing/notebooks/11.data-sparsity/), [pdf](notebooks/11.data-sparsity.pdf), [source](notebooks/11.data-sparsity.jl)]

### Week 12: Computational hard problems

### Week 13: Final exam

# Tips

1. How to open a Pluto notebook
### How to play a notebook?
1. Clone this Github repo to your local host.
```bash
git clone https://github.com/GiggleLiu/ModernScientificComputing.git
```
2. Install Pluto in Julia with `using Pkg; Pkg.add("Pluto")` and open it in a Julia REPL with
```julia
julia> using Pluto; Pluto.run(notebook="path/to/notebook.jl")
```

where the `"path/to/notebook.jl"` should be replaced by the path to the file under the `notebooks` folder.

### Controls

* Use <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>P</kbd> to toggle the presentation mode.
* Use <kbd>Ctrl</kbd> + <kbd>→</kbd> / <kbd>←</kbd> to play the previous/next slide.
