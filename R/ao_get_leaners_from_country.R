#' This returns a list of learners from the chosen country
#'
#' @param country_iso_code Country iso code
#'
#' @return tibble with leaners
#' @export
#'
#' @examples
#' \dontrun{
#' ua_leaners <- ao_get_leaners_from_country("UA")
#' }
ao_get_leaners_from_country  <- function(
  country_iso_code
) {

  cli_alert_info('Compose request body')
  rbody <- oa_make_body(
    action = 'learnersFromCountry',
    options = 'country_iso_code',
    values = country_iso_code
  )

  cli_alert_info('Send request')
  resp <- oa_request(body = rbody, token = suppressMessages(ao_auth()))
  cli_alert_info('Parse result')
  res <- oa_parser(resp$learners) %>%
         oa_set_class('oa_leaners')
  cli_alert_success('Loaded {nrow(res)} learners')

  return(res)

}
