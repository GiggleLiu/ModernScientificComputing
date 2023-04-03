export print_dir_tree, print_dependency_tree, print_type_tree

# directory
function AbstractTrees.children(path::Pair{String, String})
	base, fname = path
	full = joinpath(base, fname)
	isdir(full) || return Pair{String, String}[]
    return [base=>joinpath(fname, f) for f in readdir(full) if f !== ".git"]
end

function AbstractTrees.printnode(io::IO, path::Pair{String, String})
	print(io, startswith(path.second, "./") ? path.second[3:end] : path.second)
end

function print_dir_tree(dir; maxdepth=5)
	io = IOBuffer()
	AbstractTrees.print_tree(io, dir=>"."; maxdepth)
	Text(String(take!(io)))
end

function AbstractTrees.printnode(io::IO, uuid::Base.UUID)
    pkg_registries = Pkg.Operations.Context().registries;
    dep = get(Pkg.dependencies(), uuid, nothing)
	link = collect(Pkg.Operations.find_urls(pkg_registries, uuid))
	if length(link) > 0
    	print(io, "<a href=\"$(link[1])\">$(dep.name)</a> (v$(dep.version))")
	else
		print(io, "$(dep.name)")
	end
end

function print_dependency_tree(pkg; maxdepth=5)
	io = IOBuffer()
	AbstractTrees.print_tree(io, Pkg.project().dependencies[string(pkg)]; maxdepth)
	HTML("<p style='font-family: Consolas; line-height: 1.2em; max-height: 300px;'>" * replace(String(take!(io)), "\n"=>"<br>") * "</p>")
end

# Type tree
AbstractTrees.children(x::Type) = subtypes(x)

_typestr(T) = T isa UnionAll ? _typestr(T.body) : T

function AbstractTrees.printnode(io::IO, x::Type{T}) where T
	print(io, _typestr(T))
end

function print_type_tree(T; maxdepth=5)
	io = IOBuffer()
	AbstractTrees.print_tree(io, T; maxdepth)
	Text(String(take!(io)))
end
