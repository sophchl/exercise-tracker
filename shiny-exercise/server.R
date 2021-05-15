library(shiny)
library(dplyr)
library(RSQLite)
library(ggplot2)

# Define fields to save data to
fields_main <- c("date", "type", "duration", "level")
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
    output$exercise_levels <- renderPlot({
        input$submit
        plotExerciseLevels(input$date_range_level)
    })

    # Show the previous responses
    # (update with current response when Submit is clicked)
    output$responses_main <- DT::renderDataTable({
        input$submit
        loadDataMain()
    })
    
    output$responses_strength <- DT::renderDataTable({
        input$submit
        loadDataType("strength")
    })
    
    output$responses_endurance <- DT::renderDataTable({
        input$submit
        loadDataType("endurance")
    })
    
    output$responses_climbing <- DT::renderDataTable({
        input$submit
        loadDataType("climbing")
    })
    
    output$responses_other <- DT::renderDataTable({
        input$submit
        loadDataType("other")
    })
    
    output$responses_rest <- DT::renderDataTable({
        input$submit
        loadDataType("rest")
    })
    
})
