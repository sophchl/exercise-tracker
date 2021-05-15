library(shiny)
library(dplyr)
library(RSQLite)

# Define fields to save data to
fields_main <- c("date", "duration", "level")
fields_strength <- c("muscle", "workout")
fields_endurance <- c("endurance_type", "distance", "place")
fields_other <- c("other_type", "comment")


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    # Whenever a field from main is filled, aggregate main form data
    formDataMain <- reactive({
        data <- sapply(fields_main, function(x) input[[x]])
        data
    })

    # aggregate the data per type depending on what type is chosen
    formDataType <- reactive({
        data <- sapply(paste("fields_", input$type, sep = "") %>% get(), function(x) input[[x]])
        data
    })
    
    # When the Submit button is clicked, save the form data
    observeEvent(input$submit, {
        saveDataMain(formDataMain())
        saveDataType(formDataType(), input$type)
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
    
    output$responses_other <- DT::renderDataTable({
        input$submit
        loadDataType("other")
    })
    
})
