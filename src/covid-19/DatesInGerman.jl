module DatesInGerman

using Dates

const MONTHS = ("januar", "februar", "märz", "april", "mai", "juni", "juli", "august", "september", "oktober", "november", "dezember")

function parsefrom(date::String; inwords::Bool=true)::Date
    inwords ? date |> fromwords : date |> fromnumbers
end

function fromwords(date::String)::Date
    parts = match(r"(\d+).\s*(\S+)\s*(\d{4})", date).captures
    Date(parse(Int, parts[3]),
           findfirst(m -> m == lowercase(parts[2]), MONTHS),
           parse(Int, parts[1]))
end

function fromnumbers(date::String)::Date
    parts = match(r"(\d+)\.(\d+)\.(\d+)", date).captures
    Date(parse(Int, (parts[3])),
             parse(Int, parts[2]),
             parse(Int, parts[1]))
end

end # module
