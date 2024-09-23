import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class FemaleKnightGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Load the sprite sheet for Female Knight from assets
    final spriteSheet = await images.load('female_knight_idle.png');

    // Create the animation from the sprite sheet
    final femaleKnightAnimation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 4,  // Number of frames in the top row
        stepTime: 0.15,  // Time between frames for smooth animation
        textureSize: Vector2(100, 64),  // Each frame size (64x64)
      ),
    );

    // Create the SpriteAnimationComponent to display the animation
    final femaleKnight = SpriteAnimationComponent(
      animation: femaleKnightAnimation,
      size: Vector2(300, 250),  // Zoom to 600x600
      anchor: Anchor.center,  // Set anchor to center
      position: Vector2(size.x / 2, size.y / 2 - 50),  // Move upwards a bit
    );

    // Add the animated sprite to the game
    add(femaleKnight);
  }

  @override
  Color backgroundColor() => const Color(0x00000000);  // Set transparent background
}
