import '../../../core/utility/http_service.dart';
import '../../../features/model/api_list_response_model.dart';
import '../mıodel/category_model.dart';

abstract class ISelectCategoryService {
  final HttpService http;

  ISelectCategoryService(this.http);

//baseUrl'nin sonuna kolaylıkla ekleme yapmak için kullanılırz
  final String categoriesPath = ISelectCategoryServicePath.categories.rawValue;

//requesti atacak olan fonksiyon tanımlanır
  Future<ApiListResponse<CategoryModel>> getCategories();
}

enum ISelectCategoryServicePath { categories }

//BaseUrl'nin sonuna Settings sayfasının requesti için gelecek olan eklenti için oluşturuldu
extension ISelectCategoryServicePathExtension on ISelectCategoryServicePath {
  String get rawValue {
    switch (this) {
      case ISelectCategoryServicePath.categories:
        return "/items/categories?filter[status][_eq]=published&fields=id,name,color,cover";
    }
  }
}
