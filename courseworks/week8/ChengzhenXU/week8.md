# Homework


Firstly, we have:
$$
\eta(\tau+1,\delta)=\eta(\tau+1,\delta-1)+\eta(\tau,\delta)
$$
Proof:
$$
\eta(\tau+1,\delta)= \frac{(\tau +1 + \delta)!}{(\tau+1)!\delta!}
$$
$$
\eta(\tau+1,\delta-1)=\frac{(\tau +1 + \delta-1)!}{(\tau+1)!(\delta-1)!}
$$
$$
\eta(\tau,\delta)= \frac{(\tau  + \delta)!}{\tau!\delta!}
$$

$$
\begin{aligned}
\eta(\tau,\delta)+\eta(\tau+1,\delta-1)
&=\frac{(\tau  + \delta)!}{\tau!\delta!}+\frac{(\tau +1 + \delta-1)!}{(\tau+1)!(\delta-1)!}\\
&=\frac{(\tau + \delta)!+\tau(\tau+\delta)!+\delta(\tau+\delta)!}{\tau!\delta!(\tau+1)}\\
&=\frac{(\tau +1  + \delta)!}{(\tau+1)!\delta!}\\
&=\eta(\tau+1,\delta)
\end{aligned}
$$


So:
$$
\begin{aligned}
\eta(\tau,\delta)&=\eta(\tau,\delta-1)+\eta(\tau-1,\delta)\\
\eta(\tau,\delta-1)&=\eta(\tau,\delta-2)+\eta(\tau-1,\delta-1)\\
\eta(\tau,\delta-2)&=\eta(\tau,\delta-3)+\eta(\tau-1,\delta-2)\\
&......\\
\eta(\tau,\delta-\delta+1)&=\eta(\tau,\delta-\delta)+\eta(\tau-1,\delta-\delta+1)\\
\end{aligned}
$$
so we have:
$$
\eta(\tau,\delta)+\eta(\tau,\delta-1)+\eta(\tau,\delta-2)+...+\eta(\tau,\delta-\delta+1)
=\eta(\tau,\delta-1)+\eta(\tau-1,\delta)+\eta(\tau,\delta-2)+\eta(\tau-1,\delta-1)+...+\eta(\tau,\delta-\delta)+\eta(\tau-1,\delta-\delta+1)\\
\downarrow\\
$$
$$
\begin{aligned}
\eta(\tau,\delta)&=\eta(\tau-1,\delta)+\eta(\tau-1,\delta-1)+\eta(\tau-1,\delta-2)+...+\eta(\tau-1,1)+\eta(\tau,0)\\
&=\eta(\tau-1,\delta)+\eta(\tau-1,\delta-1)+\eta(\tau-1,\delta-2)+...+\eta(\tau-1,1)+\eta(\tau-1,0)\\
&=\sum_{k=0}^\delta \eta(\tau-1,k)
\end{aligned}
$$




# Tasks
## 1. 
For forward autodiff
```julia
julia> using ForwardDiff

julia> using Test

julia> function poorman_norm(x::Vector{<:Real})
               nm2 = zero(real(eltype(x)))
               for i=1:length(x)
                       nm2 += abs2(x[i])
               end
               ret = sqrt(nm2)
               return ret
       end
poorman_norm (generic function with 1 method)
```

```julia
julia> function forward_diff_norm!(x::Vector{<:Real}, partial_x::Vector{<:Real})
           nm2 = zero(real(eltype(x)))
           for i = 1:length(x)
               nm2 += abs2(x[i])
               partial_x[i] *= 2 * x[i]
           end
           ret = sqrt(nm2)
           partial_x .*= 1 / (2 * ret)
           return ret, partial_x
       end
forward_diff_norm! (generic function with 1 method)

```

```
julia> @testset "Forward mode autodiff test" begin
           for i in 1:100
               N = rand(1:100)
               x = rand(N)
               partial_x = [1.0 for i in 1:N]
               ret, diff_x = forward_diff_norm!(x, partial_x)
               @test ret ≈ poorman_norm(x)
               @test diff_x ≈ ForwardDiff.gradient(poorman_norm, x)        
           end
       end
Test Summary:              | Pass  Total  Time
Forward mode autodiff test |  200    200  2.0s
Test.DefaultTestSet("Forward mode autodiff test", Any[], 200, false, false, true, 1.684340441498403e9, 1.684340443527321e9)

```


## 2.
This code uses a stack to store N+1 data (x is a N-d data)
forward process:
```julia
julia> function reverse_norm_forward!(x::Vector{<:Real}, stack::Vector{<:Real})
           nm2 = zero(real(eltype(x)))
               for i=1:length(x)
                       push!(stack, x[i])
                       nm2 += abs2(x[i])
               end
               push!(stack, nm2)
               ret = sqrt(nm2)
               return ret, stack
       end
reverse_norm_forward! (generic function with 1 method)
```
backward process
```
julia> function reverse_norm_backward!(partial_x::Vector{<:Real}, stack::Vector{<:Real})
               nm2 = pop!(stack)
               partial_x .*= 1 / (2 * sqrt(nm2))
               N = length(partial_x)
               for i in 1:N
                       x = pop!(stack)
                       partial_x[N + 1 - i] *= 2 * x
               end
               return partial_x, stack
       end
reverse_norm_backward! (generic function with 1 method)
```

test
```
julia> @testset "Reverse mode autodiff test" begin
           for i in 1:100
               N = rand(1:100)
               x = rand(N)
               partial_x = [1.0 for i in 1:N]
               stack = Vector{Real}()
               ret, stack = reverse_norm_forward!(x, stack)
               partial_x, stack = reverse_norm_backward!(partial_x, stack)
               @test ret ≈ poorman_norm(x)
               @test partial_x ≈ ForwardDiff.gradient(poorman_norm, x)        
           end
       end
Test Summary:              | Pass  Total  Time
Reverse mode autodiff test |  200    200  0.1s
Test.DefaultTestSet("Reverse mode autodiff test", Any[], 200, false, false, true, 1.684340526458501e9, 1.684340526550367e9)
```



Credits to Xuanzhao Gao