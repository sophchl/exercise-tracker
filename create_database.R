library(RSQLite)
library(lubridate)

# create database

conn <- dbConnect(RSQLite::SQLite(), "shiny-exercise/data/exerciseDB.db")

exercise <- data.frame(id = numeric(),
                       date = ymd(character()),
                       duration = dhours(numeric()),
                       level = factor(character())
                       
)

strength <- data.frame(id = numeric(),
                       muscle = factor(character()),
                       workout = character()
)

endurance <- data.frame(id = numeric(),
                        endurance_type = factor(character()),
                        distance = numeric(),
                        place = character()
)

other <- data.frame(id = numeric(),
                    other_type = factor(character()),
                    comment = character())

dbWriteTable(conn, "exercise", exercise)
dbWriteTable(conn, "strength", strength)
dbWriteTable(conn, "endurance", endurance)
dbWriteTable(conn, "other", other)

dbListTables(conn)
dbDisconnect(conn)
