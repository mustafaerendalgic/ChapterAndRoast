import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:gdg_campus_coffee/branches/data/model/branch_model.dart';
import 'package:gdg_campus_coffee/branches/domain/entity/branch.dart';
import 'package:gdg_campus_coffee/branches/domain/repository/i_branch_repository.dart';

class BranchRepository implements IBranchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Branch>> getBranches() async {
    try {
      final snapshot = await _firestore
          .collection('branches')
          .get()
          .timeout(const Duration(seconds: 8));
          
      final models = snapshot.docs.map((doc) => BranchModel.fromJson(doc.data())).toList();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      if (kDebugMode) print('❌ Error fetching branches: $e');
      return [];
    }
  }
}
