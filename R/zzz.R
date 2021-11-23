.onLoad <- function(libname, pkgname) {

  # where function
  utils::globalVariables("where")

  ## adwords developer token
  if ( Sys.getenv("OA_CLIENT_ID") != "" ) {

    oa_client_id <- Sys.getenv("OA_CLIENT_ID")
    cli_alert_info('Set client_id from System Environ')

  } else {

    oa_client_id <- NULL

  }

  ## login customer id
  if ( Sys.getenv("OA_CLIENT_SECRET") != "" ) {

    oa_client_secret <- Sys.getenv("OA_CLIENT_SECRET")
    cli_alert_info('Set client_secret from System Environ')

  } else {

    oa_client_secret <- NULL

  }

  ## login customer id
  if ( Sys.getenv("OA_TOKEN_PATH") != "" ) {

    oa_token_path <- Sys.getenv("OA_TOKEN_PATH")
    cli_alert_info('Set token_path from System Environ')

  } else {

    oa_token_path <- NULL

  }


  # options
  op <- options()
  op.oa <- list(oa.client_id     = oa_client_id,
                oa.client_secret = oa_client_secret,
                oa.token_path    = oa_token_path,
                oa.base_url      = 'https://app.academyocean.com/api/v1/',
                oa.max_tries     = 15,
                oa.interval      = 10)

  toset <- !(names(op.oa) %in% names(op))
  if (any(toset)) options(op.oa[toset])

  invisible()
}

.onAttach <- function(lib, pkg,...){

  packageStartupMessage(racademyoceanWelcomeMessage())

}


racademyoceanWelcomeMessage <- function(){
  # library(utils)

  paste0("\n",
         "---------------------\n",
         "Welcome to racademyocean version ", utils::packageDescription("racademyocean")$Version, "\n",
         "\n",
         "Author:           Alexey Seleznev (Head of analytics dept at Netpeak).\n",
         "Telegram channel: https://t.me/R4marketing \n",
         "YouTube channel:  https://www.youtube.com/R4marketing/?sub_confirmation=1 \n",
         "Email:            selesnow@gmail.com\n",
         "Site:             https://selesnow.github.io \n",
         "Blog:             https://alexeyseleznev.wordpress.com \n",
         "Facebook:         https://facebook.com/selesnown \n",
         "Linkedin:         https://www.linkedin.com/in/selesnow \n",
         "\n",
         "Type ?racademyocean for the main documentation.\n",
         "The github page is: https://github.com/selesnow/racademyocean/\n",
         "Package site: https://selesnow.github.io/racademyocean/docs\n",
         "\n",
         "Suggestions and bug-reports can be submitted at: https://github.com/selesnow/racademyocean/issues\n",
         "Or contact: <selesnow@gmail.com>\n",
         "\n",
         "\tTo suppress this message use:  ", "suppressPackageStartupMessages(library(racademyocean))\n",
         "---------------------\n"
  )
}
