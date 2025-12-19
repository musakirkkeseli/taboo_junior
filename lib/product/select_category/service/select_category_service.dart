import '../../../features/model/api_list_response_model.dart';
import '../mıodel/category_model.dart';
import 'ISelectCategoryService.dart';

class SelectCategoryService extends ISelectCategoryService {
  SelectCategoryService(super.http);

  @override
  Future<ApiListResponse<CategoryModel>> getCategories() async {
    return http.requestList<CategoryModel>(
      requestFunction: () => http.get(categoriesPath),
      fromJson: (json) => CategoryModel.fromJson(json),
    );
  }
}
