#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(shinydashboard)
library(flexdashboard)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Análisis de datos del sitio Academatica"),

    h3("Erick Pineda - 17012140 "),
    h3("Ariel Chitay - 19002065"),
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Seleccione cantidad de filas que desea ver de la tabla Video Stats:",
                        min = 1,
                        max = 50,
                        value = 10)
            ,
            numericInput("nrows", "Enter the number of rows to display:", 5)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            #plotOutput("distPlot"),
            
            
            tabsetPanel(type = "tabs",
                        
                        tabPanel("Tabla Video Stats", 
                                 tableOutput("table"),
                                 tableOutput("tbl")
                        ),
                        tabPanel("Conteo General", 
                                 
                                 tableOutput("tblConteoGeneral"),
                                 tableOutput("tblCantidadVistas")
                                 
                                 ),
                        tabPanel("Visitas",
                                 #tableOutput("tblNombres")
                                 h3("Dispersión de visitas"),
                                 plotOutput("tblGrafica"),
                                 h3("Top de 50 Videos"),
                                 plotOutput("tblGrafica2")
                                 
                                  
                                 
                                 )
                        ,
                        tabPanel("Likes",
                                 #tableOutput("tblNombres")
                                 h3("Nivel de aceptación por Video"),
                                 plotOutput("tblLikes")
                                
                                 
                                 
                                 
                        )
                        ,
                        tabPanel("Medidores",
                                 #tableOutput("tblNombres")
                                 h3("Medidores"),
                                 infoBoxOutput("infoBoxConfirmadosHoy",width = 3),
                                 gaugeOutput("gaugeEnTratamiento",width = "100%", height = "auto"),
                                 gaugeOutput("gaugeLike",width = "100%", height = "auto"),
                                 gaugeOutput("gaugeNotLike",width = "100%", height = "auto")
                                 
                                 
                                 
                                 
                        )
                        
                        
                        
                        
                       
            )
            
            
            
        )
    )
))
