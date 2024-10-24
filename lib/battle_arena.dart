import 'package:first_app/avatar_view_page.dart';
import 'package:first_app/local_data_storage.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'boss_game.dart';
import 'playerInventory.dart'; // Import your PlayerInventory
import 'playerStats.dart'; // Import your PlayerStats

import 'package:particles_flutter/component/particle/particle.dart';
import 'package:particles_flutter/core/runner.dart';
import 'package:particles_flutter/painters/circular_painter.dart';
import 'package:particles_flutter/particles_engine.dart';

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

class _BattleArenaState extends State<BattleArena>
    with SingleTickerProviderStateMixin {
  late BossGame game; // Declare the game instance for Boss
  late GameWidget avatarGame; // GameWidget passed from widget
  int bossHP = 300; // Current bossHP
  int initialBossHP = 300; // Initial bossHP
  int hpIncrement = 100; // Increment boss HP after each victory
  bool showAttackOptions =
      false; // Toggle between main buttons and attack options
  bool isPlayerTurn = true; // Track whose turn it is
  List<attack_class> attacks = PlayerStats.getPlayerAttacks();
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    game = BossGame(); // Initialize the main game (BossGame)
    avatarGame = widget.avatar; // Use the passed GameWidget instance

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 20)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);

    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shakeController.reverse();
      }
    });

    DataStorage().loadBossHP().then((hp) {
      setState(() {
        bossHP = hp; // Set the loaded HP from persistent storage
        initialBossHP = hp;
      });
    });
    attacks.shuffle();

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
    _shakeController.dispose();
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

  Future<bool> handleAttack(attack_class attack) async {
    // If you dont want this logic, delete from here
    if (PlayerStats.getHP.currentValue <= 0) {
      // Display a popup if the player has no HP
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Not enough HP'),
            content: const Text('Your HP is 0. Try again tomorrow!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return false;
    }
    // To here

    final stat = PlayerStats.playerUnknowStat(attack.statAffected.name);
    if (stat.currentValue >= attack.statCost) {
      stat.decrease(attack.statCost);
      setState(() {
        bossHP -= attack.damage;
        DataStorage().saveBossHP(bossHP);
      });
      print('Attacked the boss');
      if (bossHP <= 0) {
        setState(() {
          initialBossHP += hpIncrement;
          bossHP = initialBossHP;
          DataStorage().saveBossHP(bossHP);
          print("New bossHP: $bossHP");
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('lastVictoryTime', DateTime.now().millisecondsSinceEpoch);


        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('You won!'),
              content: const Text('Boss HP increases!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context,true);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
      endPlayerTurn();
      return true;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Not enough points'),
            content: Text(
                'You need more ${attack.statAffected.name} points to perform this attack. ${PlayerStats.getINT.currentValue} ${attack.statAffected.name} points left.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
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

  void endPlayerTurn() {
    setState(() {
      isPlayerTurn = false;
    });
    Future.delayed(Duration(seconds: 1), bossAttack);
  }

  void bossAttack() {
    setState(() {
      // Boss attack logic here
      PlayerStats.decreaseHP(10); // Example damage
      print('Boss attacked the player');
      isPlayerTurn = true;
    });
    _shakeController.forward();
  }

  void handleRecover() {
    if (isPlayerTurn) {
      PlayerStats.increaseSTA(20);
      print('Recovered 20 stamina points');
      endPlayerTurn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/battlebg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Battle Arena'),
          backgroundColor: const Color.fromARGB(255, 80, 18, 206),
        ),
        body: Stack(
          children: [
            // Add a placeholder or any other widget here
            Positioned(
              top: 10.0,
              left: 10.0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E2E2E),
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.brown, width: 3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PlayerStatsDisplay(
                      stat: PlayerStats.getHP,
                      icon: Icons.favorite,
                      color: Colors.red,
                    ),
                    PlayerStatsDisplay(
                      stat: PlayerStats.getSTA,
                      icon: Icons.flash_on,
                      color: Colors.yellow,
                    ),
                    PlayerStatsDisplay(
                      stat: PlayerStats.getSTR,
                      icon: Icons.fitness_center,
                      color: Colors.blue,
                    ),
                    PlayerStatsDisplay(
                      stat: PlayerStats.getINT,
                      icon: Icons.school,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: 350,
              right: 450,
              child: AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: avatarGame,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 380,
              right: 35,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: GameWidget(game: game),
                  ),
                  Container(
                    padding: const EdgeInsets.all(
                        3.0), // Padding for the gold border
                    decoration: BoxDecoration(
                      color: Colors.amber, // Pure gold color
                      borderRadius:
                          BorderRadius.circular(5), // Ensure rectangular shape
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Container(
                      width: 150,
                      height: 20,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red.shade900, Colors.red.shade400],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(
                            5), // Ensure rectangular shape
                        border:
                            Border.all(color: Colors.red.shade900, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.shade900.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: LinearProgressIndicator(
                              value: bossHP / initialBossHP,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.red.shade900),
                            ),
                          ),
                          Center(
                            child: Text(
                              '${(bossHP / initialBossHP * 100).toInt()}%',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.black,
                                    offset: Offset(2.0, 2.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 50.0, left: 16.0, right: 16.0),
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
                              onPressed: isPlayerTurn
                                  ? () async {
                                      if (await handleAttack(attack)) {
                                        // attack successful, do next turn
                                      } else {
                                        // attack failed, do nothing
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 15),
                                backgroundColor: Colors.redAccent,
                              ),
                              child: Text(
                                '${attack.name}\n(${attack.damage} DMG)\n(${attack.statCost} ${attack.statAffected.name})',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ElevatedButton(
                            onPressed: isPlayerTurn
                                ? () {
                                    setState(() {
                                      showAttackOptions = false;
                                    });
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 15),
                              backgroundColor: Colors.grey,
                            ),
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
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
                          onPressed: isPlayerTurn
                              ? () {
                                  setState(() {
                                    showAttackOptions = true;
                                  });
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 30),
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Text(
                            'Attack',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: isPlayerTurn ? showInventory : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 30),
                            backgroundColor: Colors.blueAccent,
                          ),
                          child: const Text(
                            'Inventory',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
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
                          onPressed: isPlayerTurn ? handleFlee : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 30),
                            backgroundColor: Colors.greenAccent,
                          ),
                          child: const Text(
                            'Flee (20 STA)',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: isPlayerTurn ? handleRecover : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 30),
                            backgroundColor: Colors.orangeAccent,
                          ),
                          child: const Text(
                            'Recover',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
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

class PlayerStatsDisplay extends StatelessWidget {
  final Stat stat;
  final IconData icon;
  final Color color;

  const PlayerStatsDisplay({
    Key? key,
    required this.stat,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(
            '${stat.name}: ${stat.currentValue}/${stat.maxValue}',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
