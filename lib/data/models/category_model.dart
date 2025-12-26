import 'package:hive/hive.dart';

/// Category Model cho Hive
@HiveType(typeId: 0)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int iconCode;

  @HiveField(3)
  final int colorValue;

  @HiveField(4)
  final bool isExpense;

  @HiveField(5)
  final bool isCustom;

  @HiveField(6)
  final DateTime createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconCode,
    required this.colorValue,
    required this.isExpense,
    this.isCustom = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Tạo từ Map (default categories)
  factory CategoryModel.fromMap(
    Map<String, dynamic> map, {
    required bool isExpense,
  }) {
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      iconCode: map['icon'] as int,
      colorValue: map['color'] as int,
      isExpense: isExpense,
      isCustom: false,
    );
  }

  /// Copy with
  CategoryModel copyWith({
    String? id,
    String? name,
    int? iconCode,
    int? colorValue,
    bool? isExpense,
    bool? isCustom,
  }) {
    return CategoryModel(
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
  String toString() {
    return 'CategoryModel(id: $id, name: $name, isExpense: $isExpense)';
  }
}

/// Manual Hive Adapter for CategoryModel
class CategoryModelAdapter extends TypeAdapter<CategoryModel> {
  @override
  final int typeId = 0;

  @override
  CategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryModel(
      id: fields[0] as String,
      name: fields[1] as String,
      iconCode: fields[2] as int,
      colorValue: fields[3] as int,
      isExpense: fields[4] as bool,
      isCustom: fields[5] as bool? ?? false,
      createdAt: fields[6] as DateTime? ?? DateTime.now(),
    );
  }

  @override
  void write(BinaryWriter writer, CategoryModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.iconCode)
      ..writeByte(3)
      ..write(obj.colorValue)
      ..writeByte(4)
      ..write(obj.isExpense)
      ..writeByte(5)
      ..write(obj.isCustom)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
