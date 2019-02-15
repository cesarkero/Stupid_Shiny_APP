libraries <- c("processx", "devtools", "ROAuth", "jsonlite", "rtweet", "ggplot2",
               "dplyr", "stringi", "tidytext", "leaflet", "yaml", "digest", "udunits2", 
               "wordcloud", "wordcloud2", "topicmodels", "ngram", "Rmpfr", "stringr","shinyjs",
               "base64enc","httpuv", "plotly", "data.table")

lapply(libraries, function (x) {if(x %in% rownames(installed.packages()) == FALSE) {install.packages(x)}})
lapply(libraries, require,  character.only=T)
