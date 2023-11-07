# Did you start with your .Renviron mounted into ~/.Renviron?

# Does your ~/.Renviron contains your credentials? If not add lines for ...
#DBHOST="mydatabasehostname"
#DBNAME="mydatabasename"
#DBUSER="mydbusername"
#DBPASS="mydbpassword"

# You can do this from here and re-read the R environment variables by running:
#file.edit("~/.Renviron")
#readRenviron("~/.Renviron")

library(DBI)
library(dplyr)

con_bibmon <- dbConnect(
  odbc::odbc(), driver = "ODBC Driver 18 for SQL Server", 
  server = Sys.getenv("DBHOST"), database = Sys.getenv("DBNAME"), Port = 1433, 
  UID = Sys.getenv("DBUSER"), PWD = Sys.getenv("DBPASS")
)

df <- 
  tbl(con_bibmon, "DIVA_School_dept") %>%
  head(10) %>%
  collect()

dbDisconnect(con_bibmon)

# now we can work with the df data frame
library(DT)
datatable(df)
