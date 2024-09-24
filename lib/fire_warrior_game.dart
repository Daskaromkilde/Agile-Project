import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class FireWarriorGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Load the sprite sheet for Fire Warrior from assets
    final spriteSheet = await images.load('Fire_WarriorFireSword-Sheet.png');

    // Create the animation from the sprite sheet
    final fireWarriorAnimation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 8,  // Number of frames in the top row (idle animation)
        stepTime: 0.1,  // Time between frames for smooth animation
        textureSize: Vector2(144, 100),  // Each frame size
      ),
    );

    // Create the SpriteAnimationComponent to display the animation
    final fireWarrior = SpriteAnimationComponent(
      animation: fireWarriorAnimation,
      size: Vector2(600, 500),  // Zoom to 600x500
      anchor: Anchor.center,  // Set anchor to center
      position: Vector2(size.x / 2 + 65, size.y /2),  // Adjust position to move upwards
    );

    // Add the animated sprite to the game
    add(fireWarrior);
  }

  @override
  Color backgroundColor() => const Color(0x00000000);  // Set transparent background
}
