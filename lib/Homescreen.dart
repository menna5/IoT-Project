// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:untitled7/ImageTextWidget.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MqttServerClient client;
  String xValue = '';
  String yValue = '';
  String zValue = '';

  @override
  void initState() {
    super.initState();
    _connectToMqtt();
  }

  void _connectToMqtt() async {
    client = MqttServerClient('192.168.1.7', 'MobileApp');
    client.port = 1883;
    client.keepAlivePeriod = 20;
    client.onConnected = _onConnected;
    client.logging(on: true);

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('MobileApp')
        .startClean()
        .keepAliveFor(20)
        .withWillQos(MqttQos.atMostOnce);

    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      print('Client connected');
      client.subscribe('humid', MqttQos.atMostOnce);
      client.subscribe('temp', MqttQos.atMostOnce);
      client.subscribe('photo', MqttQos.atMostOnce);

      client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
        final String payload =
        MqttPublishPayload.bytesToStringAsString(message.payload.message);

        print('Received message:$payload from topic: ${c[0].topic}');
        setState(() {
          if (c[0].topic == 'humid') {
            xValue = payload;
          } else if (c[0].topic == 'temp') {
            yValue = payload;
          } else if (c[0].topic == 'photo') {
            zValue = payload;
          }
        });
      });
    } else {
      print(
          'ERROR: MQTT client connection failed - disconnecting, state is ${client.connectionStatus}');
      client.disconnect();
    }
  }

  void _onConnected() {
    print('Connected to MQTT server');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    DateTime now = DateTime.now();
    List<String> daysInEnglish = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    String dayName = daysInEnglish[now.weekday];
    List<String> monthsInEnglish = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    String monthName = monthsInEnglish[now.month - 1];

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/Home.png'),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25),
                  Center(
                    child: Text(
                      '$dayName  ',
                      style: TextStyle(
                        fontSize: 23,
                        color: Color(0xFF494A4B),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Center(
                    child: Text(
                      '${now.day}',
                      style: TextStyle(
                          fontSize: 65,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF494A4B)),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Center(
                    child: Text(
                      '$monthName , ${now.year}',
                      style: TextStyle(
                        fontSize: 23,
                        color: Color(0xFF494A4B),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(30),
                      margin: EdgeInsets.all(20),
                      width: size.width,
                      height: 350,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 95),
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          ImageTextWidget(
                            imagePath: 'assets/images/icon (4).png',
                            text: 'Humidity: $xValue', fontFamily: '',
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ImageTextWidget(
                            imagePath: 'assets/images/icon (4).png',
                            text: 'Temperature: $yValue', fontFamily: '',
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ImageTextWidget(
                            imagePath: 'assets/images/icon (4).png',
                            text: 'Photoresistor: $zValue', fontFamily: '',
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
