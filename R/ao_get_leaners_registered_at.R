#' This returns an array of learners from the Academy, or an empty array, if there is no data.
#'
#' @param date Date string for filter
#' @param operator One of the following comparison operators '=', '>', '<', '>=', '<=', '<>'
#'
#' @return tibble with leaners
#' @export
ao_get_leaners_registered_at <- function(
  date = Sys.Date() - 1,
  operator = c('=', '>', '<', '>=', '<=', '<>')
) {

  cli_alert_info('Compose request body')
  rbody <- oa_make_body(
    action = 'learnersRegisteredAt',
    options = c('date', 'operator'),
    values = c(as.character(date),  match.arg(operator))
    )

  cli_alert_info('Send request')
  resp <- oa_request(body = rbody, token = suppressMessages(ao_auth()))
  cli_alert_info('Parse result')
  res <- oa_parser(resp) %>%
         oa_set_class('oa_leaners')

  cli_alert_success('Loaded {nrow(res)} leaners')

  return(res)

}
