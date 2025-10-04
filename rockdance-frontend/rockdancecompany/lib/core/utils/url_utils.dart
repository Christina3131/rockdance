// lib/core/utils/url_utils.dart
import 'package:url_launcher/url_launcher.dart';

Future<void> openSocial({required String webUrl, String? nativeUrl}) async {
  // Try native app first
  if (nativeUrl != null) {
    final n = Uri.parse(nativeUrl);
    if (await canLaunchUrl(n)) {
      await launchUrl(n, mode: LaunchMode.externalApplication);
      return;
    }
  }
  // Fallback to web
  final w = Uri.parse(webUrl);
  if (!await launchUrl(w, mode: LaunchMode.externalApplication)) {
    await launchUrl(w, mode: LaunchMode.inAppBrowserView);
  }
}
