class BookQuery {
  final String search;
  final int? genreId;
  final int? publisherId;
  final int? yearFrom;
  final int? yearTo;
  final String sortField;
  final bool sortAscending;
  final int page;
  final int size;
  final bool includeDeleted;

  const BookQuery({
    this.search = '',
    this.genreId,
    this.publisherId,
    this.yearFrom,
    this.yearTo,
    this.sortField = 'title',
    this.sortAscending = true,
    this.page = 1,
    this.size = 10,
    this.includeDeleted = false,
  });

  BookQuery copyWith({
    String? search,
    Object? genreId = _unset,
    Object? publisherId = _unset,
    Object? yearFrom = _unset,
    Object? yearTo = _unset,
    String? sortField,
    bool? sortAscending,
    int? page,
    int? size,
    bool? includeDeleted,
  }) {
    return BookQuery(
      search: search ?? this.search,
      genreId: identical(genreId, _unset) ? this.genreId : genreId as int?,
      publisherId: identical(publisherId, _unset)
          ? this.publisherId
          : publisherId as int?,
      yearFrom: identical(yearFrom, _unset) ? this.yearFrom : yearFrom as int?,
      yearTo: identical(yearTo, _unset) ? this.yearTo : yearTo as int?,
      sortField: sortField ?? this.sortField,
      sortAscending: sortAscending ?? this.sortAscending,
      // Любое изменение условий отбора возвращает на первую страницу,
      // если page не передан явно.
      page: page ?? 1,
      size: size ?? this.size,
      includeDeleted: includeDeleted ?? this.includeDeleted,
    );
  }

  static const _unset = Object();

  factory BookQuery.fromUri(Uri uri) {
    final q = uri.queryParameters;
    final sortRaw = q['sort'] ?? 'title,asc';
    final sortParts = sortRaw.split(',');
    final field = sortParts.isNotEmpty && sortParts.first.isNotEmpty
        ? sortParts.first
        : 'title';
    final ascending = sortParts.length < 2 || sortParts[1] != 'desc';
    return BookQuery(
      search: q['search'] ?? '',
      genreId: int.tryParse(q['genreId'] ?? ''),
      publisherId: int.tryParse(q['publisherId'] ?? ''),
      yearFrom: int.tryParse(q['yearFrom'] ?? ''),
      yearTo: int.tryParse(q['yearTo'] ?? ''),
      sortField: field,
      sortAscending: ascending,
      page: int.tryParse(q['page'] ?? '') ?? 1,
      size: int.tryParse(q['size'] ?? '') ?? 10,
      includeDeleted: q['includeDeleted'] == 'true',
    );
  }

  Map<String, String> toQueryParameters() {
    final map = <String, String>{
      'sort': '$sortField,${sortAscending ? 'asc' : 'desc'}',
      'page': '$page',
      'size': '$size',
    };
    if (search.trim().isNotEmpty) {
      map['search'] = search.trim();
    }
    if (genreId != null) {
      map['genreId'] = '$genreId';
    }
    if (publisherId != null) {
      map['publisherId'] = '$publisherId';
    }
    if (yearFrom != null) {
      map['yearFrom'] = '$yearFrom';
    }
    if (yearTo != null) {
      map['yearTo'] = '$yearTo';
    }
    if (includeDeleted) {
      map['includeDeleted'] = 'true';
    }
    return map;
  }

  String toLocation() {
    return Uri(path: '/books', queryParameters: toQueryParameters()).toString();
  }

  @override
  bool operator ==(Object other) {
    return other is BookQuery &&
        other.search == search &&
        other.genreId == genreId &&
        other.publisherId == publisherId &&
        other.yearFrom == yearFrom &&
        other.yearTo == yearTo &&
        other.sortField == sortField &&
        other.sortAscending == sortAscending &&
        other.page == page &&
        other.size == size &&
        other.includeDeleted == includeDeleted;
  }

  @override
  int get hashCode => Object.hash(
    search,
    genreId,
    publisherId,
    yearFrom,
    yearTo,
    sortField,
    sortAscending,
    page,
    size,
    includeDeleted,
  );
}
