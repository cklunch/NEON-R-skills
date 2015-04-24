shinyServer(function(input,output){
  dummy <- reactive({
    if(input$dist=="Normal")
      return(rnorm(100))
    if(input$dist=="Cauchy")
      return(rcauchy(100))
    if(input$dist=="Uniform")
      return(runif(100))
  })
  output$fig <- renderPlot(
    hist(dummy())
    )
})