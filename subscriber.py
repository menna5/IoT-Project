import paho.mqtt.client as mqtt

# MQTT broker address
broker_address = "192.168.1.3"
# MQTT broker port
port = 1883
# MQTT topics to which the subscriber will subscribe
topic1 = "temp"
topic2 = "humid"
topic3 = "photo"

# Quality of Service (QoS)
qos = 0

# Callback function to handle incoming temperature messages
def on_message_temp(client, userdata, message):
    print("Temperature:", message.payload.decode())

# Callback function to handle incoming humidity messages
def on_message_humid(client, userdata, message):
    print("Humidity:", message.payload.decode())
    
# Callback function to handle incoming photoresistor messages
def on_message_photo(client, userdata, message):
    print("Photoresistor:", message.payload.decode())


# Create an MQTT client instance with the name "subscriber"
client = mqtt.Client("subscriber")
# Connect to the MQTT broker using the specified IP address and port
client.connect(broker_address, port)

# Subscribe to the specified topics and set the respective callback functions
client.subscribe(topic1, qos)
client.message_callback_add(topic1, on_message_temp)

client.subscribe(topic2, qos)
client.message_callback_add(topic2, on_message_humid)

client.subscribe(topic3, qos)
client.message_callback_add(topic3, on_message_photo)

# Start the MQTT client loop to receive messages
client.loop_forever()
