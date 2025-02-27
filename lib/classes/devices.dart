class Floor {
  final int id;
  final String name;

  Floor({required this.id, required this.name});

  factory Floor.fromJson(Map<String, dynamic> json) {
    return Floor(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Building {
  final int id;
  final String name;
  final List<Floor> floors;

  Building({required this.id, required this.name, required this.floors});

  factory Building.fromJson(Map<String, dynamic> json) {
    List<Floor> floors = (json['floors'] as List<dynamic>)
        .map((floorJson) => Floor.fromJson(floorJson))
        .toList();
    return Building(
      id: json['id'],
      name: json['name'],
      floors: floors,
    );
  }
}
