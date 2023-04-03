export hidepluto, presentmode, copycode, blackboard, livecoding, @mermaid_str,
    leftright, updown, fancydl, kbd, del, highlight, localimage, netimage,
    segments, showfile

"""
shortcut: `Ctrl+'`

Hide all pluto elements!
"""
function hidepluto(; showhelp=false)
    hidehelp = """
#helpbox-wrapper {
    display: none;
}
"""

HTML("""
<style>
body.hide_all_inputs pluto-input {
    display: none;
}
body.hide_all_inputs pluto-shoulder {
    display: none;
}
body.hide_all_inputs pluto-runarea {
    display: none;
}
body.hide_all_inputs pluto-cell {
    min-height: 0;
    margin-top: 0;
}
body.hide_all_inputs > header {
    display: none;
}

body.hide_all_inputs .add_cell {
    display: none;
}
body.hide_all_inputs footer {
    display: none;
}
$(showhelp ? "" : hidehelp)
</style>
<script>
//const button = document.querySelector("#showhide");
//button.onclick = () => {
    //document.body.classList.toggle("hide_all_inputs")
//}
document.onkeyup = function(e) {
  if (e.ctrlKey && e.which == 222) {
    document.body.classList.toggle("hide_all_inputs");
} else if (e.ctrlKey && e.altKey && e.which == 80) {
    present();
} else if (e.ctrlKey && e.which == 37) {
    prev_button = document.querySelector(".changeslide.prev");
    prev_button.dispatchEvent(new Event('click'));
} else if (e.ctrlKey && e.which == 39) {
    prev_button = document.querySelector(".changeslide.next");
    prev_button.dispatchEvent(new Event('click'));
  }
};
document.body.classList.toggle("hide_all_inputs");
</script>
""")
end

"""
shortcut (enter/exit present mode): `Ctrl+Alt+P`
shortcut (previous slide): `Ctrl+←` (or click on the left of the webpage)
shortcut (next slide): `Ctrl+→` (or click on the right of the webpage)

Turn on the present mode.
"""
function presentmode()
    html"""
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

"""
A fancier `dl` style.
"""
function fancydl()
    html"""
dl {
border: 3px double #ccc;
padding: 0.5em;
}
dt {
float: left;
clear: left;
width: 100px;
text-align: right;
font-weight: bold;
color: green;
}
dt::after {
content: ":";
}
dd {
margin: 0 0 0 110px;
padding: 0 0 0.5em 0;
}
"""
end

function blackboard(text::String; width::Int=620, height::Int=300, coding=false, subtitle="")
    pad = 15
    HTML("""<div style="width: $(width)px; height: $(height)px; background-color:#B89405; padding:$(pad)px">
         <div style="background-color: #002233; width:$(width-2pad)px; height:$(height-2pad)px; margin: auto; text-align: center; color: #FFFFFF; padding-top: $(pad)px">
         <p style="font-size: 24pt; font-family: cursive; vertical-align:middle; margin: auto; ">
         $(coding ? "<&#47;>" : "✎") $text</p>
         <p style="font-size: 20px;">$subtitle</p>
         </div>
         </div>""")
end

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
    HTML("""<table class="nohover" style="border:none; margin: 0px" $(width === nothing ? "" : "width=$(width)px")>
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

function copycode(code::String)
    HTML("""
    <pre style="margin:5px 0; position: relative; padding: 0 0 1.0rem 1rem; border-radius: 5px;">
    <button style="position: absolute; top: 5px; right: 5px">copy</button>
    <code style="border-radius: 0px; white-space: pre-wrap; word-break: break-all;">$code</code>
    </pre>
    <script>
    // use a class selector if available
    let block = currentScript.parentElement.firstElementChild;

    // only add button if browser supports Clipboard API
    block.setAttribute("tabindex", 0);
    if (navigator.clipboard) {
        let button = block.firstElementChild;
        button.addEventListener("click", async () => {
        await copyCode(block, button);
        });
    }

    async function copyCode(block, button) {
    let code = block.querySelector("code");
    let text = code.innerText;

    await navigator.clipboard.writeText(text);

    // visual feedback that task is completed
    button.innerText = "Code Copied";

    setTimeout(() => {
        button.inniiiiierText = "copy";
    }, 700);
    }</script>
    """)
end

function localimage(path::String; width=nothing, height=nothing)
    attrs = []
    width === nothing || push!(attrs, :width=>"$(width)px")
    height === nothing || push!(attrs, :height=>"$(height)px")
    LocalResource(path, attrs...)
end

function netimage(path::String; width=nothing, height=nothing)
    attrs = []
    width === nothing || push!(attrs, "width"=>"$(width)px")
    height === nothing || push!(attrs, "height"=>"$(height)px")
    return HTML("""<img src="$path" style="$(joinstyle(attrs))"/>""")
end
joinstyle(attrs) = join(["$x:$y" for (x, y) in attrs], "; ")

function segments(ratios, texts; height=30,
        colors=fill("transparent", length(ratios)),
        textcolor="black", bordercolor="black")
    ls = round.(Int, ratios / sum(ratios) .* 100)
    @assert length(ls) == length(texts) == length(colors)
    divs = "<tr>" * join(["""<td style="vertical-align: middle; color:$(textcolor); text-align: center;background-color:$c; width: $l%; height:$(height)px; border: 1px solid $bordercolor; border-collapse: collapse">$t</td>""" for (l, t, c) in zip(ls, texts, colors)], "") * "</tr>"
    divs = "<tr>" * join(["""<td style="text-align: center; width: $l%; height:30px; border-style: none;">$t</td>""" for (l, t) in zip(ls, ratios)], "") * "</div>" * divs
    return HTML("""<table style="width:100%; border-style: none; margin: 0px">$divs</table>""")
end

function showfile(filename)
	Text("FILE: $filename\n"* ("-"^80) * "\n" * read(filename, String) * "\n")
end
