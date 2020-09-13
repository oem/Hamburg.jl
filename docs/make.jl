using Pkg
pkg"activate .."
push!(LOAD_PATH, "../src/")
using Documenter, Hamburg

makedocs(sitename="Hamburg Documentation")
