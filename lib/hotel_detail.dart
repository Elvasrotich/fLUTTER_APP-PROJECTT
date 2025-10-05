// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'models/hotel.dart';
import 'src/auth_service.dart';
import 'login_page.dart';

class HotelDetailPage extends StatefulWidget {
  final Hotel hotel;
  const HotelDetailPage({super.key, required this.hotel});

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.hotel.name)),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewPadding.bottom + 16,
          ),
          children: [
            Hero(
              tag: 'hotel-image-${widget.hotel.id}',
              child: Image.asset(
                widget.hotel.imageUrl,
                height: 250,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low,
                cacheWidth: 480,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.broken_image,
                    size: 64,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title is shown in the AppBar; remove duplicate here
                  const SizedBox.shrink(),
                  const SizedBox(height: 8),
                  // Hotel name as a bold heading in the content (smaller than AppBar)
                  Text(
                    widget.hotel.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Description in its own styled container (card-like)
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.hotel.desc,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.5,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Price: ${widget.hotel.price}",
                    style: const TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
          child: ElevatedButton(
            onPressed: () async {
              // Capture synchronous references to navigator, messenger and context
              // to avoid use_build_context_synchronously lint.
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);

              // Check if a user is signed in
              final user = await AuthService.currentUser();
              bool signedIn = user != null;
              if (!signedIn) {
                // ask user to sign in first
                final res = await navigator.push<bool?>(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
                signedIn = res == true;
              }

              if (!signedIn) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('You must sign in to book.')),
                );
                return;
              }

              final email = await AuthService.currentUser();
              // show a confirmation dialog including the email
              final ok = await showDialog<bool?>(
                context: navigator.context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm booking'),
                  content: Text('Book ${widget.hotel.name} as $email?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              );

              if (ok == true) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Booking confirmed for $email')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48), // full-width button
            ),
            child: const Text("Book Now"),
          ),
        ),
      ),
    );
  }
}
