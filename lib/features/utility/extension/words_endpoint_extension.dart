import '../../../core/utility/endpoint_builder.dart';

extension WordsEndpointExtension on EndpointBuilder {
  /// Words endpoint için özelleştirilmiş builder
  static EndpointBuilder words() {
    return EndpointBuilder(collection: 'items/words');
  }

  /// Kategori filtresi ekler
  EndpointBuilder filterByCategory(String categoryId) {
    return addNestedFilter(
      ['categories', 'categories_id'],
      'id',
      categoryId,
    );
  }

  /// Durum filtresi ekler
  EndpointBuilder filterByStatus(String status) {
    return addFilter('status', status);
  }

  /// Zorluk filtresi ekler
  EndpointBuilder filterByDifficulty(String difficulty) {
    return addFilter('difficulty', difficulty);
  }

  /// Standart word alanlarını ekler
  EndpointBuilder withWordFields() {
    return addFields([
      // 'id',
      'word',
      // 'difficulty',
      'forbidden',
      // 'categories.categories_id.id',
      // 'categories.categories_id.name',
    ]);
  }
}
