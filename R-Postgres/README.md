# Using Postgres from R 

Databases can be a more productive than file systems for saving results from R programs.  Advantages of uses databases over filesystems.
- Support concurrent IO
- Data Acess is simplified
- Use databases to manage cluster jobs
- Store configuration data in tables

## DBaas
Use dbaas to create a Postgres database.  The username and password you provide will have root access. The default settings are sufficient for most use cases. Save the connection string and follow instuctions for creating a .pgpass file in your home directory

## Postgres Language Support
R language support is provided by the RPostgresSQL library. 
```
library("RPostgreSQL")
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "jfdey",
                 host = "mydb", port = 32057,
                 user = "jfdey")

dbWriteTable(con, "Table Name", dataframe )

dbDisconnect(con)
```
