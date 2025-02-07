import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/image_model.dart';
import '../providers/favorites_provider.dart';

class DetailsScreen extends StatelessWidget {
  final ImageModel image;

  const DetailsScreen({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles de ${image.tittle}"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              image.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              image.tittle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Consumer<FavoritesProvider>(
              builder: (context, favoritesProvider, child) {
            final isFavorite = favoritesProvider.isFavorite(image);
            return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.all(18),
                child: ElevatedButton.icon(
                  onPressed: () {
                    favoritesProvider.toggleFavorite(image);
                  },
                  icon: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      key: ValueKey<bool>(isFavorite),
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                  ),
                  label: Text(isFavorite
                      ? 'Quitar de favoritos'
                      : 'Agregar a favoritos'),
                ));
          }),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
