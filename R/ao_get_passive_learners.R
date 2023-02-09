#' This returns a list of learners who registered in an Academy but took no further actions (no lessons opened)
#'
#' @return tibble with passive leaners
#' @export
#'
#' @examples
#' \dontrun{
#' passive <- ao_get_passive_learners()
#' }
ao_get_passive_learners <- function(
) {

  cli_alert_info('Compose request body')
  rbody <- oa_make_body(
    action = 'passiveLearners'
  )

  cli_alert_info('Send request')
  resp <- oa_request(body = rbody, token = suppressMessages(ao_auth()))
  cli_alert_info('Parse result')
  res <- oa_parser(resp) %>%
         oa_set_class('oa_leaners')
  cli_alert_success('Loaded {nrow(res)} learners')

  return(res)

}
