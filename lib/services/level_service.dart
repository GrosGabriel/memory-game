import 'package:hive_ce_flutter/hive_flutter.dart';

class LevelService {
  int? currentLevel;

  final Box storage = Hive.box('storage');

  Map<int, int> _movesPerLevel = {};

  void init() {
    final data = storage.get('movesPerLevel');

    if (data is Map) {
      _movesPerLevel = data.map<int, int>(
        (k, v) => MapEntry(int.parse(k.toString()), v as int),
      );
    } else {
      _movesPerLevel = {};
    }
  }

  Map<int, int> get movesPerLevel => _movesPerLevel;

  void save() {
    storage.put(
      'movesPerLevel',
      _movesPerLevel.map((k, v) => MapEntry(k.toString(), v)),
    );
  }

  void updateMoves(int level, int flips) {
    final current = _movesPerLevel[level];
    if (current == null || flips < current) {
      _movesPerLevel[level] = flips;
      save();
    }
  }
}


