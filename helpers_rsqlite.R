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
  data <- data %>% 
    mutate(date = as.Date(date, origin = lubridate::origin))
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

# date_range <- values
# data_test <- dbGetQuery(db, "SELECT * FROM responses_main")

plotExerciseLevels <- function(date_range) {
  
  # Connect to the database
  db <- dbConnect(SQLite(), sqlitePath)
  
  # fetch the data needed
  query <- sprintf("SELECT * FROM responses_main WHERE date BETWEEN %s AND %s", 
                   date_range[1] %>% as.numeric(), date_range[2] %>% as.numeric())
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  
  # plot data
  plot <- data %>% 
    mutate(level = factor(level,
                          levels = c("very_low", "low", "medium", "high", "very_high", "extreme"),
                          labels = c("very low", "low", "medium", "high", "very high", "extreme"),
                          ordered = TRUE),
           date = as.Date(date, origin = lubridate::origin)) %>% 
    ggplot(aes(x = date, y = level)) + 
    geom_point(aes(color = factor(type), size = duration), alpha = .5) +
    scale_size_continuous(name = "Duration", range = c(8, 15)) + 
    scale_color_brewer("Exercise type", palette = "Set2") +
    guides(colour = guide_legend(override.aes = list(size = 8))) +
    ggtitle("Exercise Level over Time") +
    theme_minimal()
  
  # disconnect
  plot
}

plotExerciseLevels2 <- function(date_range) {
  
  # Connect to the database
  db <- dbConnect(SQLite(), sqlitePath)
  
  # fetch the data needed
  query <- sprintf("SELECT rowid,* FROM responses_main WHERE date BETWEEN %s AND %s", 
                   date_range[1] %>% as.numeric(), date_range[2] %>% as.numeric())
  data <- dbGetQuery(db, query)
  
  # get the exercise type data
  selected_rowids = data$rowid
  query <-  sprintf("SELECT id,muscle FROM responses_strength WHERE id BETWEEN %s AND %s", 
                    selected_rowids[1], selected_rowids %>% tail(1))
  strength_data <- dbGetQuery(db,query)
  query <-  sprintf("SELECT id,endurance_type FROM responses_endurance WHERE id BETWEEN %s AND %s", 
                    selected_rowids[1], selected_rowids %>% tail(1))
  endurance_data <- dbGetQuery(db,query) 
  query <-  sprintf("SELECT id,climbing_type FROM responses_climbing WHERE id BETWEEN %s AND %s", 
                    selected_rowids[1], selected_rowids %>% tail(1))
  climbing_data <- dbGetQuery(db,query) 
  query <-  sprintf("SELECT id,other_type FROM responses_other WHERE id BETWEEN %s AND %s", 
                    selected_rowids[1], selected_rowids %>% tail(1))
  other_data <- dbGetQuery(db,query)
  query <-  sprintf("SELECT id,rest_activity FROM responses_rest WHERE id BETWEEN %s AND %s", 
                    selected_rowids[1], selected_rowids %>% tail(1))
  rest_data <- dbGetQuery(db,query)
  dbDisconnect(db)
  
  # merge data
  data_all <- data %>% 
    left_join(strength_data, by = c("rowid" = "id")) %>% 
    left_join(endurance_data, by = c("rowid" = "id")) %>% 
    left_join(climbing_data, by = c("rowid" = "id")) %>% 
    left_join(other_data, by = c("rowid" = "id")) %>% 
    left_join(rest_data, by = c("rowid" = "id")) %>% 
    unite("all_types", muscle:rest_activity, na.rm = TRUE) %>% 
    mutate(all_types = recode(all_types, "NULL" = "none"))
  
  # plot data
  plot <- data_all %>%
    mutate(level = factor(level,
                          levels = c("very_low", "low", "medium", "high", "very_high", "extreme"),
                          labels = c("very low", "low", "medium", "high", "very high", "extreme"),
                          ordered = TRUE),
           date = as.Date(date, origin = lubridate::origin)) %>%
    plot_ly(x = ~date, y = ~level, type = "scatter", mode = "markers",
            color = ~type, colors = "Set2",
            text = ~paste('</br> Type: ', all_types,
                          '</br> Duration: ', duration, 'h'),
            hovertemplate = paste('%{text}'),
            marker = list(size = ~duration %>% rescale(to = c(15,30))))
  plot
  
}

plotExerciseOverview <- function(date_range) {
  
  # Connect to the database
  db <- dbConnect(SQLite(), sqlitePath)
  
  # fetch the data needed
  query <- sprintf("SELECT rowid,* FROM responses_main WHERE date BETWEEN %s AND %s", 
                   date_range[1] %>% as.numeric(), date_range[2] %>% as.numeric())
  data <- dbGetQuery(db, query)
  
  # get the exercise type data
  selected_rowids = data$rowid
  query <-  sprintf("SELECT id,muscle FROM responses_strength WHERE id BETWEEN %s AND %s", 
                    selected_rowids[1], selected_rowids %>% tail(1))
  strength_data <- dbGetQuery(db,query)
  query <-  sprintf("SELECT id,endurance_type FROM responses_endurance WHERE id BETWEEN %s AND %s", 
                    selected_rowids[1], selected_rowids %>% tail(1))
  endurance_data <- dbGetQuery(db,query) 
  query <-  sprintf("SELECT id,climbing_type FROM responses_climbing WHERE id BETWEEN %s AND %s", 
                    selected_rowids[1], selected_rowids %>% tail(1))
  climbing_data <- dbGetQuery(db,query) 
  query <-  sprintf("SELECT id,other_type FROM responses_other WHERE id BETWEEN %s AND %s", 
                    selected_rowids[1], selected_rowids %>% tail(1))
  other_data <- dbGetQuery(db,query)
  query <-  sprintf("SELECT id,rest_activity FROM responses_rest WHERE id BETWEEN %s AND %s", 
                    selected_rowids[1], selected_rowids %>% tail(1))
  rest_data <- dbGetQuery(db,query)
  dbDisconnect(db)
  
  # merge data
  data_all <- data %>% 
    left_join(strength_data, by = c("rowid" = "id")) %>% 
    left_join(endurance_data, by = c("rowid" = "id")) %>% 
    left_join(climbing_data, by = c("rowid" = "id")) %>% 
    left_join(other_data, by = c("rowid" = "id")) %>% 
    left_join(rest_data, by = c("rowid" = "id")) %>% 
    unite("all_types", muscle:rest_activity, na.rm = TRUE) %>% 
    mutate(all_types = recode(all_types, "NULL" = "none"))
  
  
  plot <- data_all %>% 
    plot_ly(x = ~type, type = "histogram", color = ~all_types) %>% 
    layout(barmode = "overlay")
  
  plot
  
}
## update ---------

updateData <- function(table, id, variable, new_value, value_is_numeric) {
  
  # Connect to the database
  db <- dbConnect(SQLite(), sqlitePath)
  
  # query
  if(value_is_numeric == TRUE){
    new_value <- as.numeric(new_value)
  }
  
  if (table == "responses_main"){
    
    query <- sprintf("UPDATE responses_main SET %s = %s WHERE rowid == %s",
                     variable, new_value, id)
  } else {
    query <- sprintf("UPDATE %s SET %s = %s WHERE id == %s",
                     table, variable, new_value, id)
  }
  
  dbSendQuery(db, query)
  dbDisconnect(db)
  
}


  
  

