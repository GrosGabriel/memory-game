import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'start_screen.dart';
import 'services/level_service.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

Future<void> main() async {

  await Hive.initFlutter();
  await Hive.openBox("storage");
  

  runApp(GameApp());
}

class GameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() {
      final levelService = LevelService();
      levelService.init();
      return levelService;
    });
    return GetMaterialApp(
      home: StartScreen(),
    );
  }
}


