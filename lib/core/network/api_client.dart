class ApiClient {
  const ApiClient();

  Future<T> get<T>(String path) {
    throw UnimplementedError(
      'API client belum diimplementasikan untuk endpoint $path',
    );
  }

  Future<T> post<T>(String path, {Map<String, dynamic>? body}) {
    throw UnimplementedError(
      'API client belum diimplementasikan untuk endpoint $path',
    );
  }
}
