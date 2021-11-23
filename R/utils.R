# utils micro function ----------------------------------------------------

oa_make_body<- function(
  action,
  options = NULL,
  values = NULL
) {

  option_name <- str_glue('options[{options}]')

  r_body <- list(
    action  = action
    )

  if ( ! is.null(values) ) {
    r_body <- append(r_body, map(values, ~ .))
    r_body <- set_names(r_body, c('action', as.character(option_name)))
  }

 return(r_body)

}

oa_request <- function(
  body,
  token
) {

  retry(
    {
      resp <- request(getOption('oa.base_url')) %>%
                req_method("POST") %>%
                req_body_form(body) %>%
                req_headers(Authorization = oa_access_token(token)) %>%
                req_perform()
    },
    until     = ~ inherits(., "httr2_response") && resp_status(.) == 200,
    interval  = getOption('oa.interval'),
    max_tries = getOption('oa.max_tries')
  )

  resp <- resp_body_json(resp)

  if ( 'error' %in% names(resp) ) {
    cli_abort(resp$error$message)
  }

  return(resp)

}

oa_parser <- function(
  response
) {

  res <- tibble(data = response) %>%
         unnest_wider('data')

  return(res)

}

oa_set_class <- function(x, obj_class = NULL) {
  class(x) <- c(obj_class, class(x))
  return(x)
}

