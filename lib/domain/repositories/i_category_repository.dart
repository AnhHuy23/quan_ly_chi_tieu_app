import '../entities/category_entity.dart';

/// Abstract Category Repository Interface
///
/// Định nghĩa contract cho category repository.
/// Data layer sẽ implement interface này.
abstract class ICategoryRepository {
  /// Lấy tất cả danh mục
  Future<List<CategoryEntity>> getAll();

  /// Lấy danh mục theo loại (thu/chi)
  Future<List<CategoryEntity>> getByType({required bool isExpense});

  /// Lấy danh mục theo ID
  Future<CategoryEntity?> getById(String id);

  /// Thêm danh mục mới
  Future<CategoryEntity> add({
    required String name,
    required int iconCode,
    required int colorValue,
    required bool isExpense,
  });

  /// Cập nhật danh mục
  Future<void> update(CategoryEntity category);

  /// Xóa danh mục
  Future<void> delete(String id);
}
