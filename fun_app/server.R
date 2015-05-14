shinyServer(function(input,output){
  dummy <- reactive({
    if(input$dist=="Normal")
      return(rnorm(input$num))
    if(input$dist=="Cauchy")
      return(rcauchy(input$num))
    if(input$dist=="Uniform")
      return(runif(input$num))
  })
  output$fig <- renderPlot(
    hist(dummy())
    )
})