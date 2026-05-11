import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class OracleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _userId = 'current_user_device_001'; // Simulated unique user

  Future<int> getFortuneRights() async {
    try {
      final doc = await _firestore.collection('users').doc(_userId).get();
      if (!doc.exists) {
        await _firestore.collection('users').doc(_userId).set({'fortune_rights': 0});
        return 0;
      }
      return doc.data()?['fortune_rights'] ?? 0;
    } catch (e) {
      if (kDebugMode) print('Error fetching fortune rights: $e');
      return 0;
    }
  }

  Future<void> incrementRights() async {
    try {
      // Use set with merge to ensure doc exists
      await _firestore.collection('users').doc(_userId).set({
        'fortune_rights': FieldValue.increment(1)
      }, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) print('Error incrementing fortune rights: $e');
    }
  }

  Future<void> decrementRights() async {
    try {
      await _firestore.collection('users').doc(_userId).set({
        'fortune_rights': FieldValue.increment(-1)
      }, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) print('Error decrementing fortune rights: $e');
    }
  }

  Stream<int> streamFortuneRights() {
    return _firestore.collection('users').doc(_userId).snapshots().map((doc) {
      return doc.data()?['fortune_rights'] ?? 0;
    });
  }
}
