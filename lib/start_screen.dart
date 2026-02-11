import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'game_screen.dart';
import 'services/level_service.dart';
import 'custom_scaffold.dart';


class StartScreen extends StatelessWidget {
  final LevelService levelService = Get.find<LevelService>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Welcome to the memory game !!!", textAlign : TextAlign.center , style: TextStyle(fontSize: 48)),
            Padding(
              padding: EdgeInsets.all(16),
            ),
            ElevatedButton(
              style : ElevatedButton.styleFrom(padding: EdgeInsets.all(16)),
              child: Text(
                "Level easy (${levelService.movesPerLevel.containsKey(1) ? "Completed in ${levelService.movesPerLevel[1]} flips" : "Not completed"})",
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () { 
                levelService.currentLevel = 1;
                Get.to(() => GameScreen()); 
    },
            ),

            SizedBox(height: 16),

            ElevatedButton(
              style : ElevatedButton.styleFrom(padding: EdgeInsets.all(16)),
              child: Text(
                "Level medium (${levelService.movesPerLevel.containsKey(2) ? "Completed in ${levelService.movesPerLevel[2]} flips" : "Not completed"})",
                style: TextStyle(fontSize: 24), 
              ),
              onPressed: () { 
                levelService.currentLevel = 2;
                Get.to(() => GameScreen()); 
              },

            ),

              SizedBox(height: 16),


              ElevatedButton(
                    style : ElevatedButton.styleFrom(padding: EdgeInsets.all(16)),
                child: Text(
                  "Level hard (${levelService.movesPerLevel.containsKey(3) ? "Completed in ${levelService.movesPerLevel[3]} flips" : "Not completed"})",
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () { 
                  levelService.currentLevel = 3;
                  Get.to(() => GameScreen()); 
                },
                
             ),

            
          ],
        ),
      ),
    );
  }
}