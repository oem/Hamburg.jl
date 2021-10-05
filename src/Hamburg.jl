module Hamburg

using CSV, DataFrames
using Documenter, DocStringExtensions
export dataset

include("covid-19/Covid19.jl")
include("pollen/Pollen.jl")

"""
$(SIGNATURES)
Takes topic and name of the specific dataset and loads it into a DataFrame.

# Examples
```julia-repl
julia> dataset("covid-19", :infected)
```

```julia-repl
julia> dataset("covid-19", :infected, fetch = true)
```
"""
function dataset(topic::String, dataset::Symbol; fetch::Bool = false)::DataFrame
    if fetch
        if topic == "covid-19"
            Covid19.fetch() |> Covid19.parse |> Covid19.build
        else
            throw(ArgumentError("live-fetching for $topic/$dataset is currently not supported. But go ahead and open an issue on github if you need this, always happy to hear from you!"))
        end
    else
        CSV.read(joinpath(@__DIR__, topic, "$dataset.csv"), DataFrame)
    end
end

end # module
