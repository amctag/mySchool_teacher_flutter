import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_school_teacher/services/network/api_config.dart';
import 'package:my_school_teacher/core/persistence/app_preferences.dart';

class TeacherApiException implements Exception {
  const TeacherApiException(
    this.message, {
    this.statusCode,
    this.accountInactive = false,
    this.paymentRequired = false,
  });

  final String message;
  final int? statusCode;
  final bool accountInactive;
  final bool paymentRequired;

  @override
  String toString() => message;
}

class TeacherApiClient {
  TeacherApiClient({
    required AppPreferences preferences,
    http.Client? httpClient,
    String? baseUrl,
  }) : _preferences = preferences,
       _http = httpClient ?? http.Client(),
       _baseUrl = (baseUrl ?? ApiConfig.baseUrl).replaceAll(RegExp(r'/$'), '');

  final AppPreferences _preferences;
  final http.Client _http;
  final String _baseUrl;
  final Map<String, Map<String, dynamic>> _getCache = {};
  bool _refreshing = false;

  Uri _uri(String path) => Uri.parse('$_baseUrl${ApiConfig.apiPrefix}$path');

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) {
    return _send('POST', path, body: body, auth: auth);
  }

  Future<Map<String, dynamic>> get(
    String path, {
    bool auth = true,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = _getCache[path];
      if (cached != null) {
        return _clone(cached);
      }
    }
    return _send('GET', path, auth: auth);
  }

  void clearGetCache() => _getCache.clear();

  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) {
    return _send('PATCH', path, body: body, auth: auth);
  }

  Future<Map<String, dynamic>> delete(String path, {bool auth = true}) {
    return _send('DELETE', path, auth: auth);
  }

  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required List<int> bytes,
    required String filename,
    String fieldName = 'file',
    Map<String, String> fields = const {},
    bool auth = true,
    bool retrying = false,
  }) async {
    final request = http.MultipartRequest('POST', _uri(path));
    request.headers['Accept'] = 'application/json';
    if (auth) {
      final token = _preferences.accessToken;
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
    }
    request.fields.addAll(fields);
    request.files.add(
      http.MultipartFile.fromBytes(fieldName, bytes, filename: filename),
    );

    final streamed = await _http.send(request);
    final response = await http.Response.fromStream(streamed);

    if (auth && response.statusCode == 401 && !retrying) {
      final refreshed = await _refreshTokens();
      if (refreshed) {
        return postMultipart(
          path,
          bytes: bytes,
          filename: filename,
          fieldName: fieldName,
          fields: fields,
          auth: auth,
          retrying: true,
        );
      }
    }

    return _decode(response);
  }

  Future<void> saveLoginTokens(Map<String, dynamic> data) {
    return _preferences.saveTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
      accessTokenExpiresAt: data['accessTokenExpiresAt'] as String?,
      refreshTokenExpiresAt: data['refreshTokenExpiresAt'] as String?,
    );
  }

  Future<void> clearTokens() {
    clearGetCache();
    return _preferences.clearSession();
  }

  Future<Map<String, dynamic>> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
    bool retrying = false,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (auth) {
      final token = _preferences.accessToken;
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    final uri = _uri(path);
    final encodedBody = body == null ? null : jsonEncode(body);
    final response = await switch (method) {
      'GET' => _http.get(uri, headers: headers),
      'PATCH' => _http.patch(uri, headers: headers, body: encodedBody),
      'DELETE' => _http.delete(uri, headers: headers),
      _ => _http.post(uri, headers: headers, body: encodedBody),
    };

    if (auth && response.statusCode == 401 && !retrying) {
      final refreshed = await _refreshTokens();
      if (refreshed) {
        return _send(
          method,
          path,
          body: body,
          auth: auth,
          retrying: true,
        );
      }
    }

    final decoded = _decode(response);
    if (method == 'GET') {
      _getCache[path] = _clone(decoded);
    } else {
      _getCache.clear();
    }
    return decoded;
  }

  Future<bool> _refreshTokens() async {
    if (_refreshing) {
      return false;
    }

    final refreshToken = _preferences.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    _refreshing = true;
    try {
      final data = await _send(
        'POST',
        '/teacher/refresh',
        body: {'refreshToken': refreshToken},
        retrying: true,
      );
      await saveLoginTokens(data);
      return true;
    } catch (_) {
      return false;
    } finally {
      _refreshing = false;
    }
  }

  Map<String, dynamic> _clone(Map<String, dynamic> value) {
    return jsonDecode(jsonEncode(value)) as Map<String, dynamic>;
  }

  Map<String, dynamic> _decode(http.Response response) {
    final decoded = response.body.isEmpty ? null : jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'data': decoded};
    }

    throw TeacherApiException(
      _messageFrom(decoded) ?? 'Request failed (${response.statusCode}).',
      statusCode: response.statusCode,
    );
  }

  String? _messageFrom(dynamic decoded) {
    if (decoded is Map && decoded['message'] != null) {
      final message = decoded['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
      if (message is List && message.isNotEmpty) {
        return message.first.toString();
      }
    }
    return null;
  }
}
