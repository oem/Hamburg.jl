module Hamburg

using CSV
export datasets

include("covid-19/Covid19.jl")

function datasets(topic, dataset)
  CSV.read("$topic/$dataset.csv")
end

end # module
