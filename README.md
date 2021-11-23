
# racademyocean

<!-- badges: start -->
<!-- badges: end -->

The goal of racademyocean is loading data from [AcademyOcean API](https://academyocean.com/api).

## Installation

You can install the development version of racademyocean from CRAN:

``` r
install.packages("racademyocean")
```

Or [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("selesnow/racademyocean")
```

## Functions of racademyocean

* `ao_auth()`
* `ao_get_academies()`
* `ao_get_certificates()`
* `ao_get_leaners()`
* `ao_get_teams()`
* `ao_course_progress()`
* `ao_get_leaners_amount_from_countries()`
* `ao_get_leaners_from_country()`
* `ao_get_leaners_registered_at()`
* `ao_get_leaners_with_score()`
* `ao_get_learners_churn_at_content()`
* `ao_get_learners_course_complete()`
* `ao_get_learners_quiz_statistic()`
* `ao_get_learners_repeated_logins()`
* `ao_get_passive_leaners()`
* `ao_get_passive_learners()`

## Example

``` r
library(racademyocean)

ao_auth(
    client_id = 'your client ID', 
    client_secret = 'your client secret'
)

academies <- ao_get_academies()
leaners <- ao_get_leaners()
```

