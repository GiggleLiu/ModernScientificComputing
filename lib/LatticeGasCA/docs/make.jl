using LatticeGasCA
using Documenter

DocMeta.setdocmeta!(LatticeGasCA, :DocTestSetup, :(using LatticeGasCA); recursive=true)

makedocs(;
    modules=[LatticeGasCA],
    authors="GiggleLiu <cacate0129@gmail.com> and contributors",
    repo="https://github.com/GiggleLiu/LatticeGasCA.jl/blob/{commit}{path}#{line}",
    sitename="LatticeGasCA.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://GiggleLiu.github.io/LatticeGasCA.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/GiggleLiu/LatticeGasCA.jl",
    devbranch="main",
)
