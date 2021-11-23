#' This returns an array of learners who logged in to the Academy more than one time.
#'
#' @return tibble with leaners
#' @export
ao_get_learners_repeated_logins <-  function() {

  cli_alert_info('Compose request body')
  rbody <- oa_make_body(
    action = 'learnersRepeatedLogIns'
  )

  cli_alert_info('Send request')
  resp <- oa_request(body = rbody, token = suppressMessages(ao_auth()))
  cli_alert_info('Parse result')
  res <- oa_parser(resp) %>%
         oa_set_class('oa_leaners')
  cli_alert_success('Loaded {nrow(res)} learners')

  return(res)

}
