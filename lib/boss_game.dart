import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class BossGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Load the sprite sheet image for Necromancer from assets
    final spriteSheet = await images.load('Necromancer.png');

    // Create the animation from the sprite sheet
    final bossAnimation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 8,  // Number of frames in the top row
        stepTime: 0.15,  // Time between frames for smooth animation
        textureSize: Vector2(160, 128),  // Each frame size for Necromancer
      ),
    );

    // Create the SpriteAnimationComponent to display the animation
    final boss = SpriteAnimationComponent(
      animation: bossAnimation,
      size: Vector2(400, 400),  // Zoom to 600x600
      anchor: Anchor.center,  // Set anchor to center
      position: Vector2(size.x / 2, size.y / 2 - 150),  // Move upwards a bit
    );

    // Add the animated sprite to the game
    add(boss);
  }

  @override
  Color backgroundColor() => const Color(0x00000000);  // Set transparent background
}
