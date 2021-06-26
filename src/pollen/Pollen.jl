module Pollen

using HTTP, Gumbo, CSV, Cascadia, DataFrames, JSONTables, Dates, Query
using Pipe:@pipe
using Cascadia:matchFirst

const CSV_POLLEN = joinpath(@__DIR__, "levels.csv")
const JSON_POLLEN = joinpath(@__DIR__, "levels.json")

function fetch()::NamedTuple
    url = ENV["POLLEN_API_URL"]
    response = HTTP.get(url)
    html = parsehtml(String(response))
    dates = parsedate(html.root)
    elm, willow, poplar, hazel, alder, oak, beech, birch, mugwort, ragweed, plantain, sorrel, rye, grass = parsetable(html.root)

    (elm = elm,
    willow = willow,
    poplar = poplar,
    hazel = hazel,
    alder = alder,
    oak = oak,
    beech = beech,
    birch = birch,
    mugwort = mugwort,
    ragweed = ragweed,
    plantain = plantain,
    sorrel = sorrel,
    rye = rye,
    grass = grass,
    date = dates)
end

function record()
    persisted = CSV.read(CSV_POLLEN, DataFrame)
    df = @pipe fetch() |> DataFrame |> vcat(_, persisted) |> unique(_, :date) |> sort!(_, :date, rev=true)
    df |> CSV.write(CSV_POLLEN)

    open(JSON_POLLEN, "w") do f
        write(f, arraytable(df |> @mutate(formatted_date = format_date(_.date)) |> DataFrame))
    end
end

format_date(date::Date)::String = "$(Dates.dayname(date)), $(Dates.monthname(date)) $(Dates.day(date))"

function parsedate(root)::Vector{Date}
    datestring = matchFirst(sel"#date0 p", root)[1].text
    parts = match(r"(\d+)\.(\d+)\.", datestring).captures
    current = Date(Dates.year(today()), parse(Int, parts[2]), parse(Int, parts[1]))
    collect(current:Dates.Day(1):current + Dates.Day(6))
end

function parsetable(root)
    table = matchFirst(sel"#pollen_tabelle", root)
    parsecategories(table, ("elm_text",
                            "wil_text",
                            "pop_text",
                            "haz_text",
                            "ald_text",
                            "oak_text",
                            "bee_text",
                            "bir_text",
                            "mug_text",
                            "hog_text",
                            "pla_text",
                            "rum_text",
                            "rye_text",
                            "gra_text",))
end

parsecategories(table, selectors) = map(s -> parsecategory(table, s), selectors)

function parsecategory(table, selector)
    category = matchFirst(Selector("#$selector + .grid_item_pollen_tabelle"), table)
    map(b -> grade(b), dayvalues(category))
end

function dayvalues(category)
    [category.attributes["data-day0"],
     category.attributes["data-day1"],
     category.attributes["data-day2"],
     category.attributes["data-day3"],
     category.attributes["data-day4"],
     category.attributes["data-day5"],
     category.attributes["data-day6"]]
end

function grade(burden)
    burdens = ("noburden", "weakburden", "moderateburden", "strongburden")
    findfirst(b -> b == burden, burdens) - 1
end

end # module