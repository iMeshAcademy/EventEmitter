import 'dart:async';

import 'package:eventify/eventify.dart';

ExtendedEmitter emitter = new ExtendedEmitter();
int events = 0;
int listenerCount = 1000000;
void main() {
  List<TestModel> models = createAMillionRecords();

  print("Emitter is going to fire 1000000 events");
  DateTime start = DateTime.now();
  emitter.emit("update");
  Duration end = DateTime.now().difference(start);

  print("Total time took to emit 1 million events - ${end}. Count - $events");
  print(
      "Test time to remove all events. Events left - > ${emitter.getListenersCount("update")}");
  start = DateTime.now();
  for (var i = 0; i < models.length; i++) {
    var m = models[i];
    emitter.off(m.listener);
    // emitter.removeListener(m.listener.eventName, m.listener.callback);
  }
  end = DateTime.now().difference(start);

  print(
      "Total time took to remove 1 million events - ${end}. Events left - > ${emitter.getListenersCount("update")}");

  events = 0;
  print("Emitter is going to fire ${listenerCount} events");
  start = DateTime.now();
  emitter.emit("update");
  end = DateTime.now().difference(start);

  print(
      "Total time took to emit ${listenerCount} events - ${end}. Count - $events");

  print(
      "-------------------------------------------------------------------------------");
  print(
      "-------------------------------------------------------------------------------");

  print("Adding $listenerCount listeners to emitter.");
  models.clear();
  listenerCount = 10000000;
  start = DateTime.now();
  models = createAMillionRecords();
  end = DateTime.now().difference(start);
  print(
      "Total time took to add ${listenerCount}listeners - ${end}. Count - ${models.length}");
  events = 0;

  print("Emitter is going to fire ${listenerCount} events");

  start = DateTime.now();
  emitter.emit("update");
  end = DateTime.now().difference(start);

  print(
      "Total time took to emit ${listenerCount} events - ${end}. Count - $events");

  events = 0;

  print("Removing $listenerCount listeners from subject using cancel().");
  start = DateTime.now();
  for (var i = 0; i < models.length; i++) {
    var m = models[i];
    m.listener.cancel();
  }
  end = DateTime.now().difference(start);
  print(
      "Total time took to remove ${listenerCount} listeners - ${end}. Remaining listeners - ${emitter.getListenersCount("update")}");
}

List<TestModel> createAMillionRecords() {
  List<TestModel> models = <TestModel>[];
  for (var i = 0; i < listenerCount; i++) {
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

class TestModel {
  void callback(Event ev, Object cxt) {
    events++;
  }

  Listener listener;
  TestModel() {
    this.listener = emitter.on("update", this, callback);
  }

  void off() {
    emitter.off(listener);
  }

  void remove() {
    emitter.removeListener(listener.eventName, callback);
  }
}
