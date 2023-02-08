# livecoding
function livecoding(src)
	HTML("""
<div></div>
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/asciinema-player@3.0.1/dist/bundle/asciinema-player.css" />
<script src="https://cdn.jsdelivr.net/npm/asciinema-player@3.0.1/dist/bundle/asciinema-player.min.js"></script>
<script>
var target = currentScript.parentElement.firstElementChild;
AsciinemaPlayer.create('$src', target);
target.firstChild.firstChild.firstChild.style.background = "#000000";
target.firstChild.firstChild.firstChild.style.color = "#FFFFFF";
</script>
""")
end

# mermain diagram
macro mermaid_str(str)
	return HTML("""<script src="https://cdn.bootcss.com/mermaid/8.14.0/mermaid.min.js"></script>
<script>
  // how to do it correctly?
  mermaid.init({
    noteMargin: 10
  }, ".someClass");
</script>

<div class="mermaid someClass">
  $str
</div>
""")
end

function del(str)
    return HTML("<del>$str</del>")
end

if isdefined(@__MODULE__, :AbstractTrees)
# print directory
function print_dir_tree(dir; maxdepth=5)
	io = IOBuffer()
	AbstractTrees.print_tree(io, dir=>"."; maxdepth)
	Text(String(take!(io)))
end

function AbstractTrees.children(path::Pair{String, String})
	base, fname = path
	full = joinpath(base, fname)
	isdir(full) || return Pair{String, String}[]
    return [base=>joinpath(fname, f) for f in readdir(full) if f !== ".git"]
end

function AbstractTrees.printnode(io::IO, path::Pair{String, String})
	print(io, startswith(path.second, "./") ? path.second[3:end] : path.second)
end
end

######## Layouts ########
# keyboard
function kbd(str)
    return HTML("<kbd>$(string(str))</kbd>")
end
# left right layout
function leftright(a, b; width=600, left=0.5)
    HTML("""
<style>
table.nohover tr:hover td {
background-color: white !important;
}</style>
        
<table width=$(width)px class="nohover" style="border:none">
<tr>
<td width=$(width*left)>$(html(a))</td>
<td width=$(width*(1-left))>$(html(b))</td>
</tr></table>
""")
end

# up down layout
function updown(a, b; width=nothing)
    HTML("""<table class="nohover" style="border:none" $(width === nothing ? "" : "width=$(width)px")>
<tr>
<td>$(html(a))</td>
</tr>
<tr>
<td>$(html(b))</td>
</tr></table>
""")
end

function highlight(str)
    HTML("""<span style="background-color:yellow">$(str)</span>""")
end

function present()
html"""
<style>
ul li { margin-bottom: 0.5em; }
body {font-size: 18pt;}
</style>
<script>
document.body.onkeyup = function(e) {
if (e.ctrlKey && e.altKey && e.which == 80) {
    present();
} else if (e.ctrlKey && e.which == 37) {
	var prev_button = document.querySelector(".changeslide.prev");
	prev_button.dispatchEvent(new Event('click'));
} else if (e.ctrlKey && e.which == 39) {
	var prev_button = document.querySelector(".changeslide.next");
	prev_button.dispatchEvent(new Event('click'));
  }
};
document.body.onclick = function(e) {
	if (e.target.tagName == 'BODY'){
		e.preventDefault();
		var prev_button = document.querySelector(".changeslide.next");
		prev_button.dispatchEvent(new Event('click'));
} else if (e.target.tagName == 'PLUTO-SHOULDER'){
	e.preventDefault();
	var prev_button = document.querySelector(".changeslide.prev");
	prev_button.dispatchEvent(new Event('click'));
	}
};
</script>
"""
end

html"""
<style>
pre {
  margin: 5px 0 ;
}
pluto-output.rich_output pre:not(.no-block) {
  position: relative;
  padding: 1.0rem 0 1.0rem 1rem;
  border-radius: 5px;

  /* more stuff */
}

pre:not([class="no-block"]) button{
  position: absolute;
  top: 5px;
  right: 5px;

  /* more stuff */
}
pluto-output.rich_output pre:not([class="no-block"])>code[class*="language-"] {
  border-radius: 0px;
  white-space: pre-wrap;
  word-break: break-all;
}
</style>

<script>
const copyButtonLabel = "Copy Code";

// use a class selector if available
let blocks = document.querySelectorAll("pluto-output.rich_output pre:not(.no-block)");

blocks.forEach((block) => {
  // only add button if browser supports Clipboard API
  block.setAttribute("tabindex", 0);
  if (navigator.clipboard) {
    let button = document.createElement("button");

    button.innerText = copyButtonLabel;
    block.appendChild(button);

    button.addEventListener("click", async () => {
      await copyCode(block, button);
    });
  }
});

async function copyCode(block, button) {
  let code = block.querySelector("code");
  let text = code.innerText;

  await navigator.clipboard.writeText(text);

  // visual feedback that task is completed
  button.innerText = "Code Copied";

  setTimeout(() => {
    button.innerText = copyButtonLabel;
  }, 700);
}</script>
"""
