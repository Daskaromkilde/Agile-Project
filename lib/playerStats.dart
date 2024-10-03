class PlayerStats {
  static Stat exp = Stat(currentValue: 0, maxValue: 10000, level: 0);
  static Stat str = Stat(currentValue: 0, maxValue: 100, level: 0);
  static Stat intell = Stat(currentValue: 0, maxValue: 100, level: 0);
  static Stat hp = Stat(currentValue: 0, maxValue: 100, level: 0);
  static Stat sta = Stat(currentValue: 0, maxValue: 100, level: 0);

  static int level = 0;

  // Getters for EXP
  static Stat get getEXP => exp;

  // Getters for STR
  static Stat get getSTR => str;

  // Getters for INT
  static Stat get getINT => intell;

  // Getters for HP
  static Stat get getHP => hp;

  // Getters for STA
  static Stat get getSTA => sta;

  // Function to increase EXP
  static void increaseEXP(int amount) {
    exp.increasPlayerEXP(amount);
  }

  // Function to increase STR
  static void increaseSTR(int amount) {
    str.increase(amount);
  }

  static void increaseSTA(int amount) {
    sta.increase(amount);
  }

  // Function to increase INT
  static void increaseINT(int amount) {
    intell.increase(amount);
  }

  // Function to increase HP
  static void increaseHP(int amount) {
    hp.increase(amount);
  }

  // Function to decrease EXP
  static void decreaseEXP(int amount) {
    exp.decrease(amount);
  }

  // Function to decrease STR
  static void decreaseSTR(int amount) {
    str.decrease(amount);
  }

  // Function to decrease STA
  static void decreaseSTA(int amount) {
    sta.decrease(amount);
  }

  // Function to decrease INT
  static void decreaseINT(int amount) {
    intell.decrease(amount);
  }

  // Function to decrease HP
  static void decreaseHP(int amount) {
    hp.decrease(amount);
  }

  // Function to decrease all stats by a certain amount
  static void decreaseAllStats(int amount) {
    exp.decrease(amount);
    str.decrease(amount);
    intell.decrease(amount);
    hp.decrease(amount);
    sta.decrease(amount);
  }

  static void levelupIncrease(int amount) {
    str.increasMaxValue(amount);
    intell.increasMaxValue(amount);
    hp.increasMaxValue(amount);
  }

  static void levelupIncreaseByFactor(double times) {
    str.increasMaxValue((str.maxValue * times) as int);
    intell.increasMaxValue((str.maxValue * times) as int);
    hp.increasMaxValue((str.maxValue * times) as int);
  }
}

class Stat {
  int currentValue;
  int maxValue;
  int level;

  Stat(
      {required this.currentValue,
      required this.maxValue,
      required this.level});

  void increase(int amount) {
    currentValue = currentValue + amount;
  }

  void increasMaxValue(int amount) {
    maxValue += amount;
  }

  void increasPlayerEXP(int amount) {
    if (currentValue + amount >= maxValue) {
      levelUp();
    } else {
      currentValue = currentValue + amount;
    }
  }

  void decrease(int amount) {
    currentValue = (currentValue - amount).clamp(0, currentValue);
  }

  void levelUp() {
    double expoFaktor = 6;
    level++;
    currentValue = currentValue % maxValue;
    maxValue = (maxValue * expoFaktor).toInt();
    expoFaktor *= 1.4;
    PlayerStats.levelupIncreaseByFactor(2);
  }

  void increaseMaxValue(int amount) {
    maxValue += amount;
    currentValue = maxValue;
  }
}
