# Stupid_Shiny_APP

[Link to APP](https://modlearth.shinyapps.io/Stupid_Shiny_APP/)

![Stupid Shiny APP](/screenshot/screenshot.png)

## Intructions
The APP contain 3 tabs showing the following:
1. A boxplot of number of words by source. Something very very useful to be an autentic data analyzer.
2. A map showing just those tweets geolocated. I mean, as we must know, twitter captures all geolocations, that's for sure, but, data contain just those coords autorized by users...I guess.
3. A render table of just one column: tweets. 
Moreover, there is an extra plot comparing the number of followers by group.

Each time you call the APP it downloads a bunch of tweets with the function *search_tweets()*. You just need to select a word as a filter, a number of tweets the APP is going to download and apply changes.

### Elements:
1. ui.R --> how APP shows
2. server.R --> what APP does
3. Stupid_shiny_plotly_presentation --> slides as resume of the APP
