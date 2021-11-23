#' Get the list of all academies. It returns the list of all academies in account with a description of them.
#'
#' @return tibble with academies
#' @export
ao_get_academies <- function() {

  cli_alert_info('Compose request body')
  rbody <- oa_make_body(
    action = 'academies'
  )

  cli_alert_info('Send request')
  resp <- oa_request(body = rbody, token = suppressMessages(ao_auth()))
  cli_alert_info('Parse result')
  res <- oa_parser(resp) %>%
         oa_set_class('oa_academies')
  cli_alert_success('Loaded {nrow(res)} academies')

  return(res)

}
