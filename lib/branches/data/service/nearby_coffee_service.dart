import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:gdg_campus_coffee/branches/domain/entity/branch.dart';

class NearbyCoffeeService {
  Future<List<Branch>> fetchNearbyCoffeeShops() async {
    try {
      Position position = await _determinePosition();
      
      // Adana Seytim Real Data (Fallback & Primary)
      final List<Branch> adanaShops = [
        Branch(
          name: 'Mado Seyhan',
          description: 'Traditional Turkish coffee & desserts',
          rating: 4.5,
          distance: '0.2 km',
          latitude: 37.0295,
          longitude: 35.3055,
          photos: [
            'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?auto=format&fit=crop&q=80&w=400',
            'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&q=80&w=400',
          ],
        ),
        Branch(
          name: 'Gönül Kahvesi',
          description: 'Cozy atmosphere with premium blends',
          rating: 4.2,
          distance: '0.5 km',
          latitude: 37.0275,
          longitude: 35.3035,
          photos: [
            'https://images.unsplash.com/photo-1447933601403-0c6688de566e?auto=format&fit=crop&q=80&w=400',
            'https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&q=80&w=400',
          ],
        ),
        Branch(
          name: 'Kahve Dünyası',
          description: 'Modern coffee experience',
          rating: 4.7,
          distance: '0.8 km',
          latitude: 37.0310,
          longitude: 35.3070,
          photos: [
            'https://images.unsplash.com/photo-1559496417-e7f25cb247f3?auto=format&fit=crop&q=80&w=400',
            'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?auto=format&fit=crop&q=80&w=400',
          ],
        ),
      ];

      // 2. Query Overpass API (OpenStreetMap)
      final url = Uri.parse('https://overpass-api.de/api/interpreter');
      final query = '''
        [out:json];
        (
          node(around:5000, ${position.latitude}, ${position.longitude})["amenity"="cafe"];
          node(around:5000, ${position.latitude}, ${position.longitude})["shop"="coffee"];
        );
        out;
      ''';
      
      final response = await http.post(url, body: {'data': query}).timeout(const Duration(seconds: 5));
      
      List<Branch> liveShops = [];
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List elements = data['elements'];
        
        liveShops = elements.map((e) {
          final tags = e['tags'] ?? {};
          return Branch(
            name: tags['name'] ?? 'Local Cafe',
            description: tags['cuisine'] ?? 'Artisanal Coffee',
            rating: 4.0 + (e['id'] % 10) / 10,
            distance: '${(_calculateDistance(position, e['lat'], e['lon']) / 1000).toStringAsFixed(1)} km',
            latitude: e['lat'],
            longitude: e['lon'],
            photos: [],
          );
        }).toList();
      }
      
      return [...adanaShops, ...liveShops];
    } catch (e) {
      print('Error fetching nearby coffee: $e');
      return []; // Return empty so ViewModel can handle it
    }
  }

  Future<Position> _determinePosition() async {
    // SEYTIM (Seyhan Belediyesi Teknoloji ve İnovasyon Merkezi)
    const double seytimLat = 37.0286961;
    const double seytimLon = 35.3048137;

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Position(longitude: seytimLon, latitude: seytimLat, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Position(longitude: seytimLon, latitude: seytimLat, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0);
      }
    }
    
    // For now, always use Seytim as requested
    return Position(longitude: seytimLon, latitude: seytimLat, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0);
  }

  double _calculateDistance(Position start, double endLat, double endLon) {
    return Geolocator.distanceBetween(start.latitude, start.longitude, endLat, endLon);
  }
}
