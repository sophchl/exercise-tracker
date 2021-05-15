library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Where to store data
    DT::dataTableOutput("responses_main", width = 500), 
    DT::dataTableOutput("responses_strength", width = 500),
    DT::dataTableOutput("responses_endurance", width = 500),
    DT::dataTableOutput("responses_other", width = 500), tags$hr(),
    
    # Application title
    titlePanel("Track your Exercise!"),
    
    # Select inputs
    dateInput("date",
              hr("Date input"),
              min = "2021-01-01"),
    selectInput("type",
                hr("Exercise Type"),
                choices = list("Strength" = "strength",
                               "Endurance" = "endurance",
                               "Other" = "other")),
    sliderInput("duration",
                hr("Duration in hours"),
                min = 0,
                max = 6,
                step = 0.25,
                value = 1),
    selectInput("level",
                hr("How high was the exercise level?"),
                choices = list("very low" = "very_low",
                               "low" = "low", 
                               "medium" = "medium",
                               "high" = "high",
                               "very high" = "very_high",
                               "extreme" = "extreme")),
    h3("Exercise Information"),
    conditionalPanel(
        condition = "input.type == 'strength'",
        checkboxGroupInput("muscle",
                    hr("Muscle"),
                    choices = list("Legs" = "legs",
                                   "Core" = "core",
                                   "Back" = "back",
                                   "Arms" = "arms", 
                                   "Fingers" = "fingers")),
        
        textInput("workout",
                  hr("What workout did you do?"),
                  value = "Enter text.."),
    ),
    conditionalPanel(
        condition = "input.type == 'endurance'",
        selectInput("endurance_type",
                    hr("Type of Endurance Exercise"),
                    choices = list("run", "bike", "walk")
                    ),
        numericInput("distance", 
                     hr("Distance in km"),
                     value = 1),
        textInput("place",
                  hr("Place/Round etc."),
                  value = "Enter text.."),
    ),
    conditionalPanel(
        condition = "input.type == 'other'",
        selectInput("other_type",
                    hr("Type of Other Exercise"),
                    choices = list("hike", "climb", "ski", "other")),
        textInput("comments",
                  hr("Comments"),
                  value = "Enter text..")
    ),

    # Submit inputs
    actionButton("submit", "Submit")

))
