import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gdg_campus_coffee/menu/data/model/product_model.dart';
import 'package:gdg_campus_coffee/market/data/model/catalog_product_model.dart';
import 'package:gdg_campus_coffee/branches/data/model/branch_model.dart';

Future<void> seedDatabase() async {
  // Give the app a few seconds to settle before starting the heavy sync
  await Future.delayed(const Duration(seconds: 3));
  
  if (kDebugMode) print('🚀 [SEED] Starting Eternal Archive Sync (v8)...');
  
  try {
    final firestore = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;

    // Set a timeout for the version check to prevent hanging
    final versionDoc = await firestore.collection('app_metadata').doc('version').get()
        .timeout(const Duration(seconds: 5), onTimeout: () {
          if (kDebugMode) print('⏳ [SEED] Connection timed out. Skipping sync for now.');
          throw 'Timeout';
        });

    if (versionDoc.exists && versionDoc.data()?['db_version'] == 8) {
      if (kDebugMode) print('✅ [SEED] Database is already at version 8.');
      return;
    }

    if (kDebugMode) print('🧹 [SEED] Clearing old data for v8 migration...');
    final collections = ['products', 'market_items', 'branches', 'ai_suggestions'];
    for (final coll in collections) {
      final snapshot = await firestore.collection(coll).get();
      final batch = firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }

    Future<String> uploadAsset(String assetPath) async {
      try {
        final byteData = await rootBundle.load(assetPath);
        final bytes = byteData.buffer.asUint8List();
        final fileName = assetPath.split('/').last;
        final ref = storage.ref().child('product_images/$fileName');
        await ref.putData(bytes, SettableMetadata(contentType: 'image/png'));
        return await ref.getDownloadURL();
      } catch (e) {
        if (kDebugMode) print('⚠️ [SEED] Failed to upload $assetPath: $e');
        return assetPath;
      }
    }

    final productData = [
      {
        'name': 'The Obsidian Roast',
        'category': 'PREMIUM ROAST NO. 042',
        'description': 'Double shot of our signature obsidian roast.',
        'quote': '"A liquid sonnet for the midnight scholar, where ink-stained thoughts meet the dark heart of the bean."',
        'subTitle': 'Single Origin - 250g',
        'price': 18.00,
        'image': 'assets/images/espresso_pour.png',
        'isFeatured': true,
        'badge': 'NEW',
        'provenanceBody': 'Harvested from the shade-grown canopies of the Yirgacheffe highlands, these heirloom varietals are processed with a meticulous double-fermentation technique.',
        'flavorNotes': ['Dark Chocolate', 'Toasted Oak'],
        'origin': 'Ethiopia',
        'roastLevel': 'Dark/Bold',
        'ritualGenre': 'Existential Philosophy',
        'ritualVessel': 'Matte Obsidian Stein',
      },
      {
        'name': 'Cappuccino',
        'description': 'Velvety microfoam over a rich cocoa base.',
        'price': 5.75,
        'image': 'assets/images/cappuccino.png',
        'isFeatured': true,
        'isHot': true,
        'provenanceBody': 'Our cappuccino is built on a foundation of medium-roast Brazilian Santos beans.',
        'origin': 'Brazil',
        'roastLevel': 'Medium',
      },
      {
        'name': 'Mocha',
        'description': 'Rich chocolate meets bold espresso.',
        'price': 6.25,
        'image': 'assets/images/ceramic_mug.png',
        'isFeatured': true,
        'provenanceBody': 'Crafted with 70% dark Belgian chocolate shavings.',
        'origin': 'Colombia',
        'roastLevel': 'Dark',
      },
      // Archive Items - WILL NEVER BE REMOVED
      {
        'name': 'Latte',
        'description': 'Long milk with subtle vanilla notes',
        'price': 6.00,
        'badge': 'MILD',
        'image': 'assets/images/espresso_pour.png',
        'origin': 'Vietnam',
        'roastLevel': 'Light',
      },
      {
        'name': 'Flat White',
        'description': 'Tight microfoam, double ristretto',
        'price': 5.25,
        'badge': 'BOLD',
        'image': 'assets/images/espresso_pour.png',
        'origin': 'Sumatra',
        'roastLevel': 'Bold',
      },
      {
        'name': 'Cortado',
        'description': 'Equal parts espresso and steamed milk',
        'price': 4.75,
        'badge': 'INTENSE',
        'image': 'assets/images/espresso_pour.png',
        'origin': 'Honduras',
        'roastLevel': 'Intense',
      },
      {
        'name': 'Cold Brew',
        'description': '12-hour steep, chocolatey finish',
        'price': 4.50,
        'badge': 'SMOOTH',
        'image': 'assets/images/espresso_pour.png',
        'origin': 'Nicaragua',
        'roastLevel': 'Smooth',
      },
    ];

    final batch = firestore.batch();

    for (final data in productData) {
      final url = await uploadAsset(data['image'] as String);
      final model = ProductModel(
        name: data['name'] as String?,
        category: data['category'] as String?,
        description: data['description'] as String?,
        quote: data['quote'] as String?,
        subTitle: data['subTitle'] as String?,
        price: (data['price'] as num?)?.toDouble(),
        image: url,
        isFeatured: data['isFeatured'] as bool? ?? false,
        badge: data['badge'] as String?,
        provenanceBody: data['provenanceBody'] as String?,
        flavorNotes: (data['flavorNotes'] as List?)?.map((e) => e as String).toList(),
        origin: data['origin'] as String?,
        roastLevel: data['roastLevel'] as String?,
        isHot: true,
      );
      batch.set(firestore.collection('products').doc(), model.toJson());
    }

    final marketItems = [
      {'name': 'Obsidian Thermos', 'description': 'VACUUM SEALED STAINLESS STEEL', 'price': 34.00, 'image': 'assets/images/thermos.png', 'category': 'DRINKWARE'},
      {'name': 'Ceramic Ritual Mug', 'description': 'CERAMIC STONEWARE, 350ML', 'price': 18.50, 'image': 'assets/images/ceramic_mug.png', 'category': 'ARTISANAL'},
    ];

    for (final item in marketItems) {
      final url = await uploadAsset(item['image'] as String);
      batch.set(firestore.collection('market_items').doc(), CatalogProductModel(
        name: item['name'] as String?,
        description: item['description'] as String?,
        price: (item['price'] as num?)?.toDouble(),
        image: url,
        category: item['category'] as String?,
      ).toJson());
    }

    final jvPhotos = [
      await uploadAsset('assets/images/map_photo1.png'),
      await uploadAsset('assets/images/map_photo2.png'),
      await uploadAsset('assets/images/map_photo3.png'),
    ];

    final branches = [
      {
        'name': 'Juan Valdez',
        'description': 'Colombian heritage & Premium Roasts',
        'distance': '0.4 miles away',
        'rating': 4.8,
        'markerLabel': 'Kahve Dünyası',
        'photos': jvPhotos,
      },
      {
        'name': 'Library Cafe',
        'description': 'Quiet sanctuary for researchers and espresso lovers.',
        'distance': '1.2 miles away',
        'rating': 4.6,
        'markerLabel': 'Central Library',
        'photos': [jvPhotos[1], jvPhotos[2]],
      },
    ];

    for (final branch in branches) {
      batch.set(firestore.collection('branches').doc(), BranchModel(
        name: branch['name'] as String?,
        description: branch['description'] as String?,
        distance: branch['distance'] as String?,
        rating: (branch['rating'] as num?)?.toDouble(),
        markerLabel: branch['markerLabel'] as String?,
        photos: (branch['photos'] as List?)?.map((e) => e as String).toList(),
      ).toJson());
    }

    final suggestions = [
      'What should I drink while reading Kafka?',
      'Recommend a smooth brew for a rainy afternoon.',
      'Suggest a bold pairing for existential philosophy.',
    ];
    for (final s in suggestions) {
      batch.set(firestore.collection('ai_suggestions').doc(), {'text': s});
    }

    batch.set(firestore.collection('app_metadata').doc('version'), {'db_version': 8});
    await batch.commit();
    if (kDebugMode) print('✨ [SEED] Eternal Archive sync (v8) completed successfully!');
    
  } catch (e) {
    if (kDebugMode) print('❌ [SEED] ERROR during v8 sync: $e');
  }
}
