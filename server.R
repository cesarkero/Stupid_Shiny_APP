source("Base.R")

shinyServer(function (input, output) {

    tweets <- reactive ({
        tweets <- search_tweets(q=input$UserOrHashtag,
                                n=input$Ntweets,
                                include_rts = F)
        
        #create a table from twitter data
        tweets <- as.data.frame(tweets)
        #create Nwords variable
        tweets <- mutate(tweets, Nwords = str_count(text, " "))
    })

    # create plot
    PLOT1 <- reactive({
        #filtrar las fuentes
        t <- tweets()
        setDT(t)[!source %in% c("Facebook","Hootsuite Inc.","IFTT",
                                "Instagram","TweetDeck","Twitter for iPad",
                                "Twitter for iPhone","Twitter Web App",
                                "Twitter Web Client","Twitter for Android"),
                 source := "Other"]
        PLOT1 <- plot_ly(t, y = ~Nwords, type="box", color = ~factor(source))
    })
    
    # create map
    MAP1 <- reactive({
        tgeo <- tweets()["c(NA, NA)" != tweets()$geo_coords,] #pick tweets with geo_coords
        tcoords <- tweets()["c(NA, NA)" != tweets()$coords_coords,]
        
        ## % of tweets with geo_coords
        Nt <- dim(tweets())[1]
        Ngeo <- dim(tgeo)[1]
        Pgeo <- (dim(tgeo)[1]/dim(tweets())[1])*100
        ## points to be mapped
        y <- c()
        x <- c()
        if (nrow(tgeo) == 0) {
            MAP1 <- leaflet(width="100%") %>% addTiles(group="OSM")
        } else {
            for (i in 1:nrow(tgeo)) {
                y[[i]] <- tgeo$geo_coords[[i]][1]
                x[[i]] <- tgeo$geo_coords[[i]][2]
            }
            tweet_coords <- data.frame(
                lat = y,
                lng = x)

            #icons to be mapped
            #url to thumnail of the profile is in $profile_image_url
            jpg_profile_list <- character()
            for (i in 1:nrow(tgeo)){
                jpg_URL <- tgeo[i,]$profile_image_url
                jpg_profile_list[[i]] <- jpg_URL
            }
            stupidIcon <- makeIcon(
                iconUrl = jpg_profile_list,
                iconWidth = 31*215/230, iconHeight = 31,
                iconAnchorX = 31*215/230/2, iconAnchorY = 16
            )

            #tweets text to be mapped
            tweet_text_list <- character()
            for (i in 1:nrow(tgeo)){
                tweet_URL <- paste0("https://twitter.com/",tgeo[i,]$screen_name,"/status/",tgeo[i,]$status_id)
                tweet_profile <- paste0("@",tgeo[i,]$screen_name)
                tweet_text <- tgeo[i,]$text
                html_URL_text <- paste0("<a href='",tweet_URL,"'>",paste0(tweet_profile," --> ", tweet_text),"</a>")
                tweet_text_list[[i]] <- html_URL_text
            }

            #MAP
            MAP1 <- tweet_coords %>%
                leaflet(width="100%") %>%
                addTiles(group="OSM") %>%
                # Base groups
                addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
                addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
                addProviderTiles('Esri.WorldImagery', group = "ESRI") %>%
                # add markers
                addMarkers(icon = stupidIcon,
                           popup = tweet_text_list,
                           group = "Tweets") %>%
                # Layers control
                addLayersControl(
                    baseGroups = c("OSM", "Toner", "Toner Lite", "ESRI"),
                    overlayGroups = c("Tweets"),
                    options = layersControlOptions(collapsed = FALSE))
        }
        
    })
    
    # create table
    TABLE1 <- reactive({
        TABLE1 <- tweets()$text
    })
    
    output$P1 <- renderPlotly({PLOT1()})
    output$M1 <- renderLeaflet({MAP1()})
    output$T1 <- renderTable({TABLE1()})
    
})
