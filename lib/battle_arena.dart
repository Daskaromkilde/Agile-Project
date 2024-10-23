import 'package:first_app/avatar_view_page.dart';
import 'package:first_app/local_data_storage.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'boss_game.dart';
import 'playerInventory.dart'; // Import your PlayerInventory
import 'playerStats.dart'; // Import your PlayerStats

class BattleArena extends StatefulWidget {
  // Pass selected avatar path from AvatarViewPage
  final String avatarName;
  final String selectedAvatar;
  final GameWidget
      avatar; // Pass game instance from outside, which is the selected avatar

  const BattleArena({
    super.key,
    required this.avatarName,
    required this.selectedAvatar,
    required this.avatar,
  });

  @override
  _BattleArenaState createState() => _BattleArenaState();
}

class _BattleArenaState extends State<BattleArena> {
  late BossGame game; // Declare the game instance for Boss
  late GameWidget avatarGame; // GameWidget passed from widget
  int bossHP = 300; // Current bossHP
  int initialBossHP = 300; // Initial bossHP
  int hpIncrement = 100; // Increment boss HP after each victory
  bool showAttackOptions =
      false; // Toggle between main buttons and attack options

  @override
  void initState() {
    super.initState();
    game = BossGame(); // Initialize the main game (BossGame)
    avatarGame = widget.avatar; // Use the passed GameWidget instance

    DataStorage().loadBossHP().then((hp) {
      setState(() {
        bossHP = hp; // Set the loaded HP from persistent storage
        initialBossHP = hp;

      });
    });

    PlayerInventory.addItem(PlayerInventory.healthPotion, 5);
    PlayerInventory.addItem(PlayerInventory.slimeGel, 8);
    PlayerInventory.addItem(PlayerInventory.monsterEye, 2);

    attack_class attack1 = attack_class(
      name: 'Fireball',
      damage: 20,
      statusEffectOn: true,
      statCost: 5,
      statAffected: PlayerStats.getINT,
      effect: statusEffect.burn,
      effectDuration: 5, // Example duration
      effectDPS: 10, // Example damage per second
    );
    attack_class attack2 = attack_class(
      name: 'Ice Shard',
      damage: 15,
      statusEffectOn: true,
      statCost: 4,
      statAffected: PlayerStats.getINT,
      effect: statusEffect.freeze,
      effectDuration: 4, // Example duration
      effectDPS: 8, // Example damage per second
    );

    attack_class attack3 = attack_class(
      name: 'Punch',
      damage: 25,
      statusEffectOn: false,
      statCost: 6,
      statAffected: PlayerStats.getSTA,
      effect: statusEffect.stun,
      effectDuration: 3, // Example duration
      effectDPS: 12, // Example damage per second
    );

    PlayerStats.addAttack(attack1);
    PlayerStats.addAttack(attack2);
    PlayerStats.addAttack(attack3);
  }

  @override
  void dispose() {
    game.onDetach(); // Properly detach the boss game when the widget is disposed
    super.dispose();
  }

  void showInventory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2E2E2E), // Dark background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
            side: const BorderSide(
                color: Colors.brown, width: 3), // Border color and width
          ),
          title: const Text(
            'Inventory',
            style: TextStyle(
              fontSize: 24,
              color: Colors.yellow, // Title color
              fontFamily:
                  'Adventure', // Custom font (make sure to add this font to your project)
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: PlayerInventory.items.map((item) {
                return ListTile(
                  leading: Image.asset(item.image, width: 50, height: 50),
                  title: Text(
                    item.type,
                    style: const TextStyle(
                      color: Colors.white, // Item text color
                      fontFamily: 'Adventure', // Custom font
                    ),
                  ),
                  subtitle: Text(
                    'Quantity: ${item.quantity}',
                    style: const TextStyle(
                      color: Colors.white70, // Subtitle text color
                      fontFamily: 'Adventure', // Custom font
                    ),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      item.use();
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown, // Button color
                    ),
                    child: const Text(
                      'Use',
                      style: TextStyle(
                        color: Colors.white, // Button text color
                        fontFamily: 'Adventure', // Custom font
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Colors.yellow, // Button text color
                  fontFamily: 'Adventure', // Custom font
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void handleFlee() {
    if (PlayerStats.getSTA.currentValue >= 20) {
      PlayerStats.decreaseSTA(20);
      widget.avatar.game?.detach();

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AvatarViewPage(
                  selectedAvatar: widget.selectedAvatar,
                  avatarName: widget.avatarName,
                  game: widget.avatar,
                )),
      );
      print('Fled the battle');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Not enough stamina'),
            content: const Text('You need at least 20 stamina points to flee.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  bool handleAttack(attack_class attack) {
    if (PlayerStats.playerUnknowStat(attack.statAffected.name).currentValue >=
        attack.statCost) {
      PlayerStats.playerUnknowStat(attack.statAffected.name)
          .decrease(attack.statCost);
      setState((){
        bossHP -= attack.damage;
        DataStorage().saveBossHP(bossHP);
      });
      // Handle attack action
      print('Attacked the boss');
      if (bossHP <= 0) {
        // Boss defeated, increment boss HP for next round
        setState(() {
          initialBossHP += hpIncrement;  // Increase bossHP by hpIncrement, preserving its current value
          bossHP = initialBossHP;
          DataStorage().saveBossHP(bossHP); // Save the new boss HP to persistent storage
          print("New bossHP: $bossHP");
        }); // Save the new boss HP to persistent storage
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('You won!'),
              content: const Text('Boss HP increases!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }

      return true;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Not enough ${attack.statAffected.name}' ' points'),
            content: const Text('EMPTY '),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return false;
    }
  }

  void handleRecover() {
    PlayerStats.increaseSTA(20);
    print('Recovered 20 stamina points');
  }

  @override
  Widget build(BuildContext context) {
    List<attack_class> attacks = PlayerStats.getPlayerAttacks();
    attacks.shuffle(); // Shuffle the attacks for random order

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/pxArt.png'), // Your background image
          fit: BoxFit.cover, // Covers the whole screen
        ),
      ),
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // Make the scaffold background transparent
        appBar: AppBar(
          title: const Text('Battle Arena'),
          backgroundColor: const Color.fromARGB(255, 80, 18, 206),
        ),
        body: Stack(
          children: [
            // Player Stats on the Left
            Positioned(
              bottom:
                  150.0, // Adjusted margin from the bottom to move it higher
              left: 20.0, // Adjusted margin from the left
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your total stats: ${PlayerStats.getHP.currentValue} HP',
                    style:
                        const TextStyle(fontSize: 20, color: Colors.redAccent),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: 100, // Set a specific width
                    height: 100, // Set a specific height
                    child: avatarGame, // Use the passed game widget (avatar)
                  ),
                ],
              ),
            ),
            // Boss HP and Animation on the Right
            Positioned(
              top: 50.0, // Adjusted margin from the top to lower the boss
              right: 20.0, // Adjusted margin from the right
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Boss HP: $bossHP',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 150, // Set height for the boss animation container
                    width: 150, // Set width for the boss animation container
                    child: GameWidget(
                        game: game), // Use the game instance for the boss
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(
              bottom: 50.0,
              left: 16.0,
              right: 16.0), // Adjusted padding to make the buttons higher
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showAttackOptions)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showAttackOptions)
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 4,
                        children: [
                          for (var attack in attacks.take(3))
                            ElevatedButton(
                              onPressed: () {
                                if (handleAttack(attack)) {
                                  // attack successful, do next turn
                                } else {
                                  // attack failed, do nothing
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 15),
                                backgroundColor: Colors.redAccent,
                              ),
                              child: Text(
                                '${attack.name}\n(${attack.damage} DMG)\n(${attack.statCost} ${attack.statAffected.name})',
                                style: const TextStyle(
                                  fontSize: 10, // Increase font size
                                  color:
                                      Colors.white, // Set text color to white
                                ),
                              ),
                            ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showAttackOptions =
                                    false; // Go back to main buttons
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 15),
                              backgroundColor: Colors.grey,
                            ),
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 10, // Increase font size
                                color: Colors.white, // Set text color to white
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                )
              else
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showAttackOptions = true; // Show attack options
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 30),
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Text(
                            'Attack',
                            style: TextStyle(
                              fontSize: 18, // Increase font size
                              color: Colors.white, // Set text color to white
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: showInventory, // Show inventory popup
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 30),
                            backgroundColor: Colors.blueAccent,
                          ),
                          child: const Text(
                            'Inventory',
                            style: TextStyle(
                              fontSize: 18, // Increase font size
                              color: Colors.white, // Set text color to white
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: handleFlee,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 30),
                            backgroundColor: Colors.greenAccent,
                          ),
                          child: const Text(
                            'Flee (20 STA)',
                            style: TextStyle(
                              fontSize: 18, // Increase font size
                              color: Colors.white, // Set text color to white
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: handleRecover,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 30),
                            backgroundColor: Colors.orangeAccent,
                          ),
                          child: const Text(
                            'Recover',
                            style: TextStyle(
                              fontSize: 18, // Increase font size
                              color: Colors.white, // Set text color to white
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
