library(RSQLite)

# create database

conn <- dbConnect(RSQLite::SQLite(), "shiny-exercise/data/exerciseDB.db")

responses_main <- data.frame(date = numeric(),
                             type = character(),
                             duration = numeric(),
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

# factor(levels = c("very_low", "low", "medium", "high", "very_high", "extreme"), ordered = TRUE) 
# factor(levels = c("run", "bike", "walk"), ordered = FALSE)
# factor(levels = c("lead_indoor", "lead_outdoor", "bouldering_indoor", "bouldering_outdoor", "multipitch", "toppas"), ordered = FALSE)
# factor(levels = c("hike", "ski", "canoeing", "yoga", "other"), ordered = FALSE),
