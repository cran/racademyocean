#' This returns a list of learners who have completed a given course.
#'
#' @param course_id Course id, you can get it from edit course, from field ‘course URL’
#'
#' @return tibble with leaners
#' @export
#'
#' @examples
#' \dontrun{
#' leaners <- ao_get_learners_course_complete(
#'     'ppc-spetsialist-free'
#' )
#' }
ao_get_learners_course_complete  <- function(
  course_id = 'GlnLgyVkeqaXkm09Q7Y4'
) {

  cli_alert_info('Compose request body')
  rbody <- oa_make_body(
    action = 'learnersCourseComplete',
    options = 'course_id',
    values = course_id
  )

  cli_alert_info('Send request')
  resp <- oa_request(body = rbody, token = suppressMessages(ao_auth()))
  cli_alert_info('Parse result')
  res <- oa_parser(resp) %>%
         oa_set_class('oa_leaners')
  cli_alert_success('Loaded {nrow(res)} learners')

  return(res)

}
