# Hamburg.jl

A little package that makes various information about Hamburg, Germany available in an easily accessible fashion.

## Usage

```julia
] add Hamburg
using Hamburg
dataset(topic, dataset)
```

## Topics

### covid-19

![covid19](docs/clusters.png)

#### sources

Since July 27, 2020:

[hamburg.de](https://www.hamburg.de/corona-zahlen)

Since August 10, the number of hospitalized patients from this source is also being stored.

Before July 27, 2020:

[Robert Koch Institut](https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Situationsberichte/Gesamt.html)

The number of deaths are not quite matching up between those two datasources, it seems that the RKI is reporting around 30 more people who died through COVID-19.

The numbers reported to the RKI are also delayed by one day, the time of recording has been moved back one day to align with the dates from hamburg.de.

#### datasets

##### infected

Number of people infected by covid-19, recorded since July 27, 2020

`dataset("covid-19", "infected")`

**Columns**:

- **deaths**: Total number of deaths due to COVID-19
- **new**: New confirmed cases
- **recordedat**: Date of measurement
- **recovered**: Number of people recovered (not a precise number since people are not required to report recoveries)
- **total**: Total number of confirmed cases
- **hospitalizations**: Total number of hospitalized patients (due to covid 19), including the patients in intensive care
- **intensivecare**: Number of patients in intensive care due to covid 19
- **first_vaccination**: Number of people who received the first shot of the vaccine
- **second_vaccination**: Number of people who received the second shot of the vaccine

##### boroughs

The number infected, by borough.

These are aggregated numbers, representing the cases for the last 7 days. This is so that the privacy of individuals can be guaranteed.

`dataset("covid-19", "boroughs")`

##### agegroups

The distribution of age groups among the infected.

`dataset("covid-19", "agegroups")`

#### Examples

The dataset is used to show a [color-coded dashboard](https://oem.github.io/covid19/):

![covid19 hh dashboard](docs/dashboard.png 'COVID-19 in Hamburg')

There is an [example notebook](https://github.com/oem/Hamburg.jl/blob/master/docs/Hamburg.ipynb) that digs a bit deeper into the data and visualizes it.

#### as CSV

The datasets are also available as csv files, in case you want to use them separately:

[infected.csv](https://github.com/oem/Hamburg.jl/blob/master/src/covid-19/infected.csv)

[boroughs.csv](https://github.com/oem/Hamburg.jl/blob/master/src/covid-19/boroughs.csv)

[agegroups.csv](https://github.com/oem/Hamburg.jl/blob/master/src/covid-19/agegroups.csv)

The dataset sources will be checked for updates every day:

![DatasetUpdater](https://github.com/oem/Hamburg.jl/workflows/DatasetUpdater/badge.svg)

### holidays

#### sources

[publicholidays.de](https://publicholidays.de/school-holidays/hamburg/)

#### datasets

##### school

`dataset("holidays", "school")`

**Columns**:

- **name**: Name of the holiday
- **start**: Start date
- **end**: End date

## Contribute?

Yes, absolutely! If you have an interesting dataset, be it favourite ramen places in hamburg, high/low tide times or anything else, go for it. Just make sure that you provide your sources.
