# Weather Service Backend
Simple flask app that calls the [Metaweather](https://www.metaweather.com/) service.  
Listens on port `5003` and takes a city argument in the URL `/{CITY}`. Returns JSON formatted weather data for the current day and the next 4 days.  

Example: `http://host:5003/toronto`