## helpers from example saving locally ---------

saveData <- function(data) {
  data <- as.data.frame(t(data))
  if (exists("responses")) {
    responses <<- rbind(responses, data)
  } else {
    responses <<- data
  }
}

loadData <- function() {
  if (exists("responses")) {
    responses
  }
}

# helpers from example for saving in RSQLite database ---------

library(RSQLite)
sqlitePath <- "/path/to/sqlite/database"
table <- "responses"

saveData <- function(data) {
  
  # Connect to the database
  db <- dbConnect(SQLite(), sqlitePath)
  
  # Construct the update query by looping over the data fields
  query <- sprintf(
    "INSERT INTO %s (%s) VALUES ('%s')",
    table, 
    paste(names(data), collapse = ", "),
    paste(data, collapse = "', '")
  )
  
  # Submit the update query and disconnect
  dbGetQuery(db, query)
  dbDisconnect(db)
}

loadData <- function() {
  
  # Connect to the database
  db <- dbConnect(SQLite(), sqlitePath)
  
  # Construct the fetching query
  query <- sprintf("SELECT * FROM %s", table)
  
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
}
