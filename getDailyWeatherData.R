# Download daily historical weather data by airport code
# Just modify the airport name and years if needed

airports <- c('KSFO') #KSFO=San Francisco
years <- 2012:2015

# NO NEED TO CHANGE ANYTHING IN THE CODE BELOW THIS LINE
#------------------------------------------------------------------------------------------------

getWeather <- function(airports, years) {
  options(warn = -1) # temporarily turn off warnings
  # make url for wunderground.com
  url <- paste0('http://www.wunderground.com/history/airport/', airports, '/', years,
                '/1/1/CustomHistory.html?dayend=31&monthend=12&yearend=', years,
                '&req_city=&req_state=&req_statename=&reqdb.zip=&reqdb.magic',
                '=&reqdb.wmo=&format=1')
  weather <- read.csv(url(url), stringsAsFactors = FALSE) # get data from wunderground.com
  names(weather)[1] <- 'Date'
  options(warn = 0) # turn warnings back on
  return(weather)
}

airports <- data.frame(airports)
years <- data.frame(years)

for (i in 1:nrow(airports)) {
        for (j in 1:nrow(years)) {
                weatherAirportsYears <- getWeather(airports = airports[i, ], years = years[j, ])
                if(j == 1 ) {
                        weatherAirports <- weatherAirportsYears
                        } else {
                                weatherAirports <- rbind(weatherAirports, weatherAirportsYears)
                                }
                print(sprintf("... airport (%d of %d), year (%d of %d): %d records added",
                              i, nrow(airports), j, nrow(years), nrow(weatherAirportsYears)))
                }
        if( i == 1 ) {
                weather <- weatherAirports
                } else {
                        weather <- rbind(weather, weatherAirports)
                }
}

names(weather) <- gsub('\\.', '', names(weather))
weather$MaxGustSpeedMPH[is.na(weather$MaxGustSpeedMPH)] <- 0
weather$Date <- as.Date(weather$Date)
weather <- subset(weather, weather$Date >= '2012-11-30' & weather$Date <= '2015-05-13')
weather$PrecipitationIn <- as.numeric(sub('T', 0, weather$PrecipitationIn))
weather$Events <- factor(weather$Events)
weather$WindDirDegrees <- as.integer(sub('<br />', '', weather$WindDirDegreesbr))
weather$WindDirDegreesbr <- NULL
weather <- data.frame(model.matrix(~ -1 + ., weather))
weather$Date <- as.Date(weather$Date, origin = '1970-01-01')
weather$Events <- NULL
names(weather) <- gsub('Events', '', names(weather))
weather$Fog[weather$Fog.Rain == 1] <- 1
weather$Rain[weather$Fog.Rain == 1] <- 1
weather$Rain[weather$Rain.Thunderstorm == 1] <- 1
weather$Thunderstorm[weather$Rain.Thunderstorm == 1] <- 1
weather$Fog.Rain <- weather$Rain.Thunderstorm <- NULL


file.weather <- 'WeatherData.csv'
write.csv(weather, file.weather, row.names = FALSE)
print(sprintf('Data saved in %s', file.weather))
suppressMessages(library(gdata))
invisible(keep(weather, sure = TRUE))
