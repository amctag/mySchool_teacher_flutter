import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:my_school_teacher/core/persistence/app_preferences.dart';
import 'package:my_school_teacher/services/network/teacher_api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late TeacherApiClient client;
  late int getCount;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    getCount = 0;
    client = TeacherApiClient(
      preferences: AppPreferences(await SharedPreferences.getInstance()),
      baseUrl: 'https://example.test',
      httpClient: MockClient((request) async {
        if (request.method == 'GET') {
          getCount += 1;
        }
        return http.Response(
          jsonEncode({'ok': true, 'count': getCount}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
  });

  test('reuses GET responses until the cache is cleared', () async {
    final first = await client.get('/teacher/me/agendas', auth: false);
    final second = await client.get('/teacher/me/agendas', auth: false);

    expect(getCount, 1);
    expect(second['ok'], first['ok']);

    client.clearGetCache();
    await client.get('/teacher/me/agendas', auth: false);

    expect(getCount, 2);
  });

  test('mutating requests drop cached GET responses', () async {
    await client.get('/teacher/me/agendas', auth: false);
    expect(getCount, 1);

    await client.post('/teacher/me/agendas', body: {'title': 'New'});
    await client.get('/teacher/me/agendas', auth: false);

    expect(getCount, 2);
  });
}
