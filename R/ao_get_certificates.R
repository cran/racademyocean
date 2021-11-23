#' This returns certificates received by learners
#'
#' @param emails Search for a user by email
#' @param cl A cluster object created by \code{\link{makeCluster}}, or an integer to indicate number of child-processes (integer values are ignored on Windows) for parallel evaluations (see Details on performance).
#'
#' @return tibble with certificates
#' @export
ao_get_certificates <- function(
  emails,
  cl = NULL
) {
  UseMethod("ao_get_certificates")
}

#' @export
ao_get_certificates.default <- function(
  emails,
  cl = NULL
) {

  cli_alert_info('Requested data by each email')
  res <- pblapply(emails, ao_get_certificates_helper)

  cli_alert_info('Binding result')
  res <- bind_rows(res) %>%
         oa_set_class('oa_certificates')

  cli_alert_success('Loaded {nrow(res)} leaners')

  return(res)

}

#' @export
ao_get_certificates.oa_leaners <- function(emails, cl = NULL){

  res <- ao_get_certificates(emails$email, cl)

  return(res)

}

ao_get_certificates_helper <- function(
  email
) {

  rbody <- oa_make_body(action = 'certificates', options = 'email', values = email)
  resp  <- oa_request(body = rbody, token = suppressMessages(ao_auth()))
  res   <- oa_parser(resp) %>%
           mutate(email = email)

  return(res)
}


#' @export
print.oa_certificates <- function (x, ...) {

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
