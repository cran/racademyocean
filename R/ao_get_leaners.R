#' This returns an array of learners from the Academy, or an empty array, if there is no data.
#'
#' @return tibble with leaners
#' @export
ao_get_leaners <- function(

) {

  cli_alert_info('Compose request body')
  rbody <- oa_make_body(action = 'learners')
  cli_alert_info('Send request')
  resp <- oa_request(body = rbody, token = suppressMessages(ao_auth()))
  cli_alert_info('Parse result')
  res <- oa_parser(resp) %>%
         oa_set_class('oa_leaners')

  cli_alert_success('Loaded {nrow(res)} leaners')

  return(res)

}

#' @export
print.oa_leaners <- function (x, ...) {

  cli_div(theme = list (span.obj_name = list(color = "orange", "font-style" = 'bold')))
  cli_text("{.obj_name Academy Ocean Leaners}")
  cli_end()

  cli_text("Total leaners: {nrow(x)}")
  if ( 'spent_time_in_academy' %in% names(x) ) cli_text("Average spent time in academy: ", round(mean(x$spent_time_in_academy), 1))
  if ( 'certificates_amount' %in% names(x) ) cli_text("Number od certificates: {sum(x$certificates_amount)}")
  if ( 'score' %in% names(x) ) cli_text("Total score: {sum(x$score)}")

  if ( 'country' %in% names(x) ) {
    main_countri <- count(as_tibble(x), .data$country, sort = T) %>% slice_head(n = 1)
    cli_text("Main country: {main_countri$country} ({round(main_countri$n / nrow(x) * 100, 0)}%)")
  }

  print(as_tibble(x), ...)

}
