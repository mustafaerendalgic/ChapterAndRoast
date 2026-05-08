import 'package:gdg_campus_coffee/branches/domain/entity/branch.dart';

abstract class IBranchRepository {
  Future<List<Branch>> getBranches();
}
