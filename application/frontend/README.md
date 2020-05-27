# Weather Service Frontend
Simple flask app that calls the [weather service backend](../backend/README.md) and formats the data in an HTML table.  
Listens on port `5002` and takes a city argument in the URL `/{CITY}`. 

Example: `http://host:5002/toronto`

The weather service backend URL can be set with the environment variable `WEATHER_SVC_URL`. If not present, it defaults to `http://localhost:5003`.