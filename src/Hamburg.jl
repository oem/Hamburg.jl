module Hamburg

using CSV
export dataset

include("covid-19/Covid19.jl")

function dataset(topic, dataset)
  CSV.read("src/$topic/$dataset.csv")
end

end # module
