import '../../../core/utility/http_service.dart';
import '../../../features/model/api_list_response_model.dart';
import '../model/tabu_model.dart';

abstract class IGameService {
  final HttpService http;

  IGameService(this.http);

  Future<ApiListResponse<TabuModel>> getWordList(
      int page, String categoryId, String difficulty);
}
