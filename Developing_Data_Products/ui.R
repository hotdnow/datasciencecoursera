# Developing Data Products - Assignment 1
# ui.R


# Load required library

library(shiny)

# Create Shiny user interface using 'fluidpage' parameter so that the display
# automatically adjusts to the dimensions of the  user's browser window.

shinyUI(fluidPage(
     
     # Title of the left portion of the page
     
     titlePanel(h3("It All Averages Out...")),
     
     # Include background information and user documentation 
     
     p("Welcome!"),
     p("The below application was built using 'Shiny' from RStudio. Getting started with the 
     application is very easy..."),
     p("Here's all the", strong("documentation"), "you will need:"),
     p("1. Drag each of the two sliders below to select integers."),
     p("2. Based on your selections, the barchart on the screen will dynamically 
     update and display three types of averages."),
     p("3. The averages of two numbers, say 'x' and 'y', calculated in this application are:"),
     
     code("-", strong("Arithmetic average:"),"(x+y)/2"),
     br(),br(),
     code("-", strong("Geometric average:"),"sqrt(xy)"),
     br(),br(),
     code("-", strong("Harmonic average:"),"2/[1/x + 1/y]"),
     br(),
     br(),
     p("That's all there is to it...Have fun!"),
     br(),
          
     # The left sidebar contains two sliders that capture the user's selections
     # for the integers to use in calculating the various averages.
     # The user's selections are stored in the variables 'x_value' and 'y_value'
     
     sidebarLayout(
          sidebarPanel(
               sliderInput("x_value", "Select the first integer:",
                           min = 1, max = 50, value = 15, step = 1),
               br(),
               br(),

               sliderInput("y_value", "Select the second integer:",
                           min = 1, max = 50, value = 30, step = 1)
               
          ),
          
     # The main panel displays the user's selected integers as well as a three
     # bar graph showing the computed averages.
          
          mainPanel(
               textOutput("text1"),
               textOutput("text2"),
               plotOutput("barPlot")
               
          )
     )
))
