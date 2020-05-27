# PyWeather Application
A simple two tier web app that returns the 5 day forecast for a city provided. It uses the [Metaweather](https://www.metaweather.com/) service.

### Backend
Simple flask app that calls the [Metaweather](https://www.metaweather.com/) service. Returns JSON formatted weather data for the current day and the next 4 days.  

### Frontend
Simple flask app that calls the [weather service backend](../backend/README.md) and formats the data in an HTML table.  