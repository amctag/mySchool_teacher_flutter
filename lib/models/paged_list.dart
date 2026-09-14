class PagedList<T> {
  const PagedList({
    required this.items,
    this.page = 1,
    this.limit = 20,
    this.total = 0,
    this.totalPages = 0,
  });

  factory PagedList.fromMeta({
    required List<T> items,
    Map<String, dynamic>? pagination,
    int fallbackPage = 1,
    int fallbackLimit = 20,
  }) {
    final page = (pagination?['page'] as num?)?.toInt() ?? fallbackPage;
    final limit = (pagination?['limit'] as num?)?.toInt() ?? fallbackLimit;
    final total = (pagination?['total'] as num?)?.toInt() ?? items.length;
    final totalPages =
        (pagination?['totalPages'] as num?)?.toInt() ??
        (total == 0 ? 0 : (total / limit).ceil());
    return PagedList(
      items: items,
      page: page,
      limit: limit,
      total: total,
      totalPages: totalPages,
    );
  }

  final List<T> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  bool get hasMore => totalPages > 0 && page < totalPages;
}
