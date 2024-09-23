import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class BlueWitchGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Load the sprite sheet for Blue Witch from assets
    final spriteSheet = await images.load('blue_witch/blue_witch_sheet.png');

    // Create the list of frames for vertical animation
    final List<Sprite> frames = [];
    const int frameCount = 6;  // Total number of frames (vertical)
    const double frameWidth = 64;  // Width of each frame
    const double frameHeight = 64;  // Height of each frame

    // Loop through each frame vertically and extract it
    for (int i = 0; i < frameCount; i++) {
      frames.add(
        Sprite(
          spriteSheet,
          srcPosition: Vector2(0, i * frameHeight),  // Move vertically for each frame
          srcSize: Vector2(frameWidth, frameHeight),  // Set frame size
        ),
      );
    }

    // Create the SpriteAnimation from the list of frames
    final blueWitchAnimation = SpriteAnimation.spriteList(
      frames,
      stepTime: 0.15,  // Time between frames for smooth animation
    );

    // Create the SpriteAnimationComponent to display the animation
    final blueWitch = SpriteAnimationComponent(
      animation: blueWitchAnimation,
      size: Vector2(600, 600),  // Zoom to 600x600
      anchor: Anchor.center,  // Set anchor to center
      position: Vector2(size.x / 2, size.y / 2 - 150),  // Adjust position upwards
    );

    // Add the animated sprite to the game
    add(blueWitch);
  }

  @override
  Color backgroundColor() => const Color(0x00000000);  // Transparent background
}
