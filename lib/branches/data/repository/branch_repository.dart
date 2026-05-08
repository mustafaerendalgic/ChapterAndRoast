import 'package:gdg_campus_coffee/branches/data/model/branch_model.dart';
import 'package:gdg_campus_coffee/branches/domain/entity/branch.dart';
import 'package:gdg_campus_coffee/branches/domain/repository/i_branch_repository.dart';

class BranchRepository implements IBranchRepository {
  @override
  Future<List<Branch>> getBranches() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay

    final models = [BranchModel(name: 'Kahve Dünyası'), BranchModel(name: 'Juan Valdez')];

    return models.map((model) => model.toEntity()).toList();
  }
}
