library(shinyjs)
library(bslib)
library(shiny)
library(dplyr)
library(tidyr)
library(RSQLite)
library(ggplot2)
library(plotly)
library(scales)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    useShinyjs(),
    theme = bs_theme(version = 4, bootswatch = "minty"),
    
    # Application title
    titlePanel("Track your Exercise!"),
    
    sidebarLayout(
    
        sidebarPanel(
            
            h3("Enter your details here"), tags$hr(),
            p("Enter the details for each exercise day. Once the submit button is clicked the data is saved and the fields are reset."),
        
            div(
                id = "form",
                
                # Select inputs main
                dateInput("date",
                          hr("Date input"),
                          min = "2021-01-01",
                          weekstart = 1,
                          format = "yyyy-mm-dd"),
                checkboxInput("rest_day",
                              "Rest day",
                              value = FALSE),
                
                # enter details only if it was not a rest day
                conditionalPanel(
                    condition = "input.rest_day == 0",
                    
                    sliderInput("duration_h",
                                hr("Duration in hours"),
                                min = 0,
                                max = 6,
                                step = 1,
                                value = 0),
                    sliderInput("duration_m",
                                hr("Duration in minutes"),
                                min = 0,
                                max = 60,
                                step = 5,
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
                                                   "Outdoor Bouldering" = "bouldering_outdoor",
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
                                                   "Talking a walk" = "walking_chill",
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
            tags$hr()
    
        ),
    
        mainPanel(
            # Graphs
            h3("Visualization"), tags$hr(),
            p("For each visualization you can select the time range the graph should show"),
            # levels
            dateRangeInput("date_range_level",
                           hr("Select the date range for analysis"),
                           min = "2021-01-01", 
                           max = Sys.Date(), 
                           start = Sys.Date() -7,
                           end = Sys.Date()),
            plotlyOutput("exercise_levels"),
            dateRangeInput("date_range_overview",
                           hr("Select the date range for analysis"),
                           min = "2021-01-01", 
                           max = Sys.Date(), 
                           start = Sys.Date() -30,
                           end = Sys.Date()),
            plotlyOutput("exercise_overview"),
            
        )
    
    ),
    
    sidebarLayout(
        
        sidebarPanel(
            h3("Need to modify something?"), tags$hr(),
            p("In case you need to change an entry, you can do so by id (rownumber of the main dataset). So far a quite basic implementation - you have to enter the columns and variable names as stored in the SQLite database and put strings in quotation marks."),
            selectInput("table_update",
                        hr("Which table needs to be updated?"),
                        choices = list("Main" = "responses_main",
                                       "Strength" = "responses_strength",
                                       "Endurance" = "responses_endurance", 
                                       "Climbing" = "responses_climbing", 
                                       "Other" = "responses_other",
                                       "Rest" = "responses_rest")),
            numericInput("id_update",
                         hr("Id of the entry to be updated"),
                         value  = "0"),
            textInput("variable_update",
                      hr("Variable to be updated"),
                      value = "Enter text.."),
            textInput("value_update",
                      hr("Enter the new value"),
                      value = "Enter text.."),
            checkboxInput("value_update_numeric",
                          "Value to be updated numeric?",
                          value = FALSE),
            actionButton("update", "Update")
            
            
        ),
        
        mainPanel(
            # Display data
            h3("Data"), tags$hr(),
            h4("Main"),
            DT::dataTableOutput("responses_main", width = 700),
            h4("Strength"),
            DT::dataTableOutput("responses_strength", width = 700),
            h4("Endurance"),
            DT::dataTableOutput("responses_endurance", width = 700),
            h4("Climbing"),
            DT::dataTableOutput("responses_climbing", width = 700),
            h4("Other"),
            DT::dataTableOutput("responses_other", width = 700), 
            h4("Rest"),
            DT::dataTableOutput("responses_rest", width = 700)
        )
    ),
    
))
