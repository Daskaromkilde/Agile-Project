import 'package:flame/game.dart';
import 'necromancer_game.dart'; // Import avatars from other game files
import 'fire_warrior_game.dart';
import 'wind_warrior_game.dart';
import 'female_knight_game.dart';
import 'blue_witch_game.dart';


class AvatarUtils {
  static GameWidget getAvatarWidget(String selectedAvatar) {
    switch (selectedAvatar) {
      case 'blue_witch':
        return GameWidget(game: BlueWitchGame());
      case 'female_knight':
        return GameWidget(game: FemaleKnightGame());
      case 'necromancer':
        return GameWidget(game: NecromancerGame());
      case 'fire_warrior':
        return GameWidget(game: FireWarriorGame());
      case 'wind_warrior':
        return GameWidget(game: WindWarriorGame());
      default:
        return GameWidget(game: NecromancerGame()); // Default to NecromancerGame if no avatar is selected
    }
  }
}