import 'package:flutter/material.dart';

/// Category Entity - Pure Dart class không phụ thuộc Hive
///
/// Đây là domain entity thuần túy, dùng trong business logic
/// và có thể được convert từ/tới CategoryModel (data layer)
class CategoryEntity {
  final String id;
  final String name;
  final int iconCode;
  final int colorValue;
  final bool isExpense;
  final bool isCustom;
  final DateTime createdAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.iconCode,
    required this.colorValue,
    required this.isExpense,
    this.isCustom = false,
    required this.createdAt,
  });

  /// Get IconData từ iconCode
  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');

  /// Get Color từ colorValue
  Color get color => Color(colorValue);

  /// Copy with
  CategoryEntity copyWith({
    String? id,
    String? name,
    int? iconCode,
    int? colorValue,
    bool? isExpense,
    bool? isCustom,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCode: iconCode ?? this.iconCode,
      colorValue: colorValue ?? this.colorValue,
      isExpense: isExpense ?? this.isExpense,
      isCustom: isCustom ?? this.isCustom,
      createdAt: createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'CategoryEntity(id: $id, name: $name, isExpense: $isExpense)';
}
