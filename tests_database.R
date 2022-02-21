# connect to database

db <- dbConnect(RSQLite::SQLite(), "shiny-exercise/data/exerciseDB.db")

# manually delete entries from other tables that do not match main table

rowids <- dbGetQuery(db, "SELECT rowid from responses_main")
tables <- dbListTables(db)
type_tables <- tables[tables != "responses_main"]

for (table in type_tables){
  
  # get all ids from type table
  query <- paste("SELECT id from", table)
  ids <- dbGetQuery(db, query)
  
  # delete ids that are not in main table
  ids_delete <- subset(ids, !(id %in% rowids$rowid)) %>% pull(id)
  ids_string <- toString(sprintf("'%s'", ids_delete))
  query_part_one <- paste("DELETE from", table, "WHERE")
  query <- sprintf("DELETE from %s WHERE id IN (%s)",
                   table, ids_string)
  dbExecute(db, query)
  
}

# disconnect

dbDisconnect(db)
