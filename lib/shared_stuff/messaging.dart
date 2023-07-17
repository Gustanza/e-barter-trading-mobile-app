import 'dart:convert';
import 'package:http/http.dart';

class Messaging {
  static final Client client = Client();

  static const String serverKey =
      'AAAAx1LPf3g:APA91bGMjlmeOFA45VDGDCznYZJCh2mLQwUOOw2zTiJh2NulGQg5vg8cS24PcGaG6PWRSDfmfrpjRZ0OlOgIF_eqYx5rtaq6mYUNiGLkL3y6Y6T9RsQ9aSIlVQ-lYJ9F9tZb_RIu08H4';

  static Future<Response> sendTo(
          {required String title,
          required String body,
          required String kwenda}) =>
      client.post(
        Uri.https('fcm.googleapis.com', 'fcm/send'),
        body: json.encode({
          'notification': {'body': body, 'title': title},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': kwenda,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}
