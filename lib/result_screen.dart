import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services/level_service.dart';
import 'custom_scaffold.dart';
import 'start_screen.dart';


class ResultScreen extends StatelessWidget {
  final int totalFlips;
  final LevelService levelService = Get.find<LevelService>();

  ResultScreen({required this.totalFlips});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Congratulations ! You completed the level ${levelService.currentLevel} in $totalFlips flips !", textAlign : TextAlign.center , style: TextStyle(fontSize: 48)),
            Padding(
              padding: EdgeInsets.all(16),
            ),
            ElevatedButton(
              style : ElevatedButton.styleFrom(padding: EdgeInsets.all(16)),
              child: Text(
                "Back to home",
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () { 
                Get.offAll(() => StartScreen()); 
              },
            ),
          ],
        ),
      ),
    );
  }
}