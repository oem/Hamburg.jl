module Hamburg

using CSV, DataFrames
export dataset

include("covid-19/Covid19.jl")

function dataset(topic, dataset)
    CSV.read("src/$topic/$dataset.csv", DataFrame)
end

end # module
