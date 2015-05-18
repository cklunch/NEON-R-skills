---
layout: post
title: "R Shiny basics"
date:   2015-04-24
authors: CLAIRE LUNCH, CHRISTINE LANEY
categories: [R Training]
tags : [ ]
description: "This lesson will guide you through making a simple shiny app."
---

## What is Shiny?
Shiny is an R package that provides a web framework for building web applications. Is has been developed by the same team that brings you RStudio. 

Instead of having to learn all three of the basic web programming languages:

* Hypertext Markup Language (HTML), which is used for the main content of a webpage;
* Cascading Style Sheets (CSS), which is used to add styles, like font type and background colors;
* JavaScript (NOT to be confused with Java!), which allows users to 'interact' with web content,

you can write code in R and end up with an interactive webpage or website! Shiny takes your input, and writes out the HTML, CSS, and JavaScript necessary to run your application in a web browser. If you run a shiny app in your browser (see the examples below), you should take a look at the source code for the webpage!

Shiny has also been called 'an R wrapper for JavaScript', but this doesn't quite capture Shiny's power!

## What can I do with Shiny?
There are many options! Here are a few ways we have used Shiny:

* <a href="https://cklunch.shinyapps.io/terms_app/">Keep track of NEON data product numbers and related information, like terms and units</a>
* <a href="http://www.neoninc.org/data-resources/get-data/data-product-availability">Display the upcoming availability of NEON data products</a>
* Create applications to read in files and output data sheets for NEON field crews
* Visualize NEON data
* Write data analysis programs

You could do any of these, and far more!

## Prerequisites for this lesson:

* Basic functional knowledge of R
* RStudio installed
* Package <code>shiny</code> installed and loaded (<code>library(shiny)</code>). Package <code>shinyBS</code> is also nice to have - and BS stands for BootStrap, not ...!
<br>

## Shiny structure

A Shiny app requires  (at the very least) two R files to run: a file of commands describing the user interface, named ui.R, and a file of commands describing the functionality and processing the app carries out, named server.R

The <a href="https://shiny.rstudio.com/"> Shiny website</a> is excellent, and the <a href="https://shiny.rstudio.com/gallery/"> gallery page</a> is especially helpful, since it allows you to look at example apps in a split-screen with the code that produced them. Start by looking at the very simple <a href="http://shiny.rstudio.com/gallery/telephones-by-region.html"> Telephones by region</a> example. The app provides a dropdown list of regions (like North America), and assigns the user's choice as an input (input$region in server.R, defined by selectInput() in ui.R). A section of code in server.R uses the input to generate a bar plot from the data subset defined by the input choice, and ui.R places that bar plot within the user interface. As you can see, there is a constant back and forth of inputs and outputs between the two files.

This is the general structure. Any dynamic input you want to use in server.R needs to have a corresponding command for inputting it on the ui.R side; conversely, any dynamic output you want to display on ui.R needs to be created in server.R. ui.R is also responsible for all of the layout for your web site.

Both ui.R and server.R must be in a single folder together, along with any input datasets or other code files needed to run the app (we won't cover the "other code files" scenario in this lesson, but you can find examples in the Shiny gallery). When you run the app, it will look for all the information it needs in that one folder (another advanced Shiny caveat: you can also use web addresses and other connections to pull in data, but we won't do that here).

## Making an app: getting started, technique #1
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

7. So what the heck are these commands that I just entered doing??
* server.R is just setting up a basic frame work that, well, does nothing except allow the app to run!
* ui.R is doing all the work right now...
    + fluidPage( ) makes a page that allow you to resize the browser window and have the contents move to fit the newly resized page.
    + titlePanel( ) make a nice looking title for your page, with a large font
    + mainPanel( ) holds the content of the rest of the web page
    + wellPanel( ), which creates a box with a slightly inset border and grey background that holds your p( ) [paragraph!]. Incidentally, for those web programmers in our audience, it is equivilent to calling Bootstrap's well CSS class!

## Making an app: getting started, technique #2
RStudio has recently made it even easier for you to create a new project and app at the same time, AND version it using GitHub or other versioning system. An R project keeps track of all the elements of your project (everything in your project folder). Working within a project has numerous advantages. When you open an R project:

* The working directly will be automatically set to within the folder you are working from
* The .RData file in the project directory will be loaded 
* Your previous RStudio settings will be restored - and each project can have different settings
* You will be able to rapidly switch between projects using the dropdown list provided on the top right corner of your RStudio window... and more!

For more information, check out <a href="https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects">this link</a>.

To create a project and shiny app at the same time:

* Open RStudio
* Select File --> New Project
* Follow the wizard directions

For learning purposes, it is always great to start from scratch, but using this option may save you a lot of effort once you're up and running.

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


## More reactive inputs
1. I made the app generate 100 instances of a random variable by default; let's make the number of instances into a user input.
2. First we need to make an input entry field on the UI:

    ```
    shinyUI(
    	fluidPage(
    		titlePanel("This app is awesome"),
    		sidebarLayout(
    			sidebarPanel(
    				selectInput("dist", 
    				label="Choose a distribution",
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
    ```

3. value=100 sets the initial value of input$num to 100; if we don't set an initial value the app can't run because it doesn't know what to do with the input.
4. Now replace the default 100 on the server side with input$num:

    ```
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
    ```




## Sharing your app
There are a few relatively simple options for sharing your app.

First, you can email your shiny app folder to a collaborator - if it contains a project file, then all of your file paths are relative to the folder, no matter where the folder is placed. However, realize that once you share it in this fashion, you can effectively lose control over the copy that you send. 

Even better, if you want to share your app with a number of people and want to collect their data or keep some sort of control over the development of the app, there are a couple of options to consider:

* Host your project on GitHub or similar versioning system. Your users can contribute in a relatively moderated and controlled way to the evolution of your app, or they can clone the app and use it as is on their own systems.
* Host your app on http://shinyapps.io. This service is free to an extent. With a free account, you can host several apps and your apps can be 'active' for up to 25 hours per month. Each use will cost at least 15 minutes, but multiple people can use the app at the same time. This also 'hides' your code from your user base.






