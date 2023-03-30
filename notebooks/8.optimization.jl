### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ 013c7dac-a8c6-4fff-8837-e4d6751f3fb6
begin
	using AbstractTrees, PlutoUI, Reexport
	include("../lib/PlutoLecturing/src/PlutoLecturing.jl")
	using .PlutoLecturing
end

# ╔═╡ 1ed6d587-b984-463f-9db3-220bdfa81ebe
using Plots

# ╔═╡ f020f39c-e756-4c09-8ab3-7d10e78ca43e
using Optim

# ╔═╡ 4136799e-c4ab-432b-9e8a-208b0eae060e
using ForwardDiff

# ╔═╡ 4b3de811-278b-4154-bce6-4d67dc19ff38
using Luxor

# ╔═╡ 6644b213-63ed-4814-b034-0b39caa04f23
md"""
# Announcements
1. How to avoid PR like: [https://github.com/GiggleLiu/ModernScientificComputing/pull/27](https://github.com/GiggleLiu/ModernScientificComputing/pull/27). Help desk event (Saturday night, hosted by Yusheng Zhao) will be announced in the `#coding-club` stream?
2. Why we should never add a big file into a Github repo?
2. The ChatGPT bot in [HKUST-GZ Zulip workspace](http://zulip.hkust-gz.edu.cn/), `@ChatGPT` (user stream: `#chatgpt-discussion`), credit Yijie Xu, Github repo: [https://github.com/yeahjack/chatgpt_zulip_bot](https://github.com/yeahjack/chatgpt_zulip_bot).
3. Have to cancel the next lecture, we will not have final exam!
"""

# ╔═╡ c85bdb41-ce56-48ce-a82c-6599ccbc446c
LocalResource("images/chatgpt.png")

# ╔═╡ 3dc062b0-30d0-4332-9047-0852671cb031
TableOfContents()

# ╔═╡ 7345a2c1-d4b7-470f-a936-b4cc6c177399
md"# Optimization"

# ╔═╡ 7c26b07f-6a1f-4d40-9152-b8738a1dad62
md"Reference: **Scientific Computing - Chapter 6**"

# ╔═╡ 6b4307ea-33c0-4a20-af35-d05262856528
md"""A general continous optimization problem has the following form
```math
\min_{\mathbf x}f(\mathbf x)~~~\text{ subject to certian constraints}
```
The constraints may be either equality or inequality constraints.
"""

# ╔═╡ 647a7101-ebdc-4717-a343-22edee8a7d92
md"""
# Gradient free optimization
"""

# ╔═╡ f784dc43-5058-4375-9040-f343c346cff8
md"""
Gradient-free optimizers are optimization algorithms that do not rely on the gradient of the objective function to find the optimal solution. Instead, they use other methods such as random search, genetic algorithms, or simulated annealing to explore the search space and find the optimal solution. These methods are particularly useful when the objective function is non-differentiable or when the gradient is difficult to compute. However, gradient-free optimizers can be $(PlutoLecturing.highlight("slower and less efficient than gradient-based methods")), especially when the search space is high-dimensional.

There are several popular gradient-free optimizers, including:
* **Genetic algorithms**: These are optimization algorithms inspired by the process of natural selection. They use a population of candidate solutions and apply genetic operators such as crossover and mutation to generate new solutions.

* **Simulated annealing**: This is a probabilistic optimization algorithm that uses a temperature parameter to control the probability of accepting a worse solution. It starts with a high temperature that allows for exploration of the search space and gradually decreases the temperature to converge to the optimal solution.

* **Particle swarm optimization**: This is a population-based optimization algorithm that simulates the movement of particles in a search space. Each particle represents a candidate solution, and they move towards the best solution found so far.

* **Bayesian optimization**: This is a probabilistic optimization algorithm that uses a probabilistic model to approximate the objective function and guides the search towards promising regions of the search space.

* **Nelder-Mead algorithm**: This is a direct search method that does not require the computation of gradients of the objective function. Instead, it uses a set of simplex (a geometrical figure that generalizes the concept of a triangle to higher dimensions) to iteratively explore the search space and improve the objective function value. The Nelder-Mead algorithm is particularly effective in optimizing nonlinear and non-smooth functions, and it is widely used in engineering, physics, and other fields.
"""

# ╔═╡ 1a959468-3add-4e34-a9fe-54ca67a12894
md"NOTE: [Optim.jl documentation](https://julianlsolvers.github.io/Optim.jl/stable/) contains more detailed introduction of gradient free, gradient based and hessian based optimizers."

# ╔═╡ 90472087-2580-496e-989e-e4fa58fd1e17
md"""
## The downhill simplex method
"""

# ╔═╡ 0c5dd6d1-20cd-4ec6-9017-80dbc705b75d
md"""
Here are the steps involved in the one dimentional downhill simplex algorithm:
1. Initialize a one dimensional simplex, evaluate the function at the end points $x_1$ and $x_2$ and assume $f(x_2) > f(x_1)$.
2. Evaluate the function at $x_c = 2x_1 - x_2$.
3. Select one of the folloing operations
    1. If $f(x_c)$ is smaller than $f(x_1)$, **flip** the simplex by doing $x_1 \leftarrow x_c$ and $x_2 \leftarrow x_1$.
    2. If $f(x_c)$ is larger than $f(x_1)$, but smaller than $f(x_2)$, then $x_2\leftarrow x_c$, goto case 3.
    3. If $f(x_c)$ is larger than $f(x_2)$, then **shrink** the simplex: evaluate $f$ on $x_d\leftarrow (x_1 + x_2)/2$, if it is larger than $f(x_1)$, then $x_2 \leftarrow x_d$, otherwise $x_1\leftarrow x_d, x_2\leftarrow x_1$.
4. Repeat step 2-3 until convergence.
"""

# ╔═╡ e6ab2552-6597-4bef-a9c1-e0cea14b0f67
function simplex1d(f, x1, x2; tol=1e-6)
	# initial simplex
	history = [[x1, x2]]
	f1, f2 = f(x1), f(x2)
	while abs(x2 - x1) > tol
		xc = 2x1 - x2
		fc = f(xc)
		if fc < f1   # flip
			x1, f1, x2, f2 = xc, fc, x1, f1
		else         # shrink
			if fc < f2   # let the smaller one be x2.
				x2, f2 = xc, fc
			end
			xd = (x1 + x2) / 2
			fd = f(xd)
			if fd < f1   # update x1 and x2
				x1, f1, x2, f2 = xd, fd, x1, f1
			else
				x2, f2 = xd, fd
			end
		end
		push!(history, [x1, x2])
	end
	return x1, f1, history
end

# ╔═╡ d16748d2-e157-43d2-b6fe-69cbe4a5dd9c
simplex1d(x->x^2, -1.0, 6.0)

# ╔═╡ 66416807-bcb0-4881-90f8-1595756e4a6f
md"""
The Nelder-Mead method is well summarized in this [wiki page](https://en.wikipedia.org/wiki/Nelder%E2%80%93Mead_method).
Here is a Julia implementation:
"""

# ╔═╡ 43486a15-7582-4532-b2ac-73db4bb07f97
function simplex(f, x0; tol=1e-6, maxiter=1000)
    n = length(x0)
    x = zeros(n+1, n)
    fvals = zeros(n+1)
    x[1,:] = x0
    fvals[1] = f(x0)
    alpha = 1.0
    beta = 0.5
    gamma = 2.0
    for i in 1:n
        x[i+1,:] = x[i,:]
        x[i+1,i] += 1.0
        fvals[i+1] = f(x[i+1,:])
    end
	history = [x]
    for iter in 1:maxiter
        # Sort the vertices by function value
        order = sortperm(fvals)
        x = x[order,:]
        fvals = fvals[order]
        # Calculate the centroid of the n best vertices
        xbar = dropdims(sum(x[1:n,:], dims=1) ./ n, dims=1)
        # Reflection
        xr = xbar + alpha*(xbar - x[n+1,:])
        fr = f(xr)
        if fr < fvals[1]
            # Expansion
            xe = xbar + gamma*(xr - xbar)
            fe = f(xe)
            if fe < fr
                x[n+1,:] = xe
                fvals[n+1] = fe
            else
                x[n+1,:] = xr
                fvals[n+1] = fr
            end
        elseif fr < fvals[n]
            x[n+1,:] = xr
            fvals[n+1] = fr
        else
            # Contraction
            if fr < fvals[n+1]
                xc = xbar + beta*(x[n+1,:] - xbar)
                fc = f(xc)
                if fc < fr
                    x[n+1,:] = xc
                    fvals[n+1] = fc
                else
                    # Shrink
                    for i in 2:n+1
                        x[i,:] = x[1,:] + beta*(x[i,:] - x[1,:])
                        fvals[i] = f(x[i,:])
                    end
                end
            else
                # Shrink
                for i in 2:n+1
                    x[i,:] = x[1,:] + beta*(x[i,:] - x[1,:])
                    fvals[i] = f(x[i,:])
                end
            end
        end
		push!(history, x)
        # Check for convergence
        if maximum(abs.(x[2:end,:] .- x[1,:])) < tol && maximum(abs.(fvals[2:end] .- fvals[1])) < tol
            break
        end
    end
    # Return the best vertex and function value
    bestx = x[1,:]
    bestf = fvals[1]
    return (bestx, bestf, history)
end

# ╔═╡ 962f24ff-2adc-41e3-bc5c-2f78952950d2
md"""
The `simplex` function takes three arguments: the objective function `f`, the initial guess `x0`, and optional arguments for the tolerance `tol` and maximum number of iterations `maxiter`.

The algorithm initializes a simplex (a high dimensional triangle) with `n+1` vertices, where `n` is the number of dimensions of the problem. The vertices are initially set to `x0` and `x0 + h_i`, where `h_i` is a small step size in the `i`th dimension. The function values at the vertices are also calculated.

The algorithm then iteratively performs **reflection**, **expansion**, **contraction**, and **shrink** operations on the simplex until convergence is achieved. The best vertex and function value are returned.
"""

# ╔═╡ 1024bec9-6741-4cf6-a214-9777c17d2348
md"""
We use the [Rosenbrock function](https://en.wikipedia.org/wiki/Rosenbrock_function) as the test function.
"""

# ╔═╡ f859faaa-b24e-4af2-8b72-85f2d753e87a
function rosenbrock(x)
	(1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2
end

# ╔═╡ c16945b6-397e-4cc2-9f74-9c0e6eb21a8c
let
	x = -2:0.01:2
	y = -2:0.01:2
	f = [rosenbrock((a, b)) for b in y, a in x]
	heatmap(x, y, log.(f); label="log(f)", xlabel="x₁", ylabel="x₂")
end

# ╔═╡ 81b628ce-91b1-4b63-aca1-96e10c49d7b9
function show_triangles(history)
	x = -2:0.02:2
	y = -2:0.02:2
	f = [rosenbrock((a, b)) for b in y, a in x]
	@gif for item in history
		plt = heatmap(x, y, log.(f); label="log(f)", xlabel="x₁", ylabel="x₂", xlim=(-2, 2), ylim=(-2, 2))
		plot!(plt, [item[:,1]..., item[1,1]], [item[:,2]..., item[1, 2]]; label="", color="white")
	end fps=5
end

# ╔═╡ 44f3252c-cb3b-458f-b3b9-a87ce9f6e0e2
let
	bestx, bestf, history = simplex(rosenbrock, [-1.2, -1.0]; tol=1e-3)
	@info "converged in $(length(history)) steps, with error $bestf"
	show_triangles(history)
end

# ╔═╡ c1c02449-50e7-4dc4-8807-a31b10624921
let
	# Set the initial guess
	x0 = [-1, -1.0]
	# Set the optimization options
	options = Optim.Options(iterations = 1000)
	# Optimize the Rosenbrock function using the simplex method
	result = optimize(rosenbrock, x0, NelderMead(), options)
	# Print the optimization result
	result
end

# ╔═╡ 50f91cd8-c74b-11ed-0b94-cdeb596bf99b
md"# Gradient based optimization"

# ╔═╡ 211b6c56-f16b-47fb-ba56-4534ac41be95
md"""
If $f: R^n \rightarrow R$ is differentiable, then the vector-valued function $\nabla f: R^n \rightarrow R^n$ defined by
```math
\nabla f(x) = \left(\begin{matrix}
\frac{\partial f(\mathbf{x})}{\partial x_1}\\
\frac{\partial f(\mathbf{x})}{\partial x_2}\\
\vdots\\
\frac{\partial f(\mathbf{x})}{\partial x_n}\\
\end{matrix}\right)
```
is called the gradient of $f$.
"""

# ╔═╡ eec10666-102c-44b6-a562-75ba78428d1e
md"""
Gradient descent is based on the observation that changing $\mathbf x$ slightly towards the negative gradient direction always decrease $f$ in the first order perturbation.
```math
f(\mathbf{x} - \epsilon \nabla f(\mathbf x)) \approx f(\mathbf x) - \epsilon \nabla f(\mathbf x)^T \nabla f(\mathbf x) = f(\mathbf x) - \epsilon \|\nabla f(\mathbf x)\|_2 < f(\mathbf{x})
```
"""

# ╔═╡ d59aaccf-1435-4c7b-998e-5dfb174990c3
md"""## Gradient descent

In each iteration, the update rule of the gradient descent method is
```math
\begin{align}
&\theta_{t+1} = \theta_t - \alpha g_t
\end{align}
```

where 
*  $\theta_t$ is the values of variables at time step $t$.
*  $g_t$ is the gradient at time $t$ along $\theta_t$, i.e. $\nabla_{\theta_t} f(\theta_t)$.
*  $\alpha$ is the learning rate.
"""

# ╔═╡ 10283699-2ebc-4e61-89e8-5585a2bf054d
md"One can obtain the gradient with `ForwardDiff`."

# ╔═╡ 3e616d99-7d57-4926-b1d5-dae47dd040e9
ForwardDiff.gradient(rosenbrock, [1.0, 3.0])

# ╔═╡ 004a79b8-afbd-40b7-9c67-a8e864432179
function gradient_descent(f, x; niters::Int, learning_rate::Real)
	history = [x]
	for i=1:niters
		g = ForwardDiff.gradient(f, x)
		x -= learning_rate * g
		push!(history, x)
	end
	return history
end

# ╔═╡ 599b0416-d1e7-4e92-8604-80bda896d88b
function show_history(history)
	x = -2:0.01:2
	y = -2:0.01:2
	f = [rosenbrock((a, b)) for b in y, a in x]
	plt = heatmap(x, y, log.(f); label="log(f)", xlabel="x₁", ylabel="x₂", xlim=(-2, 2), ylim=(-2, 2))
	plot!(plt, getindex.(history, 1), getindex.(history, 2); label="optimization", color="white")
end

# ╔═╡ 8d0dbc03-f927-4229-a8ce-6196cb62bde2
let
	x0 = [-1, -1.0]
	history = gradient_descent(rosenbrock, x0; niters=10000, learning_rate=0.002)
	@info rosenbrock(history[end])

	# plot
	show_history(history)
end

# ╔═╡ 95ac921c-20c6-432e-8a70-006804d6b0da
md"""
The problem of gradient descent: easy trapped by plateaus.
"""

# ╔═╡ 3212c3f2-f3c3-4403-9584-85386db6825c
md"""
## Gradient descent with momentum

We can add a "momentum" term to the weight update, which helps the optimization algorithm to move more quickly in the right direction and avoid getting stuck in local minima.

The intuition behind the momentum method can be understood by considering a ball rolling down a hill. Without momentum, the ball would roll down the hill and eventually come to a stop at the bottom. However, with momentum, the ball would continue to roll past the bottom of the hill and up the other side, before eventually coming to a stop at a higher point. This is because the momentum of the ball helps it to overcome small bumps and obstacles in its path and continue moving in the right direction.

In each iteration, the update rule of gradient descent method with momentum is
```math
\begin{align}
&v_{t+1} = \beta v_t - \alpha g_t\\
&\theta_{t+1} = \theta_t + v_{t+1}
\end{align}
```

where 
*  $g_t$ is the gradient at time $t$ along $\theta_t$, i.e. $\nabla_{\theta_t} f(\theta_t)$.
*  $\alpha$ is the initial learning rate.
*  $\beta$ is the parameter for the gradient accumulation.
"""

# ╔═╡ 50feee93-6a1f-4256-822f-88ceede1bbec
function gradient_descent_momentum(f, x; niters::Int, β::Real, learning_rate::Real)
	history = [x]
	v = zero(x)
	for i=1:niters
		g = ForwardDiff.gradient(f, x)
		v = β .* v .- learning_rate .* g
		x += v
		push!(history, x)
	end
	return history
end

# ╔═╡ 859705f4-9b5f-4403-a9ef-d21e3cbd0b06
let
	x0 = [-1, -1.0]
	history = gradient_descent_momentum(rosenbrock, x0; niters=10000, learning_rate=0.002, β=0.5)
	@info rosenbrock(history[end])

	# plot
	show_history(history)
end

# ╔═╡ e2a17f45-cc79-485b-abf2-fbc81a66f908
md"""
The problem of momentum based method, easily got overshoted.
Moreover, it is not **scale-invariant**.
"""

# ╔═╡ 5b911473-57b8-46a4-bdec-6f1960c1e958
md"""
## AdaGrad
AdaGrad is an optimization algorithm used in machine learning for solving convex optimization problems. It is a gradient-based algorithm that adapts the learning rate for each parameter based on the historical gradient information. The main idea behind AdaGrad is to give more weight to the parameters that have a smaller gradient magnitude, which allows for a larger learning rate for those parameters.
"""

# ╔═╡ 29ed621d-0505-4f8c-88fc-642a3ddf3ae8
md"""
In each iteration, the update rule of AdaGrad is

```math
\begin{align}
	&r_t = r_t + g_t^2\\
    &\mathbf{\eta} = \frac{\alpha}{\sqrt{r_t + \epsilon}}\\
    &\theta_{t+1} = \theta_t - \eta \odot g_t
\end{align}
```

where 
*  $\theta_t$ is the values of variables at time $t$.
*  $\alpha$ is the initial learning rate.
*  $g_t$ is the gradient at time $t$ along $\theta_t$
*  $r_t$ is the historical squared gradient sum, which is initialized to $0$.
*  $\epsilon$ is a small positive number.
*  $\odot$ is the element-wise multiplication.
"""

# ╔═╡ 50b8dcf3-9cec-4487-8a57-249c213caa21
function adagrad_optimize(f, x; niters, learning_rate, ϵ=1e-8)
	rt = zero(x)
	η = zero(x)
	history = [x]
	for step in 1:niters
	    Δ = ForwardDiff.gradient(f, x)
	    @. rt = rt + Δ .^ 2
		@. η = learning_rate ./ sqrt.(rt + ϵ)
	    x = x .- Δ .* η
		push!(history, x)
	end
	return history
end

# ╔═╡ 09f542be-490a-42bc-81ac-07a318371ca3
let
	x0 = [-1, -1.0]
	history = adagrad_optimize(rosenbrock, x0; niters=10000, learning_rate=1.0)
	@info rosenbrock(history[end])

	# plot
	show_history(history)
end

# ╔═╡ a4b4bc11-efb2-46db-b256-ba9632fadd7b
md"## Adam
The Adam optimizer is a popular optimization algorithm used in deep learning for training neural networks. It stands for Adaptive Moment Estimation and is a variant of stochastic gradient descent (SGD) that is designed to be more efficient and effective in finding the optimal weights for the neural network.

The Adam optimizer maintains a running estimate of the first and second moments of the gradients of the weights with respect to the loss function. These estimates are used to adaptively adjust the learning rate for each weight parameter during training. The first moment estimate is the mean of the gradients, while the second moment estimate is the uncentered variance of the gradients.

The Adam optimizer combines the benefits of two other optimization algorithms: AdaGrad, which adapts the learning rate based on the historical gradient information, and RMSProp, which uses a moving average of the squared gradients to scale the learning rate.

The Adam optimizer has become a popular choice for training deep neural networks due to its fast convergence and good generalization performance. It is widely used in many deep learning frameworks, such as TensorFlow, PyTorch, and Keras.
"

# ╔═╡ 8b74adc9-9e82-46db-a87e-a72928aff03f
md"""
In each iteration, the update rule of Adam is

```math
\begin{align}
&v_t = \beta_1 v_{t-1} - (1-\beta_1) g_t\\
&s_t = \beta_2 s_{t-1} - (1-\beta_2) g^2\\
&\hat v_t = v_t / (1-\beta_1^t)\\
&\hat s_t = s_t / (1-\beta_2^t)\\
&\theta_{t+1} = \theta_t -\eta \frac{\hat v_t}{\sqrt{\hat s_t} + \epsilon}
&\end{align}
```
where
*  $\theta_t$ is the values of variables at time $t$.
*  $\eta$ is the initial learning rate.
*  $g_t$ is the gradient at time $t$ along $\theta$.
*  $v_t$ is the exponential average of gradients along $\theta$.
*  $s_t$ is the exponential average of squares of gradients along $\theta$.
*  $\beta_1, \beta_2$ are hyperparameters.
"""

# ╔═╡ 6dc932f9-d37b-4cc7-90d9-1ed0bae20c41
function adam_optimize(f, x; niters, learning_rate, β1=0.9, β2=0.999, ϵ=1e-8)
	mt = zero(x)
	vt = zero(x)
	βp1 = β1
	βp2 = β2
	history = [x]
	for step in 1:niters
	    Δ = ForwardDiff.gradient(f, x)
	    @. mt = β1 * mt + (1 - β1) * Δ
	    @. vt = β2 * vt + (1 - β2) * Δ^2
	    @. Δ =  mt / (1 - βp1) / (√(vt / (1 - βp2)) + ϵ) * learning_rate
	    βp1, βp2 = βp1 * β1, βp2 * β2
	    x = x .- Δ
		push!(history, x)
	end
	return history
end

# ╔═╡ 8086d721-3360-4e66-b898-b3f1fb9e4392
let
	x0 = [-1, -1.0]
	history = adam_optimize(rosenbrock, x0; niters=10000, learning_rate=0.01)
	@info rosenbrock(history[end])

	# plot
	show_history(history)
end

# ╔═╡ ce076be7-b930-4d35-b594-1009c87213a6
md"""
## The Julia package `Optimisers.jl`
"""

# ╔═╡ 6bc59fbc-14ae-4e07-8390-3195182e17a5
import Optimisers

# ╔═╡ ec098a81-5032-4d43-85bf-a51b0a19e94e
PlutoLecturing.@xbind gradient_based_optimizer Select(["Descent", "Momentum", "Nesterov", "Rprop", "RMSProp", "Adam", "RAdam", "AdaMax", "OAdam", "AdaGrad", "AdaDelta", "AMSGrad", "NAdam", "AdamW", "AdaBelief"])

# ╔═╡ 6778a8ce-73a7-40e8-92bc-c9491daa9012
PlutoLecturing.@xbind learning_rate NumberField(0:1e-4:1.0, default=1e-4)

# ╔═╡ dcf4a168-1c11-45f2-b7e7-15d6fb4becea
md"The different optimizers are introduced in the [documentation page](https://fluxml.ai/Optimisers.jl/dev/api/)"

# ╔═╡ 77761a71-65ea-434b-a697-d86278d10abd
let
	x0 = [-1, -1.0]
	method = eval(:(Optimisers.$(Symbol(gradient_based_optimizer))(learning_rate)))
	state = Optimisers.setup(method, x0)
	history = [x0]
	for i=1:10000
		grad = ForwardDiff.gradient(rosenbrock, x0)
		state, x0 = Optimisers.update(state, x0, grad)
		push!(history, x0)
	end
	@info rosenbrock(history[end])

	# plot
	show_history(history)
end

# ╔═╡ 6bee88e1-d641-4a28-9794-6031e721a79c
md"""[Optimisers.jl documentation](https://fluxml.ai/Optimisers.jl/dev/api/#Optimisation-Rules) contains **stochastic** gradient based optimizers.
"""

# ╔═╡ cbdb2ad6-2a7d-4ccb-89f9-5ec836612477
md"""
# Hessian based optimizers
"""

# ╔═╡ 66cbb653-b06d-4b06-880b-f402fd9f1d53
md"## Newton's Method"

# ╔═╡ 5af90753-f9cc-437f-9b11-98618fdb67aa
md"""
Newton's method is an optimization algorithm used to find the roots of a function, which can also be used to find the minimum or maximum of a function. The method involves using the first and second derivatives of the function to approximate the function as a quadratic function and then finding the minimum or maximum of this quadratic function. The minimum or maximum of the quadratic function is then used as the next estimate for the minimum or maximum of the original function, and the process is repeated until convergence is achieved.
"""

# ╔═╡ e80a6b59-84d4-40e9-bf1b-08719016745e
md"""
```math
\begin{align}
& H_{k}p_{k}=-g_k\\
& x_{k+1}=x_{k}+p_k
\end{align}
```
where
*  $g_k$ is the gradient at time $k$ along $x_k$.
"""

# ╔═╡ da2d74e5-d411-499b-b4c3-cb6dfefb8c8d
function newton_optimizer(f, x; tol=1e-5)
	k = 0
	history = [x]
	while k < 1000
		k += 1
		gk = ForwardDiff.gradient(f, x)
		hk = ForwardDiff.hessian(f, x)
		dx = -hk \ gk
		x += dx
		push!(history, x)
		sum(abs2, dx) < tol && break
	end
	return history
end

# ╔═╡ a4832798-6e20-4630-889d-388fe55272f7
let
	x0 = [-1, -1.0]
	history = newton_optimizer(rosenbrock, x0; tol=1e-5)
	@info "number iterations = $(length(history)), got $(rosenbrock(history[end]))"

	# plot
	show_history(history)
end

# ╔═╡ 89fb89d4-227f-41ba-8e42-68a9c436b930
md"The drawback of Newton's method is, the Hessian is very expensive to compute!
While gradients can be computed with the automatic differentiation method with constant overhead. The Hessian requires $O(n)$ times more resources, where $n$ is the number of parameters."

# ╔═╡ 4ade7201-ae81-41ca-affb-fffcb99776fe
md"## The Broyden–Fletcher–Goldfarb–Shanno (BFGS) algorithm"

# ╔═╡ 3e406fc4-8bb1-4b11-ae9a-a33604061a8a
md"""
The BFGS method is a popular numerical optimization algorithm used to solve unconstrained optimization problems. It is an iterative method that seeks to find the minimum of a function by iteratively updating an estimate of the inverse Hessian matrix of the function.

The BFGS method belongs to a class of $(PlutoLecturing.highlight("quasi-Newton methods")), which means that it approximates the Hessian matrix of the function using only first-order derivative information. The BFGS method updates the inverse Hessian matrix at each iteration using information from the current and previous iterations. This allows it to converge quickly to the minimum of the function.

The BFGS method is widely used in many areas of science and engineering, including machine learning, finance, and physics. It is particularly well-suited to problems where the Hessian matrix is too large to compute directly, as it only requires first-order derivative information.

```math
\begin{align}
& B_{k}p_{k}=-g_k~~~~~~~~~~\text{// Newton method like update rule}\\
& \alpha_k = {\rm argmin} ~f(x + \alpha p_k)~~~~~~~~~~\text{// using line search}\\
& s_k=\alpha_{k}p_k\\
& x_{k+1}=x_{k}+s_k\\
&y_k=g_{k+1}-g_k\\
&B_{k+1}=B_{k}+{\frac {y_{k}y_{k}^{\mathrm {T} }}{y_{k}^{\mathrm {T} }s_{k}}}-{\frac {B_{k}s_{k}s_{k}^{\mathrm {T} }B_{k}^{\mathrm {T} }}{s_{k}^{\mathrm {T} }B_{k}s_{k}}}
\end{align}
```
where
*  $B_k$ is an approximation of the Hessian matrix, which is intialized to identity.
*  $g_k$ is the gradient at time $k$ along $x_k$.

We can show $B_{k+1}s_k = y_k$ (secant equation) is satisfied.
"""

# ╔═╡ d0166fdc-333b-495b-965e-1c77711ba469
let
	# Set the initial guess
	x0 = [-1.0, -1.0]
	# Set the optimization options
	options = Optim.Options(iterations = 1000, store_trace=true, extended_trace=true)
	# Optimize the Rosenbrock function using the simplex method
	result = optimize(rosenbrock, x->ForwardDiff.gradient(rosenbrock, x), x0, BFGS(), options, inplace=false)
	# Print the optimization result
	@info result
	show_history([t.metadata["x"] for t in result.trace])
end

# ╔═╡ ab2ad24c-a019-4608-9344-23eb1025e108
md"""
# Mathematical optimization
"""

# ╔═╡ e6dca5dc-dbf9-45ba-970d-23bd9a75769d
md"## Convex optimization"

# ╔═╡ 5b433d39-ed60-4831-a139-b6663a284e7a
md"A set $S\subseteq \mathbb{R}^n$ is convex if it contains the line segment between any two of its points, i.e.,
```math
\{\alpha \mathbf{x} + (1-\alpha)\mathbf{y}: 0\leq \alpha \leq 1\} \subseteq S
```
for all $\mathbf{x}, \mathbf{y} \in S$.
"

# ╔═╡ 1bf01867-adbe-4d00-a189-c0f024e65475
let
	@drawsvg begin
	function segment(a, b)
		line(a, b, :stroke)
		circle(a, 5, :fill)
		circle(b, 5, :fill)
	end
	fontsize(20)
	c1 = Point(-180, -20)
	sethue("red")
	ellipse(c1, 130, 80, :fill)
	sethue("black")
	ellipse(c1, 130, 80, :stroke)
	segment(c1 - Point(50, 25), c1 + Point(50, -25))
	Luxor.text("convex set", c1 + Point(0, 90), halign=:center)
	c2 = Point(0, -20)
	f(t) = Point(4cos(t) + 2cos(3t), 4sin(t) + 3sin(3t+π/2))
	sethue("red")
    poly(10 .* f.(range(0, 2π, length=160)) .+ c2, action = :fill)
	sethue("black")
    poly(10 .* f.(range(0, 2π, length=160)) .+ c2, action = :stroke)
	a, b = Point(c2.x-30, c2.y+30), Point(c2.x+45, c2.y)
	segment(a, b)
	Luxor.text("nonconvex set", c2 + Point(0, 90), halign=:center)
end 520 200
end

# ╔═╡ 2afe850b-cfd3-41de-b3e1-fafa44e9bbe2
md"""
A function $f: S \in R^n \rightarrow R$ is convex on a convex set $S$ if its graph along any line segment in $S$ lies on or blow the chord connecting the function values at the endpoints of the segment, i.e., if
```math
f(\alpha \mathbf{x} + (1-\alpha) \mathbf{y}) \leq \alpha f(\mathbf{x}) + (1+\alpha)f(\mathbf{y})
```
for all $\alpha \in [0, 1]$ and all $\mathbf{x}, \mathbf{y}\in S$.
"""

# ╔═╡ 8a93097f-00c1-45b0-92a1-092aeccc58a5
let
@drawsvg begin
	function segment(a, b)
		line(a, b, :stroke)
		circle(a, 5, :fill)
		circle(b, 5, :fill)
	end
	fontsize(20)
	c1 = Point(-180, -20)
	xs = -1.6:0.01:1.6
	ys = 0.8 * (2.0xs .^ 2 .- xs .^ 4 .- 0.2*xs .+ 1)
	Luxor.poly(30 .* Point.(xs, ys) .+ Ref(c1), :stroke)
	Luxor.text("nonconvex", c1 + Point(0, 90), halign=:center)
	segment(c1+Point(-17, 40), c1+Point(18, 35))
	
	c2 = Point(0, -20)
	xs = [-1.8, -0.9, 0.0, 0.7, 1.8]
	ys = [-0.7, 1.3, 1.7, 1.2, -0.7]
	Luxor.poly(30 .* Point.(xs, ys) .+ Ref(c2), :stroke)
	Luxor.text("convex", c2 + Point(0, 90), halign=:center)
	segment(c2+Point(-17, 43), c2+Point(25, 30))

	
	fontsize(20)
	c3 = Point(180, -20)
	xs = -1.4:0.01:1.3
	ys = 0.8 * (- xs .^ 4 .- 0.2*xs .+ 2.2)
	Luxor.poly(30 .* Point.(xs, ys) .+ Ref(c3), :stroke)
	Luxor.text("strictly convex", c3 + Point(0, 90), halign=:center)
	segment(c3+Point(-27, 40), c3+Point(25, 35))
end 520 200
end

# ╔═╡ ce27c364-9ae3-435a-8153-a1c898ae8984
md"Any local minimum of a convex function $f$ on a convex set $S\subseteq \mathbb{R}^n$ is a global minimum of $f$ on $S$."

# ╔═╡ afbc321c-c568-4b88-8dc1-9d87a4a0e7af
md"## Linear programming"

# ╔═╡ 7db726fc-b537-483a-8898-dd24b4f3aca2
md"""
Linear programs are problems that can be expressed in canonical form as
```math
{\begin{aligned}&{\text{Find a vector}}&&\mathbf {x} \\&{\text{that maximizes}}&&\mathbf {c} ^{T}\mathbf {x} \\&{\text{subject to}}&&A\mathbf {x} \leq \mathbf {b} \\&{\text{and}}&&\mathbf {x} \geq \mathbf {0} .\end{aligned}}
```
Here the components of $\mathbf x$ are the variables to be determined, $\mathbf c$ and $\mathbf b$ are given vectors (with $\mathbf {c} ^{T}$ indicating that the coefficients of $\mathbf c$ are used as a single-row matrix for the purpose of forming the matrix product), and $A$ is a given matrix.
"""

# ╔═╡ c76981ce-f1e5-4681-ad13-6188a962d962
md"""## Example
[https://jump.dev/JuMP.jl/stable/tutorials/linear/diet/](https://jump.dev/JuMP.jl/stable/tutorials/linear/diet/)
"""

# ╔═╡ 93b69c65-8df3-4782-8b39-20fb3879cbcc
md"""
[JuMP.jl documentation](https://jump.dev/JuMP.jl/stable/) also contains mathematical models such as **semidefinite programming** and **integer programming**.
"""

# ╔═╡ 2e17a5f6-a942-4688-bc23-25b1715d9886
md"""
# Assignments

1. Show the following graph $G=(V, E)$ has a unit-disk embedding.
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

So what is uni-disk embedding of a graph? Ask Chat-GPT with the following question
```
What is a unit-disk embedding of a graph?
```

### Hint:
To solve this issue, you can utilize an optimizer. Here's how:

1. Begin by assigning each vertex with a coordinate. You can represent the locations of all vertices as a $2 \times n$ matrix, denoted as $x$, where each column represents a coordinate of vertices in a two-dimensional space.

2. Construct a loss function, denoted as $f(x)$, that returns a positive value as punishment if any connected vertex pair $(v, w)$ has a distance ${\rm dist}(x_v, x_w) > 1$ (the unit distance), or if any disconnected vertex pair has a distance smaller than $1$. If all unit-disk constraints are satisfied, the function returns $0$.

3. Use an optimizer to optimize the loss function $f(x)$. If the loss can be reduced to $0$, then the corresponding $x$ represents a unit-disk embedding. If not, you may need to try multiple times to ensure that your optimizer does not trap you into a local minimum.
"""

# ╔═╡ 47747e2d-52c7-47a5-aa06-1ce25f7dd7fe
md"## Golden section search";

# ╔═╡ da2f6865-ff3c-46bd-80d4-f171b0e30ce9
function golden_section_search(f, a, b; tol=1e-5)
	τ = (√5 - 1) / 2
	x1 = a + (1 - τ) * (b - a)
	x2 = a + τ * (b - a)
	f1, f2 = f(x1), f(x2)
	k = 0
	while b - a > tol
		k += 1
		if f1 > f2
			a = x1
			x1 = x2
			f1 = f2
			x2 = a + τ * (b - a)
			f2 = f(x2)
		else
			b = x2
			x2 = x1
			f2 = f1
			x1 = a + (1 - τ) * (b - a)
			f1 = f(x1)
		end
	end
	#@info "number of iterations = $k"
	return f1 < f2 ? (a, f1) : (b, f2)
end;

# ╔═╡ c75753d4-ceec-402e-a4bc-8b00b4934dbf
golden_section_search(x->(x-4)^2, -5, 5; tol=1e-5);

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractTrees = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
Luxor = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
Optim = "429524aa-4258-5aef-a3af-852621145aeb"
Optimisers = "3bd65402-5787-11e9-1adc-39752487f4e2"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Reexport = "189a3867-3050-52da-a836-e630ba90ab69"

[compat]
AbstractTrees = "~0.4.4"
ForwardDiff = "~0.10.35"
Luxor = "~3.7.0"
Optim = "~1.7.4"
Optimisers = "~0.2.15"
Plots = "~1.38.8"
PlutoUI = "~0.7.50"
Reexport = "~1.2.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "7e4e83290afdd2498d991561fdef1b2e36984cec"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.AbstractTrees]]
git-tree-sha1 = "faa260e4cb5aba097a73fab382dd4b5819d8ec8c"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.4"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "cc37d689f599e8df4f464b2fa3870ff7db7492ef"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.6.1"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "Requires", "SnoopPrecompile", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "a89acc90c551067cd84119ff018619a1a76c6277"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.2.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "d0b3f8b4ad16cb0a2988c6788646a5e6a17b6b1b"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.0.5"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c6d890a52d2c4d55d326439580c3b8d0875a77d9"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.7"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "485193efd2176b88e6622a39a246f8c5b600e74e"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.6"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "9c209fb7536406834aa938fb149964b985de6c83"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.1"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random", "SnoopPrecompile"]
git-tree-sha1 = "aa3edc8f8dea6cbfa176ee12f7c2fc82f0608ed3"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.20.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "7a60c856b9fa189eb34f5f8a6f6b5529b7942957"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.6.1"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "89a9db8d28102b094992472d333674bd1a83ce2a"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.1"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "e8119c1a33d267e16108be441a287a6981ba1630"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.14.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "a4ad7ef19d2cdc2eff57abbbe68032b1cd0bd8f8"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.13.0"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "7be5f99f7d15578798f338f5433b6c432ea8037b"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "3b245d1e50466ca0c9529e2033a3c92387c59c2f"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.9"

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "Setfield", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "ed1b56934a2f7a65035976985da71b6a65b4f2cf"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.18.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "00e252f4d706b3d55a8863432e742bf5717b498d"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.35"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.Functors]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "7ed0833a55979d3d2658a60b901469748a6b9a7c"
uuid = "d9f16b24-f501-4c13-a1f2-28368ffc5196"
version = "0.4.3"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "4423d87dc2d3201f3f1768a29e807ddc8cc867ef"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.71.8"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "3657eb348d44575cc5560c80d7e55b812ff6ffe1"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.71.8+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "37e4657cd56b11abe3d10cd4a1ec5fbdb4180263"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.7.4"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.Juno]]
deps = ["Base64", "Logging", "Media", "Profile"]
git-tree-sha1 = "07cb43290a840908a771552911a6274bc6c072c7"
uuid = "e5e0dc1b-0480-54bc-9374-aad01c23163d"
version = "0.8.4"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "2422f47b34d4b127720a18f86fa7b1aa2e141f29"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.18"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Librsvg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pango_jll", "Pkg", "gdk_pixbuf_jll"]
git-tree-sha1 = "ae0923dab7324e6bc980834f709c4cd83dd797ed"
uuid = "925c91fb-5dd6-59dd-8e8c-345e74382d89"
version = "2.54.5+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "7bbea35cec17305fc70a0e5b4641477dc0789d9d"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.2.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "0a1b7c2863e44523180fdb3146534e265a91870b"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.23"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "cedb76b37bc5a6c702ade66be44f831fa23c681e"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.0"

[[deps.Luxor]]
deps = ["Base64", "Cairo", "Colors", "Dates", "FFMPEG", "FileIO", "Juno", "LaTeXStrings", "Random", "Requires", "Rsvg", "SnoopPrecompile"]
git-tree-sha1 = "909a67c53fddd216d5e986d804b26b1e3c82d66d"
uuid = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
version = "3.7.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Media]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "75a54abd10709c01f1b86b84ec225d26e840ed58"
uuid = "e89f7d12-3494-54d1-8411-f7d8b9ae1f27"
version = "0.5.0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "a0b464d183da839699f4c79e7606d9d186ec172c"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.3"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "6503b77492fd7fcb9379bf73cd31035670e3c509"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.3.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9ff31d101d987eb9d66bd8b176ac7c277beccd09"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.20+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Optim]]
deps = ["Compat", "FillArrays", "ForwardDiff", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "1903afc76b7d01719d9c30d3c7d501b61db96721"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.7.4"

[[deps.Optimisers]]
deps = ["ChainRulesCore", "Functors", "LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "e5a1825d3d53aa4ad4fb42bd4927011ad4a78c3d"
uuid = "3bd65402-5787-11e9-1adc-39752487f4e2"
version = "0.2.15"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.40.0+0"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "84a314e3926ba9ec66ac097e3635e270986b0f10"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.50.9+0"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "478ac6c952fddd4399e71d4779797c538d0ff2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.8"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "c95373e73290cf50a8a22c3375e4625ded5c5280"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.4"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SnoopPrecompile", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "f49a45a239e13333b8b936120fe6d793fe58a972"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.38.8"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "5bb5129fdd62a2bbbe17c2756932259acf467386"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.50"

[[deps.PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "261dddd3b862bd2c940cf6ca4d1c8fe593e457c8"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.3"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase", "SnoopPrecompile"]
git-tree-sha1 = "e974477be88cb5e3040009f3767611bc6357846f"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.11"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rsvg]]
deps = ["Cairo", "Glib_jll", "Librsvg_jll"]
git-tree-sha1 = "3d3dc66eb46568fb3a5259034bfc752a0eb0c686"
uuid = "c4c386cf-5103-5370-be45-f3a111cca3b8"
version = "1.0.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "ef28127915f4229c971eb43f3fc075dd3fe91880"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.2.0"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "6aa098ef1012364f2ede6b17bf358c7f1fbe90d4"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.17"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "94f38103c984f89cf77c402f2a68dbd870f8165f"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.11"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "ed8d92d9774b077c53e1da50fd81a36af3744c1c"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "93c41695bc1c08c46c5899f4fe06d6ead504bb73"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.3+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c6edfe154ad7b313c01aceca188c05c835c67360"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.4+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.gdk_pixbuf_jll]]
deps = ["Artifacts", "Glib_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Xorg_libX11_jll", "libpng_jll"]
git-tree-sha1 = "e9190f9fb03f9c3b15b9fb0c380b0d57a3c8ea39"
uuid = "da03df04-f53b-5353-a52f-6a8b0620ced0"
version = "2.42.8+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╟─6644b213-63ed-4814-b034-0b39caa04f23
# ╟─c85bdb41-ce56-48ce-a82c-6599ccbc446c
# ╟─013c7dac-a8c6-4fff-8837-e4d6751f3fb6
# ╟─3dc062b0-30d0-4332-9047-0852671cb031
# ╟─7345a2c1-d4b7-470f-a936-b4cc6c177399
# ╟─7c26b07f-6a1f-4d40-9152-b8738a1dad62
# ╟─6b4307ea-33c0-4a20-af35-d05262856528
# ╟─647a7101-ebdc-4717-a343-22edee8a7d92
# ╟─f784dc43-5058-4375-9040-f343c346cff8
# ╟─1a959468-3add-4e34-a9fe-54ca67a12894
# ╟─90472087-2580-496e-989e-e4fa58fd1e17
# ╟─0c5dd6d1-20cd-4ec6-9017-80dbc705b75d
# ╠═e6ab2552-6597-4bef-a9c1-e0cea14b0f67
# ╠═d16748d2-e157-43d2-b6fe-69cbe4a5dd9c
# ╟─66416807-bcb0-4881-90f8-1595756e4a6f
# ╠═43486a15-7582-4532-b2ac-73db4bb07f97
# ╟─962f24ff-2adc-41e3-bc5c-2f78952950d2
# ╟─1024bec9-6741-4cf6-a214-9777c17d2348
# ╠═f859faaa-b24e-4af2-8b72-85f2d753e87a
# ╠═1ed6d587-b984-463f-9db3-220bdfa81ebe
# ╠═c16945b6-397e-4cc2-9f74-9c0e6eb21a8c
# ╠═81b628ce-91b1-4b63-aca1-96e10c49d7b9
# ╠═44f3252c-cb3b-458f-b3b9-a87ce9f6e0e2
# ╠═f020f39c-e756-4c09-8ab3-7d10e78ca43e
# ╠═c1c02449-50e7-4dc4-8807-a31b10624921
# ╟─50f91cd8-c74b-11ed-0b94-cdeb596bf99b
# ╟─211b6c56-f16b-47fb-ba56-4534ac41be95
# ╟─eec10666-102c-44b6-a562-75ba78428d1e
# ╟─d59aaccf-1435-4c7b-998e-5dfb174990c3
# ╟─10283699-2ebc-4e61-89e8-5585a2bf054d
# ╠═4136799e-c4ab-432b-9e8a-208b0eae060e
# ╠═3e616d99-7d57-4926-b1d5-dae47dd040e9
# ╠═004a79b8-afbd-40b7-9c67-a8e864432179
# ╠═8d0dbc03-f927-4229-a8ce-6196cb62bde2
# ╠═599b0416-d1e7-4e92-8604-80bda896d88b
# ╟─95ac921c-20c6-432e-8a70-006804d6b0da
# ╟─3212c3f2-f3c3-4403-9584-85386db6825c
# ╠═50feee93-6a1f-4256-822f-88ceede1bbec
# ╠═859705f4-9b5f-4403-a9ef-d21e3cbd0b06
# ╟─e2a17f45-cc79-485b-abf2-fbc81a66f908
# ╟─5b911473-57b8-46a4-bdec-6f1960c1e958
# ╟─29ed621d-0505-4f8c-88fc-642a3ddf3ae8
# ╠═50b8dcf3-9cec-4487-8a57-249c213caa21
# ╠═09f542be-490a-42bc-81ac-07a318371ca3
# ╟─a4b4bc11-efb2-46db-b256-ba9632fadd7b
# ╟─8b74adc9-9e82-46db-a87e-a72928aff03f
# ╠═6dc932f9-d37b-4cc7-90d9-1ed0bae20c41
# ╠═8086d721-3360-4e66-b898-b3f1fb9e4392
# ╟─ce076be7-b930-4d35-b594-1009c87213a6
# ╠═6bc59fbc-14ae-4e07-8390-3195182e17a5
# ╟─ec098a81-5032-4d43-85bf-a51b0a19e94e
# ╟─6778a8ce-73a7-40e8-92bc-c9491daa9012
# ╟─dcf4a168-1c11-45f2-b7e7-15d6fb4becea
# ╠═77761a71-65ea-434b-a697-d86278d10abd
# ╟─6bee88e1-d641-4a28-9794-6031e721a79c
# ╟─cbdb2ad6-2a7d-4ccb-89f9-5ec836612477
# ╟─66cbb653-b06d-4b06-880b-f402fd9f1d53
# ╟─5af90753-f9cc-437f-9b11-98618fdb67aa
# ╟─e80a6b59-84d4-40e9-bf1b-08719016745e
# ╠═da2d74e5-d411-499b-b4c3-cb6dfefb8c8d
# ╠═a4832798-6e20-4630-889d-388fe55272f7
# ╟─89fb89d4-227f-41ba-8e42-68a9c436b930
# ╟─4ade7201-ae81-41ca-affb-fffcb99776fe
# ╟─3e406fc4-8bb1-4b11-ae9a-a33604061a8a
# ╠═d0166fdc-333b-495b-965e-1c77711ba469
# ╟─ab2ad24c-a019-4608-9344-23eb1025e108
# ╟─e6dca5dc-dbf9-45ba-970d-23bd9a75769d
# ╟─5b433d39-ed60-4831-a139-b6663a284e7a
# ╠═4b3de811-278b-4154-bce6-4d67dc19ff38
# ╟─1bf01867-adbe-4d00-a189-c0f024e65475
# ╟─2afe850b-cfd3-41de-b3e1-fafa44e9bbe2
# ╟─8a93097f-00c1-45b0-92a1-092aeccc58a5
# ╟─ce27c364-9ae3-435a-8153-a1c898ae8984
# ╟─afbc321c-c568-4b88-8dc1-9d87a4a0e7af
# ╟─7db726fc-b537-483a-8898-dd24b4f3aca2
# ╟─c76981ce-f1e5-4681-ad13-6188a962d962
# ╟─93b69c65-8df3-4782-8b39-20fb3879cbcc
# ╟─2e17a5f6-a942-4688-bc23-25b1715d9886
# ╟─47747e2d-52c7-47a5-aa06-1ce25f7dd7fe
# ╟─da2f6865-ff3c-46bd-80d4-f171b0e30ce9
# ╟─c75753d4-ceec-402e-a4bc-8b00b4934dbf
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
