class Item {
  final int? id;
  final String? name;
  final int? quantity;

  Item({this.id, this.name, this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': quantity,
    };
  }

  static Item fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      quantity: map['age'],
    );
  }
}