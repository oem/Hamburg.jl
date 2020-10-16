module Covid19

using HTTP, Gumbo, CSV, Cascadia, DataFrames
using Cascadia: matchFirst

include("DatesInGerman.jl")

const URL = "https://www.hamburg.de/corona-zahlen/"
const CSV_INFECTED = joinpath(@__DIR__, "infected.csv")
const CSV_BOROUGHS = joinpath(@__DIR__, "boroughs.csv")

function fetchcurrent()
    response = HTTP.get(URL)
    html = parsehtml(String(response))

    infected = parseinfected(html.root)
    deaths = parsedeaths(html.root)
    hospitalizations = parsehospitalizations(html.root)
    trend = parsetrend(html.root)
    boroughs = parseboroughs(html.root)
    recordedat = parsedateinfected(html.root)
    agegroups = parseagegroups(html.root)

    Dict(:infected => Dict(:total => infected[1], :recovered => infected[2], :new => infected[3], :recordedat => recordedat),
       :deaths => Dict(:total => deaths[1], :new => deaths[2]),
       :hospitalizations => Dict(:total => hospitalizations[1], :intensivecare => hospitalizations[2]),
       :trend => trend,
       :boroughs => boroughs,
       :agegroups => agegroups)
end

function parseinfected(root)
    map(parsenumbers, eachmatch(sel".c_chart.one .chart_legend li", root))
end

function parsedateinfected(root)
    daterecorded = matchFirst(sel".chart_publication", root)[1].text
    DatesInGerman.parsefrom(daterecorded)
end

function parsedateboroughs(root)
    daterecorded = eachmatch(sel".table-article + p", root)[end][1].text
    DatesInGerman.parsefrom(daterecorded)
end

function parsedeaths(root)
    map(parsenumbers, eachmatch(sel".c_chart.two .chart_legend li:not(.c_chart_show_noshow)", root))
end

function parsehospitalizations(root)
    map(parsenumbers, eachmatch(sel".c_chart.three .chart_legend li", root))
end

function parsetrend(root)
    map(el -> parse(Int, el[1].text), eachmatch(sel".cv_chart_container .value_show", root))
end

function parseboroughs(root)
    rows = eachmatch(sel".table-article tr", root)[20:end]
    mapped = Dict{String,Any}()
    foreach(rows) do row
        name = matchFirst(sel"td:first-child", row)[1].text
        num = parse(Int, matchFirst(sel"td:last-child", row)[1].text)
        mapped[name] = num
    end
    mapped["recordedat"] = parsedateboroughs(root)
    mapped
end

function parseagegroups(root)
    rows = eachmatch(sel".table-article tr", root)[8:18]
    mapped = Dict()
    foreach(rows) do row
        age = matchFirst(sel"[data-label=\"Alter\"]", row)[1].text |> parseage
        male = parse(Int, row[2][1].text)
        female = parse(Int, row[3][1].text)
        mapped[age] = Dict(:male => male, :female => female)
    end
    mapped
end

function parseage(age::String)::Union{Int,UnitRange{Int}}
    agerange = match(r"^(\d+).+?(\d+)", age)
    if ! isnothing(agerange)
        return parse(Int, agerange.captures[1]):parse(Int, agerange.captures[2])
    end

    young = match(r"^bis.(\d+).+$", age)
    if ! isnothing(young)
        return 0:parse(Int, young.captures[1])
    end

    old = match(r"über.(\d+).*$", age)
    if ! isnothing(old)
        return parse(Int, old.captures[1])
    end
    throw(ArgumentError("Age $age could not be parsed."))
end

function parsenumbers(el)
    text = el[2].text
    parse(Int, match(r"\d+", text).match)
end

function record()
    current = fetchcurrent()
    recordinfected(current)
    recordboroughs(current)
    return
end

function recordinfected(current)
    infected = current[:infected]
    infected[:deaths] = current[:deaths][:total]
    infected[:hospitalizations] = current[:hospitalizations][:total]
    infected[:intensivecare] = current[:hospitalizations][:intensivecare]
    df = DataFrame(infected)
    persisted = CSV.read(CSV_INFECTED, DataFrame)
    unique(vcat(df, persisted), :recordedat) |> CSV.write(CSV_INFECTED)
end

function recordboroughs(current)
    df = DataFrame(current[:boroughs])
    persisted = CSV.read(CSV_BOROUGHS, DataFrame)
    unique(vcat(df, persisted), :recordedat) |> CSV.write(CSV_BOROUGHS)
end

end # module
