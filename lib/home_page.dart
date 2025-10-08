import 'package:flutter/material.dart';
import 'models/hotel.dart';
import 'hotel_detail.dart';
import 'src/theme_controller.dart';
import 'src/favorites_controller.dart';

class HomePage extends StatelessWidget {
  final ThemeController? themeController;
  final FavoritesController? favoritesController;

  const HomePage({super.key, this.themeController, this.favoritesController});

  // convenience factory used by MyApp
  factory HomePage.withControllers(
    ThemeController controller,
    FavoritesController favs,
  ) => HomePage(themeController: controller, favoritesController: favs);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hotel Booking"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () => Navigator.of(context).pushNamed('/profile'),
          ),
          if (themeController != null)
            PopupMenuButton<ThemeMode>(
              onSelected: (mode) => themeController!.setMode(mode),
              itemBuilder: (_) => const [
                PopupMenuItem(value: ThemeMode.system, child: Text('System')),
                PopupMenuItem(value: ThemeMode.light, child: Text('Light')),
                PopupMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
              icon: const Icon(Icons.color_lens),
            ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 hotels per row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          final hotel = hotels[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HotelDetailPage(hotel: hotel),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Hero(
                            tag: 'hotel-image-${hotel.id}',
                            child: Image.asset(
                              hotel.imageUrl,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            filterQuality: FilterQuality.low,
                              cacheWidth: 360,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    height: 120,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                          if (favoritesController != null)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: AnimatedBuilder(
                                animation: favoritesController!,
                                builder: (context, _) {
                                  final fav = favoritesController!.isFavorite(
                                    hotel.id,
                                  );
                                  return Semantics(
                                    label: fav
                                        ? 'Remove from favorites'
                                        : 'Add to favorites',
                                    button: true,
                                    child: GestureDetector(
                                      onTap: () =>
                                          favoritesController!.toggle(hotel.id),
                                      child: Tooltip(
                                        message: fav
                                            ? 'Unfavorite'
                                            : 'Favorite',
                                        child: CircleAvatar(
                                          radius: 16,
                                          backgroundColor: const Color.fromRGBO(
                                            0,
                                            0,
                                            0,
                                            0.5,
                                          ),
                                          child: Icon(
                                            fav
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: fav
                                                ? Colors.redAccent
                                                : Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hotel name as a bold heading
                          Text(
                            hotel.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          // favorites icon moved as overlay on image
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
