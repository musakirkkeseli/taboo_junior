import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabumium/features/utility/const/constant_string.dart';

import '../../../core/exception/network_exception.dart';
import '../../../core/utility/logger_service.dart';
import '../../../features/utility/enum/enum_general_state.dart';
import '../mıodel/category_model.dart';
import '../service/ISelectCategoryService.dart';

part 'select_category_state.dart';

class SelectCategoryCubit extends Cubit<SelectCategoryState> {
  final ISelectCategoryService service;
  SelectCategoryCubit(this.service) : super(const SelectCategoryState());

  void fetchCategories() async {
    try {
      final data = await service.getCategories();

      if (data.data != null) {
        List<CategoryModel> categoryList = data.data ?? [];
        emit(state.copyWith(
          status: EnumGeneralStateStatus.completed,
          categoryList: categoryList,
        ));
      } else {
        emit(state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: ConstantString.unexpectedError));
      }
    } on NetworkException catch (e) {
      MyLog.debug("cubit NetworkException $e");
      emit(state.copyWith(
          status: EnumGeneralStateStatus.failure, message: e.message));
    } catch (e) {
      emit(state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: ConstantString.unexpectedError));
    }
  }
}
