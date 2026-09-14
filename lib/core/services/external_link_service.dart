import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

typedef ExternalUriLauncher = Future<bool> Function(Uri uri);

class ExternalLinkService {
  const ExternalLinkService({ExternalUriLauncher launcher = _launchExternally})
    : _launcher = launcher;

  final ExternalUriLauncher _launcher;

  Future<bool> call(String number) {
    final normalized = _normalizedPhone(number, keepLeadingPlus: true);
    if (normalized.isEmpty) {
      return Future.value(false);
    }
    return _open(Uri(scheme: 'tel', path: normalized));
  }

  Future<bool> whatsapp(String mobile) {
    final normalized = _normalizedPhone(mobile);
    if (normalized.isEmpty) {
      return Future.value(false);
    }
    return _open(Uri.https('wa.me', '/$normalized'));
  }

  Future<bool> directions(String address) {
    final normalized = address.trim();
    if (normalized.isEmpty) {
      return Future.value(false);
    }
    return _open(
      Uri.https('www.google.com', '/maps/search/', {
        'api': '1',
        'query': normalized,
      }),
    );
  }

  Future<bool> website(String website) {
    final websiteValue = website.trim();
    final secureValue = websiteValue.startsWith('http://')
        ? 'https://${websiteValue.substring(7)}'
        : websiteValue.contains('://')
        ? websiteValue
        : 'https://$websiteValue';
    final uri = Uri.tryParse(secureValue);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      return Future.value(false);
    }
    return _open(uri);
  }

  Future<bool> email(String email) {
    final normalized = email.trim();
    if (normalized.isEmpty) {
      return Future.value(false);
    }
    return _open(Uri(scheme: 'mailto', path: normalized));
  }

  Future<bool> _open(Uri uri) async {
    try {
      return await _launcher(uri);
    } on PlatformException {
      return false;
    }
  }

  static String _normalizedPhone(
    String phoneNumber, {
    bool keepLeadingPlus = false,
  }) {
    final trimmed = phoneNumber.trim();
    final digits = trimmed.replaceAll(RegExp(r'\D'), '');
    if (keepLeadingPlus && trimmed.startsWith('+')) {
      return '+$digits';
    }
    return digits;
  }

  static Future<bool> _launchExternally(Uri uri) {
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
