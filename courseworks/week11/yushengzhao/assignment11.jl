### A Pluto.jl notebook ###
# v0.19.19

using Markdown
using InteractiveUtils

# ╔═╡ 964c0fcd-60ce-4d8b-bed3-f1f6f5f1d8b3
begin 
using DataStructures 
end

# ╔═╡ 0f860824-e73f-11ed-146b-c33ae9c33cc8
# following code from lecture
struct Node{VT,PT}
    value::Union{VT,Nothing}
    prob::PT
    left::Union{Node{VT,PT},Nothing}
    right::Union{Node{VT,PT},Nothing}
end

# ╔═╡ be7181a4-b626-47ed-9cad-1b1f04ae052d
# this too
function huffman_tree(symbols, probs)
    isempty(symbols) && error("empty input!")
    # priority queue can keep the items ordered with log(# of items) effort.
    nodes = PriorityQueue(Base.Order.Forward,
        [Node(c, f, nothing, nothing) => f for (c, f) in zip(symbols, probs)])
    while length(nodes) > 1
        left = dequeue!(nodes)
        right = dequeue!(nodes)
        parent = Node(nothing, left.prob + right.prob, left, right)
        enqueue!(nodes, parent => left.prob + right.prob)
    end
    return dequeue!(nodes)
end

# ╔═╡ bf2ed6c6-637f-443a-8449-6dd496d1f67f
function decent!(tree::Node{VT}, prefix::String="", d::Dict = Dict{VT,String}()) where VT
	if tree.left === nothing # leaft
		d[tree.value] = prefix
	else   # non-leaf
		decent!(tree.left, prefix*"0", d)
		decent!(tree.right, prefix*"1", d)
	end
	return d
end

# ╔═╡ 5d8a17ec-b298-40c5-8146-458e46d80d44
text = raw"Compressed sensing (also known as compressive sensing, compressive sampling, or sparse sampling) is a signal processing technique for efficiently acquiring and reconstructing a signal, by finding solutions to underdetermined linear systems. This is based on the principle that, through optimization, the sparsity of a signal can be exploited to recover it from far fewer samples than required by the Nyquist-Shannon sampling theorem. There are two conditions under which recovery is possible. The first one is sparsity, which requires the signal to be sparse in some domain. The second one is incoherence, which is applied through the isometric property, which is sufficient for sparse signals."

# ╔═╡ 8463120f-0487-4d61-a941-e1ca52f11953
begin
    # initialize empty dictionary
    freq_dict = Dict()
    for i in 1:length(text)
        if haskey(freq_dict, text[i])
            freq_dict[text[i]] += 1.0
        else
            freq_dict[text[i]] = 1.0
        end
    end
    # print out the frequency of each character
    # sort the dictionary by value
	symbols = Char[]
	probs = Float64[]
    for (k,v) in sort(collect(freq_dict), by=x->x[2], rev=true)
		push!(symbols,k)
		push!(probs,v/length(text))
        println("Frequency of Character $k: $(v/length(text)*100) %")
    end
	symbols = join(symbols)
    huff_tree = huffman_tree(symbols,probs)
    code_dict = decent!(huff_tree)
end

# ╔═╡ 7eb3012e-8d81-41b1-8873-d16601126969
begin
    println("Huffman Code Dictionary: ")
    for (k,v) in code_dict
        println("Character $k: $v")
    end
end

# ╔═╡ 16cdc639-74f0-4979-ad5f-993374d80788
mean_code_length = let
	code_length = 0.0
	for (symbol, prob) in zip(symbols, probs)
		code_length += length(code_dict[symbol]) * prob
	end
	code_length
end

# ╔═╡ 3e0497f7-299e-4b71-9b9e-02e8e179b12f
let
total_code_length = mean_code_length * length(text)
    println("The total code length is: $(ceil(Int,total_code_length))")
end

# ╔═╡ afa26a29-2cf7-474b-987e-14ac923ab789


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DataStructures = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"

[compat]
DataStructures = "~0.18.13"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "5a896dd2d0ff25ca4c1b15e3bcb710a969e917d6"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "7a60c856b9fa189eb34f5f8a6f6b5529b7942957"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.6.1"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "d321bf2de576bf25ec4d3e4360faca399afca282"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"
"""

# ╔═╡ Cell order:
# ╠═964c0fcd-60ce-4d8b-bed3-f1f6f5f1d8b3
# ╠═0f860824-e73f-11ed-146b-c33ae9c33cc8
# ╠═be7181a4-b626-47ed-9cad-1b1f04ae052d
# ╠═bf2ed6c6-637f-443a-8449-6dd496d1f67f
# ╠═5d8a17ec-b298-40c5-8146-458e46d80d44
# ╠═8463120f-0487-4d61-a941-e1ca52f11953
# ╠═7eb3012e-8d81-41b1-8873-d16601126969
# ╠═16cdc639-74f0-4979-ad5f-993374d80788
# ╠═3e0497f7-299e-4b71-9b9e-02e8e179b12f
# ╠═afa26a29-2cf7-474b-987e-14ac923ab789
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
