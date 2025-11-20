import 'package:tabumium/features/utility/const/constant_string.dart';

enum Categories {
  entertainment,
  fashion,
  music,
  cinema,
  football,
  history,
  science,
  literature
}

extension CategoriesNameExtension on Categories {
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
}

extension CategoriesImageExtension on Categories {
  String get imageValue {
    switch (this) {
      case Categories.entertainment:
        return ConstantString.entertainmentImage;
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
}
