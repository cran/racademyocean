#' This returns a learner’s progress in specified courses
#'
#' @param course_id Course ID, you can get from course settings, from field “API, Course ID”
#' @param course_slug Course slug, you can get from course settings, from field ‘course URL’
#' @param cl A cluster object created by \code{\link{makeCluster}}, or an integer to indicate number of child-processes (integer values are ignored on Windows) for parallel evaluations (see Details on performance).
#'
#' @return When the request is executed, an array of learner’s information is returned
#' @export
ao_get_leaners_progress_by_course <- function(
    course_id,
    course_slug,
    cl = NULL
) {

  if (missing(course_id) && missing(course_slug)) stop('Set course_id or course_slug, one of this parameters is required!')

  cli_alert_info('Requested data by each course')

  if (missing(course_id)) {
    res <- pblapply(course_slug, function(.x) ao_get_leaners_progress_by_course_helper(course_slug = .x), cl = cl)
  } else {
    res <- pblapply(course_id, ao_get_leaners_progress_by_course_helper, cl = cl)
  }

  cli_alert_info('Binding result')
  res <- bind_rows(res) %>%
         oa_set_class('oa_course_progress')

  cli_alert_success('Loaded {nrow(res)} rows')

  return(res)

}

ao_get_leaners_progress_by_course_helper <- function(
    course_id,
    course_slug
) {

  if (missing(course_id) && missing(course_slug)) stop('Set course_id or course_slug, one of this parameters is required!')

  if (missing(course_id)) {
    opt_name <- 'course_slug'
    opt_val  <- course_slug
  } else {
    opt_name <- 'course_id'
    opt_val  <- course_id
  }

  rbody <- oa_make_body(action = 'learnersProgressByCourse', options = opt_name, values = opt_val)
  resp  <- oa_request(body = rbody, token = suppressMessages(ao_auth()))
  res   <- oa_parser(resp$learners) %>%
           mutate(field = opt_val)
  res   <- set_names(res, c(names(res)[1:ncol(res)-1], opt_name)) %>%
           mutate(
             across(ends_with('Date'), \(x) as.Date(x, format = '%m/%d/%Y'))
           )

  return(res)
}
