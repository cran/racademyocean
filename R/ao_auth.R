#' Authorization in 'AcademyOcean'
#'
#' @param client_id ID of your App
#' @param client_secret Secret of your app
#' @param token_path Your directory for credential storage
#'
#' @return Auth object
#' @export
#' @seealso See \href{https://academyocean.com/api#authorization}{Documentation}
#'
ao_auth <- function(
  client_id = ao_get_client_id(),
  client_secret = ao_get_client_secret(),
  token_path = oa_get_token_path()
) {

  if ( is.null(client_id) ) cli_abort('Set client_id')

  file_name <- str_c(client_id, 'oa_auth.rds', sep = "_")
  file_path <- normalizePath(str_c(token_path, file_name, sep = "/"), mustWork = F)

  if ( !dir.exists(token_path) ) dir.create(token_path, recursive = TRUE)

  if ( file.exists(file_path) ) {

    resp <- readRDS(file_path)

    if ( resp$expires_at < Sys.time() ) {
      file.remove(file_path)
      ao_auth(client_id, client_secret, token_path)
    }

  } else {

    if ( is.null(client_secret) ) cli_abort('Set client_secret')

    resp <- request('https://app.academyocean.com/oauth/token') %>%
            req_method("POST") %>%
            req_body_form(list(client_id = client_id, client_secret = client_secret, grant_type = 'client_credentials')) %>%
            req_headers(Name = "Alexey") %>%
            req_perform() %>%
            resp_body_json()

    resp$app_id <- client_id
    resp$expires_at <- as.POSIXlt(resp$expires_in,  origin = Sys.time())
    resp$path <- file_path
    class(resp) <- 'academyocean_token'
    saveRDS(resp, file_path)
  }

  options(oa.access_token = resp$access_token)
  options(oa.client_id = client_id)
  cli_alert_success('Token set succsessful!')
  return(resp)
}

ao_get_client_id <- function() {
  client_id <- getOption('oa.client_id') %||% Sys.getenv('OA_CLIENT_ID')
  if (is.null(client_id) || identical(client_id,  '')) return(NULL)
  return(client_id)
}

ao_get_client_secret <- function() {
  client_secret <- getOption('oa.client_secret') %||% Sys.getenv('OA_CLIENT_SECRET')
  if (is.null(client_secret) || identical(client_secret,  '')) return(NULL)
  return(client_secret)
}

oa_get_token_path <- function() {
  token_path <- getOption('oa.token_path') %||% Sys.getenv('OA_TOKEN_PATH')
  if (is.null(token_path) || identical(token_path,  '')) return( normalizePath(rappdirs::user_cache_dir("racademyocean"), mustWork = F))
  return(token_path)
}

oa_access_token = function(token) {
  return(token$access_token)
}

#' Print method for academyocean_token
#'
#' @param x Auth object
#' @param show_token Hide or shoh access token in console
#' @param ... Using in default print()
#'
#' @return Using only for output token in console
#' @export
print.academyocean_token <- function (x, ..., show_token = FALSE) {

  cli_div(theme = list (span.obj_name = list(color = "orange", "font-style" = 'bold')))
  cli_text("{.obj_name Academy Ocean API token}")
  cli_end()

  cli_div(theme = list (span.secret_obj = list(color = "blue", "font-style" = 'italic')))
  cli_div(theme = list (span.hiden_obj = list(color = "gray", "font-style" = 'italic')))

  if (show_token) {
    cli_text("Access token: {.secret_obj {x$access_token}}")
  } else {
    cli_text("Access token: {.hiden_obj <hidden>}")
  }
  cli_end()

  cli_text(paste0("App id: ", x$app_id))
  cli_text(paste0("Expires at: ", format(x$expires_at, "%Y-%m-%d %T")))
  cli_text("Auth file location: {.file {x$path}}")


  if ( Sys.info()["sysname"] == "Windows" ) {
    utils::writeClipboard(x$access_token)
  }

}
