import 'package:tabumium/features/utility/const/constant_string.dart';

enum Categories {
  entertainment,
  fashion,
  music,
  cinema,
  football,
  history,
  science,
  literature;

  String get titleValue {
    switch (this) {
      case Categories.entertainment:
        return ConstantString.entertainment;
      case Categories.fashion:
        return ConstantString.fashion;
      case Categories.music:
        return ConstantString.music;
      case Categories.cinema:
        return ConstantString.cinema;
      case Categories.football:
        return ConstantString.football;
      case Categories.history:
        return ConstantString.history;
      case Categories.science:
        return ConstantString.science;
      case Categories.literature:
        return ConstantString.literature;
    }
  }

  String get imageValue {
    switch (this) {
      case Categories.entertainment:
        return ConstantString.entertainmentImage2;
      case Categories.fashion:
        return ConstantString.fashionImage;
      case Categories.music:
        return ConstantString.musicImage;
      case Categories.cinema:
        return ConstantString.cinemaImage;
      case Categories.football:
        return ConstantString.footballImage;
      case Categories.history:
        return ConstantString.historyImage;
      case Categories.science:
        return ConstantString.scienceImage;
      case Categories.literature:
        return ConstantString.literatureImage;
    }
  }

  String get dataPath {
    switch (this) {
      case Categories.entertainment:
        return ConstantString.dataEntertainmentWords;
      case Categories.fashion:
        return ConstantString.dataFashionWords;
      case Categories.music:
        return ConstantString.dataMusicWords;
      case Categories.cinema:
        return ConstantString.dataCinemaWords;
      case Categories.football:
        return ConstantString.dataFootballWords;
      case Categories.history:
        return ConstantString.dataHistoryWords;
      case Categories.science:
        return ConstantString.dataScienceWords;
      case Categories.literature:
        return ConstantString.dataLiteratureWords;
    }
  }
}
