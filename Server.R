#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(RMySQL)
library(pool)
library(dplyr)
library(shinydashboard)
library(flexdashboard)





# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    
    
    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        # hist(x, breaks = bins, col = 'darkgray', border = 'white')

    })
    
    output$tbl <- renderTable({
        conn <- dbConnect(
            drv = RMySQL::MySQL(),
            dbname = "BASE_GALILEO1",
            host = "ec2-54-234-91-151.compute-1.amazonaws.com",
            username = "root",
            password = "root",
            port=33061)
        on.exit(dbDisconnect(conn), add = TRUE)
        dbGetQuery(conn, paste0(
            "SELECT * FROM academatica_video_stats LIMIT ", input$bins, ";"))
    })
    
    output$tblConteoGeneral <- renderTable({
        conn <- dbConnect(
            drv = RMySQL::MySQL(),
            dbname = "BASE_GALILEO1",
            host = "ec2-54-234-91-151.compute-1.amazonaws.com",
            username = "root",
            password = "root",
            port=33061)
        on.exit(dbDisconnect(conn), add = TRUE)
        dbGetQuery(conn, paste0(
            "SELECT
     count(distinct(C1)) 'CANTIDAD DE VIDEOS'
FROM
     academatica_video_stats
where
    C1 <> 'id'
            "
            
            ))
    })
    

    output$tblCantidadVistas <- renderTable({
        conn <- dbConnect(
            drv = RMySQL::MySQL(),
            dbname = "BASE_GALILEO1",
            host = "ec2-54-234-91-151.compute-1.amazonaws.com",
            username = "root",
            password = "root",
            port=33061)
        on.exit(dbDisconnect(conn), add = TRUE)
        a <- dbGetQuery(conn, paste0(
            "            SELECT     C1 'VIDEO',     C2 'CANTIDAD DE VISTAS' FROM     academatica_video_stats where     C1 <> 'id'  order by     C2 desc     "
            
            ))
        a
    })
    
    output$tblNombres <- renderTable({
        conn <- dbConnect(
            drv = RMySQL::MySQL(),
            dbname = "BASE_GALILEO1",
            host = "ec2-54-234-91-151.compute-1.amazonaws.com",
            username = "root",
            password = "root",
            port=33061)
        on.exit(dbDisconnect(conn), add = TRUE)
        dbGetQuery(conn, paste0(
            "
     SELECT
    academatica_video_stats.C1 'VIDEO',
    academatica_videos_metadata.C2 'Nombre',
    academatica_video_stats.C2 'CANTIDAD DE VISTAS'
    FROM
    academatica_video_stats
    left join
    academatica_videos_metadata
    on academatica_video_stats.C1=academatica_videos_metadata.C1
    where
    academatica_video_stats.C1 <> 'id'
    order by
    academatica_video_stats.C2
    desc
    "
            
        ))
    })
    
   
    
    output$tblGrafica <- renderPlot({
        conn <- dbConnect(
            drv = RMySQL::MySQL(),
            dbname = "BASE_GALILEO1",
            host = "ec2-54-234-91-151.compute-1.amazonaws.com",
            username = "root",
            password = "root",
            port=33061)
        on.exit(dbDisconnect(conn), add = TRUE)
        a <- dbGetQuery(conn, paste0(
            "            SELECT     C1 'VIDEO',     C2 'CANTIDAD DE VISTAS' FROM     academatica_video_stats where     C1 <> 'id'  order by     C2 desc     "
            
        ))
        
            
            ggplot(a,aes(x=a$"VIDEO",y=a$"CANTIDAD DE VISTAS")

                   )+geom_point(colour='red')#+
            #geom_bar(stat="identity")
    }) 

    
    
 
    
    output$tblGrafica2 <- renderPlot({
        conn <- dbConnect(
            drv = RMySQL::MySQL(),
            dbname = "BASE_GALILEO1",
            host = "ec2-54-234-91-151.compute-1.amazonaws.com",
            username = "root",
            password = "root",
            port=33061)
        on.exit(dbDisconnect(conn), add = TRUE)
        a <- dbGetQuery(conn, paste0(
            "            SELECT     C1 'VIDEO',     C2 'CANTIDAD DE VISTAS' FROM     academatica_video_stats where     C1 <> 'id'  order by     C2 desc     "
            
        ))
        
        a <- head(a,40)
        
        ggplot(a,aes(x=a$"VIDEO",y=a$"CANTIDAD DE VISTAS", group=1)

        )+geom_line()+
            geom_point()
    }) 
    
    
    output$tblLikes <- renderPlot({
        conn <- dbConnect(
            drv = RMySQL::MySQL(),
            dbname = "BASE_GALILEO1",
            host = "ec2-54-234-91-151.compute-1.amazonaws.com",
            username = "root",
            password = "root",
            port=33061)
        on.exit(dbDisconnect(conn), add = TRUE)
        a <- dbGetQuery(conn, paste0(
            "            
              SELECT
    C1 'VIDEO',
    C3 'CANTIDAD DE LIKES'
    FROM
    academatica_video_stats
    where
    C1 <> 'id'
    order by
    C2
    desc
            "
            
        ))
        
        a <- head(a,40)
        
        ggplot(a,aes(x=a$"VIDEO",y=a$"CANTIDAD DE LIKES", group=1)
               
        )+geom_line(colour='red')+
            geom_point()
    }) 
    
    
    output$infoBoxConfirmadosHoy <- renderInfoBox({
        infoBox(
            "Cantidad de videos",icon = icon("ambulance"),
            color = "light-blue", fill = T,
            value = tags$p( 859, 
                            style = "font-size: 200%;")
            #,width = 2.5
        )
    })
    
    
    output$gaugeEnTratamiento <- renderGauge({
        gauge(859, min = 0, max = 859, symbol = ' ', label = paste("En Visitas"),gaugeSectors(
            success = c(859, 400), warning = c(399,200), danger = c(199, 1), colors = c("#CC6699")
        ))
    })
    
    output$gaugeLike <- renderGauge({
        gauge(401, min = 0, max = 859, symbol = ' ', label = paste("En Likes"),gaugeSectors(
            success = c(859, 400), warning = c(399,200), danger = c(199, 1), colors = c("#CC6699")
        ))
    })
    
    output$gaugeNotLike <- renderGauge({
        gauge(140, min = 0, max = 859, symbol = ' ', label = paste("En No Likes"),gaugeSectors(
            success = c(859, 400), warning = c(399,200), danger = c(199, 1), colors = c("#CC6699")
        ))
    })
    
})
