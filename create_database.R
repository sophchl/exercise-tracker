library(RSQLite)
library(lubridate)

# create database

conn <- dbConnect(RSQLite::SQLite(), "shiny-exercise/data/exerciseDB.db")

responses_main <- data.frame(id = numeric(),
                       date = ymd(character()),
                       duration = dhours(numeric()),
                       level = factor(character())
                       
)

responses_strength <- data.frame(id = numeric(),
                       muscle = factor(character()),
                       workout = character()
)

responses_endurance <- data.frame(id = numeric(),
                        endurance_type = factor(character()),
                        distance = numeric(),
                        place = character()
)

responses_other <- data.frame(id = numeric(),
                    other_type = factor(character()),
                    comment = character())

dbWriteTable(conn, "responses_main", responses_main)
dbWriteTable(conn, "responses_strength", responses_strength)
dbWriteTable(conn, "responses_endurance", responses_endurance)
dbWriteTable(conn, "responses_other", responses_other)

dbListTables(conn)
dbDisconnect(conn)
