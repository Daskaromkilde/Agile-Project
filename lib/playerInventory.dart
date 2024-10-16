enum ItemType {
  weapon,
  armor,
  potion,
  misc,
}

class Item {
  static const String sword = 'Sword';
  static const String healthPotion = 'Health Potion';
  static const String staminaPotion = 'Stamina Potion';
  static const String monsterEye = 'Monster Eye';
  static const String slimeGel = 'Slime Gel';
}

class ItemContainer {
  final String type;
  int quantity;
  final String image;
  final ItemType itemType; // New property for item type

  void use() {
    print('Used $type');
  }

  void remove() {
    PlayerInventory.removeItem(this);
  }

  void increase() {
    quantity++;
  }

  void increaseBy(int amount) {
    quantity += amount;
  }

  void decreaseBy(int amount) {
    quantity -= amount;
  }

  ItemContainer(this.type, this.quantity, this.image,
      this.itemType); // Updated constructor
}

class PlayerInventory {
  static final List<ItemContainer> _items = [];

  // Predefined item containers
  static final ItemContainer healthPotion = ItemContainer(
    Item.healthPotion,
    0, // Initial quantity set to 0
    'assets/images/items/Potion/Red Potion 2.png',
    ItemType.potion,
  );

  static final ItemContainer staminaPotion = ItemContainer(
    Item.staminaPotion,
    0, // Initial quantity set to 0
    'assets/images/items/Potion/Green Potion 2.png',
    ItemType.potion,
  );

  static final ItemContainer monsterEye = ItemContainer(
    Item.monsterEye,
    0, // Initial quantity set to 0
    'assets/images/items/Monster Part/Monster Eye.png',
    ItemType.misc,
  );

  static final ItemContainer slimeGel = ItemContainer(
    Item.slimeGel,
    0, // Initial quantity set to 0
    'assets/images/items/Monster Part/Slime Gel.png',
    ItemType.misc,
  );

  static void addItem(ItemContainer item, int quantity) {
    // Check if the item already exists in the inventory
    for (var existingItem in _items) {
      if (existingItem.type == item.type) {
        // If it exists, increase the quantity
        existingItem.increaseBy(quantity);
        return;
      }
    }
    // If it doesn't exist, add it to the inventory with the specified quantity
    _items.add(ItemContainer(item.type, quantity, item.image, item.itemType));
  }

  static void removeItem(ItemContainer item) {
    _items.remove(item);
  }

  static List<ItemContainer> get items => List.unmodifiable(_items);
}
