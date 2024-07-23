using Documenter
using ThreadUtils
DocMeta.setdocmeta!(ThreadUtils, :DocTestSetup, :(using ThreadUtils); recursive=true)
makedocs(
    sitename = "ThreadUtils",
    format = Documenter.HTML(),
    modules = [ThreadUtils]
)
deploydocs(
    repo = "github.com/dokudo91/ThreadUtils.jl.git",
)