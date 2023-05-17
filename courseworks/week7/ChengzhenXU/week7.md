**Chat-gpt:**
- Unit-desk embedding:
A unit-disk embedding of a graph is a way of representing a graph in the plane such that each vertex is mapped to a point, and each edge is mapped to a curve connecting its corresponding vertices, such that the curves do not intersect and each vertex is contained within a unit disk centered at its corresponding point. In other words, a unit-disk embedding of a graph is a planar embedding in which the vertices are represented by non-overlapping unit disks. This type of embedding is commonly used in wireless network design and other applications where nodes have limited communication ranges. The goal is to find an embedding that minimizes the number of overlaps between disks while still maintaining connectivity between nodes.

- How to show a graph has a unit-disk embedding?
To show that a graph has a unit-disk embedding, it is necessary to construct a planar embedding of the graph in which each vertex is represented by a non-overlapping unit disk. One common approach is to use the Delaunay triangulation to construct a planar embedding of the graph and use the dual graph's vertex positions as the points to represent the vertices of the original graph. Then, arcs can be used to connect adjacent vertices in a way that satisfies the conditions of a unit-disk embedding.
The construction of a unit-disk embedding can be a challenging task, and it may not always be possible to find such an embedding for a given graph. However, there are several algorithms and techniques that can be used to find or approximate unit-disk embeddings for different types of graphs. One common approach is to use force-directed methods, which simulate the physical forces between the vertices and disks to find a layout that minimizes the overlaps between disks. Other approaches involve using linear programming or geometric algorithms to find an optimal or near-optimal unit-disk embedding for a given graph.


**Task**
Show the following graph has a unit-disk embedding.
```
V = 1, 2, ..., 10
E = [(1, 2), (1, 3),
	(2, 3), (2, 4), (2, 5), (2, 6),
	(3, 5), (3, 6), (3, 7),
	(4, 5), (4, 8),
	(5, 6), (5, 8), (5, 9),
	(6, 7), (6, 8), (6, 9),
	(7,9), (8, 9), (8, 10), (9, 10)]
```

```julia
julia> using LinearAlgebra

julia> using Plots

julia> using ForwardDiff

julia> N = 10
10

julia> E = [(1, 2), (1, 3),
               (2, 3), (2, 4), (2, 5), (2, 6),
               (3, 5), (3, 6), (3, 7),
               (4, 5), (4, 8),
               (5, 6), (5, 8), (5, 9),
               (6, 7), (6, 8), (6, 9),
               (7,9), (8, 9), (8, 10), (9, 10)]
21-element Vector{Tuple{Int64, Int64}}:
 (1, 2)
 (1, 3)
 (2, 3)
 (2, 4)
 (2, 5)
 (2, 6)
 (3, 5)
 (3, 6)
 (3, 7)
 ⋮
 (5, 9)
 (6, 7)
 (6, 8)
 (6, 9)
 (7, 9)
 (8, 9)
 (8, 10)
 (9, 10)
```
Distance Function: 
$$
distance=\sqrt{(x_{i}-x_{j})^{2}-(y_{i}-y_{j})^{2}}
$$

```julia
julia> function distance(x, i, j)
               return sqrt((x[2 * i - 1] - x[2 * j - 1])^2 + (x[2 * i] - x[2 * j])^2)
       end
distance (generic function with 2 methods)

```

Function to test whether it is a unit-disk or not:
L==0: unit-disk
L!=0: not unit-disk
```julia
julia> function is_unit_disk(x::AbstractArray)
               E = [(1, 2), (1, 3), (2, 3), (2, 4), (2, 5), (2, 6), (3, 5), (3, 6), (3, 7),(4, 5), (4, 8), (5, 6), (5, 8), (5, 9), (6, 7), (6, 8), (6, 9), (7,9), (8, 9), (8, 10), (9, 10)]

               Loss = 0

               for i in 1:10
                       for j in i + 1:10
                               if (i, j) in E
                                       d_ij = distance(x, i, j)
                                       if d_ij >= 1
                                               Loss += 1
                                       end
                               else
                                       d_ij = distance(x, i, j)
                                       if d_ij <= 1
                                               Loss += 1
                                       end
                               end
                       end
               end

               if Loss == 0
                       println("The result is a unit disk.")
               else
                       println("The result is not a unit disk.")
               end
               return Loss
       end
is_unit_disk (generic function with 1 method)

```


Here we define the loss function based on distance, given as
$$
\begin{aligned}
L &= L_{Edge} + L_{NonEdge}\\
L_{Edge} &= \sum_{i, j} 2 * {|x - 0.95|}^{0.2} * \text{sign}(x - 0.95)\\
L_{NonEdge} &= - \sum_{i, j} {|x - 1.05|}^{0.2} * \text{sign}(x - 1.05)
\end{aligned}
$$

Here the cutoff slightly larger or smaller than $1$ to fasten the convergence. Such a loss function will have a continium ```ForwardDiff``` so that gradient based optimalizer can be applied. 

```julia

julia> function Loss_distance_12(x::AbstractArray)
               E = [(1, 2), (1, 3), (2, 3), (2, 4), (2, 5), (2, 6), (3, 5), (3, 6), (3, 7),(4, 5), (4, 8), (5, 6), (5, 8), (5, 9), (6, 7), (6, 8), (6, 9), (7,9), (8, 9), (8, 10), (9, 10)]

               Loss_1 = 0
               Loss_2 = 0
julia> function Loss_distance_12(x::AbstractArray)
               E = [(1, 2), (1, 3), (2, 3), (2, 4), (2, 5), (2, 6), (3, 5), (3, 6), (3, 7),(4, 5), (4, 8), (5, 6), (5, 8), (5, 9), (6, 7), (6, 8), (6, 9), (7,9), (8, 9), (8, 10), (9, 10)]

               Loss_1 = 0
               Loss_2 = 0
               cut_1 = 0.95
               cut_2 = 1.05

               for i in 1:10
                       for j in i + 1:10
                               if (i, j) in E
                                       d_ij = distance(x, i, j)
                                       
                                       if d_ij >= cut_1
                                               Loss_1 += 2 * (abs(d_ij - cut_1))^(.2) * sign(d_ij - cut_1)
                                       end
                               else
                                       d_ij = distance(x, i, j)
                                       if d_ij <= cut_2
                                               Loss_2 += - (abs(d_ij - cut_2))^(.2) * sign(d_ij - cut_2)
                                       end
                               end
                       end
               end

               return Loss_1, Loss_2
       end
Loss_distance_12 (generic function with 1 method)

```

Loss distance
```julia
julia> function Loss_distance(x::AbstractArray)
               Loss_1, Loss_2 = Loss_distance_12(x::AbstractArray)
               Loss = Loss_1 + Loss_2
               return Loss
       end
Loss_distance (generic function with 1 method)
````

```julia
julia> ForwardDiff.gradient(Loss_distance, rand(20))
20-element Vector{Float64}:
  0.40244381993890727
  1.1019762515776184
  1.408082354445131
 -1.7722572278041242
  0.834699963040196
 -0.25726173106326267
 -0.3697443696524072
 -0.5486387144072347
 -0.26164783322497254
  ⋮
  0.6964373248111138
 -1.5654003702722836
 -0.1035910566797204
 -0.15170239622445125
  0.6006145460827936
  0.9468150026933249
 -0.842850209157153
  0.8992365546746024
```


```julia
julia> function gradient_descent(f, x; niters::Int, learning_rate::Real)
               history = [x]
               for i=1:niters
                       g = ForwardDiff.gradient(f, x)
                       x -= learning_rate * g
                       push!(history, x)
               end
               return x, f(x)
       end
gradient_descent (generic function with 1 method)
```


```julia
julia> begin
               x_0 = 3 * rand(20)
               best_x, best_loss = gradient_descent(Loss_distance, x_0; niters = 500000, learning_rate = 0.0001)
               result = is_unit_disk(best_x)
       end
The result is a unit disk.
0

```
**Credits to Xuanzhao Gao**

I once tried to change the x[20] to x[10],y[10], where I found that it was not more convenient than just using x[20]. So I keep it unchanged.

