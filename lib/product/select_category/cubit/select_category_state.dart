part of 'select_category_cubit.dart';

class SelectCategoryState {
  final EnumGeneralStateStatus status;
  final List<CategoryModel> categoryList;
  final String? message;

  const SelectCategoryState({
    this.status = EnumGeneralStateStatus.loading,
    this.categoryList = const [],
    this.message,
  });

  SelectCategoryState copyWith({
    EnumGeneralStateStatus? status,
    List<CategoryModel>? categoryList,
    String? message,
  }) {
    return SelectCategoryState(
      status: status ?? this.status,
      categoryList: categoryList ?? this.categoryList,
      message: message ?? this.message,
    );
  }
}
