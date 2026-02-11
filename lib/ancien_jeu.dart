import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

void main() {
  runApp(GameApp());
}

class GameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: StartScreen(),
    );
  }
}

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Welcome !!!", style: TextStyle(fontSize: 48)),
            Padding(
              padding: EdgeInsets.all(16),
            ),
            ElevatedButton(
              child: Text(
                "Start the game",
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () => Get.to(() => GameScreen()),
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: TapGame(),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final String winner;
  final int score;
  const ResultScreen({required this.winner, required this.score});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (winner == "No one, it's a tie")
                Text("No one wins, it's a tie !",
                style: TextStyle(fontSize: 48))
               else ...[
              Text('Congratulations, $winner wins !',
                style: TextStyle(fontSize: 48)),
            Text("Great work, you got $score points!",
                style: TextStyle(fontSize: 48)),
               ],
            Padding(
              padding: EdgeInsets.all(16),
            ),
            ElevatedButton(
              child: Text(
                "Back to start",
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () => Get.to(() => StartScreen()),
            ),
          ],
        ),
      ),
    );
  }
}

class TapGame extends FlameGame {
  final gravity = Vector2(0, 100);

  var gameFinished = false;
  var timeLeft = 30.0;
  var scoreRectangle = 0;
  var scoreCircle = 0;
  var scorePolygon = 0;

  @override
  void update(double dt) {
    super.update(dt);
    timeLeft -= dt;

    if (timeLeft <= 0 && !gameFinished) {
      gameFinished = true;
      if(scoreRectangle > scoreCircle && scoreRectangle > scorePolygon){
        Get.offAll(() => ResultScreen(winner : "Rectangle",score: scoreRectangle));
      } else if(scoreCircle > scoreRectangle && scoreCircle > scorePolygon){
        Get.offAll(() => ResultScreen(winner : "Circle",score: scoreCircle));
      } else if(scorePolygon > scoreRectangle && scorePolygon > scoreCircle){
        Get.offAll(() => ResultScreen(winner : "Polygon",score: scorePolygon));
      } else {
        Get.offAll(() => ResultScreen(winner : "No one, it's a tie",score: scoreCircle));
      }
    }
  }

  TapGame() {
    add(
      TapBoxRectangle(),
    );
    add(
      TapBoxCircle(),
    );
    add(
      TapBoxPolygon(),
    );
  }

  incrementScoreRectangle() {
    scoreRectangle++;
  }

  incrementScoreCircle() {
    scoreCircle++;

  }

  incrementScorePolygon() {
    scorePolygon++;

  }
}

class TapBoxRectangle extends RectangleComponent with HasGameRef<TapGame>, TapCallbacks {
  final random = Random();
  var timeSinceLastMove = 0.0;
  var velocity = Vector2(0, 0);
  TapBoxRectangle()
      : super(
          position: Vector2(100, 150),
          size: Vector2(50, 50),
          anchor: Anchor.center,
        );

  @override
  void onTapDown(TapDownEvent event) {
    gameRef.incrementScoreRectangle();
    changeLocation();
  }


  @override
  void update(double dt) {
    super.update(dt);
    transform.angle += dt;

    velocity += gameRef.gravity * dt;
    position += velocity * dt;

    timeSinceLastMove += dt;
    if (timeSinceLastMove > 1.0) {
      changeLocation();
    }

    if (position.y > gameRef.size.y - size.y) {
      position.y = gameRef.size.y - size.y;
      velocity = Vector2(0, 0);
    }
  }

  void changeLocation() {
    position.x = random.nextDouble() * (gameRef.size.x - size.x);
    position.y = random.nextDouble() * (gameRef.size.y - size.y);

    timeSinceLastMove = 0.0;
  }


}

class TapBoxCircle extends CircleComponent with HasGameRef<TapGame>, TapCallbacks {
  final random = Random();
  var timeSinceLastMove = 0.0;
  var velocity = Vector2(0, 0);
  TapBoxCircle()
      : super(
          position: Vector2(100, 100),
          radius: 25,
          anchor: Anchor.center,
        );

  @override
  void onTapDown(TapDownEvent event) {
    gameRef.incrementScoreCircle();
    changeLocation();
  }

  @override
  void update(double dt) {
    super.update(dt);

    velocity += gameRef.gravity * dt;
    position += velocity * dt;

    timeSinceLastMove += dt;
    if (timeSinceLastMove > 1.0) {
      changeLocation();
    }
    if (position.y > gameRef.size.y - radius) {
      position.y = gameRef.size.y - radius;
      velocity = Vector2(0, 0);
    }
  }

  void changeLocation() {
    position.x = random.nextDouble() * (gameRef.size.x - radius * 2) + radius;
    position.y = random.nextDouble() * (gameRef.size.y - radius * 2) + radius;

    timeSinceLastMove = 0.0;
  }

}

class TapBoxPolygon extends PolygonComponent with HasGameRef<TapGame>, TapCallbacks {
  final random = Random();
  var timeSinceLastMove = 0.0;
  var velocity = Vector2(0, 0);
  TapBoxPolygon()
      : super(
          [
            Vector2(0, 0),
            Vector2(50, 0),
            Vector2(25, 50),
          ],
          position: Vector2(100, 50),
          anchor: Anchor.center,
        );

  @override
  void onTapDown(TapDownEvent event) {
    gameRef.incrementScorePolygon();

    changeLocation();
  }


  @override
  void update(double dt) {
    super.update(dt);
    transform.angle += dt;

    velocity += gameRef.gravity * dt;
    position += velocity * dt;

    timeSinceLastMove += dt;
    if (timeSinceLastMove > 1.0) {
      changeLocation();
    }

    if (position.y > gameRef.size.y - size.y) {
      position.y = gameRef.size.y - size.y;
      velocity = Vector2(0, 0);
    }
  }

  void changeLocation() {
    position.x = random.nextDouble() * (gameRef.size.x - size.x);
    position.y = random.nextDouble() * (gameRef.size.y - size.y);

    timeSinceLastMove = 0.0;
  }
}