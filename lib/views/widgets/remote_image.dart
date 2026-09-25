import 'package:flutter/material.dart';

/// Network image that still shows on Flutter web when the file host
/// (st79068.ispot.cc) does not send Access-Control-Allow-Origin.
///
/// On web, [WebHtmlElementStrategy.prefer] draws the photo in an HTML
/// `<img>`, which the browser can display without CORS. Mobile keeps the
/// normal byte fetch.
class RemoteImage extends StatelessWidget {
  const RemoteImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorBuilder,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: errorBuilder,
      webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
    );
  }
}
