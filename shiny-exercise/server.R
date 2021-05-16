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
    
    # Whenever a field from main is filled, aggregate main form data
    formDataMain <- reactive({
        input$date %>% as.Date() %>% as.numeric()
        data <- sapply(fields_main, function(x) input[[x]])
        data
    })

    # aggregate the data per type depending on what type is chosen
    formDataType <- reactive({
        data <- sapply(paste("fields_", input$type, sep = "") %>% get(), function(x) input[[x]])
        data
    })
    
    # When the Submit button is clicked, save the form data and reset
    observeEvent(input$submit, {
        saveDataMain(formDataMain())
        saveDataType(formDataType(), input$type)
        reset("form")
    })
    
    # Graphics
    output$exercise_levels <- renderPlotly({
        input$submit
        input$update
        plotExerciseLevels2(input$date_range_level)
    })
    
    output$exercise_overview <- renderPlotly({
        input$submit
        input$update
        plotExerciseOverview(input$date_range_overview)
    })
    
    # Update
    observeEvent(input$update, {
        updateData(table = input$table_update, id = input$id_update, 
                   variable = input$variable_update, new_value = input$value_update, 
                   value_is_numeric = input$value_update_numeric)
    })

    # Show the previous responses
    # (update with current response when Submit is clicked)
    output$responses_main <- DT::renderDataTable({
        input$submit
        input$update
        loadDataMain()
    })
    
    output$responses_strength <- DT::renderDataTable({
        input$submit
        input$update
        loadDataType("strength")
    })
    
    output$responses_endurance <- DT::renderDataTable({
        input$submit
        input$update
        loadDataType("endurance")
    })
    
    output$responses_climbing <- DT::renderDataTable({
        input$submit
        input$update
        loadDataType("climbing")
    })
    
    output$responses_other <- DT::renderDataTable({
        input$submit
        input$update
        loadDataType("other")
    })
    
    output$responses_rest <- DT::renderDataTable({
        input$submit
        input$update
        loadDataType("rest")
    })
    
})
