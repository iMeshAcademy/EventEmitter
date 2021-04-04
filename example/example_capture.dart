import 'dart:async';

import 'package:eventify/eventify.dart';

ExtendedEmitter emitter = new ExtendedEmitter();
int events = 0;
void main() {
  // int count = 0;

  // EventCallback cb1 = (ev, context) {
  //   count++;
  //   if (count % 2 == 1) {
  //     ev.handled = true;
  //   }
  // };

  // EventCallback cb2 = (ev, context) {
  //   print("Received event - ${ev.eventName}");
  //   count++;

  //   if (count >= 10) {
  //     (ev.eventData as Timer).cancel();
  //   }
  // };

  // emitter.on("timer", null, cb1);
  // emitter.on("timer", null, cb2);

  // emitter.doSomeOperation();

  List<TestModel> models = createAMillionRecords();

  print("Emitter is going to fire 1000000 events");
  int start = DateTime.now().microsecondsSinceEpoch;
  emitter.emit("update");
  int end = DateTime.now().microsecondsSinceEpoch;

  print(
      "Total time took to emit 1 million events - ${end - start}. Count - $events");
  print(
      "Test time to remove all events. Events left - > ${emitter.getListenersCount("update")}");
  start = DateTime.now().microsecondsSinceEpoch;
  for (var i = 0; i < models.length; i++) {
    var m = models[i];
    emitter.off(m.listener);
    // emitter.removeListener(m.listener.eventName, m.listener.callback);
  }
  end = DateTime.now().microsecondsSinceEpoch;

  print(
      "Total time took to remove 1 million events - ${end - start}. Events left - > ${emitter.getListenersCount("update")}");

  events = 0;
  print("Emitter is going to fire 1000000 events");
  start = DateTime.now().microsecondsSinceEpoch;
  emitter.emit("update");
  end = DateTime.now().microsecondsSinceEpoch;

  print(
      "Total time took to emit 1 million events - ${end - start}. Count - $events");
}

List<TestModel> createAMillionRecords() {
  var count = 1000000;
  List<TestModel> models = <TestModel>[];
  for (var i = 0; i < count; i++) {
    models.add(new TestModel());
  }

  return models;
}

class ExtendedEmitter extends EventEmitter {
  void timerCallback(Timer timer) {
    emit("timer", this, timer);
  }

  void doSomeOperation() {
    Timer.periodic(Duration(seconds: 1), timerCallback);
  }
}

void callback(Event ev, Object? cxt) {
  events++;
}

class TestModel {
  Listener? listener;
  TestModel() {
    this.listener = emitter.on("update", this, callback);
  }

  void off() {
    emitter.off(listener);
  }

  void remove() {
    emitter.removeListener(listener!.eventName, callback);
  }
}
