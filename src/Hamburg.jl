module Hamburg

using CSV, DataFrames
export dataset

include("covid-19/Covid19.jl")
"""
`dataset` exposes various datasets, organized by topic.\n
General usage: `dataset(topic, dataset)`\n
For example: `dataset("covid-19", "infected")`
"""
function dataset(topic, dataset)
    CSV.read(joinpath(@__DIR__, topic, "$dataset.csv"))
end

end # module
