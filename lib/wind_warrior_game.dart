import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class WindWarriorGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Load the sprite sheet for Wind Warrior from assets
    final spriteSheet = await images.load('wind_SpriteSheet_288x128.png');

    // Create the animation from the sprite sheet
    final windWarriorAnimation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 8,  // Number of frames in the top row
        stepTime: 0.15,  // Time between frames for smooth animation
        textureSize: Vector2(288, 128),  // Each frame size
      ),
    );

    // Create the SpriteAnimationComponent to display the animation
    final windWarrior = SpriteAnimationComponent(
      animation: windWarriorAnimation,
      size: Vector2(2000, 1000),  // Zoom to 600x600
      anchor: Anchor.center,  // Set anchor to center
      position: Vector2(size.x / 2, size.y / 2 - 400),  // Move upwards a bit
    );

    // Add the animated sprite to the game
    add(windWarrior);
  }

  @override
  Color backgroundColor() => const Color(0x00000000);  // Set transparent background
}
