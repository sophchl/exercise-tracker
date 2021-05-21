library(RSQLite)

# create database

conn <- dbConnect(RSQLite::SQLite(), "shiny-exercise/data/exerciseDB.db")

responses_main <- data.frame(date = numeric(),
                             type = character(),
                             duration_h = numeric(),
                             duration_m = numeric(),
                             level = character()
                       
)

responses_strength <- data.frame(id = numeric(),
                                 muscle = character(),
                                 workout = character(),
                                 comment = character()
)

responses_endurance <- data.frame(id = numeric(),
                                  endurance_type = character(),
                                  distance = numeric(),
                                  place = character(),
                                  comment = character()
)

responses_climbing <- data.frame(id = numeric(),
                                 climbing_type = character(),
                                 focus = character(),
                                 comment = character()
)

responses_other <- data.frame(id = numeric(),
                              other_type = character(),
                              comment = character()
)

responses_rest <- data.frame(id = numeric(),
                             rest_activity = character(),
                             comment = character()
)

dbWriteTable(conn, "responses_main", responses_main)
dbWriteTable(conn, "responses_strength", responses_strength)
dbWriteTable(conn, "responses_endurance", responses_endurance)
dbWriteTable(conn, "responses_climbing", responses_climbing)
dbWriteTable(conn, "responses_other", responses_other)
dbWriteTable(conn, "responses_rest", responses_rest)

dbListTables(conn)
dbDisconnect(conn)

# to remove values from database
# db <- dbConnect(RSQLite::SQLite(), "shiny-exercise/data/exerciseDB.db")

all_dates <- dbGetQuery(db, "SELECT date FROM responses_main") %>% 
  pull(date) %>% 
  as.Date(origin = lubridate::origin)
dates_keep <- all_dates[1:7]
smallest_date <- min(dates_keep) %>% as.numeric()
largest_date <- max(dates_keep) %>% as.numeric()
dbGetQuery(db,"DELETE FROM responses_main WHERE date < smallest_date OR date > largest_date")
query <- sprintf("DELETE FROM responses_main WHERE date < %s OR date > %s",
                 smallest_date, largest_date)
dbExecute(db, query)
  
all_my_other_tables <- dbListTables(db)[dbListTables(db) != "responses_main"]
for (t in all_my_other_tables){

query <- sprintf("DELETE FROM %s WHERE id IN (SELECT %s.id FROM %s LEFT JOIN responses_main ON %s.id=responses_main.rowid WHERE responses_main.rowid IS NULL)",
                 t,t,t,t)
dbExecute(db, query)

}
  
dbDisconnect(db)
