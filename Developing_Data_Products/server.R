# Developing Data Products - Assignment 1
# server.R


# Define a function 'calcMeans' that calculates the three types of averages.
# The user-selected values for 'x' and 'y' (collected via ui.R will be passed
# into this function.

calcMeans <- function(x,y) {
               Arithmetic.mean <- (x+y)/2
               Geometric.mean <- sqrt(x*y)
               Harmonic.mean <- 2 / (1/x + 1/y)
               final_means <- cbind(Arithmetic.mean, Geometric.mean, Harmonic.mean)
               final_means
}

# Define generic function, which is required for all shiny apps

shinyServer(function(input, output) {
     
     # Create two text output variables that will be passed back to 'ui.R'
     # for display in the user's browser window. The sentences created display
     # the user-selected integer values for use in the various averages.
     
     output$text1 <- renderText({ 
          paste("The first integer selected was:", input$x_value)
     })

     output$text2 <- renderText({ 
          paste("The second integer selected was:", input$y_value)
     })

     # Create a bar graph contained in the variable 'barPlot' that will be passed 
     # back to 'ui.R' for display in the user's browser window. The plot displays
     # three bars--one for each type of average. The averages are computed via the
     # calcMeans function defined above and stored in the vector 'values_to_plot'.
     # The 'text' line at the bottom of this section prints the actual mean values
     # on the bars.
     
     output$barPlot <- renderPlot({
          values_to_plot <- calcMeans(input$x_value, input$y_value)
          barGraph <- barplot(values_to_plot, 
                              ylim=c(0,50),
                              col = "skyblue",
                              main = "Various Types of Averages",
                              cex.axis = 1.25,
                              cex.names = 1.25
                              )
          text(barGraph, 0, paste("Mean = ",round(values_to_plot, 2)),cex=1.2,pos=3)
     })

})
