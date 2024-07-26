// ignore_for_file: use_build_context_synchronously

import 'package:fall_detect_web_app/services/firestore_operations.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final String deviceId;

  const SettingsPage({super.key, required this.deviceId});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double currentSliderValue = 2.0; // Slider default position
  bool isLoading = true; // Add a loading state

  final FirestoreOperations _firestoreService = FirestoreOperations();

  @override
  void initState() {
    super.initState();
    // Retrieve deviceId from the userId object
    _fetchSensitivity();
  }

  // Slider Title
  final Map<double, String> sensitivityLabels = {
    1.0: 'Very Sensitive',
    2.0: 'Moderate Sensitive',
    3.0: 'Not Sensitive',
  };

  // Slider Description
  final Map<double, String> sensitivityDescription = {
    1.0:
        'This level is ideal for individuals who are at a higher risk of falling or have a history of frequent falls. The fall detection system will be highly responsive, triggering alerts with minimal movement and that even minor disturbances are detected promptly. This setting is suitable for elderly individuals or those with severe mobility impairments or are recovering from surgery.',
    2.0:
        'This is a balanced setting is designed for users who may experience occasional falls but do not require the highest level of sensitivity. The system will respond to moderate changes in movement, providing a reliable fall detection while minimizing false alarms. This level is appropriate for individuals with moderate mobility issues.',
    3.0:
        'This level is the least responsive and is best suited for users who are active and have a low risk of falling. The fall detection system will trigger alerts only in response to significant movements, reducing the likelihood of false alarms during regular activities. This setting is ideal for individuals with good mobility who still want a layer of safety monitoring.',
  };

  // Slider Value
  final Map<double, double> sensitivityLevels = {
    1.0: 0.75,
    2.0: 0.65,
    3.0: 0.55,
  };

  Future<void> _fetchSensitivity() async {
    double sensitivity =
        await _firestoreService.getSensitivity(widget.deviceId);
    setState(() {
      currentSliderValue = sensitivityLevels.entries
          .firstWhere((entry) => entry.value == sensitivity,
              orElse: () => const MapEntry(2.0, 0.65))
          .key;
      isLoading = false; // Update loading state
    });
  }

  Future<void> updateSensitivityLevel(double value) async {
    setState(() {
      currentSliderValue = value;
    });
  }

  Future<void> saveSensitivityLevel() async {
    double updatedValue = sensitivityLevels[currentSliderValue] ?? 0.65;
    await FirestoreOperations()
        .updateSensitivity(widget.deviceId, updatedValue);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Success',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text('Sensitivity has been updated successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                children: [
                  const SizedBox(height: 50.0),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.70,
                    width: MediaQuery.of(context).size.width * 0.70,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    padding: const EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Set sensitivity for the device",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Text(
                          sensitivityLabels[currentSliderValue] ??
                              'Moderate Sensitive',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Text(
                          sensitivityDescription[currentSliderValue] ??
                              'This is a balanced setting designed for users who may experience occasional falls but do not require the highest level of sensitivity. The system will respond to moderate changes in movement, providing reliable fall detection while minimizing false alarms. This level is appropriate for individuals with moderate mobility issues.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        Slider(
                          value: currentSliderValue,
                          min: 1,
                          max: 3,
                          divisions: 2,
                          label: sensitivityLabels[currentSliderValue],
                          onChanged: (double value) {
                            updateSensitivityLevel(value);
                          },
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'High',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'Medium',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'Low',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              saveSensitivityLevel();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            icon: const Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Save",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
