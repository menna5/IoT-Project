from flask import Flask, render_template
import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import plotly.graph_objects as go

# cred = credentials.Certificate("finalkey.json")
# firebase_admin.initialize_app(cred, {'databaseURL': 'https://final-project-f23d0-default-rtdb.firebaseio.com/'})

ref = db.reference('/')

def get_values(name):
    ref = db.reference('/')
    temp_sensor = ref.child(f'climate/{name}').get()

    timestamp = []
    value = []
    
    for key, val in temp_sensor.items():
        value.append(val[name])
        timestamp.append(val['timestamp'])

    return timestamp, value

def viz(timestamp, value, name):
    data = go.Scatter(x=timestamp, y=value)
    fig = go.Figure(data=data)

    fig.layout.title = f'{name} Over Day'
    fig.layout.xaxis.title = 'Timestamp'
    fig.layout.yaxis.title = name

    return fig

def all_viz(timestamp, temp, humid, photo):
    trace1 = go.Scatter(x=timestamp, y=temp, mode='lines', name='Temperature')
    trace2 = go.Scatter(x=timestamp, y=humid, mode='lines', name='Humidity')
    trace3 = go.Scatter(x=timestamp, y=photo, mode='lines', name='Photoresistor')

    fig = go.Figure()
    fig.add_trace(trace1)
    fig.add_trace(trace2)
    fig.add_trace(trace3)

    fig.update_layout(
        title='Climate Over Time',
        xaxis_title='Timestamp',
        yaxis_title='Value'
    )

    return fig

timestamp, temp = get_values('temp')
tempFig = viz(timestamp, temp, 'Temperature').to_json()

_, humid = get_values('humid')
HumidFig = viz(timestamp, humid, 'Humidity').to_json()

_, photo = get_values('photo')
PhotoFig = viz(timestamp, photo, 'Photoresistor').to_json()

allFig = all_viz(timestamp, temp, humid, photo).to_json()

app = Flask(__name__)

@app.route("/")
def home():
  return render_template("home.html", allFig=allFig)

@app.route("/humid")
def humid():
  return render_template("humid.html", HumidFig=HumidFig)

@app.route("/temp")
def temp():
  return render_template("temp.html", tempFig=tempFig)

@app.route("/photo")
def photo():
  return render_template("photo.html", PhotoFig=PhotoFig)

if __name__ == "__main__":
  app.run()