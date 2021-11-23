#' Returns statistics about the specified quiz for the specified learner(s).
#'
#' @param email Search for a users by emails
#' @param content_id ID of the quiz you want to see statistics for
#'
#' @return tibble with quize stat
#' @export
#'
#' @examples
#' \dontrun{
#' quize_stat <- ao_get_learners_quiz_statistic(
#'     email = 'mike.p@gmail.com',
#'     content_id = 'R9eYq5oE6wLoY3NAPmwx'
#' )
#' }
ao_get_learners_quiz_statistic <- function(
  email,
  content_id
) {

  cli_alert_info('Compose request body')
  rbody <- oa_make_body(
    action = 'getLearnersQuizStatistic',
    options = 'records',
    values = content_id
  )

  rbody <- set_names(rbody, c('action', str_glue("options[records][{email}][]")))

  cli_alert_info('Send request')
  resp <- oa_request(body = rbody, token = suppressMessages(ao_auth()))
  cli_alert_info('Parse result')
  res <- oa_parser(resp[[1]][[1]]) %>%
         oa_set_class('oa_quize_stat')
  cli_alert_success('Loaded {nrow(res)} learners')

  return(res)

}
