// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:eventify/eventify.dart';
import 'dart:async';

Future parseStores(Object config) {
  return new Future(() {
    print("Inside the future.");
    Map<String, Map<String, dynamic>> storeConfigs =
        config as Map<String, Map<String, dynamic>>;
    storeConfigs.forEach((str, val) {
      print("${str}:${val}");
      val.forEach((store, details) {
        print("${store}:${details}");
      });
    });
  });
}

void main() {
  Map<String, dynamic> data = {
    "stores": {
      "store1": {"generator": 1, "config": {}},
      "store2": {"generator": 2, "config": {}}
    },
    "models": {
      "model1": {"generator": 1, "name": "modelel1", "linkedStore": "store1"}
    }
  };

  Function parseModels = (config) {};

  print(data.runtimeType);
  data.forEach((key, val) {
    switch (key) {
      case "stores":
        parseStores(val).then((res) {
          print("Store is parsed");
        });
        break;
      case "models":
        parseModels(val);
        break;
      default:
    }
  });

  print("After the loop!!");

  EventEmitter emitter = new EventEmitter();
  emitter.on("test", null, (ev, context) {
    print("${ev.eventName} - ${ev.eventData}");
  });

  emitter.emit("test", null, "Test data");

  int count = 0;

  ExtendedEmitter timer = new ExtendedEmitter();
  timer.on("timer", null, (ev, context) {
    count++;
    print("Received ${ev.eventName} event from ${ev.sender}!");
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
