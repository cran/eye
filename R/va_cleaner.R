#' Cleaning up Visual acuity entries
#' @name clean_va
#' @param x Vector with VA entries
#' @param quali strings for qualitative visual acuity entries
#' @param message message for replaced NA values
#' @description VA cleaning:
#' 1. [tidyNA]:
#'   Replacing empty placeholders (".","", "(any number of empty space)",
#'   "NULL", "NA", "N/A" , "-") - any cases - with NA
#' 1. Simplifying the notation for qualitative
#' VA notation (NPL becomes NLP, PL becomes LP)
#' 1. Removing non-Snellen character strings
#' @return character vector
#' @family VA cleaner
#' @export
clean_va <- function(x, quali = c("nlp", "lp", "hm", "cf"), message = TRUE) {
  originalNA <- is.na(x)
  x_tidied <- tidyNA_low(x)
  x_tidied <- gsub("\\s", "", x_tidied)

  # unifying nlp/npl etc
  replace_PL = c(pl = "lp", npl = "nlp")
  new_vec <- replace_PL[x_tidied]
  x_tidied <- unname(ifelse(is.na(new_vec), x_tidied, new_vec))

  x_quali <- x_tidied %in% quali
  x_snell <- grepl("/", x_tidied)
  x_num <- !is.na(suppressWarnings(as.numeric(x_tidied)))
  x_keep <- as.logical(x_quali + x_snell + x_num + originalNA)

  if(message){
  introduceNA(x, !x_keep)
  }
  x_tidied[!x_keep] <- NA

  if (sum(x_quali, x_snell) == 0) {
    return(as.numeric(x_tidied))
  }
  x_tidied
}

#' @rdname clean_va
#' @export
cleanVA <- clean_va

#' introduce NA for implausible VA entries
#' @name introduceNA
#' @param x vector
#' @param test plausibility test
#' @return vector
#' @keywords internal
introduceNA <- function(x, test){
  if(any(test)){
    message(paste0(
      sum(test, na.rm = TRUE), "x NA introduced for: ",
      paste(unique(x[test]), collapse = ", ")
    ))
  }
}

#' convert quali entries
#' @description converting quality VA entries
#' @name convertQuali
#' @param x vector
#' @param to_class to which class
#' @return vector
#' @keywords internal

convertQuali <- function(x, to_class){
  if(to_class == "snellen"){
    to_class <- "snellenft"
  }
  if (any(x %in% eye_codes$quali)) {
    x_quali <- va_chart[[to_class]][match(x, va_chart$quali[1:4])]
    x <- ifelse(!is.na(x_quali), x_quali, x)
  }
  x
}


#' Tidy NA entries to actual NA values
#' @name tidyNA
#' @description Creates tidy NA entries - NA equivalent strings are tidied to
#'   actual NA values
#' @param x Vector
#' @param ... passed to [isNAstring]
#' @return character vector
#' @examples
#' x <- c("a", "   ", ".", "-", "NULL")
#' tidyNA(x)
#'
#' # in addition to the default strings, a new string can be added
#' tidyNA(x, string = "a")
#'
#' # or just remove the strings you want
#' tidyNA(x, string = "a", defaultstrings = FALSE)
#' @export
#'
tidyNA <- function(x, ...){
  y <- tolower(x)
  x[isNAstring(y, ...)] <- NA_character_
  x
}

#' @rdname tidyNA
#' @details tidyNA_low is an internal function used for VA cleaning
#'   returning a lower case vector.
#' @keywords internals
tidyNA_low <- function(x, ...){
  y <- tolower(x)
  y[isNAstring(y, ...)] <- NA_character_
  y
}

#' @rdname tidyNA
#' @param string vector of full strings to be replaced by NA
#' @param defaultstrings by default (TRUE), the following strings will be replaced by
#'   NA values: c("\\.+", "", "\\s+", "n/a", "na", "null", "^-$").
#' @keywords internal
isNAstring <- function(x, string = NULL, defaultstrings = TRUE) {
  if(defaultstrings){
    full <- c(c("\\.+", "", "\\s+", "n/a", "na", "null", "^-$"), string)
  } else {
    full <- string
  }
  fullpaste <- paste0("^", paste(full, collapse = "$|^"), "$")
  isNA <- grepl(fullpaste, x)
  isNA
}


