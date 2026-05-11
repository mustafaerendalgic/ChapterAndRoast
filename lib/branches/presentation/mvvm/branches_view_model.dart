import 'package:flutter/material.dart';
import 'package:gdg_campus_coffee/branches/data/repository/branch_repository.dart';
import 'package:gdg_campus_coffee/branches/domain/entity/branch.dart';
import 'package:gdg_campus_coffee/branches/data/service/nearby_coffee_service.dart';

class BranchesViewModel extends ChangeNotifier {
  final _repository = BranchRepository();
  final _nearbyService = NearbyCoffeeService();

  bool loading = false;
  List<Branch> branches = [];

  BranchesViewModel() {
    fetchBranches();
  }

  Future<void> fetchBranches() async {
    loading = true;
    notifyListeners();

    try {
      // Fetch ONLY live nearby shops (Real Data)
      final nearby = await _nearbyService.fetchNearbyCoffeeShops();
      
      final allBranches = [...nearby];
      
      // Seytim coordinates for sorting
      const double seytimLat = 37.0286961;
      const double seytimLon = 35.3048137;

      // Sort by physical proximity to Seytim
      allBranches.sort((a, b) {
        if (a.latitude == null || a.longitude == null) return 1;
        if (b.latitude == null || b.longitude == null) return -1;

        double distA = _calculateSimpleDistance(seytimLat, seytimLon, a.latitude!, a.longitude!);
        double distB = _calculateSimpleDistance(seytimLat, seytimLon, b.latitude!, b.longitude!);
        
        return distA.compareTo(distB);
      });

      branches = allBranches;
    } catch (e) {
      branches = [];
    }

    loading = false;
    notifyListeners();
  }

  double _calculateSimpleDistance(double lat1, double lon1, double lat2, double lon2) {
    // Basic Euclidean for quick sorting (or use Geolocator.distanceBetween)
    return (lat1 - lat2) * (lat1 - lat2) + (lon1 - lon2) * (lon1 - lon2);
  }
}
