/// A class representing the player's stats.
class PlayerStats {
  static Stat exp = Stat(currentValue: 0, maxValue: 100, level: 0);
  static Stat str = Stat(currentValue: 50, maxValue: 50, level: 0);
  static Stat intell = Stat(currentValue: 50, maxValue: 50, level: 0);
  static Stat hp = Stat(currentValue: 200, maxValue: 200, level: 0);
  static Stat sta = Stat(currentValue: 50, maxValue: 50, level: 0);

  static int level = 0;

  /// Getter for EXP stat.
  static Stat get getEXP => exp;

  /// Getter for STR stat.
  static Stat get getSTR => str;

  /// Getter for INT stat.
  static Stat get getINT => intell;

  /// Getter for HP stat.
  static Stat get getHP => hp;

  /// Getter for STA stat.
  static Stat get getSTA => sta;

  static void increaseEXP(int amount) {
    if (exp.currentValue + amount > exp.maxValue) {
      exp.currentValue = exp.maxValue;
    } else {
      exp.increasPlayerEXP(amount);
    }
  }

  /// Increases the STR stat by the given amount.
  static void increaseSTR(int amount) {
    if (str.currentValue + amount > str.maxValue) {
      str.currentValue = str.maxValue;
    } else {
      str.increase(amount);
    }
  }

  /// Increases the STA stat by the given amount.
  static void increaseSTA(int amount) {
    if (sta.currentValue + amount > sta.maxValue) {
      sta.currentValue = sta.maxValue;
    } else {
      sta.increase(amount);
    }
  }

  /// Increases the INT stat by the given amount.
  static void increaseINT(int amount) {
    if (intell.currentValue + amount > intell.maxValue) {
      intell.currentValue = intell.maxValue;
    } else {
      intell.increase(amount);
    }
  }

  /// Increases the HP stat by the given amount.
  static void increaseHP(int amount) {
    if (hp.currentValue + amount > hp.maxValue) {
      hp.currentValue = hp.maxValue;
    } else {
      hp.increase(amount);
    }
  }

  /// Decreases the EXP stat by the given amount.
  static void decreaseEXP(int amount) {
    if (exp.currentValue - amount < 0) {
      exp.currentValue = 0;
    } else {
      exp.decrease(amount);
    }
  }

  /// Decreases the STR stat by the given amount.
  static void decreaseSTR(int amount) {
    if (str.currentValue - amount < 0) {
      str.currentValue = 0;
    } else {
      str.decrease(amount);
    }
  }

  /// Decreases the STA stat by the given amount.
  static void decreaseSTA(int amount) {
    if (sta.currentValue - amount < 0) {
      sta.currentValue = 0;
    } else {
      sta.decrease(amount);
    }
  }

  /// Decreases the INT stat by the given amount.
  static void decreaseINT(int amount) {
    if (intell.currentValue - amount < 0) {
      intell.currentValue = 0;
    } else {
      intell.decrease(amount);
    }
  }

  /// Decreases the HP stat by the given amount.
  static void decreaseHP(int amount) {
    if (hp.currentValue - amount < 0) {
      hp.currentValue = 0;
    } else {
      hp.decrease(amount);
    }
  }

  /// Decreases all stats by the given amount.
  static void decreaseAllStats(int amount) {
    exp.decrease(amount);
    str.decrease(amount);
    intell.decrease(amount);
    hp.decrease(amount);
    sta.decrease(amount);
  }

  static void increaseAllStats(int amount) {
    exp.increase(amount);
    str.increase(amount);
    intell.increase(amount);
    hp.increase(amount);
    sta.increase(amount);
  }

  /// Increases the max value of STR, INT, and HP stats by the given amount.
  static void levelupIncrease(int amount) {
    str.increasMaxValue(amount);
    intell.increasMaxValue(amount);
    hp.increasMaxValue(amount);
  }

  /// Increases the max value of STR, INT, and HP stats by a factor.
  static void levelupIncreaseByFactor(double times) {
    str.increasMaxValue((str.maxValue * times).toInt());
    intell.increasMaxValue((str.maxValue * times).toInt());
    hp.increasMaxValue((str.maxValue * times).toInt());
  }
}

/// A class representing a single stat.
class Stat {
  int currentValue;
  int maxValue;
  int level;

  /// Creates a new Stat with the given current value, max value, and level.
  Stat({
    required this.currentValue,
    required this.maxValue,
    required this.level,
  });

  /// Increases the current value by the given amount.
  void increase(int amount) {
    currentValue = currentValue + amount;
  }

  /// Increases the max value by the given amount.
  void increasMaxValue(int amount) {
    maxValue += amount;
  }

  /// Increases the player's EXP by the given amount.
  /// If the current value exceeds the max value, the player levels up.
  void increasPlayerEXP(int amount) {
    if (currentValue + amount >= maxValue) {
      levelUp();
    } else {
      currentValue = currentValue + amount;
    }
  }

  /// Decreases the current value by the given amount, ensuring it does not go below zero.
  void decrease(int amount) {
    currentValue = (currentValue - amount).clamp(0, currentValue);
  }

  /// Levels up the player, increasing the max value exponentially.
  void levelUp() {
    double expoFaktor = 4;
    level++;
    currentValue = currentValue % maxValue;
    maxValue = (maxValue * expoFaktor).toInt();
    expoFaktor *= 1.2;
    PlayerStats.levelupIncreaseByFactor(2);
  }

  /// Increases the max value by the given amount and sets the current value to the new max value.
  void increaseMaxValue(int amount) {
    maxValue += amount;
    currentValue = maxValue;
  }
}
