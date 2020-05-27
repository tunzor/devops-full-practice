# PyWeather Application
A simple two tier web app that returns the 5 day forecast for a city provided. It uses the [Metaweather](https://www.metaweather.com/) service.

The original code was taken from [this project](https://github.com/tunzor/k8s-practice/tree/master/pyweather).

### Backend
Simple flask app that calls the [Metaweather](https://www.metaweather.com/) service. Returns JSON formatted weather data for the current day and the next 4 days.  

### Frontend
Simple flask app that calls the [weather service backend](../backend/README.md) and formats the data in an HTML table.  