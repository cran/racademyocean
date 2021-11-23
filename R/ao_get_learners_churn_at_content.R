#' This returns an array of learners who churned at a specific lesson in the course.
#'
#' @param course_id Course id, you can get it from edit course, from field ‘course URL’
#' @param content_id 	content id, you can get it from edit content, from field ‘lesson/quiz URL’
#'
#' @return tibble with leaners
#' @export
#'
#' @examples
#' \dontrun{
#' churn <- ao_get_learners_churn_at_content(
#'     course_id = 'ppc-spetsialist-free',
#'     content_id = 'itogovyy-test'
#' )
#' }
ao_get_learners_churn_at_content <- function(
  course_id,
  content_id
) {

  cli_alert_info('Compose request body')
  rbody <- oa_make_body(
    action = 'learnersChurnAtContent',
    options = c('course_id', 'content_id'),
    values = c(course_id,  content_id)
  )

  cli_alert_info('Send request')
  resp <- oa_request(body = rbody, token = suppressMessages(ao_auth()))
  cli_alert_info('Parse result')
  res <- oa_parser(resp) %>%
         oa_set_class('oa_leaners')
  cli_alert_success('Loaded {nrow(res)} learners')

  return(res)

}
