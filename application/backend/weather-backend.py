from flask import Flask
import requests
import json

app = Flask(__name__)


@app.route('/')
def index():
    return 'City required in URL request /{CITY}'


@app.route('/<city>')
def weather(city):
    locationEndpoint = 'https://www.metaweather.com/api/location/search/?query={}'.format(city)

    try:
        locationData = requests.get(locationEndpoint)
    except:
        return 'Metaweather service not available/reachable'

    if locationData.text == '[]':
        return 'Error: City not found'
    else:
        cityId = locationData.json()[0]["woeid"]

        weatherEndpoint = 'https://www.metaweather.com/api/location/{}'.format(cityId)
        weatherData = requests.get(weatherEndpoint).json()

        weather_data = []
        for date in weatherData['consolidated_weather']:
            weather_data.append({'date': date['applicable_date'], 'temperature': date['the_temp'], 'weather_state': date['weather_state_name']})
        return json.dumps(weather_data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5003)