# Did you start with your .Renviron mounted into ~/.Renviron?
# And the .Renviron contains your DBPASS and DBUSER credentials?
# If not, please do:
#file.edit("~/.Renviron")
#readRenviron("~/.Renviron")

library(DBI)
library(dplyr)

con_bibmon <- dbConnect(
  odbc::odbc(), driver = "ODBC Driver 17 for SQL Server", 
  server = "bibmet-ref.ug.kth.se", database = "BIBMON", Port = 1433, 
  UID = Sys.getenv("DBUSER"), PWD = Sys.getenv("DBPASS")
)

df <- 
  tbl(con_bibmon, "DIVA_School_dept") %>%
  head(10) %>%
  collect()

dbDisconnect(con_bibmon)

library(DT)

datatable(df)


