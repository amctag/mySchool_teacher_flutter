class ApiConfig {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://amctag-my-school.38f0fz.easypanel.host',
  );

  static const apiPrefix = '/api/v1';
}
