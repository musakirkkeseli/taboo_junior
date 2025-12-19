import 'package:tabumium/features/utility/const/constant_string.dart';

class EndpointBuilder {
  final String collection;
  final Map<String, dynamic> _filters = {};
  final List<String> _fields = [];
  int? _limit;
  int? _page;
  final Map<String, dynamic> _additionalParams = {};

  EndpointBuilder({
    required this.collection,
  });

  final String baseUrl = ConstantString.backendUrl;

  /// Basit eşitlik filtresi ekler
  /// Örnek: addFilter('status', 'published') -> filter[status][_eq]=published
  EndpointBuilder addFilter(String field, dynamic value,
      {String operator = '_eq'}) {
    _filters['$field][_$operator'] = value;
    return this;
  }

  /// İç içe geçmiş filtre ekler
  /// Örnek: addNestedFilter(['categories', 'categories_id'], 'id', 'uuid-value')
  EndpointBuilder addNestedFilter(
    List<String> path,
    String field,
    dynamic value, {
    String operator = '_eq',
  }) {
    final filterPath = '${path.join('][')}][$field][_$operator';
    _filters[filterPath] = value;
    return this;
  }

  /// Alan listesi ekler
  /// Örnek: addFields(['id', 'word', 'difficulty'])
  EndpointBuilder addFields(List<String> fields) {
    _fields.addAll(fields);
    return this;
  }

  /// Tek bir alan ekler
  EndpointBuilder addField(String field) {
    _fields.add(field);
    return this;
  }

  /// Limit ayarlar
  EndpointBuilder setLimit(int limit) {
    _limit = limit;
    return this;
  }

  /// Sayfa numarası ayarlar
  EndpointBuilder setPage(int page) {
    _page = page;
    return this;
  }

  /// Özel parametre ekler
  EndpointBuilder addParam(String key, dynamic value) {
    _additionalParams[key] = value;
    return this;
  }

  /// URL'i oluşturur
  String build() {
    final uri = Uri.parse('$baseUrl/$collection');
    final queryParams = <String, String>{};

    // Filtreleri ekle
    _filters.forEach((key, value) {
      queryParams['filter[$key'] = value.toString();
    });

    // Alanları ekle
    if (_fields.isNotEmpty) {
      queryParams['fields'] = _fields.join(',');
    }

    // Limit ekle
    if (_limit != null) {
      queryParams['limit'] = _limit.toString();
    }

    // Sayfa ekle
    if (_page != null) {
      queryParams['page'] = _page.toString();
    }

    // Ek parametreleri ekle
    _additionalParams.forEach((key, value) {
      queryParams[key] = value.toString();
    });

    return uri.replace(queryParameters: queryParams).toString();
  }

  /// Kopyasını oluşturur
  EndpointBuilder copy() {
    final builder = EndpointBuilder(
      collection: collection,
    );
    builder._filters.addAll(_filters);
    builder._fields.addAll(_fields);
    builder._limit = _limit;
    builder._page = _page;
    builder._additionalParams.addAll(_additionalParams);
    return builder;
  }

  /// Tüm parametreleri temizler
  EndpointBuilder clear() {
    _filters.clear();
    _fields.clear();
    _limit = null;
    _page = null;
    _additionalParams.clear();
    return this;
  }
}
