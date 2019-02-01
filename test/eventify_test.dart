import 'package:eventify/eventify.dart';
import 'package:test/test.dart';

EventEmitter emitter;

void main() {
  setUp(() {
    emitter = new EventEmitter();
  });

  executeOnEventListnerTest();
  executeOffEventListnerTest();
  executeRemoveListenerTest();
  executeEmitTest();
  clearTest();
  removeAllByCallbackTest();
  removeAllByEventTest();
  getListenersCountTest();
}

void executeOnEventListnerTest() {
  group("on", () {
    test("register listener", () {
      expect(emitter.count, 0);
      bool fired = false;
      dynamic listener = emitter.on("test", null, (ev, cont) {
        if (ev != null && ev.eventName == "test") {
          fired = true;
        }
      });

      expect(emitter.count, 1);
      expect(listener != null, true);
      emitter.emit("test");
      expect(fired, true);
    });

    test("register listener with context", () {
      expect(emitter.count, 0);
      bool fired = false;
      Listener listener = emitter.on("test", 1, (ev, cont) {
        if (ev != null && ev.eventName == "test" && cont == 1) {
          fired = true;
        }
      });

      expect(emitter.count, 1);
      expect(listener != null, true);
      expect(listener.context, 1);
      emitter.emit("test");
      expect(fired, true);
    });

    test("register listener - Validate return value - listener", () {
      expect(emitter.count, 0);
      bool fired = false;
      EventCallback cb = (ev, cont) {
        if (ev != null && ev.eventName == "test" && cont == 1) {
          fired = true;
        }
      };

      Listener listener = emitter.on("test", 1, cb);

      expect(emitter.count, 1);
      expect(listener != null, true);
      expect(listener.context, 1);
      expect(listener.eventName, "test");
      expect(listener.callback, cb);
      expect(listener.cancel != null, true);

      emitter.emit("test");
      expect(fired, true);
      fired = false;
      listener.callback(new Event("test"), 1);
      expect(fired, true);
    });

    test("register multiple listeners of different event", () {
      expect(emitter.count, 0);
      double val = 0;

      EventCallback cb = (ev, cont) {
        if (null != ev) {
          switch (ev.eventName) {
            case "add":
              val += ev.eventData as int;
              break;
            case "sub":
              val -= ev.eventData as int;

              break;
            case "mult":
              val *= ev.eventData as int;

              break;
            case "div":
              val /= (ev.eventData as int);

              break;
          }
        }
      };

      Listener listener1 = emitter.on("add", null, cb);
      Listener listener2 = emitter.on("sub", null, cb);
      Listener listener3 = emitter.on("mult", null, cb);
      Listener listener4 = emitter.on("div", null, cb);

      expect(emitter.count, 4);
      expect(listener1 != null, true);
      expect(listener2 != null, true);
      expect(listener3 != null, true);
      expect(listener4 != null, true);

      expect(listener1 != listener2, true);
      expect(listener3 != listener4, true);
      expect(listener1 == listener4, false);
      expect(listener2 == listener4, false);
      expect(listener2 != listener3, true);

      emitter.emit("add", null, 10);
      expect(val, 10);

      emitter.emit("sub", null, 5);
      expect(val, 5);

      emitter.emit("mult", null, 5);
      expect(val, 25);

      emitter.emit("div", null, 5);
      expect(val, 5);
    });

    test("register multiple listeners of same event", () {
      expect(emitter.count, 0);
      double val = 0;

      EventCallback cb1 = (ev, cont) {
        if (null != ev) {
          switch (ev.eventName) {
            case "add":
              val += ev.eventData as int;
              break;
          }
        }
      };

      EventCallback cb2 = (ev, cont) {
        if (null != ev) {
          switch (ev.eventName) {
            case "add":
              val += ev.eventData as int;
              break;
          }
        }
      };

      EventCallback cb3 = (ev, cont) {
        if (null != ev) {
          switch (ev.eventName) {
            case "add":
              val += ev.eventData as int;
              break;
          }
        }
      };

      EventCallback cb4 = (ev, cont) {
        if (null != ev) {
          switch (ev.eventName) {
            case "add":
              val += ev.eventData as int;
              break;
          }
        }
      };

      Listener listener1 = emitter.on("add", null, cb1);
      Listener listener2 = emitter.on("add", null, cb2);
      Listener listener3 = emitter.on("add", null, cb3);
      Listener listener4 = emitter.on("add", null, cb4);

      expect(emitter.count, 1);
      expect(emitter.getListenersCount("add"), 4);

      expect(listener1 != null, true);
      expect(listener2 != null, true);
      expect(listener3 != null, true);
      expect(listener4 != null, true);

      expect(listener1 != listener2, true);
      expect(listener3 != listener4, true);
      expect(listener1 == listener4, false);
      expect(listener2 == listener4, false);
      expect(listener2 != listener3, true);

      emitter.emit("add", null, 10);
      expect(val, 40);

      emitter.emit("add", null, -10);
      expect(val, 0);

      emitter.emit("add", null, 1);
      expect(val, 4);

      emitter.emit("add", null, 0);
      expect(val, 4);

      emitter.emit("div", null, 10);
      expect(val, 4);
    });
  }, skip: false);
}

void executeOffEventListnerTest() {
  group("off", () {
    test("remove only one listene using off", () {
      expect(emitter.count, 0);
      dynamic listener = emitter.on("test", null, (ev, cont) {});

      expect(emitter.count, 1);
      expect(listener != null, true);
      emitter.off(listener);
      expect(emitter.getListenersCount("test"), 0);
    });

    test("remove listener using listener.cancel", () {
      expect(emitter.count, 0);
      dynamic listener = emitter.on("test", null, (ev, cont) {});

      expect(emitter.count, 1);
      expect(listener != null, true);
      listener.cancel();
      expect(emitter.getListenersCount("test"), 0);
    });

    test("Remove multiple listener of same event, different callback", () {
      expect(emitter.count, 0);
      EventCallback cb1 = (ev, cont) {};

      EventCallback cb2 = (ev, cont) {};

      Listener listener1 = emitter.on("test", 1, cb1);
      Listener listener2 = emitter.on("test", 1, cb2);

      expect(emitter.count, 1);
      expect(emitter.getListenersCount("test"), 2);
      emitter.off(listener1);
      expect(emitter.getListenersCount("test"), 1);
      emitter.off(listener1);
      expect(emitter.getListenersCount("test"), 1);
      emitter.off(listener2);
      expect(emitter.getListenersCount("test"), 0);
    });

    test("Remove multiple listeners of different events", () {
      expect(emitter.count, 0);
      EventCallback cb1 = (ev, cont) {};

      EventCallback cb2 = (ev, cont) {};

      Listener listener1 = emitter.on("test1", 1, cb1);
      Listener listener2 = emitter.on("test2", 1, cb2);

      expect(emitter.count, 2);
      expect(emitter.getListenersCount("test1"), 1);
      emitter.off(listener1);
      expect(emitter.getListenersCount("test1"), 0);

      expect(emitter.getListenersCount("test2"), 1);
      emitter.off(listener2);
      expect(emitter.getListenersCount("test2"), 0);
    });
  }, skip: false);
}

void executeRemoveListenerTest() {
  group("removeListener", () {
    test("remove only one listener using removeListener", () {
      expect(emitter.count, 0);
      EventCallback cb = (ev, cont) {};
      dynamic listener = emitter.on("test", null, cb);

      expect(emitter.count, 1);
      expect(listener != null, true);
      emitter.removeListener("test", cb);
      expect(emitter.getListenersCount("test"), 0);
    });

    test("Remove multiple listener of same event, different callback", () {
      expect(emitter.count, 0);
      EventCallback cb1 = (ev, cont) {};

      EventCallback cb2 = (ev, cont) {};

      emitter.on("test", 1, cb1);
      emitter.on("test", 1, cb2);

      expect(emitter.count, 1);
      expect(emitter.getListenersCount("test"), 2);
      emitter.removeListener("test", cb1);
      expect(emitter.getListenersCount("test"), 1);
      emitter.removeListener("test", cb2);
      expect(emitter.getListenersCount("test"), 0);
    });

    test("Remove multiple listeners of different events", () {
      expect(emitter.count, 0);
      EventCallback cb1 = (ev, cont) {};

      EventCallback cb2 = (ev, cont) {};

      emitter.on("test1", 1, cb1);
      emitter.on("test2", 1, cb2);

      expect(emitter.count, 2);
      expect(emitter.getListenersCount("test1"), 1);
      emitter.removeListener("test1", cb2);
      expect(emitter.getListenersCount("test1"), 1);

      emitter.removeListener("test1", cb1);
      expect(emitter.getListenersCount("test1"), 0);

      expect(emitter.getListenersCount("test2"), 1);
      emitter.removeListener("test2", cb2);
      expect(emitter.getListenersCount("test2"), 0);
    });
  }, skip: false);
}

void executeEmitTest() {
  group("emit", () {
    test("emit single event to single listener", () {
      expect(emitter.count, 0);
      int count = 0;
      EventCallback cb = (ev, cont) {
        count++;
      };
      emitter.on("test", null, cb);
      emitter.emit("test", null, 1);
      expect(count, 1);
    });

    test("Emit single event to 3 listeners", () {
      expect(emitter.count, 0);
      int count = 0;

      EventCallback cb1 = (ev, cont) {
        count++;
      };

      EventCallback cb2 = (ev, cont) {
        count++;
      };
      EventCallback cb3 = (ev, cont) {
        count++;
      };

      emitter.on("test", 1, cb1);
      emitter.on("test", 1, cb2);
      emitter.on("test", 1, cb3);

      emitter.emit("test", null, 1);
      expect(count, 3);
    });

    test("Emit multiple event, single callback.", () {
      expect(emitter.count, 0);
      double val = 0;

      EventCallback cb = (ev, cont) {
        if (null != ev) {
          switch (ev.eventName) {
            case "add":
              val += ev.eventData as int;
              break;
            case "sub":
              val -= ev.eventData as int;

              break;
            case "mult":
              val *= ev.eventData as int;

              break;
            case "div":
              val /= (ev.eventData as int);

              break;
          }
        }
      };

      emitter.on("add", null, cb);
      emitter.on("sub", null, cb);
      emitter.on("mult", null, cb);
      emitter.on("div", null, cb);

      emitter.emit("add", null, 10);
      expect(val, 10);

      emitter.emit("sub", null, 5);
      expect(val, 5);

      emitter.emit("mult", null, 5);
      expect(val, 25);

      emitter.emit("div", null, 5);
      expect(val, 5);
    });

    test("Emit single event, multiple callback, handle from one callback", () {
      expect(emitter.count, 0);
      int count = 0;

      EventCallback cb1 = (ev, cont) {
        count++;
      };

      EventCallback cb2 = (ev, cont) {
        count++;
        ev.handled = true;
      };
      EventCallback cb3 = (ev, cont) {
        count++;
      };

      emitter.on("test", 1, cb1);
      emitter.on("test", 1, cb2);
      emitter.on("test", 1, cb3);

      emitter.emit("test", null, 1);
      expect(count, 2);
    });

    test("Emit multiple event, multiple callback.", () {
      expect(emitter.count, 0);
      double val = 0;

      EventCallback addcb = (ev, cont) {
        if (null != ev) {
          switch (ev.eventName) {
            case "add":
              val += ev.eventData as int;
              break;
          }
        }
      };

      EventCallback sub = (ev, cont) {
        if (null != ev) {
          switch (ev.eventName) {
            case "sub":
              val -= ev.eventData as int;
              break;
          }
        }
      };

      EventCallback mul = (ev, cont) {
        if (null != ev) {
          switch (ev.eventName) {
            case "mult":
              val *= ev.eventData as int;
              break;
          }
        }
      };

      EventCallback div = (ev, cont) {
        if (null != ev) {
          switch (ev.eventName) {
            case "div":
              val /= ev.eventData as int;
              break;
          }
        }
      };

      emitter.on("add", null, addcb);
      emitter.on("sub", null, sub);
      emitter.on("mult", null, mul);
      emitter.on("div", null, div);

      emitter.emit("add", null, 10);
      expect(val, 10);

      emitter.emit("sub", null, 5);
      expect(val, 5);

      emitter.emit("mult", null, 5);
      expect(val, 25);

      emitter.emit("div", null, 5);
      expect(val, 5);
    });
  }, skip: false);
}

void clearTest() {
  group("clear", () {
    test("clear one event", () {
      expect(emitter.count, 0);
      EventCallback cb = (ev, cont) {};
      emitter.on("test", null, cb);
      expect(emitter.count, 1);
      emitter.clear();
      expect(emitter.count, 0);
    });

    test("Clear 3 same events, different callbacks", () {
      expect(emitter.count, 0);

      EventCallback cb1 = (ev, cont) {};

      EventCallback cb2 = (ev, cont) {};
      EventCallback cb3 = (ev, cont) {};

      emitter.on("test", 1, cb1);
      emitter.on("test", 1, cb2);
      emitter.on("test", 1, cb3);

      expect(emitter.count, 1);

      expect(emitter.getListenersCount("test"), 3);
      emitter.clear();
      expect(emitter.count, 0);
      expect(emitter.getListenersCount("test"), 0);
    });

    test("clear 3 different events.", () {
      expect(emitter.count, 0);

      EventCallback cb = (ev, cont) {};

      emitter.on("add", null, cb);
      emitter.on("sub", null, cb);
      emitter.on("mult", null, cb);
      emitter.on("div", null, cb);

      expect(emitter.count, 4);
      emitter.clear();
      expect(emitter.count, 0);
      expect(emitter.getListenersCount("add"), 0);
    });
  }, skip: false);
}

void removeAllByCallbackTest() {
  group("removeAllByCallback", () {
    test("removeAllByCallback one event", () {
      expect(emitter.count, 0);
      EventCallback cb = (ev, cont) {};
      emitter.on("test", null, cb);
      expect(emitter.count, 1);
      emitter.removeAllByCallback(cb);
      expect(emitter.getListenersCount("test"), 0);
      expect(emitter.count, 1);
    });

    test("removeAllByCallback, same events, multiple callbacks.", () {
      expect(emitter.count, 0);

      EventCallback cb1 = (ev, cont) {};
      EventCallback cb2 = (ev, cont) {};
      EventCallback cb3 = (ev, cont) {};

      emitter.on("test", 1, cb1);
      emitter.on("test", 1, cb2);
      emitter.on("test", 1, cb3);

      expect(emitter.count, 1);
      expect(emitter.getListenersCount("test"), 3);

      emitter.removeAllByCallback(cb1);
      expect(emitter.count, 1);
      expect(emitter.getListenersCount("test"), 2);

      emitter.removeAllByCallback(cb2);
      expect(emitter.count, 1);
      expect(emitter.getListenersCount("test"), 1);

      emitter.removeAllByCallback(cb1);
      expect(emitter.count, 1);
      expect(emitter.getListenersCount("test"), 1);

      emitter.removeAllByCallback(cb3);
      expect(emitter.count, 1);
      expect(emitter.getListenersCount("test"), 0);
    });

    test("removeAllByCallback, multiple events, same callbacks", () {
      expect(emitter.count, 0);

      EventCallback cb = (ev, cont) {};

      emitter.on("add", null, cb);
      emitter.on("sub", null, cb);
      emitter.on("mult", null, cb);
      emitter.on("div", null, cb);

      expect(emitter.count, 4);
      emitter.removeAllByCallback(cb);
      expect(emitter.count, 4);
      expect(emitter.getListenersCount("add"), 0);
      expect(emitter.getListenersCount("sub"), 0);
      expect(emitter.getListenersCount("mult"), 0);
      expect(emitter.getListenersCount("div"), 0);
    });

    test("removeAllByCallback, multiple events, multiple callbacks", () {
      expect(emitter.count, 0);

      EventCallback cb1 = (ev, cont) {};
      EventCallback cb2 = (ev, cont) {};
      EventCallback cb3 = (ev, cont) {};
      EventCallback cb4 = (ev, cont) {};

      emitter.on("add", null, cb1);
      emitter.on("sub", null, cb2);
      emitter.on("mult", null, cb3);
      emitter.on("div", null, cb4);

      expect(emitter.count, 4);
      emitter.removeAllByCallback(cb1);
      expect(emitter.count, 4);
      expect(emitter.getListenersCount("add"), 0);
      expect(emitter.getListenersCount("sub"), 1);
      expect(emitter.getListenersCount("mult"), 1);
      expect(emitter.getListenersCount("div"), 1);

      emitter.removeAllByCallback(cb2);
      expect(emitter.count, 4);
      expect(emitter.getListenersCount("add"), 0);
      expect(emitter.getListenersCount("sub"), 0);
      expect(emitter.getListenersCount("mult"), 1);
      expect(emitter.getListenersCount("div"), 1);

      emitter.removeAllByCallback(cb3);
      expect(emitter.count, 4);
      expect(emitter.getListenersCount("add"), 0);
      expect(emitter.getListenersCount("sub"), 0);
      expect(emitter.getListenersCount("mult"), 0);
      expect(emitter.getListenersCount("div"), 1);

      emitter.removeAllByCallback(cb4);
      expect(emitter.count, 4);
      expect(emitter.getListenersCount("add"), 0);
      expect(emitter.getListenersCount("sub"), 0);
      expect(emitter.getListenersCount("mult"), 0);
      expect(emitter.getListenersCount("div"), 0);
    });
  }, skip: false);
}

void removeAllByEventTest() {
  group("removeAllByEvent", () {
    test("removeAllByEvent one event", () {
      expect(emitter.count, 0);
      EventCallback cb = (ev, cont) {};
      emitter.on("test", null, cb);
      expect(emitter.count, 1);
      emitter.removeAllByEvent("test");
      expect(emitter.count, 0);
    });

    test("removeAllByEvent, same events, multiple callbacks.", () {
      expect(emitter.count, 0);

      EventCallback cb1 = (ev, cont) {};
      EventCallback cb2 = (ev, cont) {};
      EventCallback cb3 = (ev, cont) {};

      emitter.on("test", 1, cb1);
      emitter.on("test", 1, cb2);
      emitter.on("test", 1, cb3);

      expect(emitter.count, 1);
      expect(emitter.getListenersCount("test"), 3);

      emitter.removeAllByEvent("test");
      expect(emitter.count, 0);
      expect(emitter.getListenersCount("test"), 0);
    });

    test("removeAllByCallback, multiple events, same callbacks", () {
      expect(emitter.count, 0);

      EventCallback cb = (ev, cont) {};

      emitter.on("add", null, cb);
      emitter.on("sub", null, cb);
      emitter.on("mult", null, cb);
      emitter.on("div", null, cb);

      expect(emitter.count, 4);

      emitter.removeAllByEvent("add");
      expect(emitter.count, 3);
      expect(emitter.getListenersCount("add"), 0);

      emitter.removeAllByEvent("sub");
      expect(emitter.count, 2);
      expect(emitter.getListenersCount("sub"), 0);

      emitter.removeAllByEvent("mult");
      expect(emitter.count, 1);
      expect(emitter.getListenersCount("mult"), 0);

      emitter.removeAllByEvent("div");
      expect(emitter.count, 0);
      expect(emitter.getListenersCount("div"), 0);
    });

    test("removeAllByCallback, multiple events, multiple callbacks", () {
      expect(emitter.count, 0);

      EventCallback cb1 = (ev, cont) {};
      EventCallback cb2 = (ev, cont) {};
      EventCallback cb3 = (ev, cont) {};
      EventCallback cb4 = (ev, cont) {};

      emitter.on("add", null, cb1);
      emitter.on("sub", null, cb2);
      emitter.on("mult", null, cb3);
      emitter.on("div", null, cb4);

      expect(emitter.count, 4);

      emitter.removeAllByEvent("add");
      expect(emitter.count, 3);
      expect(emitter.getListenersCount("add"), 0);

      emitter.removeAllByEvent("sub");
      expect(emitter.count, 2);
      expect(emitter.getListenersCount("sub"), 0);

      emitter.removeAllByEvent("mult");
      expect(emitter.count, 1);
      expect(emitter.getListenersCount("mult"), 0);

      emitter.removeAllByEvent("div");
      expect(emitter.count, 0);
      expect(emitter.getListenersCount("div"), 0);
    });
  }, skip: false);
}

void countTest() {
  group("count", () {
    test("count one event", () {
      expect(emitter.count, 0);
      EventCallback cb = (ev, cont) {};
      emitter.on("test", null, cb);
      expect(emitter.count, 1);
    });

    test("count, same events, multiple callbacks.", () {
      expect(emitter.count, 0);

      EventCallback cb1 = (ev, cont) {};
      EventCallback cb2 = (ev, cont) {};
      EventCallback cb3 = (ev, cont) {};

      emitter.on("test", 1, cb1);
      emitter.on("test", 1, cb2);
      emitter.on("test", 1, cb3);

      expect(emitter.count, 1);
    });

    test("count, multiple events, same callbacks", () {
      expect(emitter.count, 0);

      EventCallback cb = (ev, cont) {};

      emitter.on("add", null, cb);
      emitter.on("sub", null, cb);
      emitter.on("mult", null, cb);
      emitter.on("div", null, cb);

      expect(emitter.count, 4);
    });

    test("count, multiple events, multiple callbacks", () {
      expect(emitter.count, 0);

      EventCallback cb1 = (ev, cont) {};
      EventCallback cb2 = (ev, cont) {};
      EventCallback cb3 = (ev, cont) {};
      EventCallback cb4 = (ev, cont) {};

      emitter.on("add", null, cb1);
      emitter.on("sub", null, cb2);
      emitter.on("mult", null, cb3);
      emitter.on("div", null, cb4);

      expect(emitter.count, 4);
    });
  }, skip: false);
}

void getListenersCountTest() {
  group("getListenersCount", () {
    test("getListenersCount one event", () {
      expect(emitter.count, 0);
      EventCallback cb = (ev, cont) {};
      emitter.on("test", null, cb);
      expect(emitter.getListenersCount("test"), 1);
    });

    test("getListenersCount, same events, multiple callbacks.", () {
      expect(emitter.count, 0);

      EventCallback cb1 = (ev, cont) {};
      EventCallback cb2 = (ev, cont) {};
      EventCallback cb3 = (ev, cont) {};

      emitter.on("test", 1, cb1);
      emitter.on("test", 1, cb2);
      emitter.on("test", 1, cb3);

      expect(emitter.count, 1);
      expect(emitter.getListenersCount("test"), 3);
    });

    test("getListenersCount, multiple events, same callbacks", () {
      expect(emitter.count, 0);

      EventCallback cb = (ev, cont) {};

      emitter.on("add", null, cb);
      emitter.on("sub", null, cb);
      emitter.on("mult", null, cb);
      emitter.on("div", null, cb);

      expect(emitter.count, 4);
      expect(emitter.getListenersCount("add"), 1);
      expect(emitter.getListenersCount("sub"), 1);
      expect(emitter.getListenersCount("mult"), 1);
      expect(emitter.getListenersCount("div"), 1);
    });

    test("getListenersCount, multiple events, multiple callbacks", () {
      expect(emitter.count, 0);

      EventCallback cb1 = (ev, cont) {};
      EventCallback cb2 = (ev, cont) {};
      EventCallback cb3 = (ev, cont) {};
      EventCallback cb4 = (ev, cont) {};

      emitter.on("add", null, cb1);
      emitter.on("sub", null, cb2);
      emitter.on("mult", null, cb3);
      emitter.on("div", null, cb4);

      expect(emitter.count, 4);
      expect(emitter.getListenersCount("add"), 1);
      expect(emitter.getListenersCount("sub"), 1);
      expect(emitter.getListenersCount("mult"), 1);
      expect(emitter.getListenersCount("div"), 1);
    });
  }, skip: false);
}
