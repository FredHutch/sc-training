#!/usr/bin/env Rscript
#
#  calculate Pi using Monti Carlo
#
# Rscript pi.R 

require("RPostgreSQL")
library(optparse)

option_list = list(
  make_option(c("-v", "--verbose"), action="store_true", default=FALSE,
              help="Should the program print extra stuff out? [default %default]"),
  make_option(c("-J", "--job_id"), action="store", default=NA, type="character",
              help="Slurm Job ID"),
  make_option(c("-n", "--job_num"), action="store", default=NA, type="character",
              help="job number"),
  make_option(c("-t", "--table"), action="store", default=NA, type="character", 
              help="DB table name")
)
opt = parse_args(OptionParser(option_list=option_list))
if (is.na(opt$job_id) || is.na(opt$job_num) || is.na(opt$table) ) {
   stop("job_id, job_num and table are required arguments use --help for more info", call.=FALSE)
}

# loads the PostgreSQL driver
drv <- dbDriver("PostgreSQL")
# creates a connection to the postgres database
# note that "con" will be used later in each connection to the database
con <- dbConnect(drv, dbname = "jfdey",
                 host = "mydb", port = 32055,
                 user = "jfdey")

create_table <- function(con, tbl_name)
{
   # specifies the details of the table
   sql_command <- paste("CREATE TABLE ", tbl_name, " ( ",
      "job_id VARCHAR(16) NOT NULL, ",
      "job_num VARCHAR(8) NOT NULL, ",
      "pi numeric(8,7) ",
      ")"
      , sep="")
   print(paste("create table: ",sql_command))

   # sends the command and creates the table
   dbGetQuery(con, sql_command)
}

insert_result <- function(con, tbl_name, job_id, job_num, result)
{
   sql_command <- paste("INSERT INTO ", tbl_name,
      " ( job_id, job_num, pi ) ",
      "VALUES (", 
      "'", job_id,  "', ",
      "'", job_num, "', ",
      "'", result, "'",
      ")"
      , sep="")
   dbGetQuery(con, sql_command)
}

montecarlo_pi<- function(n)
{
  N <- n
  R <- 1
  x <- runif(N, min= -R, max= R)
  y <- runif(N, min= -R, max= R)
  is.inside <- (x^2 + y^2) <= R^2
  pi.estimate <- 4 * sum(is.inside) / N
  pi.estimate
}

print(paste("job_id: ", opt$job_id))
print(paste("job_num: ", opt$job_num))
print(paste("Table Name: ", opt$table))

create_table(con, opt$table)
for (i in 100:124) {
   pi <- montecarlo_pi(10000000)
   cat(format(pi),"\n")
   insert_result(con, opt$table, opt$job_id, i, pi)
}

dbDisconnect(con)
