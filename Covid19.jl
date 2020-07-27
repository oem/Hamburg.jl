module Covid19

using HTTP, Gumbo, Cascadia
using Cascadia: matchFirst

export fetchcurrent

const URL = "https://www.hamburg.de/corona-zahlen/"

function fetchcurrent()
  response = HTTP.get(URL)
  html = parsehtml(String(response))
  infected = parseinfected(html.root)
  deaths = parsedeaths(html.root)
  hospitalizations = parsehospitalizations(html.root)
  trend = parsetrend(html.root)
  Dict(:infected => Dict(:total => infected[1], :recovered => infected[2], :new => infected[3]),
       :trend => trend)
end

function parseinfected(root)
  map(parsenumbers, eachmatch(sel".c_chart.one .chart_legend li", root))
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

function parsenumbers(el)
  text = el[2].text
  parse(Int, match(r"\d+", text).match)
end

end # module
