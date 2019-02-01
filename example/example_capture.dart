import 'dart:async';

import 'package:eventify/eventify.dart';

void main() {
  int count = 0;
  ExtendedEmitter emitter = new ExtendedEmitter();

  EventCallback cb1 = (ev, context) {
    count++;
    if (count % 2 == 1) {
      ev.handled = true;
    }
  };

  EventCallback cb2 = (ev, context) {
    print("Received event - ${ev.eventName}");
    count++;

    if (count >= 10) {
      (ev.eventData as Timer).cancel();
    }
  };

  emitter.on("timer", null, cb1);
  emitter.on("timer", null, cb2);

  emitter.doSomeOperation();
}

class ExtendedEmitter extends EventEmitter {
  void timerCallback(Timer timer) {
    emit("timer", this, timer);
  }

  void doSomeOperation() {
    Timer.periodic(Duration(seconds: 1), timerCallback);
  }
}
