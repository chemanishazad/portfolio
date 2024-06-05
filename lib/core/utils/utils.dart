import 'package:url_launcher/url_launcher.dart';

class Utilty {
  static Future<void> openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  static Future<void> openMail() => openUrl("mailto:chemanishazad@gmail.com");

  static Future<void> openMyLocation() =>
      openUrl("https://maps.app.goo.gl/nVbQs96SKJrhiiGm9");
  static Future<void> openMyPhoneNo() => openUrl("tel:+91-8778145196");
  static Future<void> openWhatsapp() => openUrl("https://wa.me/8778145196");
}
