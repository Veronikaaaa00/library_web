class AuthorQuery {
  final String search;
  final String? country;
  final int? birthYearFrom;
  final int? birthYearTo;
  final String sortField;
  final bool sortAscending;
  final int page;
  final int size;
  final bool includeDeleted;

  const AuthorQuery({
    this.search = '',
    this.country,
    this.birthYearFrom,
    this.birthYearTo,
    this.sortField = 'lastName',
    this.sortAscending = true,
    this.page = 1,
    this.size = 10,
    this.includeDeleted = false,
  });

  AuthorQuery copyWith({
    String? search,
    Object? country = _unset,
    Object? birthYearFrom = _unset,
    Object? birthYearTo = _unset,
    String? sortField,
    bool? sortAscending,
    int? page,
    int? size,
    bool? includeDeleted,
  }) {
    return AuthorQuery(
      search: search ?? this.search,
      country: identical(country, _unset) ? this.country : country as String?,
      birthYearFrom: identical(birthYearFrom, _unset)
          ? this.birthYearFrom
          : birthYearFrom as int?,
      birthYearTo: identical(birthYearTo, _unset)
          ? this.birthYearTo
          : birthYearTo as int?,
      sortField: sortField ?? this.sortField,
      sortAscending: sortAscending ?? this.sortAscending,
      page: page ?? 1,
      size: size ?? this.size,
      includeDeleted: includeDeleted ?? this.includeDeleted,
    );
  }

  static const _unset = Object();

  factory AuthorQuery.fromUri(Uri uri) {
    final q = uri.queryParameters;
    final sortRaw = q['sort'] ?? 'lastName,asc';
    final sortParts = sortRaw.split(',');
    final field = sortParts.isNotEmpty && sortParts.first.isNotEmpty
        ? sortParts.first
        : 'lastName';
    final ascending = sortParts.length < 2 || sortParts[1] != 'desc';
    return AuthorQuery(
      search: q['search'] ?? '',
      country: (q['country'] ?? '').isEmpty ? null : q['country'],
      birthYearFrom: int.tryParse(q['birthYearFrom'] ?? ''),
      birthYearTo: int.tryParse(q['birthYearTo'] ?? ''),
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
    if (country != null && country!.trim().isNotEmpty) {
      map['country'] = country!.trim();
    }
    if (birthYearFrom != null) {
      map['birthYearFrom'] = '$birthYearFrom';
    }
    if (birthYearTo != null) {
      map['birthYearTo'] = '$birthYearTo';
    }
    if (includeDeleted) {
      map['includeDeleted'] = 'true';
    }
    return map;
  }

  String toLocation() {
    return Uri(
      path: '/authors',
      queryParameters: toQueryParameters(),
    ).toString();
  }

  @override
  bool operator ==(Object other) {
    return other is AuthorQuery &&
        other.search == search &&
        other.country == country &&
        other.birthYearFrom == birthYearFrom &&
        other.birthYearTo == birthYearTo &&
        other.sortField == sortField &&
        other.sortAscending == sortAscending &&
        other.page == page &&
        other.size == size &&
        other.includeDeleted == includeDeleted;
  }

  @override
  int get hashCode => Object.hash(
    search,
    country,
    birthYearFrom,
    birthYearTo,
    sortField,
    sortAscending,
    page,
    size,
    includeDeleted,
  );
}
