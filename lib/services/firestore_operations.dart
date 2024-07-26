import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreOperations {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  //Stream the document containing the Overall Status of the user from Firestore
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream(
      String deviceId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(deviceId)
        .snapshots();
  }

  //Stream all the Fall History data from Firestore
  Stream<QuerySnapshot> getFallDocumentsStream(String deviceId) {
    return FirebaseFirestore.instance
        .collection(deviceId)
        .orderBy('time', descending: true)
        .snapshots();
  }

  //Delete a fall history if a false positive is detected
  Future<void> deleteFallDocument(String deviceId, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection(deviceId)
          .doc(documentId)
          .delete();
    } catch (error) {
      throw Exception("Failed to delete fall document: $error");
    }
  }

  //Update device name set by user
  Future<void> updateUserInput(String deviceId, String userInput) async {
    try {
      // Update the document with the specified device ID
      await users.doc(deviceId).update({'username': userInput});
      print('User input updated successfully for device ID: $deviceId');
    } catch (error) {
      print('Error updating user input: $error');
    }
  }

  //Read the sensitivity level of the device in the Cloud Firestore
  Future<double> getSensitivity(String deviceId) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(deviceId).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        double sensitivity = data['sensitivity']?.toDouble() ?? 2.2;
        return sensitivity; // Default value if null
      } else {
        return 2.2; // Default value if document doesn't exist
      }
    } catch (e) {
      print('Error fetching sensitivity: $e');
      return 2.2; // Default value on error
    }
  }

  //Changes the sensitivity of the device based on the user's preferance
  Future<void> updateSensitivity(String deviceId, double sensitivity) async {
    try {
      await users.doc(deviceId).update({'sensitivity': sensitivity});
      print('Sensitivity input updated successfully for device ID: $deviceId');
    } catch (e) {
      print('Error updating sensitivity: $e');
    }
  }
}
