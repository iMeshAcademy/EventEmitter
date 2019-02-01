// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:eventify/eventify.dart';
import 'dart:async';

void main() {
  EventEmitter emitter = new EventEmitter();
  emitter.on("test", null, (ev, context) {
    print("${ev.eventName} - ${ev.eventData}");
  });

  emitter.emit("test", null, "Test data");

  int count = 0;

  ExtendedEmitter timer = new ExtendedEmitter();
  timer.on("timer", null, (ev, context) {
    count++;
    print("Received ${ev.eventName} event from emitter!");
    if (count == 10) {
      Timer t = ev.eventData as Timer;
      t.cancel();
    }
  });

  timer.doSomeOperation();
}

class ExtendedEmitter extends EventEmitter {
  void timerCallback(Timer timer) {
    emit("timer", this, timer);
  }

  void doSomeOperation() {
    Timer.periodic(Duration(seconds: 1), timerCallback);
  }
}
