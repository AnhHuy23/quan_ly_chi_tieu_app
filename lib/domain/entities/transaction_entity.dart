/// Transaction Entity - Pure Dart class không phụ thuộc Hive/Flutter
///
/// Đây là domain entity thuần túy, dùng trong business logic
/// và có thể được convert từ/tới TransactionModel (data layer)
class TransactionEntity {
  final String id;
  final double amount;
  final String categoryId;
  final String note;
  final DateTime date;
  final bool isExpense;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.categoryId,
    this.note = '',
    required this.date,
    required this.isExpense,
    required this.createdAt,
    this.updatedAt,
  });

  /// Copy with
  TransactionEntity copyWith({
    String? id,
    double? amount,
    String? categoryId,
    String? note,
    DateTime? date,
    bool? isExpense,
    DateTime? updatedAt,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      date: date ?? this.date,
      isExpense: isExpense ?? this.isExpense,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'TransactionEntity(id: $id, amount: $amount, categoryId: $categoryId, isExpense: $isExpense)';
}
