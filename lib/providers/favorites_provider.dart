import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/image_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<ImageModel> _favorites = [];
  List<ImageModel> get favorites => _favorites;

  Future<void> fetchFavorites() async {
    try {
      final snapshot = await _firestore.collection('favorites').get();
      _favorites =
          snapshot.docs.map((doc) => ImageModel.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching favorites: $e');
    }
  }

  Future<void> addFavorite(ImageModel image) async {
    try {
      await _firestore.collection('favorites').add(image.toFirestore());
      _favorites.add(image);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding favorite: $e');
    }
  }

  Future<void> removeFavorite(ImageModel image) async {
    try {
      final snapshot = await _firestore
          .collection('favorites')
          .where('imageUrl', isEqualTo: image.imageUrl)
          .get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      _favorites.removeWhere((item) => item.imageUrl == image.imageUrl);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing favorite: $e');
    }
  }

  void toggleFavorite(ImageModel image) async {
    if (isFavorite(image)) {
      removeFavorite(image);
    } else {
      addFavorite(image);
    }
  }

  bool isFavorite(ImageModel image) {
    return _favorites.any((item) => item.imageUrl == image.imageUrl);
  }
}
