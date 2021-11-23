#' This returns a breakdown of learners by country.
#'
#' @param country_iso_code Country iso code
#'
#' @return tibble with leaners geo
#' @export
#'
#' @examples
#' \dontrun{
#' leaners_stat <- ao_get_leaners_amount_from_countries(
#'     country_iso_code = "UA"
#' )
#' }
ao_get_leaners_amount_from_countries  <- function(
  country_iso_code = NULL
) {

  cli_alert_info('Compose request body')
  rbody <- oa_make_body(
    action = 'learnersAmountFromCountries',
    options = 'country_iso_code',
    values = country_iso_code
  )

  cli_alert_info('Send request')
  resp <- oa_request(body = rbody, token = suppressMessages(ao_auth()))
  cli_alert_info('Parse result')
  res <- oa_parser(resp)

  cli_alert_success('Loaded {nrow(res)} rows')

  return(res)

}
