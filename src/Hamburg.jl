module Hamburg

using CSV, DataFrames, Pipe
using Documenter, DocStringExtensions
export dataset

include("covid-19/Covid19.jl")
include("pollen/Pollen.jl")

"""
$(SIGNATURES)
Takes topic and name of the specific dataset and loads it into a DataFrame.

# Examples
```julia-repl
julia> dataset("covid-19", "infected")
```
"""
function dataset(topic::String, dataset::String)::DataFrame
    CSV.read(joinpath(@__DIR__, topic, "$dataset.csv"), DataFrame)
end

end # module
