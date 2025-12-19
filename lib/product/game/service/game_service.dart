import '../../../features/model/api_list_response_model.dart';
import '../../../features/utility/extension/words_endpoint_extension.dart';
import '../model/tabu_model.dart';
import 'IGameService.dart';

class GameService extends IGameService {
  GameService(super.http);

  @override
  Future<ApiListResponse<TabuModel>> getWordList(
      int page, String categoryId) async {
    final wordUrl = WordsEndpointExtension.words()
        .filterByStatus('published')
        .filterByCategory(categoryId)
        .withWordFields()
        .setLimit(10)
        .setPage(page)
        .build();
    return http.requestList<TabuModel>(
      requestFunction: () => http.get(wordUrl),
      fromJson: (json) => TabuModel.fromJson(json),
    );
  }
}
