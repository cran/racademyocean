#' This returns a learner’s progress in all active courses/groups.
#'
#' @param emails Search for a users by emails
#' @param cl A cluster object created by \code{\link{makeCluster}}, or an integer to indicate number of child-processes (integer values are ignored on Windows) for parallel evaluations (see Details on performance).
#'
#' @return tibble with course progress
#' @export
ao_get_course_progress <- function(
  emails,
  cl = NULL
) {
  UseMethod("ao_get_course_progress")
}

#' @export
ao_get_course_progress.default <- function(
  emails,
  cl = NULL
) {

  cli_alert_info('Requested data by each email')
  res <- pblapply(emails, ao_get_course_progress_helper)

  cli_alert_info('Binding result')
  res <- bind_rows(res) %>%
         oa_set_class('oa_course_progress')

  cli_alert_success('Loaded {nrow(res)} leaners')

  return(res)

}

#' @export
ao_get_course_progress.oa_leaners <- function(emails, cl = NULL){

  res <- ao_get_course_progress(emails$email, cl)

  return(res)

}

ao_get_course_progress_helper <- function(
  email
) {

  rbody <- oa_make_body(action = 'courseProgress', options = 'email', values = email)
  resp  <- oa_request(body = rbody, token = suppressMessages(ao_auth()))
  res   <- oa_parser(resp) %>%
           mutate(email = email)

  return(res)
}

#' @export
print.oa_course_progress <- function (x, ...) {

  cli_div(theme = list (span.obj_name = list(color = "orange", "font-style" = 'bold')))
  cli_text("{.obj_name Academy Ocean Course Progress}")
  cli_end()

  cli_text("Total leaners: {length(unique(x$email))}")
  cli_text("Total lesson amount: {sum(x$lessons_amount)}")
  cli_text("Total progress amount: {sum(x$progress_amount)} ({round(sum(x$progress_amount) / sum(x$lessons_amount) * 100, 1)}%)")

  print(as_tibble(x))

}
