import 'dart:async';

import 'package:fall_detect_web_app/data/user_id.dart';
import 'package:fall_detect_web_app/services/firestore_operations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ActivityPage extends StatefulWidget {
  final String deviceId;

  const ActivityPage({super.key, required this.deviceId});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  Color beigeColor = const Color(0xFFF5F5DC);
  final FirestoreOperations _firestoreService = FirestoreOperations();
  final List<SensorDataPoint> sensorDataPoints =
      []; // List to store data points

  bool _isStreamActive = false; // Flag to track stream status
  StreamSubscription?
      _sensorDataSubscription; // StreamSubscription to manage stream
  @override
  void initState() {
    super.initState();
    _listenToSensorData();
  }

  @override
  void dispose() {
    _sensorDataSubscription?.cancel(); // Cancel the stream subscription
    super.dispose();
  }

  void _listenToSensorData() {
    _firestoreService.getUserStream(widget.deviceId).listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        final newPoint = SensorDataPoint(
          accelerometer: data['accelerometer'],
          time: data['time'].toDate(),
        );

        // Update the list (add new, remove old if needed)
        setState(() {
          sensorDataPoints.add(newPoint);
          if (sensorDataPoints.length >= 9) {
            sensorDataPoints.removeAt(0); // Remove oldest point
          }
        });
      }
    });
    _isStreamActive = true;
  }

  //Gets the accelerometer values against the time
  List<FlSpot> _getaccelerometerChartData(List<SensorDataPoint> dataPoints) {
    return dataPoints.map((point) {
      double xValue = point.time.millisecondsSinceEpoch.toDouble();
      return FlSpot(xValue, point.accelerometer.toDouble());
    }).toList();
  }

  SideTitles getBottomTitles() {
    return SideTitles(
      showTitles: true,
      reservedSize: 15,
      interval: 10000, // Show label for each minute
      getTitlesWidget: (value, meta) {
        DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
        String formattedTime = "${date.hour}:${date.minute}:${date.second}";
        return Text(formattedTime, style: const TextStyle(fontSize: 10));
      },
    );
  }

  SideTitles getLeftTitles() {
    return SideTitles(
      showTitles: true,
      reservedSize: 40,
      getTitlesWidget: (value, meta) {
        return Text(
          value.toStringAsFixed(2), // Format the value to 2 decimal places
          style: const TextStyle(fontSize: 10),
        );
      },
    );
  }

  Widget _buildLineChartOrMessage() {
    // ignore: prefer_is_empty
    if (sensorDataPoints.length < 2) {
      // Render the message widget in a rounded container
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: beigeColor,
          ),
          child: const Padding(
            padding: EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                'Insufficient Data',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      if (!_isStreamActive) {
        _listenToSensorData(); // Start listening only once
      }

      final accelerometerChartData =
          _getaccelerometerChartData(sensorDataPoints);

      return Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.80,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: beigeColor),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: LineChart(
                      LineChartData(
                        minY: 0.0,
                        lineBarsData: [
                          LineChartBarData(
                              spots: accelerometerChartData,
                              isCurved: true,
                              barWidth: 3,
                              color: Colors.blue,
                              preventCurveOverShooting: true,
                              dotData: const FlDotData(
                                show: true,
                              )),
                        ],
                        titlesData: FlTitlesData(
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            leftTitles: AxisTitles(
                              axisNameWidget: const Text(
                                " Overall Acceleration (m/s^2)",
                                style: TextStyle(fontSize: 12),
                              ),
                              sideTitles: getLeftTitles(),
                            ),
                            bottomTitles: AxisTitles(
                              axisNameWidget: const Text("Time"),
                              sideTitles: getBottomTitles(),
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 50),
          _buildLineChartOrMessage(),
        ],
      ),
    );
  }
}
