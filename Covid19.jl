module Covid19

using HTTP, Gumbo, Cascadia
using Cascadia: matchFirst

export fetchcurrent

const URL = "https://www.hamburg.de/corona-zahlen/"

function fetchcurrent()
  response = HTTP.get(URL)
  html = parsehtml(String(response))
  infected = parseinfected(html.root)
  infected
end

function parseinfected(root)
  infected, healed, new = map(eachmatch(sel".c_chart.one .chart_legend li", root)) do el
    text = el[2].text
    parse(Int, match(r"\d+", text).match)
  end
end

function parsedeaths(root)
  eachmatch(sel".c_chart.two .chart_legend li", root)
end

end # module
