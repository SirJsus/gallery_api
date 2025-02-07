import 'package:flutter/foundation.dart';
import '../models/image_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<ImageModel> _favorites = [];

  List<ImageModel> get favorites => _favorites;

  void toggleFavorite(ImageModel image) async {
    if (_favorites.contains(image)) {
      _favorites.remove(image);
    } else {
      _favorites.add(image);
    }
    notifyListeners();
  }

  bool isFavorite(ImageModel image) {
    return _favorites.contains(image);
  }
}
