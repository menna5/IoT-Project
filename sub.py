import paho.mqtt.client as mqtt
from firebase_admin import credentials, initialize_app, db
from datetime import datetime
import uuid  # for generating unique client IDs

# Generate a unique client ID, to solve non connection problem
client_id = "subscriber_" + str(uuid.uuid4())

# cred = credentials.Certificate("finalkey.json")
# initialize_app(cred, {'databaseURL': 'https://final-project-f23d0-default-rtdb.firebaseio.com/'})
ref = db.reference('/')

# Broker Configuration
broker_address = "192.168.1.9"
port = 1883
qos = 0

# Callback function to update sensor data
def on_message(client, userdata, message):
    topic = message.topic
    payload = message.payload.decode()
    data = {'timestamp': datetime.now().isoformat(), f'{topic}': payload}
    ref.child('climate').child(topic).push(data)
    print(f"Received message on topic {topic}: {payload}")

# Create an MQTT client instance with a unique client ID
client = mqtt.Client(client_id)
client.on_message = on_message
client.connect(broker_address, port)

# Subscribe to topics
topics = ["temp", "humid", "photo"]
for topic in topics:
    client.subscribe(topic, qos)

# Start the MQTT loop to continuously listen for messages
client.loop_forever()
