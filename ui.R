source("Base.R")

fluidPage(
    
    headerPanel("Stupid Shiny APP - Useless word analysis"),
    
    sidebarLayout(

        sidebarPanel(helpText("This is an Stupid shinny app that allows you to make useless 
                              word analysis from words found in twitter. 
                              Follow the steps:"),
                     helpText("(1) Pick a word"),
                     helpText("(2) Define the number of tweets you want to analyze"),
                     helpText("(3) Push the button and enjoy the USELESS"),
                     
                     textInput(inputId = "UserOrHashtag",
                               label = "Twitter User or Hashtag:",
                               value = "Galicia"),
                     
                     sliderInput("Ntweets", "Maximum number of tweets to capture:",
                                 min=25, max= 500, value=100, step = 1),
                     
                     submitButton("Update View", icon = icon("refresh")),
                     width = 3
        ),
        
        mainPanel(
            tabsetPanel(
                tabPanel("Boxplot de kk",plotlyOutput("P1")),
                tabPanel("Miermap",leafletOutput("M1")),
                tabPanel("Tweets and go home",tableOutput("T1"))
            )
        )
    )
)
