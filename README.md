# Hamburg.jl

A little package that makes various information about Hamburg, Germany available in an easily accessible fashion.

## Usage

```julia
]add https://github.com/oem/Hamburg.jl
using Hamburg
dataset(topic, dataset)
```

## Topics

### covid-19

#### Sources

Since July 27, 2020:

[hamburg.de](https://www.hamburg.de/corona-zahlen)

Before July 27, 2020:

[Robert Koch Institut](https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Situationsberichte/Gesamt.html)

#### datasets

##### infected

Number of people infected by covid-19, recorded since July 27, 2020

`dataset("covid-19", "infected")`

##### boroughs

The number infected, by borough.

These are aggregated numbers, representing the cases for the last 14 days. This is so that the privacy of individuals can be guaranteed.

`dataset("covid-19", "boroughs")`
