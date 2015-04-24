---
layout: post
title: "R Shiny basics"
date:   2015-04-24
authors: CLAIRE LUNCH, CHRISTINE LANEY
categories: [R Training]
tags : [ ]
description: "This lesson will guide you through making a simple shiny app."
code1: 
image:
  feature: 
  credit: 
  
---

## Prerequisites for this lesson:

- Basic functional knowledge of R

- RStudio installed

<br>

## Shiny structure

A Shiny app requires two R files to run: a file of commands describing the user interface, named ui.R, and a file of commands describing the functionality and processing the app carries out, named server.R

The <a href="https://shiny.rstudio.com/"> Shiny website</a> is excellent, and the <a href="https://shiny.rstudio.com/gallery/"> gallery page</a> is especially helpful, since it allows you to look at example apps in a split-screen with the code that produced them. Start by looking at the very simple <a href="https://http://shiny.rstudio.com/gallery/telephones-by-region.html"> Telephones by region</a> example. The app takes one input (input$region in server.R, defined by selectInput() in ui.R), and creates a barplot from the data subset defined by the input choice.

This is the general structure. Any dynamic input you want to use in server.R needs to have a corresponding command for inputting it on the ui.R side; conversely, any dynamic output you want to display on ui.R needs to be created in server.R.

Both ui.R and server.R must be in a single folder together, along with any input datasets or other code files needed to run the app (we won't cover the "other code files" scenario in this lesson, but you can find examples in the Shiny gallery). When you run the app, it will look for all the information it needs in that one folder (another advanced Shiny caveat: you can also use web addresses and other connections to pull in data, but we won't do that here).

## Making an app: getting started
1. Create a folder wherever you like on your computer and call it awesome_app
2. In this folder, create two R script files, ui.R and server.R (surprise!)
3. Before we make the app actually do anything, we'll put in the code on the server side that will make the app run. In server.R, write the Shiny server function, empty:

    ```
    shinyServer(function(input,output){
    
    })
    ```

4. On the user interface side, we'll make a title for the app.
In ui.R, enter:

    ```
    shinyUI(
    	fluidPage(
    		titlePanel("This app is awesome"),
    		mainPanel(
    			wellPanel(
    				p("We're going to put some content here.")
    			)
    		)
    	)
    )
    ```

5. Save both files, then click on the "Run App" button. Look what you made!
6. If you're used to using R Studio, you'll notice the "Run App" button used to be the "Run" button. This means you can't use that button to try out single lines of code when you're writing shiny apps. The keyboard shortcuts, command-enter or ctrl-enter, still work the normal way.


## Making an app: Outputs
1. We're going to start by graphing a dummy variable. Most of the action will be on the server side, all we have to do on the user interface side is create a place to put the graph.
2. Add the dummy variable to your server.R code:

    ```
    shinyServer(function(input,output){
    	dummy <- rnorm(100)
    })
    ```

3. The plot command ("hist" here for a histogram) is nested inside a renderPlot function to create the output object. output$fig is the output object.

    ```
    shinyServer(function(input,output){
    	dummy <- rnorm(100)
    	output$fig <- renderPlot(
    		hist(dummy)
    	)
    })
    ```

4. In ui.R we need to make a place for the output object to go. Here we just use the name of the output object, "fig":

    ```
    shinyUI(
    	fluidPage(
    		titlePanel("This app is awesome"),
    		mainPanel(
    			wellPanel(
    				p("We're going to put some content here."),
    				plotOutput("fig")
    			)
    		)
    	)
    )
    ```

5. Note one very important thing in the ui.R code - there is now a comma after the p() text. Commas separate different panels in the UI, and different commands within the same panel.
6. Run the app. Look, it's a histogram!


## Making an app: Inputs
1. Shiny apps are delightful because they're interactive, so let's make this one interactive!
2. Above, we made the dummy variable in server.R using the rnorm() function. Instead, we can have the UI offer a choice of distributions to sample from, and then plot a histogram of the one we choose.
3. In ui.R, let's first make a sidebar panel to put the input drop-down menu in:

    ```
    shinyUI(
    	fluidPage(
    		titlePanel("This app is awesome"),
    		sidebarLayout(
    			sidebarPanel(
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
    ```

4. Note that both mainPanel() and sidebarPanel() are nested in sidebarLayout(). If you run the app at this point, you'll see it runs the same but now has a empty grey box on the side.
5. Now add the input function to the sidebar:

    ```
    shinyUI(
    	fluidPage(
    		titlePanel("This app is awesome"),
    		sidebarLayout(
    			sidebarPanel(
    				selectInput("dist", 
    				label="Choose a distribution",
    				choices=list("Normal","Cauchy","Uniform"))
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
    ```

6. Now the server.R side needs to know what to do with each option:

    ```
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
    ```

7. The dummy variable is now a reactive object. Note that in the hist() function we now call hist(dummy()) instead of hist(dummy)
8. Run the app and cycle through the options!






