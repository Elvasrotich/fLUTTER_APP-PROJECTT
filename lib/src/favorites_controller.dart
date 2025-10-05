import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesController extends ChangeNotifier {
  static const _key = 'favorite_hotels';
  final Set<int> _ids = {};

  Set<int> get ids => _ids;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    _ids.clear();
    for (final s in list) {
      final v = int.tryParse(s);
      if (v != null) {
        _ids.add(v);
      }
    }
    notifyListeners();
  }

  Future<void> toggle(int id) async {
    if (_ids.contains(id)) {
      _ids.remove(id);
    } else {
      _ids.add(id);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _ids.map((e) => e.toString()).toList());
  }

  bool isFavorite(int id) => _ids.contains(id);
}
