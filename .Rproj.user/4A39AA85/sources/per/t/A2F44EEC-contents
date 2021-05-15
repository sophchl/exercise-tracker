# helpers from example for saving in RSQLite database ---------

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

## my helpers for saving locally ---------

saveDataMain <- function(data) {
  data <- as.data.frame(t(data))
  if (exists("responses_main")) {
    responses_main <<- rbind(responses_main, data)
  } else {
    responses_main <<- data
  }
}

saveDataType <- function(data, type) {
  responses_type = paste("responses_", type, sep = "")
  data <- as.data.frame(t(data))
  if (exists(responses_type)) {
    eval(call("<<-", as.name(responses_type), eval(call("rbind", as.name(responses_type), data))))
  } else {
    eval(call("<<-", as.name(responses_type), data))
  }
}

loadDataMain <- function() {
  if (exists("responses_main")) {
    responses_main
  }
}

loadDataType <- function(type) {
  responses_type = paste("responses_", type, sep = "")
  if (exists(responses_type)) {
    as.name(responses_type)
  }
}

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
