import 'example_SocketService.dart';

class SecondClass {
  SecondClass() {
    SocketService.emitter.on('EVENT_NEW_NOTIFICATION_1', this, (ev, context) {
      print("Received event ${ev.eventName} - ${ev.eventData}");
    });
  }
}
