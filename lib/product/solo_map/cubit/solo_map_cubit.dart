import 'package:tabumium/core/utility/logger_service.dart';

import '../../../core/utility/base_cubit.dart';
import '../../../features/utility/cache_manager.dart';
import '../../../features/utility/enum/enum_general_state.dart';
import '../model/solo_game_model.dart';

part 'solo_map_state.dart';

class SoloMapCubit extends BaseCubit<SoloMapState> {
  SoloMapCubit() : super(SoloMapState());
  final MyLog _log = MyLog("SoloMapCubit");

  Future<void> fetchSoloMapData() async {
    final level = CacheManager.db.getSoloLevel();

    Map<String, dynamic> params = {
      "data": [
        {
          "id": 20,
          "word": "word10",
          "clues": ["clue1", "clue2", "clue3", "clue4", "clue5"],
        },
        {
          "id": 19,
          "word": "word9",
          "clues": ["clue1", "clue2", "clue3", "clue4", "clue5"],
        },
        {
          "id": 18,
          "word": "word8",
          "clues": ["clue1", "clue2", "clue3", "clue4", "clue5"],
        },
        {
          "id": 17,
          "word": "word7",
          "clues": ["clue1", "clue2", "clue3", "clue4", "clue5"],
        },
        {
          "id": 16,
          "word": "word6",
          "clues": ["clue1", "clue2", "clue3", "clue4", "clue5"],
        },
        {
          "id": 15,
          "word": "word5",
          "clues": ["clue1", "clue2", "clue3", "clue4", "clue5"],
        },
        {
          "id": 14,
          "word": "word4",
          "clues": ["clue1", "clue2", "clue3", "clue4", "clue5"],
        },
        {
          "id": 13,
          "word": "word3",
          "clues": ["clue1", "clue2", "clue3", "clue4", "clue5"],
        },
        {
          "id": 12,
          "word": "word2",
          "clues": ["clue1", "clue2", "clue3", "clue4", "clue5"],
        },
        {
          "id": 11,
          "word": "word1",
          "clues": ["clue1", "clue2", "clue3", "clue4", "clue5"],
        },
        {
          "id": 10,
          "word": "word10",
          "clues": ["clue1", "clue2", "clue3", "clue4", "clue5"],
        },
        {
          "id": 9,
          "word": "word9",
          "clues": ["clue1", "clue2", "clue3", "clue4", "clue5"],
        },
        {
          "id": 8,
          "word": "word8",
          "clues": ["clue1", "clue2", "clue3", "clue4", "clue5"],
        },
        {
          "id": 7,
          "word": "word7",
          "clues": ["clue1", "clue2", "clue3", "clue4", "clue5"],
        },
        {
          "id": 6,
          "word": "word6",
          "clues": ["clue1", "clue2", "clue3", "clue4", "clue5"],
        },
        {
          "id": 5,
          "word": "word5",
          "clues": ["clue1", "clue2", "clue3", "clue4", "clue5"],
        },
        {
          "id": 4,
          "word": "word4",
          "clues": ["clue1", "clue2", "clue3", "clue4", "clue5"],
        },
        {
          "id": 3,
          "word": "word3",
          "clues": ["clue1", "clue2", "clue3", "clue4", "clue5"],
        },
        {
          "id": 2,
          "word": "word2",
          "clues": ["clue1", "clue2", "clue3", "clue4", "clue5"],
        },
        {
          "id": 1,
          "word": "word1",
          "clues": ["clue1", "clue2", "clue3", "clue4", "clue5"],
        },
      ]
    };
    SoloGameModel soloGameModel = SoloGameModel.fromJson(params);
    SoloGame soloGame = (soloGameModel.data ?? []).firstWhere((element) {
      _log.d("element.id: ${element.id} *** level-1: $level");
      return element.id == level;
    });
    await Future.delayed(Duration(seconds: 2));
    safeEmit(state.copyWith(
        status: EnumGeneralStateStatus.completed,
        soloGameList: soloGameModel.data ?? [],
        soloGame: soloGame));
  }

  levelUp() {
    final currentLevel = (state.soloGame ?? SoloGame(id: 1)).id ?? 1;
    CacheManager.db.setSoloLevel(currentLevel + 1);
    state.soloGameList?.forEach((element) {
      if (element.id == currentLevel + 1) {
        safeEmit(state.copyWith(soloGame: element));
        return;
      }
    });
  }
}
