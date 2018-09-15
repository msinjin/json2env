#' Parse JSON Formatted Arguments
#'
#' \code{json2env} parses arguments in javascript object notation (JSON) and
#' loads them into an environment (typically that of the enclosing function).
#'
#' \code{json2env} loads JSON formatted name-value pairs into an environment
#' (\code{parent.frame} of the calling environment by default). This is
#' particularly useful in web applications where it is desireable for a function
#' to receive arguments in JSON format.
#'
#' @importFrom jsonlite fromJSON
#' @export json2env
#'
#' @param json_args JSON-formatted name-value pairs to be converted.
#' @param replace Boolean indicating if provided JSON arguments take priority
#'   over formals of the same name. If TRUE, JSON arguments replace the values
#'   of formals of the same name (default). If FALSE, JSON arguments are ignored
#'   when a formal of the same name is declared.
#' @param envir The environment JSON arguments are to be loaded into. Defaults
#'   to the environment of the calling function (\code{parent.frame()});
#'   however, specific environments could be named.
#'
#' @seealso \code{\link{list2env}}, \code{\link{fromJSON}}, \code{\link{toJSON}}
#' @return Note that \code{json2env} does not have a return value and so does
#'   not need to be assigned (\code{<-}). Rather the side effect of \code{json2env}
#'   is being used to assign names with values to an environment.
#' @examples
#' json_args <- '{"a" : 3, "b" : 4, "c" : 5}'
#'
#' my_fun <- function(json_args, a = 1, b = 2, d = 6, replace = T) {
#'     json2env(json_args, replace = replace)
#'     print(c(a, b, c, d))
#' }
#'
#' my_fun(json_args) # [1] 3 4 5 6
#' my_fun(json_args, replace = F) # [1] 1 2 5 6

json2env <-
    function(json_args,
             replace = T,
             envir = parent.frame()) {
        if (!isValidJSON(I(json_args))) {
            stop("json2env() was expecting json_args in JSON format.")
        }
        json_list <-
            jsonlite::fromJSON(json_args, simplifyVector = F)
        if (any(is.null(names(json_list))) | any(names(json_list) == "")) {
            stop("json2env() was expecting json_args in name-value pairs.")
        }
        if (replace == T) {
            # Overwrite values in target environment
            list2env(json_list, envir = envir)
        } else {
            # Only add name-values to target environment if they don't already exist
            list2env(json_list[!names(json_list) %in% names(envir)], envir = envir)
        }
    }
