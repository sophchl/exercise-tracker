## helpers for saving in SQLite database ---------

# for testing
# sqlitePath <- "shiny-exercise/data/exerciseDB.db"
# data = data.frame(matrix(c(1:4),2,2))
# type = "strength"

sqlitePath <- "data/exerciseDB.db"
table_main <- "responses_main"

saveDataMain <- function(data) {
  
  # Connect to the database
  db <- dbConnect(SQLite(), sqlitePath)
  
  # Construct the update query by looping over the data fields
  query <- sprintf(
    "INSERT INTO %s (%s) VALUES ('%s')",
    table_main, 
    paste(names(data), collapse = ", "),
    paste(data, collapse = "', '")
  )
  
  # Submit the update query and disconnect
  dbGetQuery(db, query)
  dbDisconnect(db)
}

saveDataType <- function(data, type) {
  
  # Connect to the database
  db <- dbConnect(SQLite(), sqlitePath)
  
  # Construct the update query by looping over the data fields
  table_type <- paste("responses_", type, sep = "")
  data_cols <- c("id", names(data))
  last_row_id <- dbGetQuery(db, "SELECT rowid FROM responses_main") %>% pull(rowid) %>% last()
  data_values <- c(last_row_id, data)
  
  query <- sprintf(
    "INSERT INTO %s (%s) VALUES ('%s')",
    table_type,
    paste(data_cols, collapse = ", "),
    paste(data_values, collapse = "', '")
  )
  
  # Submit the update query and disconnect
  dbGetQuery(db, query)
  dbDisconnect(db)
}

loadDataMain <- function() {
  
  # Connect to the database
  db <- dbConnect(SQLite(), sqlitePath)
  
  # Construct the fetching query
  query <- sprintf("SELECT * FROM %s", table_main)
  
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
}

loadDataType <- function(type) {
  
  # Connect to the database
  db <- dbConnect(SQLite(), sqlitePath)
  
  # Construct the fetching query
  table_type <- paste("responses_", type, sep = "")
  query <- sprintf("SELECT * FROM %s", table_type)
  
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
}

## load and plot ---------

