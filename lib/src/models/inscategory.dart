class InsCategory {
  late String name;
  late String description;

  InsCategoryMap() {
    var mapping = Map<String, dynamic>();

    mapping['name'] = name;
    mapping['description'] = description;

    return mapping;
  }
}
