% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/myop.R
\name{myop}
\alias{myop}
\alias{myopic}
\title{Myopic eye data}
\usage{
myop(x, var = "value")

myopic(x, var = "value")
}
\arguments{
\item{x}{data frame}

\item{var}{Character vector of length 1 specifying the variable if there
is only one column per eye with no further info on the variable
(default "value")}
}
\value{
A tibble, see also \link[tibble:tibble]{tibble::tibble}
}
\description{
Pivot "eye" variable to one column
}
\details{
Out of convenience, data is often entered in a very "wide" format:
there will be two columns for the same variable, one column for each eye.
myop will pivot the eye variable to one column and keep all other
variables wide. E.g., eight columns that store data of four variables for two eyes
will be pivoted to 5 columns (one eye and four further variable columns,
see also \emph{examples}).

\strong{myop requires a specific data format}

If there is a column called "eye" or "eyes", myop will not make
any changes - because the data is then already assumed to be in long
format. If you \emph{also} have columns with eye-specific values,
then you have messy data. Maybe, you could remove or rename the "eye"
column and then let myop do the work.

myop will only recognize meaningful coding for eyes:
\itemize{
\item Right eyes: \emph{"r", "re", "od", "right"}
\item Left eyes:  \emph{"l", "le", "os", "left"}
\item for other codes see also \link{eye_codes}
The strings for eyes need to be \strong{separated by period or underscores}.
(Periods will be replaced by underscores). Any order is allowed.
\item \strong{Will work}: "va_r", "right_morningpressure", "night_iop.le", "gat_os_postop"
\item \strong{Will fail}: "VAr", "rightmorningPressure", "night_IOPle", "gatOSpostop"
}

An exception is when there is only one column for each eye. Then
the column names can consist of eye strings (see above) only.
In this case, \emph{var} will be used to "name" the resulting variable.

If there are only eye columns in your data (should actually not happen),
myop will create identifiers by row position.

\strong{Please always check the result for plausibility.}
Depending a lot on how the data was entered, the results could become
quite surprising. There is basically a nearly infinite amount of
possible combinations of how to enter data, and it is likely that
myop will not be able to deal with all of them
}
\section{internal preparation}{

\itemize{
\item Rename data names with  \link{myop_rename}, replacing "." with "_"
\item Use of \code{\link[=sort_substr]{sort_substr()}} - sorting eye strings first, then strings coding
for methods  (IOP/VA), then the rest.
}
}

\section{myopization}{

The actual work is done with \link{myopizer} and \link{myop_pivot}
}

\examples{
# Example to clean a bit messy data frame
iopva <- data.frame(
  id = c("a", "e", "j", "h"),
  va_r = c(37L, 36L, 33L, 38L),
  iop_r = c(38L, 40L, 33L, 34L),
  va_l = c(30L, 39L, 37L, 40L),
  iop_l = c(31L, 34L, 33L, 31L)
)
myop(iopva)

iop_wide <- data.frame(id = letters[1:3],  r = 11:13 , l = 14:16)
# the variable has not been exactly named, so you can specify
# it with the var argument
myop(iop_wide, var = "iop")
}
