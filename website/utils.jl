using Random

function hfun_bar(vname)
    val = Meta.parse(vname[1])
    return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
    var = vname[1]
    return pagevar("index", var)
end

function hfun_livecoding(src)
    id = "asciinema" * randstring()
	"""
<div id="$id" class="x"></div>
<script>
var target = document.getElementById('$id');
AsciinemaPlayer.create('$(src[1])', target);
</script>
"""
end

function hfun_msc()
    generate_list("modernscientificcomputing"; reverse=false)
end
function generate_list(folder; reverse)
    lst = String[]
    for item in readdir(folder)
        path = joinpath(folder, item)
        if endswith(item, ".md")
            open(path, "r") do f
                line = readline(f)
                date = readdate(item)
                title = readtitle(line)
                if isempty(date)
                    name = title
                else
                    name = "($date) " * title
                end
                push!(lst, """<li><a href="/$(path[1:prevind(path, length(path)-2)])">$(name)</a></li>""")
            end
        end
    end
    return "<ol>$(join(reverse ? lst[end:-1:1] : lst, "\n"))</ol>"
end

function readtitle(str::String)
    try
        ex = Meta.parse(str)
        if ex isa Expr && ex.head == :macrocall && ex.args[1] == Symbol("@def") && ex.args[3].head == :(=) && ex.args[3].args[1] == :title
            return ex.args[3].args[2]
        else
            return "title not found"
        end
    catch e
        return "title not found"
    end
end

function readdate(item)
    res = match(r"(\d+)-(\d+)-(\d+).*", item)
    if res === nothing
        return ""
    else
        return "$(res[1])-$(res[2])-$(res[3])"
    end
end

function lx_baz(com, _)
    # keep this first line
    brace_content = Franklin.content(com.braces[1]) # input string
    # do whatever you want here
    return uppercase(brace_content)
end
