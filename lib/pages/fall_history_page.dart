// ignore_for_file: avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fall_detect_web_app/services/firestore_operations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FallHistoryPage extends StatefulWidget {
  final String deviceId;

  const FallHistoryPage({super.key, required this.deviceId});

  @override
  State<FallHistoryPage> createState() => _FallHistoryPageState();
}

class _FallHistoryPageState extends State<FallHistoryPage> {
  final FirestoreOperations _firestoreService = FirestoreOperations();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 50),
          Expanded(
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    _firestoreService.getFallDocumentsStream(widget.deviceId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      var time = (data['time'] as Timestamp).toDate();
                      var formattedTime =
                          DateFormat('HH:mm, dd/MM/yyyy').format(time);
                      var latitude = data['latitude'];
                      var longitude = data['longitude'];

                      return Dismissible(
                        key: Key(data.id), // Unique key for each item
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          // Show a confirmation dialog when the item is swiped
                          return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirm"),
                                  content: const Text(
                                      "Are you sure you want to delete this item?"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text("CANCEL"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text("DELETE"),
                                    )
                                  ],
                                );
                              });
                        },
                        onDismissed: (direction) {
                          _firestoreService
                              .deleteFallDocument(widget.deviceId, data.id)
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Item deleted")),
                            );
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Failed to delete item")),
                            );
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(249, 236, 167, 47),
                                borderRadius: BorderRadius.circular(20)),
                            child: ListTile(
                              title: Text(
                                'Time: $formattedTime',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(
                                'Location: $latitude, $longitude',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  color: Colors.white70,
                                  child: const Icon(
                                    Icons.warning_outlined,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
