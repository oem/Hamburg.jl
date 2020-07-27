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
  @show infected
  @show deaths
end

function parseinfected(root)
  map(parsenumbers, eachmatch(sel".c_chart.one .chart_legend li", root))
end

function parsedeaths(root)
  map(parsenumbers,eachmatch(sel".c_chart.two .chart_legend li:not(.c_chart_show_noshow)", root))
end

function parsenumbers(el)
  text = el[2].text
  parse(Int, match(r"\d+", text).match)
end

end # module
