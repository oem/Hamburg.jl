module Pollen

using HTTP, Gumbo, CSV, Cascadia, DataFrames, JSON, Dates
using Cascadia:matchFirst

const URL = "https://www.wetteronline.de/?gid=10147&pcid=pc_city_pollen&sid=StationDetail"
const CSV_POLLEN = joinpath(@__DIR__, "pollen.csv")

function fetch()
    response = HTTP.get(URL)
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
    date = dates) |> DataFrame
end

function record()
    persisted = CSV.read(CSV_POLLEN, DataFrame)
    df = fetch()
    unique(vcat(df, persisted), :date) |> CSV.write(CSV_POLLEN)
end

function parsedate(root)
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