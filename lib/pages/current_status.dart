import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fall_detect_web_app/services/firestore_operations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentStatus extends StatefulWidget {
  final String deviceId;

  const CurrentStatus({super.key, required this.deviceId});

  @override
  State<CurrentStatus> createState() => _CurrentStatusState();
}

class _CurrentStatusState extends State<CurrentStatus> {
  final FirestoreOperations _firestoreService = FirestoreOperations();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _firestoreService.getUserStream(widget.deviceId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            final data = snapshot.data?.data();

            if (data != null) {
              // Extract fields from the document data
              var fallStatus = data['fall_status'];
              var time = (data['time'] as Timestamp).toDate();
              var formattedTime = DateFormat('HH:mm, dd/MM/yyyy').format(time);
              var latitude = data['latitude'];
              var longitude = data['longitude'];
              var emergencyStatus = data['emergency'];

              // Determine the image, status, and background color based on emergency and fall status
              String image;
              Color color;
              String status;

              if (emergencyStatus) {
                image = 'images/Help.jpg';
                color = Colors.red;
                status = "Needs Help/ Assistance";
              } else {
                if (fallStatus) {
                  image = 'images/Fall.jpg';
                  color = Colors.red;
                  status = "Fall Detected";
                } else {
                  image = 'images/Standing.jpg';
                  color = Colors.green;
                  status = "Ok";
                }
              }

              // Display the extracted fields in the UI
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: color,
                      ),
                      width: MediaQuery.of(context).size.width * 0.40,
                      height: MediaQuery.of(context).size.height * 0.70,
                      child: Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.50,
                          width: MediaQuery.of(context).size.width * 0.90,
                          child: Image.asset(image),
                        ),
                      ),
                    ),
                    const SizedBox(width: 50),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.grey[800],
                      ),
                      width: MediaQuery.of(context).size.width * 0.40,
                      height: MediaQuery.of(context).size.height * 0.70,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 40, horizontal: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Detection: $status",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 50.0),
                              Text(
                                "Time: $formattedTime",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 50.0),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: "Location: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 30,
                                          color: Colors.white),
                                    ),
                                    TextSpan(
                                      text:
                                          "$latitude, $longitude", // Assuming latitude & longitude are valid doubles
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 30,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Column(
                  children: [
                    Text(
                      "No Data Available",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Check Internet Connection",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}
