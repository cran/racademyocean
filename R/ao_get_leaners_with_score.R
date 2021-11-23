#' This returns a list of learners filtered by their score
#'
#' @param score Filter score the ratio of completed content to available content, across all courses/groups
#' @param operator One of the following comparison operators '=', '>', '<', '>=', '<=', '<>'
#'
#' @return tibble with leaners
#' @export
#'
#' @examples
#' \dontrun{
#' leaners <- ao_get_leaners_with_score(
#'     score = 20,
#'     operator = '>'
#' )
#' }
ao_get_leaners_with_score  <- function(
  score = 1,
  operator = c('>=', '>', '<', '=', '<=', '<>')
) {

  cli_alert_info('Compose request body')
  rbody <- oa_make_body(
    action = 'learnersWithScore',
    options = c('score', 'operator'),
    values = c(score,  match.arg(operator))
  )

  cli_alert_info('Send request')
  resp <- oa_request(body = rbody, token = suppressMessages(ao_auth()))
  cli_alert_info('Parse result')
  res <- oa_parser(resp)%>%
         oa_set_class('oa_leaners')
  cli_alert_success('Loaded {nrow(res)} learners')

  return(res)

}
