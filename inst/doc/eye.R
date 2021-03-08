## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(eye)
library(eyedata)

## ----va-----------------------------------------------------------------------
## automatic detection of VA notation and converting to logMAR by default
x <- c(23, 56, 74, 58) ## ETDRS letters
to_logmar(x) # wrapper of va(x, to = "logmar")

## ... or convert to snellen
to_snellen(x) # wrapper of va(x, to = "snellen") 

## eye knows metric as well 
to_snellen(x, type = "m") 

## And the decimal snellen notation, so much loved in Germany
to_snellen(x, type = "dec") 

## Remove weird entries and implausible entries depending on the VA choice
x <- c("NLP", "0.8", "34", "3/60", "2/200", "20/50", "  ", ".", "-", "NULL")

to_snellen(x)
to_snellen(x, from = "snellendec")
to_snellen(x, from = "etdrs")
to_snellen(x, from = "logmar")

## "plus/minus" entries are converted to the most probable threshold (any spaces allowed) 
x <- c("20/200 - 1", "6/6-2", "20/50 + 3", "6/6-4", "20/33 + 4")
to_logmar(x)

## or evaluating them as logmar values (each optotype equals 0.02 logmar)
to_logmar(x, smallstep = TRUE)

## or you can also decide to completely ignore them (converting them to the nearest snellen value in the VA chart)
to_snellen(x, noplus = TRUE)

## -----------------------------------------------------------------------------
x <- c("r", "re", "od", "right", "l", "le", "os", "left")
recodeye(x)

## or with "both eyes"
x <- c(x, "both", "ou")
recodeye(x)

## chose the resulting codes
recodeye(x, to = c("od", "os", "ou"))

## Numeric codes 0:1/ 1:2 are recognized 
x <- 1:2
recodeye(x)

## with weird missing values
x <- c(1:2, ".", NA, "", "    ")
recodeye(x)

## Or if you have weird codes for eyes
x <- c("alright", "righton", "lefty","leftover")

recodeye(x, eyecodes = list(r = c("alright","righton"), l = c("lefty","leftover")))

## ----eyestr-------------------------------------------------------------------
eyes(amd2)

library(eyedata)
eyes(amd2)

# Same as `eyes`, but as text for reports
eyestr(amd2)

## Numbers smaller than or equal to 12 will be real English
eyestr(head(amd2, 100))

## Or, you can make all numbers english:
eyestr(amd2, english = "all")

## make first number capital letter
eyestr(head(amd2, 100), caps = TRUE)

## you can have all numbers printed as numbers
eyestr(head(amd2, 100), english = "none")

## -----------------------------------------------------------------------------
## the variable has not been exactly named, (but it is probably IOP data), 
## you can specify the dimension with the var argument
wide1 <- data.frame(id = letters[1:3],  r = 11:13 , l = 14:16)
myop(wide1, var = "iop")

## If the dimension is already part of the column names, this is not necessary. 
iop_wide <- data.frame(id = letters[1:3], iop_r = 11:13, iop_l = 14:16)
myop(iop_wide)

## Mildly messy data frame with several variables spread over two columns:
wide_df <- data.frame(
  id = letters[1:4], 
  surgery_right = c("TE", "TE", "SLT", "SLT"),
  surgery_left = c("TE", "TE", "TE", "SLT"),
  iop_r_preop = 21:24, iop_r_postop = 11:14,
  iop_l_preop = 31:34, iop_l_postop = 11:14, 
  va_r_preop = 41:44, va_r_postop = 45:48,
  va_l_preop = 41:44, va_l_postop = 45:48
)

## myop deals with this in a breeze:
myop(wide_df)

## -----------------------------------------------------------------------------
myop_df <- myop(wide_df)
hyperop(myop_df, cols = matches("va|iop"))

## -----------------------------------------------------------------------------
blink(wide_df)

blink(amd)

## -----------------------------------------------------------------------------
name_mess <- data.frame(name = "a", oculus = "r", eyepressure = 14, vision = 0.2)
names(name_mess)

## -----------------------------------------------------------------------------
names(name_mess) <- c("patID", "eye", "IOP", "VA")
names(name_mess)

## ---- include=FALSE-----------------------------------------------------------
names(name_mess) <- c("name", "oculus", "eyepressure", "vision")

## -----------------------------------------------------------------------------
## if you only want to rename one or a few columns: 
names(name_mess)[names(name_mess) %in% c("name", "vision")] <- c("patID", "VA")
names(name_mess)

## -----------------------------------------------------------------------------
## right and left eyes have common codes
## information on the tested dimension is included ("iop")
## VA and eye strings are separated by underscores
## No unnecessary underscores.
names(wide_df)

names(iop_wide) 

## -----------------------------------------------------------------------------
## Id and Eye are common names, there are no spaces
## VA is separated from the rest with an underscore
## BUT: 
## The names are quite long 
## There is an unnecessary underscore (etdrs are always letters). Better just "VA"
c("Id", "Eye", "FollowupDays", "BaselineAge", "Gender", "VA_ETDRS_Letters", 
"InjectionNumber")

## All names are commonly used (good!)
## But which dimension of "r"/"l" are we exactly looking at? 
c("id", "r",  "l")

## -----------------------------------------------------------------------------
## VA/IOP not separated with underscore
## `eye` won't be able to recognize IOP and VA columns
c("id", "iopr", "iopl", "VAr", "VAl")

## A human may think this is clear
## But `eye` will fail to understand those variable names
c("person", "goldmann", "vision")

## Not even clear to humans
c("var1", "var2", "var3")

## ----stats, warning=FALSE, message=FALSE--------------------------------------
clean_df <- myop(wide_df)
reveal(clean_df)

reveal(clean_df, by = "eye")

reveal(clean_df, by = c("eye", "surgery"))

## ----getage, warning=FALSE, message=FALSE-------------------------------------
dob <- c("1984-10-16", "2000-01-01")

## If no second date given, the age today
getage(dob)

## If the second argument is specified, the age until then
getage(dob, "2000-01-01")                                                    

