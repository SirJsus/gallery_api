import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/image_model.dart';
import '../providers/favorites_provider.dart';

class DetailsScreen extends StatefulWidget {
  final ImageModel image;

  const DetailsScreen({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Future<void> _favoritesFuture;

  @override
  void initState() {
    _favoritesFuture =
        Provider.of<FavoritesProvider>(context, listen: false).fetchFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles de ${widget.image.tittle}"),
      ),
      body: FutureBuilder(
          future: _favoritesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.network(
                      widget.image.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.image.tittle,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Consumer<FavoritesProvider>(
                      builder: (context, favoritesProvider, child) {
                    final isFavorite =
                        favoritesProvider.isFavorite(widget.image);
                    return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.all(18),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            favoritesProvider.toggleFavorite(widget.image);
                          },
                          icon: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) =>
                                ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
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
              );
            }
          }),
    );
  }
}
