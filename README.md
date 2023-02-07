# Modern Scientific Computing (AMAT 5315)

(Work in progress!!!)

# *PART 1: Computing*
### Week 1: Understanding our computing devices
* [Lecture notes](#)
* [Pluto notebook](notebooks/1.understanding-our-computing-devices.jl) [[pdf](notebooks/1.understanding-our-computing-devices.pdf)]

### Week 2: Get your computer ready for programming (Hands on)

### Week 3: The Julia programming language

# *PART 2: Mathematical modeling*
This part does not contain any lecture note.
Please check the following book as a reference.
> Heath M T. Scientific computing: an introductory survey, revised second edition[M]. Society for Industrial and Applied Mathematics, 2018.

### Week 4: Systems of linear equations

### Week 5: Eigenvalue problems and sparse matrices

### Week 6: Nonlinear equations

### Week 7: Optimization

### Week 8: Fast fourier transform

### Week 9: Random numbers and stochastic simulation

# *PART 3: Scientific applications*
### Week 10: Probabilistic modeling

### Week 11: Sparsity detection

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
