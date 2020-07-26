module Covid19

using HTTP, Gumbo, Cascadia, HTTP
using Cascadia: matchFirst

export fetchcurrent

const URL = "https://www.hamburg.de/corona-zahlen/"

function fetchcurrent()
  response = HTTP.get(URL)
  html = Gumbo.parsehtml(String(response))
  confirmed = parseconfirmed(html.root)
  confirmed
end

function parseconfirmed(root)
  el = matchFirst(sel".c_chart.one .chart_legend li", root)
  text = el[2].text
  parse(Int, match(r"\d+", text).match)
end

end # module
