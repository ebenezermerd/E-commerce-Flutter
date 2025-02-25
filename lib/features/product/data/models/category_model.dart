class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String group;
  final String description;
  final String? coverImg;
  final bool isActive;
  final List<CategoryModel> children;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.group,
    required this.description,
    this.coverImg,
    required this.isActive,
    required this.children,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      group: json['group'],
      description: json['description'],
      coverImg: json['coverImg'],
      isActive: json['isActive'],
      children: (json['children'] as List)
          .map((child) => CategoryModel.fromJson(child))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'group': group,
      'description': description,
      'coverImg': coverImg,
      'isActive': isActive,
      'children': children.map((child) => child.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
