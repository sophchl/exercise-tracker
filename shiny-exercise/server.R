library(shiny)
library(bslib)
library(shiny)
library(dplyr)
library(tidyr)
library(RSQLite)
library(ggplot2)
library(plotly)
library(scales)

# Define fields to save data to
fields_main <- c("date", "type", "duration_h", "duration_m", "level")
fields_strength <- c("muscle", "workout", "comment")
fields_endurance <- c("endurance_type", "distance", "place", "comment")
fields_climbing <- c("climbing_type", "focus", "comment")
fields_other <- c("other_type", "comment")
fields_rest <- c("rest_activity", "comment")


# Define server logic
shinyServer(function(input, output, session) {
    
    # Define update events for all tables and graphs
    toListen <- reactive({
        list(input$submit, input$update)
    })

    # Whenever a field from main is filled, aggregate main form data
    formDataMain <- reactive({
        input$date %>% as.Date() %>% as.numeric()
        data <- sapply(fields_main, function(x) input[[x]])
        data
    })

    # Aggregate the data per type depending on what type is chosen
    formDataType <- reactive({
        data <- sapply(paste("fields_", input$type, sep = "") %>% get(), function(x) input[[x]])
        data
    })
    
    # When the Submit button is clicked, save the form data and reset form
    observeEvent(input$submit, {
        saveDataMain(formDataMain())
        saveDataType(formDataType(), input$type)
        reset("form")
    })
    
    # Graphics
    output$exercise_levels <- renderPlotly({
        toListen()
        plotExerciseLevels(input$date_range_level)
    })
    
    output$exercise_overview <- renderPlotly({
        toListen()
        plotExerciseOverview(input$date_range_overview)
    })
    
    # Update
    observeEvent(input$update, {
        updateData(table = input$table_update, id = input$id_update,
                   variable = input$variable_update, new_value = input$value_update, 
                   value_is_numeric = input$value_update_numeric)
    })
    
    # Delete
    observeEvent(input$delete, {
        deleteData(id = input$id_delete)
    })
    
    # Show the rowid for a particular date in case main table needs to be updated
    output$rowids_for_date <- renderText({
        rowid <- returnRowId(input$date_rowid)
        paste("You have choosen date", input$date_rowid, ". ", rowid)
    })

    # Show the previous responses
    # (update with current response when Submit/Update is clicked)
    
    output$responses_main <- DT::renderDataTable({
        toListen()
        DT::datatable(loadDataMain(), 
                     options = list(order = list(1, 'desc'))
        )
    })
    
    output$responses_strength <- DT::renderDataTable({
        toListen()
        DT::datatable(loadDataType("strength"), 
                      options = list(order = list(1, 'desc'))
        )
    })
    
    output$responses_endurance <- DT::renderDataTable({
        toListen()
        DT::datatable(loadDataType("endurance"), 
                      options = list(order = list(1, 'desc'))
        )
    })
    
    output$responses_climbing <- DT::renderDataTable({
        toListen()
        DT::datatable(loadDataType("climbing"), 
                      options = list(order = list(1, 'desc'))
        )
    })
    
    output$responses_other <- DT::renderDataTable({
        toListen()
        DT::datatable(loadDataType("other"), 
                      options = list(order = list(1, 'desc'))
        )
    })
    
    output$responses_rest <- DT::renderDataTable({
        toListen()
        DT::datatable(loadDataType("rest"), 
                      options = list(order = list(1, 'desc'))
        )
    })
    
})
