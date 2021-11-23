#' Returns a list of all teams in the academy.
#'
#' @return tibble with teams
#' @export
ao_get_teams <- function() {

  cli_alert_info('Compose request body')
  rbody <- oa_make_body(
    action = 'getTeams '
  )

  cli_alert_info('Send request')
  resp <- oa_request(body = rbody, token = suppressMessages(ao_auth()))
  cli_alert_info('Parse result')
  res <- oa_parser(resp) %>%
         oa_set_class('oa_teams')
  cli_alert_success('Loaded {nrow(res)} academies')

  return(res)

}
