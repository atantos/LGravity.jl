using LGravity
using Documenter

DocMeta.setdocmeta!(LGravity, :DocTestSetup, :(using LGravity); recursive=true)

makedocs(;
    modules=[LGravity],
    authors="Alex Tantos",
    repo="https://github.com/atantos/LGravity.jl/blob/{commit}{path}#{line}",
    sitename="LGravity.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://atantos.github.io/LGravity.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/atantos/LGravity.jl",
)
