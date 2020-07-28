# Hamburg.jl

A little package that makes various information about Hamburg, Germany available in an easily accessible fashion.

## Usage

```julia
using Hamburg
datasets(topic, dataset)
```

## Topics

### covid-19

Source: [hamburg.de](https://www.hamburg.de/corona-zahlen)

#### datasets

**infected**: Number of people infected by covid-19, recorded since July 27, 2020

`datasets("covid-19", "infected")`

**boroughs**: The number infected, by borough.

These are aggregated numbers, representing the cases for the last 14 days. This is so that the privacy of individuals can be guaranteed.

`datasets("covid-19", "boroughs")`
