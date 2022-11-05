class Category {
  late int id;
  late String name;
  late String description;

  CategoryMap() {
    var mapping = Map<String, dynamic>();

    mapping['name'] = name;
    mapping['description'] = description;
    mapping['id'] = id;

    return mapping;
  }
}
