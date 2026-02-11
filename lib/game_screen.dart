import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'services/level_service.dart';
import 'utils/breakpoints.dart';
import 'utils/card_color.dart';
import 'package:flame/text.dart';
import 'result_screen.dart';



class GameScreen extends StatelessWidget {
  final LevelService levelService = Get.find<LevelService>();
  @override
  Widget build(BuildContext context) { //On gère pas le breakpoint ici, on adapate la taille du jeu en fonction
    return LayoutBuilder(builder : (BuildContext context, BoxConstraints constraints) {
      final isSm = constraints.maxWidth < Breakpoints.sm;
      

      if (levelService.currentLevel == 1) {
        if (isSm) {
          return GameWidget(game: MemoryGame(rows : 3, columns : 2));
        } else {
          return GameWidget(game: MemoryGame(rows : 2, columns : 3));
        }
      } else if (levelService.currentLevel == 2) {
        if (isSm) {
          return GameWidget(game: MemoryGame(rows : 8, columns : 2));
        } else {
          return GameWidget(game: MemoryGame(rows : 4, columns : 4));
        }
      } else {
        if (isSm) {
          return GameWidget(game: MemoryGame(rows : 10, columns : 3));
        } else {
          return GameWidget(game: MemoryGame(rows : 5, columns : 6));
        }
      }
      
      

    }
    );

  }
}


class CardComponent extends PositionComponent with TapCallbacks, HasGameReference<MemoryGame> {
  final int id;
  bool isFlipped = false;
  bool isMatched = false;

  
  late final TextPaint _textPaint;


  CardComponent({required this.id, required Vector2 position, required Vector2 size,}) 
  : super(position: position, size: size) {
    _textPaint = TextPaint(
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize : size.y / 2,
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    final cardColor = CardColor(id);
    final paint = Paint()
      ..color = isMatched ? cardColor.matched : isFlipped ? cardColor.revealed : cardColor.hidden;

    canvas.drawRect(size.toRect(), paint);

     // Texte (seulement si visible)
    if (isFlipped || isMatched) {
      final text = id.toString();
      _textPaint.render(canvas, text, Vector2(size.x /2, size.y /2), anchor: Anchor.center);
    }

  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!isFlipped && !isMatched && game.canTap) {
      isFlipped = true;
      game.onCardTapped(this);
      
    }
  }
}


List<CardComponent> createCards({required int rows, required int columns, required double gameWidth, required double gameHeight,}) {
  final cards = <CardComponent>[];
  final totalCards = rows * columns;
  final pairs = totalCards ~/ 2;


  final tempCards = <int>[];
  for (int i = 0; i < pairs; i++) {
    tempCards.add(i);
    tempCards.add(i);
  }
  tempCards.shuffle(Random());

  final cardWidth = gameWidth / columns;
  final cardHeight = gameHeight / rows;

  final startX = -gameWidth / 2;
  final startY = -gameHeight / 2;

  int index = 0;
  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < columns; col++) {
      cards.add(
        CardComponent(
          id: tempCards[index],
          position: Vector2(startX + col * cardWidth, startY + row * cardHeight),
          size: Vector2(cardWidth - 8, cardHeight - 8),
        ),
      );
      index++;
    }
  }

  return cards;
}


class MemoryGame extends FlameGame {
  final int rows;
  final int columns;
  CardComponent? firstFlippedCard ;
  CardComponent? secondFlippedCard ;
  int matchedPairs = 0;
  var canTap = true;

  int totalFlips = 0;

  MemoryGame({required this.rows, required this.columns}) 
    : super(
        camera: CameraComponent.withFixedResolution( 
          width: 800, 
          height: 600,
          ),
        );
    

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewfinder.anchor = Anchor.center;
    camera.viewfinder.position = Vector2.zero();

    world.addAll(createCards(rows: rows, columns: columns, gameWidth: size.x, gameHeight: size.y)); //size.x et size.y refers to the gamesize width and height, which is 800 and 600 in this case
  }
  
  Future<void> onCardTapped(CardComponent card) async {
    if (firstFlippedCard == null) {
      firstFlippedCard = card;
      totalFlips++;
    } else if (secondFlippedCard == null && card != firstFlippedCard) {
      secondFlippedCard = card;
      canTap = false;

      if (firstFlippedCard!.id == secondFlippedCard!.id) {
        firstFlippedCard!.isMatched = true;
        secondFlippedCard!.isMatched = true;
        matchedPairs++;

        firstFlippedCard = null;
        secondFlippedCard = null;
        canTap = true;

        if (matchedPairs == (rows * columns) / 2) {
          final LevelService levelService = Get.find<LevelService>();
          levelService.updateMoves(levelService.currentLevel!, totalFlips);
          
          await Future.delayed(Duration(seconds: 1));

          Get.offAll(() => ResultScreen(totalFlips: totalFlips));
        }
      } else {
        await Future.delayed(Duration(seconds: 1));
        firstFlippedCard!.isFlipped = false;
        secondFlippedCard!.isFlipped = false;

        firstFlippedCard = null;
        secondFlippedCard = null;
        canTap = true;
      }
    }
    

  }



}



