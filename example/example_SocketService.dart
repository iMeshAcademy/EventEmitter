import 'dart:async';
import 'package:eventify/eventify.dart';

class SocketService {
  static SocketService _instance = null;

  factory SocketService() => _instance ?? SocketService._internal();

  SocketService._internal() {
    _instance = this;
    doSomeOperation();
  }
  static EventEmitter emitter = EventEmitter();

  void timerCallback(Timer timer) {
    emitter.emit('EVENT_NEW_NOTIFICATION_1', this, 'test data');
  }

  void doSomeOperation() {
    Timer.periodic(Duration(seconds: 1), timerCallback);
  }
}
