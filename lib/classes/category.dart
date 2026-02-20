class Category {
  final int mainCategoryId;
  final String mainCategoryName;
  final String mainCategoryCode;
  final int subCategoryId;
  final String subCategoryName;
  final String subCategoryCode;

  Category({
    required this.mainCategoryId,
    required this.mainCategoryName,
    required this.mainCategoryCode,
    required this.subCategoryId,
    required this.subCategoryName,
    required this.subCategoryCode,
  });

  // Factory method to create an instance from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      mainCategoryId: json['main_category_id'],
      mainCategoryName: json['main_category_name'],
      mainCategoryCode: json['main_category_code'],
      subCategoryId: json['sub_category_id'],
      subCategoryName: json['sub_category_name'],
      subCategoryCode: json['sub_category_code'],
    );
  }

  // Optional method to convert an instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'main_category_id': mainCategoryId,
      'main_category_name': mainCategoryName,
      'main_category_code': mainCategoryCode,
      'sub_category_id': subCategoryId,
      'sub_category_name': subCategoryName,
      'sub_category_code': subCategoryCode,
    };
  }

  // Factory method to create an empty category
  factory Category.empty() {
    return Category(
      mainCategoryId: 0,  // You can use 0 or a meaningful default value
      mainCategoryName: 'Unknown',
      subCategoryId: 0,
      subCategoryName: 'Unknown', mainCategoryCode: '0', subCategoryCode: '0',
    );
  }
}


