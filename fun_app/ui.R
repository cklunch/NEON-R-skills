shinyUI(
  fluidPage(
    titlePanel("This app is awesome"),
    sidebarLayout(
      sidebarPanel(
        selectInput("dist", label="Choose a distribution", 
                    choices=list("Normal","Cauchy","Uniform")),
        numericInput("num", label="Input number of samples", value=100)
      ),
      mainPanel(
        wellPanel(
          p("We're going to put some content here."),
          plotOutput("fig")
        )
      )
    )
  )
)