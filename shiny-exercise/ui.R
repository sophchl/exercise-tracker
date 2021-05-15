library(shiny)
library(shinyjs)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    useShinyjs(),
    
    # Application title
    titlePanel("Track your Exercise!"),
    
    div(
        id = "form",
        
        # Select inputs main
        dateInput("date",
                  hr("Date input"),
                  min = "2021-01-01"),
        checkboxInput("rest_day",
                      "Rest day",
                      value = FALSE),
        
        # enter details only if it was not a rest day
        conditionalPanel(
            condition = "input.rest_day == 0",
            
            sliderInput("duration",
                        hr("Duration in hours"),
                        min = 0,
                        max = 6,
                        step = 0.25,
                        value = 0),
            selectInput("level",
                        hr("How high was the exercise level?"),
                        choices = list("very low" = "very_low",
                                       "low" = "low", 
                                       "medium" = "medium",
                                       "high" = "high",
                                       "very high" = "very_high",
                                       "extreme" = "extreme")),
            selectInput("type",
                        hr("Exercise Type"),
                        choices = list("None" = "rest",
                                       "Strength" = "strength",
                                       "Endurance" = "endurance",
                                       "Climbing" = "climbing",
                                       "Outdoor Trip/Other" = "other")),
            
            # Select inputs conditional
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
                          value = "NA")
            ),
            conditionalPanel(
                condition = "input.type == 'endurance'",
                selectInput("endurance_type",
                            hr("Type of Endurance Exercise"),
                            choices = list("Running" = "run",
                                           "Biking" = "bike",
                                           "Walking" = "walk")
                ),
                numericInput("distance", 
                             hr("Distance in km"),
                             value = 1),
                textInput("place",
                          hr("Place/Round etc."),
                          value = "NA")
            ),
            conditionalPanel(
                condition = "input.type == 'climbing'",
                selectInput("climbing_type",
                            hr("What kind of climbing?"),
                            choices = list("Indoor Lead" = "lead_indoor",
                                           "Outdoor Lead" = "lead_outdoor",
                                           "Indoor Bouldering" = "bouldering_indoor",
                                           "Outdoor Boudldering" = "bouldering_outdoor",
                                           "Multipitch" = "multipitch",
                                           "Toppas" = "toppas")
                ),
                checkboxGroupInput("focus", 
                                   hr("Any focus of the training?"),
                                   choices = list("Endurance" = "endurance",
                                                  "Overhang" = "overhang",
                                                  "Slab" = "slab",
                                                  "Project" = "project",
                                                  "Falling" = "falling",
                                                  "Just climbing" = "just_climbing")
                )
            ),
            conditionalPanel(
                condition = "input.type == 'other'",
                selectInput("other_type",
                            hr("Other Activity"),
                            choices = list("Hiking" = "hike",
                                           "Skiing" = "ski",
                                           "Canoeing" = "canoeing",
                                           "Yoga" = "yoga",
                                           "Other" = "other")
                )
            )
        ),
        
        conditionalPanel(
            condition = "input.rest_day == 1",
            checkboxGroupInput("rest_activity",
                               hr("Rest day activity"),
                               choices = list("Walk" = "walk",
                                              "Stretch" = "stretch",
                                              "Foam Roll" = "foam"))
        ),
        
        # Comment for all
        textInput("comment",
                  hr("Comments"),
                  value = "NA"),
        
    ),
    
    # Submit inputs
    actionButton("submit", "Submit"),
    tags$hr(),
    
    # Display data
    h4("Main"),
    DT::dataTableOutput("responses_main", width = 500),
    h4("Strength"),
    DT::dataTableOutput("responses_strength", width = 500),
    h4("Endurance"),
    DT::dataTableOutput("responses_endurance", width = 500),
    h4("Climbing"),
    DT::dataTableOutput("responses_climbing", width = 500),
    h4("Other"),
    DT::dataTableOutput("responses_other", width = 500), 
    h4("Rest"),
    DT::dataTableOutput("responses_rest", width = 500)

))
