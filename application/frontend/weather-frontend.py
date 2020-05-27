from flask import Flask
import requests
import json
import os

app = Flask(__name__)

if "WEATHER_SVC_URL" in os.environ:
    weather_svc_url = os.environ['WEATHER_SVC_URL']
else:
    weather_svc_url = "http://localhost:5003"


@app.route('/')
def index():
    return 'City required in URL request /{CITY}'


@app.route('/<city>')
def weather(city):
    url = "{}/{}".format(weather_svc_url, city)
    try:
        weatherData = requests.get(url).text
    except:
        return 'Weather service is not available/reachable'

    if "Error" in weatherData:
        return 'The city <b>{}</b> was not found'.format(city)
    else:
        data = json.loads(weatherData)
        html = '<h1>Weather for {}</h1>'.format(city)
        html += '<table border="1">'
        html += '<tr><td>DATE</td><td>TEMP (&deg;C)</td><td>WEATHER CONDITION</td></tr>'
        for day in data:    
            html += "<tr><td>{}</td><td>{}</td><td>{}</td></tr>".format(day['date'], day['temperature'], day['weather_state'])
        html += '</table>'
        return html

@app.route('/health')
def health():
    return json.dumps({'success':True}), 200, {'ContentType':'application/json'}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5002)